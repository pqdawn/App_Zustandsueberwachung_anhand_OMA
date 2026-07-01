%% Callback für Filter des Stabilisationsdiagramms
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function filter_changed(app)
    
    % Nötige Variablen holen
    all_poles_tick = app.all_poles_check.Value;             % Wahl des Filters für alle berechneten Pole
    stable_freq_tick = app.stable_freq_check.Value;         % Wahl des Filters für stabile Frequenz
    stable_damp_tick = app.stable_damp_check.Value;         % Wahl des Filters für stabilen Dämpfungsgrad
    mac_tick = app.mac_check.Value;                         % Wahl des Filters für "MAC-Bedingung erfüllt"
    filter_or_tick = app.filter_or_radio.Value;             % Wahl des Filters für "oder"
    filter_and_tick = app.filter_and_radio.Value;           % Wahl des Filters für "und"
    pole_chosen_tick = app.pole_chosen_switch.Value;        % Wahl des Filters für gewählte Pole
    graph = app.stab_graph;                                 % Graph für Stabilisationsdiagramm
    ssi_choice = app.ssi_dropdown.Value;                    % Wahl für Art der SSI
    measurement_choice = app.measurement_dropdown.Value;    % Wahl für Messdaten
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Wenn orignale Messdaten gewählt
        if measurement_choice == 1

            % Wenn SSI-COV gewählt wurde
            if strcmp(ssi_choice, 'SSI-COV')           

                % Pole dafür holen
                all_pole = app.fig.UserData.cache.modal.cov_all_pole;                
    
            % Wenn SSI-DATA gewählt wurde
            elseif strcmp(ssi_choice, 'SSI-DATA')

                % Pole dafür holen
                all_pole = app.fig.UserData.cache.modal.data_all_pole;                  
            end

        % Wenn abgeleitete Messdaten gewählt
        elseif measurement_choice == 2

            % Wenn SSI-COV gewählt wurde
            if strcmp(ssi_choice, 'SSI-COV')        

                % Pole dafür holen
                all_pole = app.fig.UserData.cache.modal.cov_all_pole_diff;                
    
            % Wenn SSI-DATA gewählt wurde
            elseif strcmp(ssi_choice, 'SSI-DATA')

                % Pole dafür holen
                all_pole = app.fig.UserData.cache.modal.data_all_pole_diff;                  
            end
        end

        % Falls SSI noch nicht durchgeführt
        if isempty(all_pole)

            % Status aktualisieren
            update_status(status, lamp, '>> Filter angewendet', 'erfolg');            

            % Callback beenden
            return;
        end
        
        % Stabilisationsdiagramm plotten
        plot_stab_diag(graph, all_pole, all_poles_tick, ...
            stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, ...
            filter_or_tick, filter_and_tick);

        % Status aktualisieren
        update_status(status, lamp, '>> Filter angewendet', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end