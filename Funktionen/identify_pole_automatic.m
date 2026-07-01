%% Funktion zur automatischen Polauswahl
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    fig = Figur der App
%                       all_pole = Alle Pole aus der SSI
%                       user_input = Parameter für Polauswahl
%                       it_current = Aktueller Iterationsschritt für Zustandsüberwachung
%                       it_total = Gesamte Iterationsschritte für Zustandsüberwachung

% Ausgabeparameter:     all_pole = Alle Pole mit Flaggen
%                       selected_pole = Ausgewählte Pole
%                       unselected_counter = Anzahl der nicht ausgewählten Cluster
%                       cluster_quality_final = Qualitätswerte der ausgewählten Cluster

function [all_pole, selected_pole, unselected_counter, cluster_quality_final] = ...
    identify_pole_automatic(fig, all_pole, user_input, it_current, it_total)
   
    % Wenn Iterationsschritte nicht eingegeben wurden, handelt es sich um Modalanalyse
    if nargin == 3

        % Progressbar ohne Iterationsschritt instanziieren
        progressbar = uiprogressdlg(fig, 'Title', 'Cluster-Analyse',...
            'Message', 'Es fängt gleich an...', 'Cancelable', 'on', 'CancelText', 'Stop');

    % Sonst handelt es sich um Zustandsüberwachung
    else
    
        % Progressbar mit Iterationsschritt instanziieren
        progressbar_msg = ['Abschnitt ', num2str(it_current), ' von ', ...
            num2str(it_total), ' (Cluster-Analyse)'];
        progressbar = uiprogressdlg(fig, 'Title', progressbar_msg ,...
            'Message', 'Es fängt gleich an...', 'Cancelable', 'on', 'CancelText', 'Stop');
    end

    % Progressbar zeichnen
    drawnow;    

    % Stabile Pole anhand Kriterien sammeln
    [all_pole, stable_idx] = collect_stable_pole(all_pole, user_input.crit_stable_freq, ...
        user_input.crit_stable_damp, user_input.crit_mac);

    % Stabile Pole holen
    stable_pole = all_pole(stable_idx);
    num_stable = numel(stable_pole);

    % Funktion beenden falls gar keine stabilen Pole gefunden wurden
    if num_stable == 0
        selected_pole = struct([]);
        unselected_counter = 0;
        return;
    end

    % Modale Parameter extrahieren
    frequency_list = [stable_pole.eigenfreq]';
    damping_list = [stable_pole.damping_ratio]';
    mode_shape_list = {stable_pole.mode_shape}';

    % Distanzmatrix instanziieren
    distance_matrix = zeros(num_stable);

    % Alle stabilen Pole durchlaufen
    for i = 1:num_stable

        % Falls "Abbrechen" im Progressbar betätigt wird, Vorgang abbrechen
        % und Fehler zeigen
        if progressbar.CancelRequested
            error('Cluster-Analyse abgebrochen!');
        end

        % Progressbar aktualisieren (erstmal nur bis 50%)
        progress_Value = i/num_stable * 0.5;
        progressbar.Value = progress_Value;
        progressbar.Message = sprintf('Distanzmatrix wird erstellt...');        

        % Alle stabilen Pole durchlaufen
        for j = i+1:num_stable

            % Distanz zwischen zwei Polen berechnen 
            freq_diff = abs(frequency_list(i) - frequency_list(j)) / frequency_list(j);
            mac = compute_mac_value(mode_shape_list{i}, mode_shape_list{j});
            distance = freq_diff + (1 - mac);   % d_ij = |f_i - f_j| / f_j + (1 - MAC_ij)

            % Distanz in Distanzmatrix hinzufügen
            distance_matrix(i,j) = distance;
            distance_matrix(j,i) = distance;
        end
    end    

    % Distanzschwelle holen
    cluster_distance  = user_input.cluster_distance;

    % Cluster-Analyse anhand Distanzmatrix durchführen
    linkage_tree = linkage(squareform(distance_matrix), 'single');
    cluster_label = cluster(linkage_tree, 'cutoff', cluster_distance, 'criterion', 'distance');

    % Duplizierte Cluster verschmelzen (Identische Cluster können doppelt
    % auftreten, da die Eigenformen aus komplex-konjugierten Eigenwerten
    % abgeleitet werden. Die komplexen Anteile können zur Unterscheidung
    % verschiedener Moden beitragen, führen jedoch in manchen Fällen dazu,
    % dass physikalisch identische Moden in zwei separaten Clustern
    % eingeordnet werden. Diese werden nach der Cluster-Analyse wieder
    % zusammengeführt)
    cluster_label = merge_duplicated_cluster(cluster_label, stable_pole);       

    % Cluster evaluieren
    cluster_quality = evaluate_clusters(cluster_label, frequency_list, damping_list, mode_shape_list);        

    % Anzahl der gefundenen Cluster
    num_cluster_found = max(cluster_label);    

    % Array für valide Cluster instanziieren
    valid_cluster = false(num_cluster_found, 1);     
        
    % Falls Anzahl der Moden bekannt ist
    if user_input.num_mode_known

        % Zielanzahl holen
        num_clusters_target = user_input.target_num;

        % Wenn Anzahl der Referenzmoden eingegeben wurde, diese Anzahl
        % übernehmen
        if isfield(user_input, 'target_num_ref')
            num_clusters_target = user_input.target_num_ref;
        end        

        % Fehlermeldung falls Anzahl der gefundenen Cluster weniger als
        % Zielanzahl
        if num_cluster_found < num_clusters_target
            error(['Konnte nicht genau die gewünschte Anzahl von Clustern bilden! ' ...
                'Probieren Sie mit anderen Parametern.']);
        end

        % Zielanzahl nochmal holen
        num_clusters_target = user_input.target_num;    
    
        % Cluster evaluieren
        cluster_quality = evaluate_clusters(cluster_label, frequency_list, damping_list, mode_shape_list);

        % Zielanzahl von besten Clustern als valid einstufen
        [~, idx] = sort(cluster_quality, 'descend');
        idx  = idx(1:min(num_clusters_target,  num_cluster_found));
        valid_cluster(idx) = true;

    % Falls Anzahl der Moden nicht bekannt ist
    else

        % Mindestgröße der Cluster holen
        min_cluster_size  = user_input.min_cluster_size;

        % Nur Cluster mit genugender Größe als valid einstufen
        for c = 1:num_cluster_found
            mask = (cluster_label == c);
            cluster_pole = stable_pole(mask);
            cluster_size = numel(cluster_pole);
            if cluster_size >= min_cluster_size
                valid_cluster(c) = true;
            end
        end
    end

    % Variablen für Ergebnisse instanziieren
    selected_pole = struct([]);
    cluster_quality_final = zeros(sum(valid_cluster),1);
    selected_counter = 0;
    unselected_counter = 0;

    % Beste Qualität holen
    best_quality = max(cluster_quality);

    % Alle gefundenen Cluster durchlaufen
    for c = 1:num_cluster_found

        % Falls "Abbrechen" im Progressbar betätigt wird, Vorgang abbrechen
        % und Fehler zeigen
        if progressbar.CancelRequested
            error('Cluster-Analyse abgebrochen!');
        end
    
        % Progressbar aktualisieren (50% bis 100%)
        progress_Value = 0.5 + c/num_cluster_found * 0.5;
        progressbar.Value = progress_Value;
        progressbar.Message = sprintf('Cluster werden eingestuft...');        

        % Indizes der Pole dieses Clusters holen
        mask = (cluster_label == c);
        cluster_pole = stable_pole(mask);
        stable_idx_this_cluster = stable_idx(mask);

        % Wenn dieses Cluster nicht valid ist
        if ~valid_cluster(c)

            % Anzahl der nicht gewählten Cluster erhöhen
            unselected_counter = unselected_counter + 1;

            % Dieses Cluster überspringen
            continue;
        end

        % Anzahl der gewählten Cluster erhöhen
        selected_counter = selected_counter + 1;

        % Fehlermeldung falls keine stabile Frequenz vorliegt
        if ~any([cluster_pole.is_stable_freq])
            error('Ein endgültiger Cluster hat keine stabilen Frequenzen! Parameter ungeeignet!');
        end        

        % Fehlermeldung falls kein stabiler Dämpfungsgrad vorliegt
        if ~any([cluster_pole.is_stable_damp])
            error('Ein endgültiger Cluster hat keine stabilen Dämpfungsgrade! Parameter ungeeignet!');
        end
    
        % Fehlermeldung falls keine MAC-Bedingung erfüllt ist
        if ~any([cluster_pole.is_mac])
            error('In einem endgültigen Cluster ist keine MAC-Bedingung erfüllt! Parameter ungeeignet!');
        end   

        % Modale Parameter des Clusters berechnen und speichern
        mode_info = compute_cluster_statistics(cluster_pole);
        selected_pole(selected_counter).freq_mean = mode_info.mean_frequency;
        selected_pole(selected_counter).damp_mean = mode_info.mean_damping;
        selected_pole(selected_counter).mode_shape_mean = mode_info.mean_mode_shape;
        selected_pole(selected_counter).pole_idx  = stable_idx_this_cluster;

        % Qualität des Clusters normieren und speichern
        cluster_quality_final(selected_counter) = cluster_quality(c)/best_quality;

        % Pole dieses Clusters als "gewählt" markieren
        for k = 1:numel(stable_idx_this_cluster)
            all_pole(stable_idx_this_cluster(k)).is_chosen = true;
        end
    end

    % Feld "stabil" entfernen, weil es nicht mehr nötig ist
    all_pole = rmfield(all_pole, 'is_stable');

    % Wenn Cluster gewählt wurden
    if ~isempty(selected_pole)

        % Ergebnisse nach Frequenzen sortieren
        [~, srt] = sort([selected_pole.freq_mean]);
        selected_pole = selected_pole(srt);
        cluster_quality_final = cluster_quality_final(srt);
    end

    % Progressbar schließen
    pause(1);
    close(progressbar);    
