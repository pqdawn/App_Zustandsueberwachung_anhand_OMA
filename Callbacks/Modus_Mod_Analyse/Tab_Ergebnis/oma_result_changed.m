%% Callback für Button zum Darstellen der Ergebnisse anderer OMA-Methoden (Modus "Modalanalyse")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function oma_result_changed(app)

    % Nötige Variablen holen
    src = app.oma_dropdown;                                 % Dieses Dropdown    
    freq_damp_table = app.freq_damp_table;                  % Tabelle für Ergebnisse
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Gewählte OMA-Methode holen
        oma_selected = src.Value;

        % Wenn FDD gewählt
        if strcmp(oma_selected, 'FDD')

            % Ergebnisse der FDD holen
            selected_peak = app.fig.UserData.cache.modal.selected_peak;

            % Fehlermeldung falls noch keine Peaks dafür gewählt wurden
            if isempty(selected_peak)

                % Tabelle zurücksetzen
                freq_damp_table.Data = [];
                freq_damp_table.ColumnName = {'Ergebnisse werden hier angezeigt'};

                % Fehlermeldung
                error('Keine Peaks gewählt!');
            end

            % Inhalt für Tabelle holen
            eigenfreq_chosen = [selected_peak.freq]';
            table_data = eigenfreq_chosen;
            table_title = {'Frequenz [Hz]'};
            table_width = repmat({'1x'}, 1, 1);     

        % Wenn EFDD gewählt
        elseif strcmp(oma_selected, 'EFDD')

            % Ergebnisse der EFDD holen
            efdd_result = app.fig.UserData.cache.modal.efdd_result;

            % Fehlermeldung falls noch keine Peaks dafür gewählt wurden
            if isempty(efdd_result)

                % Tabelle zurücksetzen
                freq_damp_table.Data = [];
                freq_damp_table.ColumnName = {'Ergebnisse werden hier angezeigt'};

                % Fehlermeldung
                error('EFDD nicht durchgeführt!');
            end

            % Inhalt für Tabelle holen
            eigenfreq_chosen = [efdd_result.freq_d]';
            damping_ratio_chosen = [efdd_result.damping_ratio]';  
            table_data = [eigenfreq_chosen, damping_ratio_chosen];
            table_title = {'Frequenz [Hz]', 'Dämpfungsgrad [%]'};
            table_width = repmat({'1x'}, 1, 2);        

        % Wenn SSI-COV gewählt
        elseif strcmp(oma_selected, 'SSI-COV')

            % Ergebnisse der SSI-COV holen
            selected_pole = app.fig.UserData.cache.modal.cov_selected_pole;

            % Fehlermeldung falls noch keine Pole dafür gewählt wurden
            if isempty(selected_pole)

                % Tabelle zurücksetzen
                freq_damp_table.Data = [];
                freq_damp_table.ColumnName = {'Ergebnisse werden hier angezeigt'};                

                % Fehlermeldung
                error('Keine Pole gewählt!');
            end

            % Inhalt für Tabelle holen
            eigenfreq_chosen = [selected_pole.freq_mean]';
            damping_ratio_chosen = [selected_pole.damp_mean]';  
            table_data = [eigenfreq_chosen, damping_ratio_chosen.*100];
            table_title = {'Frequenz [Hz]', 'Dämpfungsgrad [%]'};
            table_width = repmat({'1x'}, 1, 2);

        % Wenn SSI-DATA gewählt
        elseif strcmp(oma_selected, 'SSI-DATA')

            % Ergebnisse der SSI-DATA holen
            selected_pole = app.fig.UserData.cache.modal.data_selected_pole;

            % Fehlermeldung falls noch keine Pole dafür gewählt wurden
            if isempty(selected_pole)

                % Tabelle zurücksetzen
                freq_damp_table.Data = [];
                freq_damp_table.ColumnName = {'Ergebnisse werden hier angezeigt'};                

                % Fehlermeldung
                error('Keine Pole gewählt!');
            end

            % Inhalt für Tabelle holen
            eigenfreq_chosen = [selected_pole.freq_mean]';
            damping_ratio_chosen = [selected_pole.damp_mean]';  
            table_data = [eigenfreq_chosen, damping_ratio_chosen.*100];
            table_title = {'Frequenz [Hz]', 'Dämpfungsgrad [%]'};
            table_width = repmat({'1x'}, 1, 2);            
        end
        
        % Tabelle für Ergebnisse aktualisieren
        freq_damp_table.Data = table_data;
        freq_damp_table.ColumnName = table_title;
        freq_damp_table.ColumnWidth = table_width;

        % Status aktualisieren
        update_status(status, lamp, '>> Tabelle aktualisiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end