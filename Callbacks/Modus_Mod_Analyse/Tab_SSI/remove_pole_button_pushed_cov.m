%% Callback für Button zum Entfernen der Pole (SSI-COV)
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function remove_pole_button_pushed_cov(app)
    
    % Nötige Variablen holen
    measurement = app.measurement_dropdown.Value;               % Dropdown der Messdaten
    all_poles_tick = app.all_poles_check.Value;                 % Wahl des Filters für alle berechneten Pole
    stable_freq_tick = app.stable_freq_check.Value;             % Wahl des Filters für stabile Frequenz
    stable_damp_tick = app.stable_damp_check.Value;             % Wahl des Filters für stabilen Dämpfungsgrad
    mac_tick = app.mac_check.Value;                             % Wahl des Filters für "MAC-Bedingung erfüllt"
    or_tick = app.filter_or_radio.Value;                        % Wahl der Filters für "oder"
    and_tick = app.filter_and_radio.Value;                      % Wahl der Filters für "und"      
    pole_chosen_tick = app.pole_chosen_switch.Value;            % Wahl des Filters für gewählte Pole
    graph = app.stab_graph;                                     % Graph für Stabilisationsdiagramm
    transfer_button = app.transfer_choice_button;	            % Button für Übertragung der Auswahlen
    freq_table = app.freq_table;                                % Tabelle für Frequenzen
    oma_dropdown = app.oma_dropdown;                            % Dropdown für OMA-Methoden
    freq_damp_table = app.freq_damp_table;                      % Tabelle für Ergebnisse (Tab "Ergebnis")
    eigenform_graph = app.eigenform_graph;                      % Graph für Eigenform
    update_eigenform_button = app.update_eigenform_button;      % Button für Darstellen der Eigenform
    oma_ssi_cov_check2 = app.oma_ssi_cov_check2;                % Wahl für SSI-COV (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table2 = app.freq_damp_table2;                    % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_ssi_cov_check3 = app.oma_ssi_cov_check3;                % Wahl für SSI-COV (Sub-Tab "Eigenform", Tab "Export")
    freq_damp_table3 = app.freq_damp_table3;                    % Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                     % Licht des Status
    status = app.status_text_area;                              % Textfeld des Status

    try
        % Fehlermeldung falls keine Daten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Fehlermeldung falls SSI-COV nicht durchgeführt
        if isempty(app.fig.UserData.cache.modal.cov_all_pole)
            error('SSI-COV nicht durchgeführt!');
        end

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
        end

        % Fehlermeldung falls Checkbox für gewählte Pole nicht an
        if strcmp(pole_chosen_tick, 'Aus')
            error('Gewählte Pole werden nicht dargestellt! Filter dafür erstmal aktivieren!')
        end

        % Wenn orignale Messdaten gewählt
        if measurement == 1

            % Pole holen
            all_pole = app.fig.UserData.cache.modal.cov_all_pole;
            selected_pole = app.fig.UserData.cache.modal.cov_selected_pole;
        
        % Wenn abgeleitete Messdaten gewählt
        elseif measurement == 2

            % Pole holen
            all_pole = app.fig.UserData.cache.modal.cov_all_pole_diff;
            selected_pole = app.fig.UserData.cache.modal.cov_selected_pole_diff;
        end

        % Fehlermeldung falls keine Pole gewählt wurden
        if isempty(selected_pole)
            error('Pole noch nicht gewählt!');
        end

        % Frequenzen der gewählten Pole holen
        freq_matrix = freq_table.Data;

        % Gewählte Zeile holen
        row_selected = freq_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(freq_matrix, 1)
            error('Keine Zeile gewählt!');
        end
        
        % Pole der zu löschenden Mode holen
        to_delete_idx = [selected_pole(row_selected).pole_idx];

        % Pole löschen
        selected_pole(row_selected) = [];

        % Diese Pole als "nicht gewählt" markieren
        for id = to_delete_idx'
            all_pole(id).is_chosen = false;
        end

        % Stabilisationsdiagramm aktualisieren
        plot_stab_diag(graph, all_pole, all_poles_tick, ...
            stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, or_tick, and_tick);

        % Wenn orignale Messdaten gewählt
        if measurement == 1

            % Variablen für gewählte Pole speichern
            app.fig.UserData.cache.modal.cov_all_pole = all_pole;
            app.fig.UserData.cache.modal.cov_selected_pole = selected_pole;

            % Vorgang hier beenden, falls gar keine Pole gewählt werden
            if isempty(selected_pole)

                % Tabelle zurücksetzen
                freq_table.Data = [];
                freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};

                % Ergebnisse in restlichen GUI-Komponenten aktualisieren
                update_result(eigenform_graph, [], [], oma_dropdown, ...
                    "SSI-COV", freq_damp_table, freq_damp_table2, freq_damp_table3);                   

                % Status aktualisieren
                update_status(status, lamp, '>> Mode entfernt', 'erfolg');
    
                % Vorgang sofort beenden
                return;
            end
    
            % Ergebnisse holen
            eigenfreq_chosen = [selected_pole.freq_mean]';
            damping_ratio_chosen = [selected_pole.damp_mean]';

            % Tabelle aktualisieren
            freq_table.Data = eigenfreq_chosen;

            % Ergebnisse in restlichen GUI-Komponenten aktualisieren
            update_result(eigenform_graph, eigenfreq_chosen, damping_ratio_chosen, oma_dropdown, ...
                "SSI-COV", freq_damp_table, freq_damp_table2, freq_damp_table3, oma_ssi_cov_check2, oma_ssi_cov_check3);
        
        % Wenn abgeleitete Messdaten gewählt
        elseif measurement == 2

            % Variablen für gewählte Pole speichern
            app.fig.UserData.cache.modal.cov_all_pole_diff = all_pole;
            app.fig.UserData.cache.modal.cov_selected_pole_diff = selected_pole;
    
            % Vorgang hier beenden, falls gar keine Pole gewählt werden
            if isempty(selected_pole)
    
                % Button für Übertragung der Auswahlen deaktivieren
                transfer_button.Enable = 'off';     

                % Tabelle zurücksetzen
                freq_table.Data = [];
                freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};

                % Status aktualisieren
                update_status(status, lamp, '>> Mode entfernt', 'erfolg');

                % Vorgang sofort beenden
                return;
            end

            % Tabelle aktualisieren
            freq_table.Data = [selected_pole.freq_mean]';
        end

        % Parameter für Cluster-Analyse löschen, da sie nun unbedingt 
        % erneut durchgeführt werden muss
        app.fig.UserData.cache.modal.used_parameter.cov_cluster = struct([]);            

        % Status aktualisieren
        update_status(status, lamp, '>> Mode entfernt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end        