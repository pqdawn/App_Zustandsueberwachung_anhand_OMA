%% Funktion zum Algorithmus der SSI-COV
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    fig = Figur der App
%                       sensor_data = Messdaten
%                       sampling_freq = Abtastfrequenz
%                       freq_limit = Frequenzgrenze
%                       max_lag = Maximaler verzögerter Zeitschritt
%                       max_model_order = Maximale Model-Order
%                       freq_variation_selected = Grenzwert für stabile Frequenz
%                       damping_variation_selected = Grenzwert für stabilen Dämpfungsgrad
%                       mac_selected = Grenzwert für "MAC-Bedingung erfüllt"
%                       it_current = Aktueller Iterationsschritt für Zustandsüberwachung
%                       it_total = Gesamte Iterationsschritte für Zustandsüberwachung

% Ausgabeparameter:     all_pole = Strukturarray für gesamte Ergebnisse

function all_pole = compute_ssi_cov(fig, sensor_data, sampling_freq, freq_limit, max_lag, ...
    max_model_order, freq_variation_selected, damping_variation_selected, mac_selected, it_current, it_total)  
    
    % Wenn Iterationsschritte nicht eingegeben wurden, handelt es sich um Modalanalyse
    if nargin == 9

        % Progressbar ohne Iterationsschritt instanziieren
        progressbar = uiprogressdlg(fig, 'Title', 'SSI-COV',...
            'Message', 'Es fängt gleich an...', 'Cancelable', 'on', 'CancelText', 'Stop');

    % Sonst handelt es sich um Zustandsüberwachung
    else
    
        % Progressbar mit Iterationsschritt instanziieren
        progressbar_msg = ['Abschnitt ', num2str(it_current), ' von ', ...
            num2str(it_total), ' (SSI-COV)'];
        progressbar = uiprogressdlg(fig, 'Title', progressbar_msg ,...
            'Message', 'Es fängt gleich an...', 'Cancelable', 'on', 'CancelText', 'Stop');
    end

    % Progressbar zeichnen
    drawnow;

    % Konstante und lineare Trends entfernen
    sensor_data = detrend(sensor_data);    

    % Matrix für alle Kovarianzmatrizen instanziieren
    [num_samples, num_sensors] = size(sensor_data);
    cov_matrices = cell(2*max_lag-1, 1);

    % Schleife über alle verzögerten Zeitschritte
    for lag = 0:2*max_lag-2

        % Falls "Abbrechen" im Progressbar betätigt wird, Vorgang abbrechen
        % und Fehler zeigen
        if progressbar.CancelRequested
            error('SSI-COV abgebrochen!');
        end

        % Progressbar aktualisieren (erstmal nur bis 50%)
        progress_Value = lag/(2*max_lag-2) * 0.5;
        progressbar.Value = progress_Value;
        progressbar.Message = sprintf('Kovarianzmatrizen werden erstellt...');

        % Kovarianzmatrix für jeden maximalen verzögerten Zeitschritt erstellen
        cov_matrices{lag + 1} = (sensor_data(lag+1:end, :)' * sensor_data(1:end-lag, :)) / (num_samples - lag);
    end

    % Größe der Toeplitzmatrix berechnen
    num_block_row = max_lag;
    block_size = num_sensors * num_block_row;
    
    % Toeplitzmatrix instanziieren
    Toeplitz_matrix = zeros(block_size, block_size);
    
    % Schleife über alle Zeilen der Toeplitzmatrix
    for i = 1:num_block_row

        % Schleife über alle Spalten der Toeplitzmatrix
        for j = 1:num_block_row

            % Obere Dreiecksmatrix
            if j >= i

                % Kovarianzmatrizen zuordnen
                Toeplitz_matrix((i-1)*num_sensors+1:i*num_sensors, (j-1)*num_sensors+1:j*num_sensors) = cov_matrices{num_block_row-j+i};
            
            % Untere Dreiecksmatrix
            else

                % Kovarianzmatrizen zuordnen
                Toeplitz_matrix((i-1)*num_sensors+1:i*num_sensors, (j-1)*num_sensors+1:j*num_sensors) = cov_matrices{num_block_row-j+i}';
            end
        end
    end

    % Progressbar aktualisieren
    progressbar.Message = sprintf('SVD wird durchgeführt...');

    % SVD der Toeplitzmatrix
    [U, S, ~] = svd(Toeplitz_matrix, 'econ');
    
    % Variablen für Ergebnisse instanziieren
    eigenfreq = [];
    damping_ratio = [];
    mode_shape = [];
    model_order = [];

    % Zeitintervall
    dt = 1/sampling_freq;
    
    % Variablen für Berechnung der stabilen Frequenzen
    prev_freq = [];
    stable_freq = [];
    
    % Variablen für Berechnung der stabilen Dämpfungsgrade
    prev_zeta = [];
    stable_zeta = [];
    
    % Variablen für Berechnung der MAC-Bedingung erfüllten Eigenformen
    prev_phi = [];
    mac_fulfilled = [];
    
    % Schleife über alle Model-Order (hier wird nur jeder zweite Eigenwert
    % betrachtet, weil die Eigenwerte immer als komplex-konjugiertes Paar
    % auftreten, und damit sie im Verlauf immer paarweise betrachtet werden)
    for order = 2:2:max_model_order

        % Falls "Abbrechen" im Progressbar betätigt wird, Vorgang abbrechen
        % und Fehler zeigen
        if progressbar.CancelRequested
            error('SSI-COV abgebrochen!');
        end
    
        % Progressbar aktualisieren (50% bis 100%)
        progress_Value = 0.5 + order/max_model_order * 0.5;
        progressbar.Value = progress_Value;
        progressbar.Message = sprintf('Zustandsräume werden gelöst...');
        
        % Verkürzte Matrizen U und S abhängig von Model-Order bilden
        U_order = U(:, 1:order);
        S_order = S(1:order, 1:order);

        % Extended-Observability-Matrix berechnen
        Ob = U_order * sqrt(S_order);
    
        % Systemmatrix berechnen
        A_est = pinv(Ob(1:end-num_sensors, :)) * Ob(num_sensors+1:end, :);

        % Ausgangsmatrix berechnen
        C_est = Ob(1:num_sensors, :);
    
        % Eigenwertzerlegung der Matrix A
        [eigenvectors, eigenvalues] = eig(A_est);
    
        % Eigenwerte aus der Diagonalmatrix holen (im zeitdiskreten Raum)
        eigenvalues = diag(eigenvalues);

        % In zeitkontinuierlichen Raum umrechnen
        eigenvalues = log(eigenvalues) / dt;
    
        % Es werden nur Eigenwerte mit einem negativen realen Wert für
        % weitere Berechnungen angewendet (positive Eigenwerte führen zum 
        % aufklingenden System!)
        eigenvalues_real = real(eigenvalues) < 0;
        eigenvalues = eigenvalues(eigenvalues_real);
        
        % Eigenkreisfrequenzen berechnen
        omega = abs(eigenvalues);

        % Eigenfrequenzen berechnen
        freq = omega / (2 * pi);

        % Zugehörige Dämpfungsgrade berechnen
        zeta = -real(eigenvalues) ./ abs(eigenvalues);

        % Eigenformen berechnen
        phi = (C_est*eigenvectors);
    
        % Eigenfrequenzen sortieren (klein -> groß)
        [freq_sorted, sorted_indices] = sort(freq);

        % Dämpfungsgrade und Eigenformen abhängig davon sortieren
        zeta_sorted = zeta(sorted_indices);
        phi_sorted = phi(:, sorted_indices);

        % Ergebnisse unterhalb der Frequenzgrenze weiter betrachten
        limit_mask = freq_sorted <= freq_limit;
        freq_sorted = freq_sorted(limit_mask);
        zeta_sorted = zeta_sorted(limit_mask);
        phi_sorted = phi_sorted(:, limit_mask);
    
        % Für Model-Order größer als 2, werden die Ergebnisse verglichen
        if order > 2
            
            % Die kleinere Anzahl an Eigenformen holen (zwischen
            % Ergebnissen der aktuellen Model-Order und denen der
            % vorherigen Model-Order)
            num_eigenfreq = min([length(prev_freq) length(freq_sorted)]);

            % Schleife über alle Eigenfrequenzen
            for k = 1:num_eigenfreq
    
                % Stabilität für Frequenzen berechnen
                stability_freq = abs((freq_sorted(k) - prev_freq(k)) / prev_freq(k)) * 100;

                % Falls der Grenzwert für stabile Frequenz erfüllt ist, in 
                % die Liste einfügen
                if stability_freq < freq_variation_selected
                    stable_freq = [stable_freq; order, freq_sorted(k)];
                end
    
                % Stabilität für Dampfüngsgrade berechnen
                stability_zeta = abs((zeta_sorted(k) - prev_zeta(k)) / prev_zeta(k)) * 100;

                % Falls der Grenzwert für stabilen Dämpfungsgrad erfüllt 
                % ist, in die Liste einfügen
                if stability_zeta < damping_variation_selected
                    stable_zeta = [stable_zeta; order, freq_sorted(k), zeta_sorted(k)];
                end
    
                % MAC-Wert für Eigenformen berechnen
                mac_value = compute_mac_value(phi_sorted(:, k), prev_phi(:, k));

                % Falls der Grenzwert für "MAC-Bedingung erfüllt" erfüllt 
                % ist, in die Liste einfügen
                if mac_value > mac_selected/100
                    mac_fulfilled = [mac_fulfilled; order, freq_sorted(k), phi_sorted(:,k)'];
                end
            end
        end
    
        % Aktuelle Ergebnisse für nächste Model-Order speichern
        prev_freq = freq_sorted;
        prev_zeta = zeta_sorted;
        prev_phi = phi_sorted;
    
        % Gesamte Ergebnisse der aktuellen Model-Order speichern
        eigenfreq = [eigenfreq; freq_sorted];
        damping_ratio = [damping_ratio; zeta_sorted];
        mode_shape = [mode_shape phi_sorted];
        model_order = [model_order; order * ones(size(freq_sorted))];
    end

    % Anzahl der Pole entspricht Anzahl der Eigenfrequenzen
    num_pole = length(eigenfreq);
    
    % Strukturarray für Pole instanziieren
    all_pole(num_pole) = struct();
    [all_pole.is_stable_freq] = deal(false);
    [all_pole.is_stable_damp] = deal(false);
    [all_pole.is_mac] = deal(false);
    
    % Alle Pole durchlaufen
    for i = 1:num_pole

        % Ergebnisse dieses Pols speichern
        all_pole(i).eigenfreq = eigenfreq(i);
        all_pole(i).damping_ratio = damping_ratio(i);
        all_pole(i).mode_shape = mode_shape(:, i);
        all_pole(i).model_order = model_order(i);
    
        % Abhängig von Toleranzkriterien markieren
        if ~isempty(stable_freq)
            all_pole(i).is_stable_freq = ismember([model_order(i), eigenfreq(i)], stable_freq(:,1:2), 'rows');
        end
        if ~isempty(stable_zeta)
            all_pole(i).is_stable_damp = ismember([model_order(i), eigenfreq(i)], stable_zeta(:,1:2), 'rows');
        end
        if ~isempty(mac_fulfilled)
            all_pole(i).is_mac = ismember([model_order(i), eigenfreq(i)], mac_fulfilled(:,1:2), 'rows');
        end
    
        % Pol als "nicht gewählt" markieren
        all_pole(i).is_chosen = false;
    end

    % Progressbar schließen
    pause(1);
    close(progressbar);
end