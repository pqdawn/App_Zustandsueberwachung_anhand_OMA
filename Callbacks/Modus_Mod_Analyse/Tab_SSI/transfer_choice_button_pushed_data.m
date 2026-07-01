%% Callback für Button zur Übertragung der Auswahlen (SSI-DATA)
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function transfer_choice_button_pushed_data(app, fig)

    % Nötige Variablen holen
    src = app.transfer_choice_button;                       % Button dieser Funktion
    all_poles_tick = app.all_poles_check.Value;             % Wahl des Filters für alle berechneten Pole
    stable_freq_tick = app.stable_freq_check.Value;         % Wahl des Filters für stabile Frequenz
    stable_damp_tick = app.stable_damp_check.Value;         % Wahl des Filters für stabilen Dämpfungsgrad
    mac_tick = app.mac_check.Value;                         % Wahl des Filters für "MAC-Bedingung erfüllt"
    or_tick = app.filter_or_radio.Value;                    % Wahl der Filters für "oder"
    and_tick = app.filter_and_radio.Value;                  % Wahl der Filters für "und"      
    pole_chosen_tick = app.pole_chosen_switch.Value;        % Wahl des Filters für gewählte Pole
    stab_graph = app.stab_graph;                            % Graph für Stabilisationsdiagramm
    measurement_dropdown = app.measurement_dropdown;        % Dropdown für Messdaten
    tolerance = app.tolerance_spinner.Value;                % Toleranz für Auswahl
    freq_table = app.freq_table;                            % Tabelle für Frequenzen
    oma_dropdown = app.oma_dropdown;                        % Dropdown für OMA-Methoden
    freq_damp_table = app.freq_damp_table;                  % Tabelle für Ergebnisse (Tab "Ergebnis")
    eigenform_graph = app.eigenform_graph;                  % Graph für Eigenform
    update_eigenform_button = app.update_eigenform_button;  % Button für Darstellen der Eigenform
    oma_ssi_data_check2 = app.oma_ssi_cov_check2;           % Wahl für SSI-DATA (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table2 = app.freq_damp_table2;                % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_ssi_data_check3 = app.oma_ssi_cov_check3;           % Wahl für SSI-DATA (Sub-Tab "Eigenform", Tab "Export")
    freq_damp_table3 = app.freq_damp_table3;                % Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Fehlermeldung falls SSI-DATA nicht durchgeführt
        if isempty(app.fig.UserData.cache.modal.data_all_pole)
            error('SSI-DATA nicht durchgeführt!');
        end

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
        end

        % Fehlermeldung falls Checkbox für gewählte Pole nicht an
        if strcmp(pole_chosen_tick, 'Aus')
            error('Gewählte Pole werden nicht dargestellt! Filter dafür erstmal aktivieren!')
        end

        % Wenn Pole von originalen Messdaten schon gewählt wurden, den 
        % Benutzer warnen
        if ~isempty(app.fig.UserData.cache.modal.data_selected_pole)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(fig, ['Pole von originalen Messdaten bereits gewählt. ' ...
                'Durch Übertragung werden sie ersetzt. Möchten Sie fortfahren?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);  
            
            % Wahl von Benutzer
            switch choice

                % Wenn "ja", alle gewählten Pole von originalen Messdaten löschen
                case 'Ja'
        
                    % Variablen für gewählte Pole löschen
                    [app.fig.UserData.cache.modal.data_all_pole.is_chosen] = deal(false);
                    app.fig.UserData.cache.modal.data_selected_pole = struct([]);
                
                % Wenn "nein", Pole von originalen Messdaten beibehalten
                % und Vorgang abbrechen
                case 'Nein'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Pole von originalen Messdaten beibehalten', 'erfolg');
                    return;
            end            
        end

        % Dropdown für Messdaten auf originale Messdaten zurücksetzen
        measurement_dropdown.Value = 1;

        % Pole der originalen Messdaten holen holen
        all_pole = app.fig.UserData.cache.modal.data_all_pole;

        % Strukturarray für gewählte Pole instanziieren
        selected_pole = struct([]);

        % Anzahl der gewählten Moden zurücksetzen
        mode_counter = 0;

        % Gewählte Eigenfrequenzen der abgeleiteten Messdaten holen
        eigenfreq_chosen_diff = [app.fig.UserData.cache.modal.data_selected_pole_diff.freq_mean];

        % Alle Eigenfrequenzen durchlaufen
        for i = 1:length(eigenfreq_chosen_diff)

            % Punkt holen
            x = eigenfreq_chosen_diff(i);

            % Pole innerhalb des Toleranzbereichs finden
            eigenfreq = [all_pole.eigenfreq];
            dist = abs(eigenfreq - x);
            idx_tol = find(dist <= tolerance);
            pole_within_tol = all_pole(idx_tol);
        
            % Pole mit stabiler Frequenz finden
            idx_stable_freq = find([pole_within_tol.is_stable_freq]);

            % Warnung falls keine Pole mit stabiler Frequenz gefunden wurden
            if isempty(idx_stable_freq)
                message = ['>> Keine stabilen Frequenzen für Frequenz', string(eigenfreq_chosen_diff(i)), ...
                    'gefunden! Diese Frequenz wird übersprungen'];
                message = strjoin(message);
                update_status(status, lamp, message, 'warnung');
                pause(1);
                continue;
            end
        
            % Endgültige Eigenfrequenz aus Polen mit stabiler Frequenz 
            % ermitteln
            stable_freq = [pole_within_tol(idx_stable_freq).eigenfreq];
            mean_freq = mean(stable_freq);
            std_freq = std(stable_freq);
        
            % Pole mit stabilem Dämpfungsgrad finden
            idx_stable_damp = find([pole_within_tol.is_stable_damp]);
            
            % Warnung falls keine Pole mit stabilem Dämpfungsgrad
            % gefunden wurden   
            if isempty(idx_stable_damp)
                message = ['>> Keine stabilen Dämpfungsgrade für Frequenz', string(eigenfreq_chosen_diff(i)), ...
                    'gefunden! Diese Frequenz wird übersprungen'];
                message = strjoin(message);
                update_status(status, lamp, message, 'warnung');
                pause(1);
                continue;
            end
        
            % Endgültigen Dämpfungsgrad aus Polen mit stabilem 
            % Dämpfungsgrad ermitteln
            stable_damp = [pole_within_tol(idx_stable_damp).damping_ratio];
            mean_damp = mean(stable_damp);
            std_damp = std(stable_damp);
        
            % Pole mit "MAC-Bedingung erfüllt" finden
            idx_mac = find([pole_within_tol.is_mac]);

            % Warnung falls keine Pole mit "MAC-Bedingung erfüllt"
            % gefunden wurden 
            if isempty(idx_mac)
                message = ['>> Keine MAC-erfüllten Eigenformen für Frequenz', string(eigenfreq_chosen_diff(i)), ...
                    'gefunden! Diese Frequenz wird übersprungen'];
                message = strjoin(message);
                update_status(status, lamp, message, 'warnung');
                pause(1);
                continue;
            end
        
            % Endgültige Eigenform anhand SVD extrahieren (Der erste 
            % Vektor in der resultierenden Matrix U beschreibt die 
            % Richtung mit der größten Varianz in den Daten und gilt 
            % somit als die repräsentativste Eigenform)
            mode_shape = [pole_within_tol(idx_mac).mode_shape];
            [U,~,~] = svd(mode_shape, 'econ');
            mode_rep = real(U(:,1));
        
            % Ergebnisse speichern
            mode_counter = mode_counter + 1;
            selected_pole(mode_counter).freq_mean = mean_freq;
            selected_pole(mode_counter).freq_std  = std_freq;
            selected_pole(mode_counter).damp_mean = mean_damp;
            selected_pole(mode_counter).damp_std  = std_damp;
            selected_pole(mode_counter).mode_shape_mean = mode_rep;
            selected_pole(mode_counter).pole_idx  = idx_tol';
        
            % Diese Pole als "gewählt" markieren
            for j = 1:length(idx_tol)
                all_pole(idx_tol(j)).is_chosen = true;
            end
        end
            
        % Stabilisationsdiagramm für originale Messdaten plotten
        plot_stab_diag(stab_graph, all_pole, all_poles_tick, ...
            stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, or_tick, and_tick);

        % Variablen für gewählte Pole speichern
        app.fig.UserData.cache.modal.data_all_pole = all_pole;
        app.fig.UserData.cache.modal.data_selected_pole = selected_pole;

        % Vorgang hier beenden, falls gar keine Pole gewählt werden
        if isempty(selected_pole)

            % Button für Übertragung der Auswahlen deaktivieren
            src.Enable = 'off';

            % Tabelle zurücksetzen
            freq_table.Data = [];
            freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};

            % Ergebnisse in restlichen GUI-Komponenten aktualisieren
            update_result(eigenform_graph, [], [], oma_dropdown, ...
                "SSI-DATA", freq_damp_table, freq_damp_table2, freq_damp_table3); 
            
            % Status aktualisieren
            update_status(status, lamp, '>> Vorgang beendet ohne Auswahl', ...
                'erfolg');

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
            "SSI-DATA", freq_damp_table, freq_damp_table2, freq_damp_table3, oma_ssi_data_check2, oma_ssi_data_check3);

        % Dieser Button deaktivieren
        src.Enable = 'off';

        % Status aktualisieren
        update_status(status, lamp, '>> Auswahlen auf originale Messdaten übertragen', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end