%% Callback für Button zum Durchführen der Zustandsüberwachung (SSI-DATA)
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function run_monitor_button_pushed_ssi_data(fig, app, segment_info)

    % Nötige Variablen holen
    freq_limit = str2double(app.freq_limit_edit_field_monitor.Value);               % Frequenzgrenze
    num_segment = str2double(app.num_segment_edit_field.Value);                     % Anzahl der Abschnitte
    freq_threshold = app.damage_freq_spinner.Value;                                 % Frequenzgrenze für Modenzuordnung
    mac_threshold = app.damage_mac_spinner.Value;                                   % MAC-Grenze für Modenzuordnung
    num_row_hankel = str2double(app.num_row_hankel_edit_field_monitor.Value);       % Zeilenanzahl der Hankelmatrix
    num_col_hankel = str2double(app.num_col_hankel_edit_field_monitor.Value);       % Spaltenanzahl der Hankelmatrix
    max_model_order = str2double(app.max_model_order_edit_field2_monitor.Value);    % Maximale Model-Order
    freq_variation = app.freq_variation_spinner2_monitor.Value;                     % Grenzwert für stabile Frequenz
    damping_variation = app.damping_variation_spinner2_monitor.Value;               % Grenzwert für stabilen Dämpfungsgrad
    mac = app.mac_spinner5_monitor.Value;                                           % Grenzwert für "MAC-Bedingung erfüllt"
    crit_stable_freq_tick = app.criteria_stable_freq_check2_monitor.Value;          % Wahl für stabile Frequenz
    crit_stable_damp_tick = app.criteria_stable_damp_check2_monitor.Value;          % Wahl für stabilen Dämpfungsgrad
    crit_mac_tick = app.criteria_mac_check2_monitor.Value;                          % Wahl für MAC-Bedingung erfüllt
    cluster_distance = app.cluster_distance_spinner2_monitor.Value;                 % Cluster-Distanzschwelle
    oma_dropdown = app.oma_dropdown2;                                               % Dropdown für OMA-Methoden
    step_table = app.step_table;                                                    % Tabelle für Abschnitte
    freq_time_graph = app.freq_time_graph;                                          % Frequenz-Zeit-Plot
    oma_ssi_data_check2 = app.oma_ssi_data_check2_monitor;                          % Wahl für SSI-DATA (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table = app.freq_damp_table2_monitor;                                 % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_ssi_data_check3 = app.oma_ssi_data_check3_monitor;                          % Wahl für SSI-DATA (Sub-Tab "Freq.-Zeit-Plot", Tab "Export")
    lamp = app.status_lamp;                                                         % Licht des Status
    status = app.status_text_area;                                                  % Textfeld des Status    

    % Infos holen
    sampling_freq = app.fig.UserData.cache.monitor.sampling_freq;
    num_sensor = app.fig.UserData.cache.monitor.num_sensor;
    direction = app.fig.UserData.cache.monitor.direction;

    % Referenzmoden holen
    ref_eigenfreq = app.fig.UserData.cache.monitor.ref_eigenfreq;
    ref_eigenvector = app.fig.UserData.cache.monitor.ref_eigenvector;

    % Die Eigenformen der Referenzmoden für MAC-Vergleich anpassen
    ref_eigenvector = cellfun(@(x) reshape(x', [], 1), ref_eigenvector, 'UniformOutput', false);        

    % Anzahl der Referenzmoden
    num_ref_mode = length(ref_eigenfreq);    

    % Strukturarray für Ergebnisse instanziieren
    new_all_pole_all_segment = struct([]);
    freq_all_segment_for_tracking = cell(1, num_segment);
    damp_all_segment_for_tracking = cell(1, num_segment);
    mode_shape_all_segment_for_tracking = cell(1, num_segment);
    cluster_quality_for_tracking = cell(1, num_segment);

    % Wenn aktuelle Parameter der SSI-DATA mit benutzten Parametern
    % übereinstimmen
    if isequal(app.fig.UserData.cache.monitor.used_parameter.data, app.fig.UserData.cache.monitor.current_parameter.data)  

        % Vorherige Ergebnisse holen
        prev_all_pole_all_segment = app.fig.UserData.cache.monitor.data_all_pole;

        % Wenn aktuelle Parameter der Cluster-Analyse mit benutzten Parametern
        % übereinstimmen
        if isequal(app.fig.UserData.cache.monitor.used_parameter.data_cluster, app.fig.UserData.cache.monitor.current_parameter.data_cluster)  

            % Vorherige Ergebnisse der Cluster-Analyse holen
            prev_selected_pole_all_segment = app.fig.UserData.cache.monitor.data_selected_pole;
            prev_cluster_quality = app.fig.UserData.cache.monitor.data_cluster_quality;
            prev_unselected_counter_all_segment = app.fig.UserData.cache.monitor.data_unselected_counter;

            % Nachricht
            message = '>> Vorherige Ergebnisse der SSI-DATA und Cluster-Analyse geholt.';
            type = 'erfolg';

        % Sonst
        else

            % Nichts zurückgeben
            prev_selected_pole_all_segment = [];

            % Nachricht
            message = '>> Vorherige Ergebnisse der SSI-DATA geholt. Cluster-Analyse fängt gleich an...';
            type = 'warnung';
        end 

    % Sonst
    else

        % Nichts zurückgeben
        prev_all_pole_all_segment = [];
        prev_selected_pole_all_segment = [];

        % Nachricht
        message = '>> SSI-DATA und Cluster-Analyse fangen gleich an...';
        type = 'warnung';
    end

    % Status aktualisieren
    update_status(status, lamp, message, type);
    pause(1); 

    % Alle Abschnitte durchlaufen
    for k= 1:num_segment    

        % Messdaten dieses Abschnitts
        data_this_segment = segment_info(k).data(:,2:end);        

        % Wenn Ergebnisse der SSI-DATA bereits vorhanden ist
        if ~isempty(prev_all_pole_all_segment)

            % Ergebnisse dieses Abschnitts holen
            all_pole_this_segment = prev_all_pole_all_segment{k};

            % Alle Pole als "nicht gewählt" markieren
            [all_pole_this_segment.is_chosen] = deal(false);            

        % Sonst
        else                         

            % SSI-DATA durchführen
            all_pole_this_segment = compute_ssi_data(fig, data_this_segment, ...
                sampling_freq, freq_limit, num_row_hankel, num_col_hankel, ...
                max_model_order, freq_variation, damping_variation, ...
                mac, k, num_segment);                           
        end

        % Wenn Ergebnisse der Cluster-Analyse bereits vorhanden ist
        if ~isempty(prev_selected_pole_all_segment) 

            % Ergebnisse dieses Abschnitts holen
            selected_pole_this_segment = prev_selected_pole_all_segment{k};
            unselected_counter_this_segment = prev_unselected_counter_all_segment(k);
            cluster_quality_this_segment = prev_cluster_quality{k};

            % Gewählte Pole als "gewählt" markieren
            for m = 1:numel(selected_pole_this_segment)
                selected_idx_this_mode = selected_pole_this_segment(m).pole_idx;
                for n = 1:numel(selected_idx_this_mode)
                    all_pole_this_segment(selected_idx_this_mode(n)).is_chosen = true;
                end            
            end   

        % Sonst
        else

            % Eingabe für Polauswahl, wobei die Zielanzahl der Moden 
            % doppelt so viel wie Referenzmoden (weil Eigenfrequenzänderungen 
            % innerhalb eines Abschnitts auftretten könnten) 
            user_input.crit_stable_freq = crit_stable_freq_tick;
            user_input.crit_stable_damp = crit_stable_damp_tick;
            user_input.crit_mac = crit_mac_tick;
            user_input.num_mode_known = true;
            user_input.cluster_distance = cluster_distance;
            user_input.target_num = num_ref_mode*2;
            user_input.target_num_ref = num_ref_mode;                        

            % Polauswahl durchführen
            [all_pole_this_segment, selected_pole_this_segment, unselected_counter_this_segment, cluster_quality_this_segment] ...
                = identify_pole_automatic(fig, all_pole_this_segment, user_input, k, num_segment);
        end

        % Ergebnisse speichern
        new_all_pole_all_segment(k).data_all_pole = all_pole_this_segment;
        new_all_pole_all_segment(k).data_selected_pole = selected_pole_this_segment;
        new_all_pole_all_segment(k).data_unselected_counter = unselected_counter_this_segment;
        freq_all_segment_for_tracking{k} = [selected_pole_this_segment.freq_mean];
        damp_all_segment_for_tracking{k} = [selected_pole_this_segment.damp_mean];
        cluster_quality_for_tracking{k} = cluster_quality_this_segment;

        % Falls gemessene Richtungen weniger als 3, müssen die Eigenformen
        % angepasst werden, damit sie für MAC-Vergleich geeignet sind
        if sum(direction) ~= 3        

            % Alle Eigenformen dieses Segments holen
            mode_shape_this_segment = [selected_pole_this_segment.mode_shape_mean];
            
            % Eigenformen in 3D instanziieren
            mode_shape_this_segment_3d = zeros(num_sensor*3, size(mode_shape_this_segment,2));
            
            % Alle Eigenformen durchlaufen
            for j = 1:size(mode_shape_this_segment,2)
            
                % Aktuelle Eigenform holen
                this_mode_shape = mode_shape_this_segment(:,j);
            
                % Eigenform anpassen
                mode_shape_this_segment_3d(:,j) = reshape_eigenform(this_mode_shape, num_sensor, direction);
            end
            
            % Eigenform einordnen
            mode_shape_all_segment_for_tracking{k} = mode_shape_this_segment_3d;       

        % Sonst direkt einordnen
        else
            mode_shape_all_segment_for_tracking{k} = [selected_pole_this_segment.mode_shape_mean];
        end
    end

    % Frequenz über Zeit verfolgen
    [track_freq, track_phi, used_mode, track_damp] = track_freq_across_time(ref_eigenfreq, ref_eigenvector, freq_all_segment_for_tracking, mode_shape_all_segment_for_tracking, cluster_quality_for_tracking, freq_threshold, mac_threshold, damp_all_segment_for_tracking);

    % Alle Abschnitte durchlaufen
    for k= 1:num_segment

        % Liste der benutzten Moden dieses Abschnitts holen
        used_this_segment = used_mode(k, :);

        % Ergebnisse holen
        all_pole_this_segment = new_all_pole_all_segment(k).data_all_pole;
        selected_pole = new_all_pole_all_segment(k).data_selected_pole;
        cluster_quality = cluster_quality_for_tracking{k};
        unselected_counter = new_all_pole_all_segment(k).data_unselected_counter;

        % Unbenutzte Moden entfernen
        selected_pole = selected_pole(used_this_segment);
        cluster_quality = cluster_quality(used_this_segment);
        unselected_diff = sum(~used_this_segment);

        % Pole erneut markieren
        [all_pole_this_segment.is_chosen] = deal(false); 
        for m = 1:numel(selected_pole)
            selected_idx_this_mode = selected_pole(m).pole_idx;
            for n = 1:numel(selected_idx_this_mode)
                all_pole_this_segment(selected_idx_this_mode(n)).is_chosen = true;
            end            
        end

        % Ergebnisse zurückgeben
        new_all_pole_all_segment(k).data_all_pole = all_pole_this_segment;
        new_all_pole_all_segment(k).data_selected_pole = selected_pole;
        new_all_pole_all_segment(k).data_cluster_quality = cluster_quality;
        new_all_pole_all_segment(k).data_unselected_counter = unselected_counter + unselected_diff;
    end

    % Parameter speichern
    app.fig.UserData.cache.monitor.used_parameter.data = app.fig.UserData.cache.monitor.current_parameter.data;  
    app.fig.UserData.cache.monitor.used_parameter.data_cluster = app.fig.UserData.cache.monitor.current_parameter.data_cluster;  

    % Ergebnisse speichern
    app.fig.UserData.cache.monitor.data_all_pole = {new_all_pole_all_segment.data_all_pole};
    app.fig.UserData.cache.monitor.data_selected_pole = {new_all_pole_all_segment.data_selected_pole};
    app.fig.UserData.cache.monitor.data_cluster_quality = {new_all_pole_all_segment.data_cluster_quality};
    app.fig.UserData.cache.monitor.data_unselected_counter = [new_all_pole_all_segment.data_unselected_counter];
    app.fig.UserData.cache.monitor.track_freq.ssi_data = track_freq;
    app.fig.UserData.cache.monitor.track_phi.ssi_data = track_phi;
    app.fig.UserData.cache.monitor.track_damp.ssi_data = track_damp;

    % Ergebnisse in restlichen GUI-Komponenten aktualisieren
    update_result_monitor(step_table, segment_info, freq_time_graph, track_freq, ref_eigenfreq, oma_dropdown, ...
        "SSI-DATA", freq_damp_table, oma_ssi_data_check2, oma_ssi_data_check3);           
end