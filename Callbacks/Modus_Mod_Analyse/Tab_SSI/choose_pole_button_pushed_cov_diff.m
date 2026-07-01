%% Callback für Auswählen der Pole (SSI-COV, abgeleitete Messdaten)
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function choose_pole_button_pushed_cov_diff(app, fig)

    % Nötige Variablen holen
    src = app.choose_pole_button;                               % Button dieser Funktion
    all_poles_tick = app.all_poles_check.Value;                 % Wahl des Filters für alle berechneten Pole
    stable_freq_tick = app.stable_freq_check.Value;             % Wahl des Filters für stabile Frequenz
    stable_damp_tick = app.stable_damp_check.Value;             % Wahl des Filters für stabilen Dämpfungsgrad
    mac_tick = app.mac_check.Value;                             % Wahl des Filters für "MAC-Bedingung erfüllt"
    or_tick = app.filter_or_radio.Value;                        % Wahl der Filters für "oder"
    and_tick = app.filter_and_radio.Value;                      % Wahl der Filters für "und"      
    pole_chosen_tick = app.pole_chosen_switch.Value;            % Wahl des Filters für gewählte Pole
    stab_graph = app.stab_graph;                                % Graph für Stabilisationsdiagramm
    tolerance = app.tolerance_spinner.Value;                    % Toleranz für Auswahl
    transfer_button = app.transfer_choice_button;               % Button für Übertragung der Auswahlen
    freq_table = app.freq_table;                                % Tabelle für Frequenzen
    update_eigenform_button = app.update_eigenform_button;      % Button für Darstellen der Eigenform
    lamp = app.status_lamp;                                     % Licht des Status
    status = app.status_text_area;                              % Textfeld des Status

    try
        % Fehlermeldung falls keine Daten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Fehlermeldung falls SSI-COV für abgeleitete Messdaten nicht durchgeführt
        if isempty(app.fig.UserData.cache.modal.cov_all_pole_diff)
            error('SSI-COV der abgeleitete Messdaten nicht durchgeführt!');
        end          

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
        end

        % Fehlermeldung falls Checkbox für gewählte Pole nicht an
        if strcmp(pole_chosen_tick, 'Aus')
            error('Gewählte Pole werden nicht dargestellt! Filter dafür erstmal aktivieren!')
        end
        
        % Wenn Pole schon gewählt wurden, den Benutzer warnen
        if ~isempty(app.fig.UserData.cache.modal.cov_selected_pole_diff)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(fig, ['Pole schon gewählt. Wollen Sie die ' ...
                'gewählten Pole beibehalten?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 1);            
            
            % Wahl von Benutzer
            switch choice

                % Wenn "nein", alle gewählten Pole löschen
                case 'Nein'

                    % Variablen für gewählte Pole löschen
                    [app.fig.UserData.cache.modal.cov_all_pole_diff.is_chosen] = deal(false);
                    app.fig.UserData.cache.modal.cov_selected_pole_diff = struct([]);

                    % Tabelle zurücksetzen
                    freq_table.Data = [];
                    freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};

                    % Stabilisationsdiagramm aktualisieren
                    plot_stab_diag(stab_graph, app.fig.UserData.cache.modal.cov_all_pole_diff, all_poles_tick, ...
                        stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, or_tick, and_tick);

                    % Status aktualisieren
                    update_status(status, lamp, ['>> Alle gewählten Pole ' ...
                        'gelöscht'], 'erfolg');
                    pause(1);
                
                % Wenn "ja", die gewählten Pole beibehalten und weiter
                case 'Ja'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Gewählte Pole beibehalten', 'erfolg');
            end            
        end
        
        % Variablen holen
        all_pole = app.fig.UserData.cache.modal.cov_all_pole_diff;
        selected_pole = app.fig.UserData.cache.modal.cov_selected_pole_diff;
        
        % Diesen Button deaktivieren
        src.Enable = 'off';

        % Anzahl der bereits gewählten Moden holen
        mode_counter = length(selected_pole);

        % Die Figur der App als aktuelle Figur wählen
        fhv = fig.HandleVisibility;
        fig.HandleVisibility = 'callback';
        set(0, 'CurrentFigure', fig);

        % Status aktualisieren
        update_status(status, lamp, '----------------------------------------------------------', 'warnung');
        update_status(status, lamp, 'RECHTSKLICK: Beenden', 'warnung');
        update_status(status, lamp, '(erst möglich nach dem ersten Klick auf das Diagramm!)', 'warnung');
        update_status(status, lamp, 'RÜCKTASTE: Letzte Auswahl rückgängig', 'warnung');
        update_status(status, lamp, 'LINKSKLICK: Polen auswählen', 'warnung');
        update_status(status, lamp, '----------------------------------------------------------', 'warnung');
        update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');

        % Solange der Vorgang nicht vom Benutzer beendet wird
        while true

            % Gewählte Punkt holen
            [x, ~, button] = ginput(1);
            
            % Den Vorgang beenden, wenn "Rechtsklick" betätigt wird
            if button == 3
                break;

            % Die letzte Auswahl löschen, wenn "Rücktaste" betätigt wird
            elseif button == 08  % ASCII code for 'Rücktaste'

                % Falls gewählte Pole vorhanden sind
                if ~isempty(selected_pole)

                    % Pole letzter Auswahl holen
                    idx_to_del = [selected_pole(end).pole_idx];

                    % Diese Pole löschen
                    selected_pole(end) = [];

                    % Diese Pole als "nicht gewählt" markieren
                    for i = 1:length(idx_to_del)
                        all_pole(idx_to_del(i)).is_chosen = false;
                    end

                    % Anzahl der bereits gewählten Moden aktualisieren
                    mode_counter = mode_counter - 1;                    

                    % Graph aktualisieren
                    plot_stab_diag(stab_graph, all_pole, all_poles_tick, ...
                            stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, or_tick, and_tick); 

                    % Tabelle aktualisieren
                    freq_table.Data = [selected_pole.freq_mean]';

                    % Status aktualisieren
                    update_status(status, lamp, '>> Letzte Auswahl gelöscht', 'erfolg');
                    pause(1);
                    update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');

                % Falls noch keine gewählten Pole vorhanden sind
                else

                    % Status aktualisieren
                    update_status(status, lamp, '>> Keine Auswahl zu löschen!', 'fehler');
                    pause(1);
                    update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');
                end
                continue;

            % Wenn Pole gewählt werden
            elseif button == 1

                % Pole innerhalb des Toleranzbereichs finden
                eigenfreq = [all_pole.eigenfreq];
                dist = abs(eigenfreq - x);
                idx_tol = find(dist <= tolerance);

                % Fehlermeldung wenn keine Pole innerhalb der Toleranz
                % gefunden wurden
                if isempty(idx_tol)
                    update_status(status, lamp, '>> Keine Pole gefunden!', 'fehler');
                    pause(1);
                    update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');
                    continue;
                end

                % Daten dieser Pole holen
                pole_within_tol = all_pole(idx_tol);

                % Warnung falls Pole innerhalb Toleranz bereits gewählt wurden
                if any([pole_within_tol.is_chosen])

                    % Maske für zu behaltende Moden
                    keep_mask = true(1, numel(selected_pole));
                    
                    % Alle Moden durchlaufen
                    for i = 1:numel(selected_pole)

                        % Wenn sich Pole dieser Mode mit der aktuellen gewählten
                        % Polen überlappen
                        if any(ismember(selected_pole(i).pole_idx, idx_tol))

                            % Diese Mode löschen
                            keep_mask(i) = false;
                        end
                    end
                    
                    % Pole der zu löschenden Mode löschen
                    to_delete_idx = {selected_pole(~keep_mask).pole_idx};
                    selected_pole = selected_pole(keep_mask);

                    % Anzahl der bereits gewählten Moden aktualisieren
                    mode_counter = mode_counter - numel(to_delete_idx);

                    % Pole der gelöschten Moden als "nicht gewählt" markieren
                    for i = 1:numel(to_delete_idx)
                        for id = to_delete_idx{i}'
                            all_pole(id).is_chosen = false;
                        end
                    end

                    % Status aktualisieren
                    update_status(status, lamp, ['>> Pole innerhalb der Toleranz ' ...
                        'wurden bereits gewählt. Sie werden überschrieben!'], 'warnung');
                    pause(1);
                end      

                % Abhängig vom gewählten Filter logische Indizes holen
                logic_idx = [];
                if all_poles_tick
                    logic_idx = true(size(pole_within_tol));
                end
                if stable_freq_tick
                    logic_idx = [logic_idx; pole_within_tol.is_stable_freq];
                end
                if stable_damp_tick
                    logic_idx = [logic_idx; pole_within_tol.is_stable_damp];
                end
                if mac_tick
                    logic_idx = [logic_idx; pole_within_tol.is_mac];
                end

                % Wenn "oder" gewählt wurde
                if or_tick

                    % Pole auswählen, wenn mindestens ein Kriterium erfüllt ist
                    idx_tol = idx_tol(any(logic_idx));
                    pole_within_tol = pole_within_tol(any(logic_idx));

                % Wenn "und" gewählt wurde
                elseif and_tick

                    % Pole auswählen, wenn alle Kriterien erfüllt sind
                    idx_tol = idx_tol(all(logic_idx));
                    pole_within_tol = pole_within_tol(all(logic_idx));
                end                    
            
                % Pole mit stabiler Frequenz finden
                idx_stable_freq = find([pole_within_tol.is_stable_freq]);

                % Fehlermeldung falls keine Pole mit stabiler Frequenz 
                % gefunden wurden
                if isempty(idx_stable_freq)
                    update_status(status, lamp, '>> Keine stabilen Frequenzen!', 'fehler');
                    pause(1);
                    update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');
                    continue;
                end

                % Gemittelte Frequenz aus Polen mit stabiler Frequenz
                % ermitteln
                stable_freq = [pole_within_tol(idx_stable_freq).eigenfreq];
                mean_freq = mean(stable_freq);

                % Ergebnisse speichern
                mode_counter = mode_counter + 1;
                selected_pole(mode_counter).freq_mean = mean_freq;
                selected_pole(mode_counter).pole_idx  = idx_tol';

                % Diese Pole als "gewählt" markieren
                for i = 1:length(idx_tol)
                    all_pole(idx_tol(i)).is_chosen = true;
                end
            
                % Stabilisationsdiagramm plotten
                plot_stab_diag(stab_graph, all_pole, all_poles_tick, ...
                    stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, or_tick, and_tick);

                % Tabelle aktualisieren
                title = {'Frequenz [Hz]'};
                freq_table.ColumnName = title;
                freq_table.Data = [selected_pole.freq_mean]';
    
                % Status aktualisieren
                update_status(status, lamp, '>> Pole erfolgreich gewählt', 'erfolg');
                pause(1);
                update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');

            % Falls andere Taste betätigt werden    
            else

                % Status aktualisieren
                update_status(status, lamp, '>> Keine gültige Taste!', 'fehler');
                pause(1);
                update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');
                continue;
            end
        end

        % Die Figur der App nicht mehr wählen
        fig.HandleVisibility = fhv;
        
        % Diesen Button wieder aktivieren
        src.Enable = 'on';

        % Variablen für gewählte Pole speichern
        app.fig.UserData.cache.modal.cov_all_pole_diff = all_pole;
        app.fig.UserData.cache.modal.cov_selected_pole_diff = selected_pole;

        % Gewählte Zeile der Tabelle zurücksetzen
        freq_table.Selection = [];
        freq_table.UserData.row_selected = NaN;

        % Vorgang hier beenden, falls gar keine Pole gewählt werden
        if isempty(selected_pole)

            % Tabelle zurücksetzen
            freq_table.Data = [];
            freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};

            % Button für Übertragung der Auswahlen deaktivieren
            transfer_button.Enable = 'off';

            % Status aktualisieren
            update_status(status, lamp, '>> Vorgang beendet ohne Auswahl', ...
                'erfolg');
            
            % Vorgang sofort beenden
            return;
        end

        % Button für Übertragung der Auswahlen aktivieren
        transfer_button.Enable = 'on';

        % Status aktualisieren
        update_status(status, lamp, '>> Vorgang beendet', ...
            'erfolg');

    % Fehler fangen
    catch ME

        % Diesen Button wieder aktivieren
        src.Enable = 'on';

        % Status aktualisieren
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end