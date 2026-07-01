%% Callback für Button zum Darstellen des Stabilisationsdiagramms anderer SSI oder Messdaten
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function ssi_measurement_changed(app)

    % Nötige Variablen holen
    all_poles_tick = app.all_poles_check.Value;             % Wahl des Filters für alle berechneten Pole
    stable_freq_tick = app.stable_freq_check.Value;         % Wahl des Filters für stabile Frequenz
    stable_damp_tick = app.stable_damp_check.Value;         % Wahl des Filters für stabilen Dämpfungsgrad
    mac_tick = app.mac_check.Value;                         % Wahl des Filters für "MAC-Bedingung erfüllt"
    or_tick = app.filter_or_radio.Value;                    % Wahl der Filters für "oder"
    and_tick = app.filter_and_radio.Value;                  % Wahl der Filters für "und"      
    pole_chosen_tick = app.pole_chosen_switch.Value;        % Wahl des Filters für gewählte Pole        
    graph = app.stab_graph;                                 % Graph für Stabilisationsdiagramm
    ssi_choice = app.ssi_dropdown.Value;                    % Wahl für Art der SSI
    measurement_choice = app.measurement_dropdown.Value;    % Wahl für Messdaten
    transfer_button = app.transfer_choice_button;           % Button für Übertragung der Auswahlen
    freq_table = app.freq_table;                            % Tabelle für Frequenzen
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Wenn orignale Messdaten gewählt wurde
        if measurement_choice == 1

            % Wenn SSI-COV gewählt wurde
            if strcmp(ssi_choice, 'SSI-COV')

                % Pole holen
                all_pole = app.fig.UserData.cache.modal.cov_all_pole;
                selected_pole = app.fig.UserData.cache.modal.cov_selected_pole;

                % Fehlermeldung falls SSI-COV nicht durchgeführt
                if isempty(all_pole)
                    error('SSI-COV nicht durchgeführt!');
                end                

            % Wenn SSI-DATA gewählt wurde
            elseif strcmp(ssi_choice, 'SSI-DATA')

                % Pole holen
                all_pole = app.fig.UserData.cache.modal.data_all_pole;
                selected_pole = app.fig.UserData.cache.modal.data_selected_pole;

                % Fehlermeldung falls SSI-DATA nicht durchgeführt
                if isempty(all_pole)
                    error('SSI-DATA nicht durchgeführt!');
                end                  
            end

            % Button für Übertragung der Auswahlen deaktivieren
            transfer_button.Enable = 'off';

        % Wenn abgeleitete Messdaten gewählt wurde
        elseif measurement_choice == 2

            % Wenn SSI-COV gewählt wurde
            if strcmp(ssi_choice, 'SSI-COV')

                % Pole holen
                all_pole = app.fig.UserData.cache.modal.cov_all_pole_diff;
                selected_pole = app.fig.UserData.cache.modal.cov_selected_pole_diff;

                % Fehlermeldung falls SSI-COV für abgeleitete Messdaten nicht durchgeführt
                if isempty(all_pole)
                    error('SSI-COV der abgeleitete Messdaten nicht durchgeführt!');
                end                

            % Wenn SSI-DATA gewählt wurde
            elseif strcmp(ssi_choice, 'SSI-DATA')
                
                % Pole holen
                all_pole = app.fig.UserData.cache.modal.data_all_pole_diff;
                selected_pole = app.fig.UserData.cache.modal.data_selected_pole_diff;

                % Fehlermeldung falls SSI-DATA für abgeleitete Messdaten nicht durchgeführt
                if isempty(all_pole)
                    error('SSI-DATA der abgeleitete Messdaten nicht durchgeführt!');
                end                    
            end

            % Button für Übertragung der Auswahlen aktivieren
            transfer_button.Enable = 'on';
        end
        
        % Stabilisationsdiagramm plotten
        plot_stab_diag(graph, all_pole, all_poles_tick, ...
            stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, or_tick, and_tick, ssi_choice, measurement_choice);

        % Wenn Pole schon gewählt wurden
        if ~isempty(selected_pole)

            % Tabelle aktualisieren
            title = {'Frequenz [Hz]'};
            freq_table.ColumnName = title;
            freq_table.Data = [selected_pole.freq_mean]';

        % Wenn noch keine Pole gewählt wurden
        else
            
            % Tabelle zurücksetzen
            freq_table.Data = [];
            freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};

            % Button für Übertragung der Auswahlen deaktivieren
            transfer_button.Enable = 'off';
        end

        % Status aktualisieren
        update_status(status, lamp, '>> Diagramm aktualisiert', 'erfolg');

    % Fehler fangen
    catch ME

        % Nachricht
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end