end

%% Funktion zur Evaluierung der Cluster

% Übergabeparameter:    cluster_label = Cluster
%                       frequencies = Eigenfrequenzen
%                       damping = Dämpfungsgrade
%                       mode_shapes = Eigenformen

% Ausgabeparameter:     cluster_score = Qualitätswerte der Cluster

function cluster_score = evaluate_clusters(cluster_label, frequencies, damping, mode_shapes)

    % Anzahl der Cluster
    num_cluster = max(cluster_label);

    % Array für Qualitätswerte instanziieren
    cluster_score = zeros(num_cluster,1);
    
    % Alle Cluster durchlaufen
    for c = 1:num_cluster
    
        % Indizes der Pole dieses Clusters finden
        idx = find(cluster_label == c);

        % Anzahl der Pole dieses Clusters
        Nc = length(idx);
    
        % Wenn weniger als 2 Pole vorliegen
        if Nc < 2

            % Direkt 0 zuordnen
            cluster_score(c) = 0;

            % Dieses Cluster überspringen
            continue;
        end
    
        % Frequenzen dieses Clusters bewerten
        f = frequencies(idx);
        sigma_f = std(f) / mean(f);
    
        % Dämpfungsgrade dieses Clusters bewerten
        z = damping(idx);
        sigma_z = std(z);
    
        % Eigenformen dieses Clusters bewerten
        mac_vals = [];
        for i = 1:Nc
            for j = i+1:Nc
                mac_vals(end+1) = compute_mac_value(mode_shapes{idx(i)}, mode_shapes{idx(j)});
            end
        end
        mean_mac = mean(mac_vals);
    
        % Qualitätswert berechnen
        cluster_score(c) = Nc * mean_mac / (1 + sigma_f + sigma_z); % q_i = (N_c * MAC) / (1 + sigma_f + sigma_zeta)
    end
