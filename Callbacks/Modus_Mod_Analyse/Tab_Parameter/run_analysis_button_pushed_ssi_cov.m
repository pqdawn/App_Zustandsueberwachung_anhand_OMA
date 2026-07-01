%% Callback für Button zum Durchführen der Modalanalyse (SSI-COV)
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function run_analysis_button_pushed_ssi_cov(fig, app)

    % Nötige Variablen holen
    freq_limit = str2double(app.freq_limit_edit_field.Value);           % Frequenzgrenze
    max_lag = str2double(app.max_lag_edit_field.Value);                 % Maximaler verzögerter Zeitschritt
    max_model_order = str2double(app.max_model_order_edit_field.Value); % Maximale Model-Order
    freq_variation = app.freq_variation_spinner.Value;                  % Grenzwert für stabile Frequenz
    damping_variation = app.damping_variation_spinner.Value;            % Grenzwert für stabilen Dämpfungsgrad
    mac = app.mac_spinner.Value;                                        % Grenzwert für "MAC-Bedingung erfüllt"
    auto_pol_choice = app.auto_pol_switch.Value;                        % Wahl für automatische Polauswahl
    crit_stable_freq_tick = app.criteria_stable_freq_check.Value;       % Wahl für stabile Frequenz
    crit_stable_damp_tick = app.criteria_stable_damp_check.Value;       % Wahl für stabilen Dämpfungsgrad
    crit_mac_tick = app.criteria_mac_check.Value;                       % Wahl für MAC-Bedingung erfüllt
    num_mode_known_choice= app.num_mode_known_ssi_cov.Value;            % Wahl für Anzahl der Moden
    cluster_distance = app.cluster_distance_spinner.Value;              % Cluster-Distanzschwelle
    min_cluster_size = app.min_cluster_size_spinner.Value;              % Mindestgröße eines Clusters
    target_num = app.target_num_spinner_ssi_cov.Value;                  % Zielanzahl
    measurement_dropdown = app.measurement_dropdown;                    % Dropdown für Messdaten
    all_poles_tick = app.all_poles_check.Value;                         % Wahl des Filters für alle berechneten Pole
    stable_freq_tick = app.stable_freq_check.Value;                     % Wahl des Filters für stabile Frequenz
    stable_damp_tick = app.stable_damp_check.Value;                     % Wahl des Filters für stabilen Dämpfungsgrad
    mac_tick = app.mac_check.Value;                                     % Wahl des Filters für "MAC-Bedingung erfüllt"
    filter_or_tick = app.filter_or_radio.Value;                         % Wahl der Filters für "oder"
    filter_and_tick = app.filter_and_radio.Value;                       % Wahl der Filters für "und"    
    pole_chosen_tick = app.pole_chosen_switch.Value;                    % Wahl des Filters für gewählte Pole    
    stab_graph = app.stab_graph;                                        % Graph für Stabilisationsdiagramm
    slider = app.stab_graph_slider;                                     % Slider für x-Achse des Stabilisationsdiagramms
    range_check = app.stab_graph_range_check;                           % Checkbox für fixierten Bereich der x-Achse
    range_edit_field = app.stab_graph_range_edit_field;                 % Eingabefeld für fixierten Bereich der x-Achse
    transfer_button = app.transfer_choice_button;                       % Button für Übertragung der Auswahlen
    freq_table = app.freq_table;                                        % Tabelle für Frequenzen
    oma_dropdown = app.oma_dropdown;                                    % Dropdown für OMA-Methoden
    freq_damp_table = app.freq_damp_table;                              % Tabelle für Ergebnisse (Tab "Ergebnis")
    eigenform_graph = app.eigenform_graph;                              % Graph für Eigenform
    oma_ssi_cov_check2 = app.oma_ssi_cov_check2;                        % Wahl für SSI-COV (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table2 = app.freq_damp_table2;                            % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_ssi_cov_check3 = app.oma_ssi_cov_check3;                        % Wahl für SSI-COV (Sub-Tab "Eigenform", Tab "Export")
    freq_damp_table3 = app.freq_damp_table3;                            % Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                             % Licht des Status
    status = app.status_text_area;                                      % Textfeld des Status

    % Messdaten und Infos holen
    data_matrix = app.fig.UserData.cache.modal.data_matrix;
    data_matrix_diff = app.fig.UserData.cache.modal.data_matrix_diff;
    sampling_freq = app.fig.UserData.cache.modal.sampling_freq;    

    % Wenn aktuelle Parameter mit benutzten Parametern nicht
    % übereinstimmen, SSI-COV durchführen
    if ~isequal(app.fig.UserData.cache.modal.used_parameter.cov, app.fig.UserData.cache.modal.current_parameter.cov)   

        % Status aktualisieren
        update_status(status, lamp, '>> SSI-COV fängt gleich an...', 'warnung');
        pause(1);        

        % Messdaten der Sensoren
        sensor_data = data_matrix(:,2:end);        

        % SSI-COV durchführen
        all_pole = compute_ssi_cov(fig, sensor_data, ...
         sampling_freq, freq_limit, max_lag, max_model_order, freq_variation, damping_variation, mac);

        % Variable speichern
        app.fig.UserData.cache.modal.cov_all_pole = all_pole;                  

        % Stabilisationsdiagramm plotten
        plot_stab_diag(stab_graph, all_pole, all_poles_tick, ...
            stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, ...
            filter_or_tick, filter_and_tick, 'SSI-COV', 1, freq_limit, slider, ...
            range_check, range_edit_field);        

        % Falls abgeleitete Messdaten vorhanden sind, muss SSI-COV auch darauf
        % durchgeführt werden
        if ~isnan(data_matrix_diff)     

            % Status aktualisieren
            update_status(status, lamp, '>> SSI-COV wird noch auf abgeleitete Messdaten durchgeführt...', 'warnung');
            pause(1);
    
            % Messdaten der Sensoren
            sensor_data_diff = data_matrix_diff(:,2:end);
    
            % SSI-COV durchführen
            all_pole = compute_ssi_cov(fig, sensor_data_diff, ...
             sampling_freq, freq_limit, max_lag, max_model_order, freq_variation, damping_variation, mac);

            % Variable speichern
            app.fig.UserData.cache.modal.cov_all_pole_diff = all_pole;      

            % Dropdown für Messdaten aktualisieren
            measurement_dropdown.Value = 2;     

            % Stabilisationsdiagramm plotten
            plot_stab_diag(stab_graph, all_pole, all_poles_tick, ...
                stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, ...
                filter_or_tick, filter_and_tick, 'SSI-COV', 2);               
        end

        % Parameter für SSI-COV speichern
        app.fig.UserData.cache.modal.used_parameter.cov = app.fig.UserData.cache.modal.current_parameter.cov;        

        % Nachricht für Status
        message = '>> SSI-COV durchgeführt und Stabilisationsdiagramm aktualisiert';        

    % Sonst
    else

        % Vorherige Ergebnisse holen
        all_pole = app.fig.UserData.cache.modal.cov_all_pole;

        % Alle Pole als "nicht gewählt" markieren
        [all_pole.is_chosen] = deal(false);

        % Variable speichern
        app.fig.UserData.cache.modal.cov_all_pole = all_pole;          

        % Stabilisationsdiagramm plotten
        plot_stab_diag(stab_graph, all_pole, all_poles_tick, ...
            stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, ...
            filter_or_tick, filter_and_tick, 'SSI-COV', 1, freq_limit, slider, ...
            range_check, range_edit_field);        

        % Falls abgeleitete Messdaten vorhanden sind, müssen ihre
        % Ergebnisse noch abgeholt werden
        if ~isnan(data_matrix_diff)  

            % Vorherige Ergebnisse holen
            all_pole = app.fig.UserData.cache.modal.cov_all_pole_diff;

            % Alle Pole als "nicht gewählt" markieren
            [all_pole.is_chosen] = deal(false);  

            % Variable speichern
            app.fig.UserData.cache.modal.cov_all_pole_diff = all_pole;             

            % Dropdown für Messdaten aktualisieren
            measurement_dropdown.Value = 2;

            % Stabilisationsdiagramm plotten
            plot_stab_diag(stab_graph, all_pole, all_poles_tick, ...
                stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, ...
                filter_or_tick, filter_and_tick, 'SSI-COV', 2);             
        end

        % Nachricht für Status
        message = '>> Vorherige Ergebnisse der SSI-COV geholt und Stabilisationsdiagramm aktualisiert';  
    end

    % Status aktualisieren
    update_status(status, lamp, message, 'erfolg');
    pause(1);

    % Falls automatische Polauswahl angeschaltet ist
    if strcmp(auto_pol_choice, 'An')

        % Wenn aktuelle Parameter mit benutzten Parametern nicht
        % übereinstimmen, oder abgeleitete Messdaten vorhanden sind, 
        % Cluster-Analyse durchführen (Für abgeleitete Messdaten wird die
        % Cluster-Analyse zwangsläufig immer erneut durchführen, um
        % Probleme später bei Übertragung der Pole zu vermeiden)
        if ~isequal(app.fig.UserData.cache.modal.used_parameter.cov_cluster, app.fig.UserData.cache.modal.current_parameter.cov_cluster) ...
            || ~isnan(data_matrix_diff(1,1))
    
            % Status aktualisieren
            update_status(status, lamp, '>> Cluster-Analyse fängt gleich an...', 'warnung');
            pause(1);                
        
            % Eingabe für Polauswahl als Structure zusammenfassen
            user_input.crit_stable_freq = crit_stable_freq_tick;
            user_input.crit_stable_damp = crit_stable_damp_tick;
            user_input.crit_mac = crit_mac_tick;
            user_input.num_mode_known = num_mode_known_choice;
            user_input.cluster_distance = cluster_distance;
            if num_mode_known_choice
                user_input.target_num = target_num;
            else
                user_input.min_cluster_size = min_cluster_size;
            end
            
            % Polauswahl durchführen
            [all_pole, selected_pole, unselected_counter] = identify_pole_automatic(fig, all_pole, user_input);

            % Nachricht für Status
            message = '>> Pole automatisch ausgewählt';            

        % Sonst
        else
    
            % Vorherige Ergebnisse holen
            selected_pole = app.fig.UserData.cache.modal.cov_selected_pole;
            unselected_counter = app.fig.UserData.cache.modal.cov_unselected_counter;

            % Gewählte Pole als "gewählt" markieren
            for i = 1:numel(selected_pole)
                stable_idx_this_mode = selected_pole(i).pole_idx;
                for k = 1:numel(stable_idx_this_mode)
                    all_pole(stable_idx_this_mode(k)).is_chosen = true;
                end            
            end
    
            % Nachricht für Status
            message = '>> Vorherige Ergebnisse der Cluster-Analyse geholt';  
        end            
    
        % Fehlermeldung falls keine Pole gefunden wurden
        if isempty(selected_pole)
            error('Keine Pole gefunden, die alle Kriterien erfüllen!');                
        end

        % Warnung falls die gewünschten Anzahl der Moden nicht erfüllt ist
        if num_mode_known_choice && numel(selected_pole) < target_num
            update_status(status, lamp, '>> Anzahl der identifizierten Cluster weniger als Zielanzahl!', 'warnung');
            pause(1);
        end

        % Tabelle aktualisieren
        title = {'Frequenz [Hz]'};
        freq_table.ColumnName = title;
        freq_table.Data = [selected_pole.freq_mean]';

        % Falls abgeleitete Messdaten vorhanden sind, wurden die
        % Polauswahl für abgeleitete Messdaten durchgeführt
        if ~isnan(data_matrix_diff)
            
            % Stabilisationsdiagramm plotten
            plot_stab_diag(stab_graph, all_pole, all_poles_tick, ...
                stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, filter_or_tick, filter_and_tick, 'SSI-COV', 2);                

            % Variablen für gewählte Pole speichern
            app.fig.UserData.cache.modal.cov_all_pole_diff = all_pole;
            app.fig.UserData.cache.modal.cov_selected_pole_diff = selected_pole;
            app.fig.UserData.cache.modal.cov_unselected_counter = unselected_counter;

            % Gewählte Pole der originalen Messdaten löschen
            app.fig.UserData.cache.modal.cov_selected_pole = struct([]);

            % Dropdown für Messdaten aktualisieren
            measurement_dropdown.Value = 2;

            % Button für Übertragung der Auswahlen aktivieren
            transfer_button.Enable = 'on';

        % Ansonsten wurden die Polauswahl für originale Messdaten
        % durchgeführt. In diesem Fall müssen weitere Tabelle 
        % aktualisiert werden
        else

            % Stabilisationsdiagramm plotten
            plot_stab_diag(stab_graph, all_pole, all_poles_tick, ...
                stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, filter_or_tick, filter_and_tick, 'SSI-COV', 1);                  

            % Variablen für gewählte Pole speichern
            app.fig.UserData.cache.modal.cov_all_pole = all_pole;
            app.fig.UserData.cache.modal.cov_selected_pole = selected_pole; 
            app.fig.UserData.cache.modal.cov_unselected_counter = unselected_counter;

            % Ergebnisse holen
            eigenfreq_chosen = [selected_pole.freq_mean]';
            damping_ratio_chosen = [selected_pole.damp_mean]';

            % Ergebnisse in restlichen GUI-Komponenten aktualisieren
            update_result(eigenform_graph, eigenfreq_chosen, damping_ratio_chosen, oma_dropdown, ...
                "SSI-COV", freq_damp_table, freq_damp_table2, freq_damp_table3, oma_ssi_cov_check2, oma_ssi_cov_check3);                
        end

        % Parameter für Cluster-Analyse speichern
        app.fig.UserData.cache.modal.used_parameter.cov_cluster = app.fig.UserData.cache.modal.current_parameter.cov_cluster;            
    
        % Status aktualisieren
        message_num_end = sprintf('Anzahl der endgültigen Cluster: %d\n', numel(selected_pole));
        message_num_rej = sprintf('Anzahl der abgelehnten Cluster: %d\n', unselected_counter);
        message_num_clus = sprintf('Anzahl der identifizierten Cluster: %d\n', (numel(selected_pole)+unselected_counter));
        message_cluster = 'Ergebnisse der Cluster-Analyse: ';
        update_status(status, lamp, '----------------------------------------------------------', 'erfolg');
        update_status(status, lamp, message_num_end, 'erfolg');
        update_status(status, lamp, message_num_rej, 'erfolg');
        update_status(status, lamp, message_num_clus, 'erfolg');
        update_status(status, lamp, message_cluster, 'erfolg');
        update_status(status, lamp, '----------------------------------------------------------', 'erfolg');

        % Nachricht für Status
        update_status(status, lamp, message, 'erfolg'); 

    % Falls automatische Polauswahl ausgeschaltet ist
    else
        
        % Vorherige Ergebnisse, die von SSI-COV abhängig sind, löschen
        app.fig.UserData.cache.modal.cov_selected_pole = struct([]);
        app.fig.UserData.cache.modal.cov_selected_pole_diff = struct([]);
        app.fig.UserData.cache.modal.cov_unselected_counter = struct([]);        
    end
end