end

%% Funktion zum Verschmelzen duplizierter Cluster

% Übergabeparameter:    cluster_label = Cluster
%                       stable_pole = Stabile Pole

% Ausgabeparameter:     cluster_label_new = Neue Cluster nach Verschmelzen

function cluster_label_new = merge_duplicated_cluster(cluster_label, stable_pole)

    % Grenzwerte für identische Cluster
    freq_tol = 1e-4;
    damp_tol = 1e-4;
    mac_tol = 0.99;

    % Anzahl der Cluster holen
    num_cluster = max(cluster_label);

    % Array für modale Parameter instanziieren
    mod_param_array = struct([]);

    % Alle Cluster durchlaufen
    for c = 1:num_cluster

        % Pole dieses Clusters holen
        mask = (cluster_label == c);
        cluster_pole = stable_pole(mask);

        % Modale Parameter des Clusters berechnen
        mode_info = compute_cluster_statistics_regardless_stability(cluster_pole);
    
        % Modale Paramter speichern
        mod_param_array(c).freq_mean = mode_info.mean_frequency;
        mod_param_array(c).damp_mean = mode_info.mean_damping;
        mod_param_array(c).mode_shape_mean = mode_info.mean_mode_shape;
    end

    % Neue Labels instanziieren
    cluster_label_new = cluster_label;

    % Markierung für bereits zusammengeführte Cluster instanziieren
    merged = false(num_cluster,1);

    % Alle Cluster durchlaufen
    for i = 1:num_cluster

        % Wenn dieses Cluster bereits zusammengeführt wurde
        if merged(i)

            % Dieses Cluster überspringen
            continue;
        end

        % Alle Cluster durchlaufen
        for j = i+1:num_cluster

            % Wenn dieses Cluster bereits zusammengeführt wurde
            if merged(j)

                % Dieses Cluster überspringen
                continue;
            end

            % Frequenzdifferenz
            freq_diff = abs(mod_param_array(i).freq_mean - mod_param_array(j).freq_mean);

            % Dämpfungsdifferenz
            damp_diff = abs(mod_param_array(i).damp_mean - mod_param_array(j).damp_mean);

            % MAC berechnen
            phi1 = mod_param_array(i).mode_shape_mean;
            phi2 = mod_param_array(j).mode_shape_mean;
            mac_value = compute_mac_value(phi1, phi2);

            % Wenn die zwei Cluster identisch sind (Grenzwerte erfüllt)
            if freq_diff < freq_tol && damp_diff < damp_tol && mac_value > mac_tol

                % Cluster j in Cluster i überführen
                cluster_label_new(cluster_label == j) = i;

                % Als "zusammengeführt" markieren
                merged(j) = true;
            end
        end
    end

    % Cluster erneut nummerieren
    unique_labels = unique(cluster_label_new);
    for k = 1:length(unique_labels)
        cluster_label_new(cluster_label_new == unique_labels(k)) = k;
    end
end