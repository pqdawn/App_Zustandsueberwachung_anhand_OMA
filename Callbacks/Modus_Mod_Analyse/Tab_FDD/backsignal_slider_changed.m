%% Callback für Slider der x-Achse des Graphs für Korrelationsfunktion der 1. Singulärwerte
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function backsignal_slider_changed(app)

    % Nötige Variablen holen
    src = app.backsignal_slider;                            % Slider dieser Funktion
    psd_graph2 = app.psd_graph3;                            % Graph für 1. Singulärwerte der PSD in [dB]
    backsignal_graph = app.backsignal_graph;                % Graph für Korrelationsfunktion der 1. Singulärwerte
    range_tick = app.backsignal_range_check.Value;          % Wahl für fixierten Bereich
    range_edit_field = app.backsignal_range_edit_field;     % Eingabefeld für fixierten Bereich der x-Achse
    log_graph = app.log_graph;                              % Graph für lineare Regression des logarithmischen Dekrements
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Werte aus dem Slider holen
        slider_value = src.Value;

        % Falls fixierter Bereich angeschaltet ist
        if range_tick

            % Grenzen und fixierten Bereich holen
            lower_limit = range_edit_field.UserData.lower_limit;
            upper_limit = range_edit_field.UserData.upper_limit;
            fixed_range = str2double(range_edit_field.Value);

            % Fehlermeldung falls Eingabe größer als Bereich des Sliders ist
            if fixed_range > diff(src.Limits)
                error('Eingegebener Bereich ungültig!');
            end

            % Überprüfen, welche Seite des Sliders gezogen wurde
            dLeft = abs(slider_value(1) - lower_limit);
            dRight = abs(slider_value(2) - upper_limit);

            % Wenn die linke Seite gezogen wurde
            if dLeft > dRight
                
                % Rechte Seite nach dem fixierten Bereich anpassen
                slider_value(2) = slider_value(1) + fixed_range;

            % Wenn die rechte Seite gezogen wurde
            else

                % Linke Seite nach dem fixierten Bereich anpassen
                slider_value(1) = slider_value(2) - fixed_range;
            end

            % Überprüfen, ob die Werte innerhalb der Grenzen des Sliders
            % passen, wenn nicht, müssen sie ggf. angepasst werden
            limits = src.Limits;
            if slider_value(1) < limits(1)
                slider_value(1) = limits(1);
                slider_value(2) = slider_value(1) + fixed_range;
                message = '>> Passt nicht ganz zum fixierten Bereich! Wird ggf. angepasst!';
                update_status(status, lamp, message, 'warnung');
                pause(1);
            elseif slider_value(2) > limits(2)
                slider_value(2) = limits(2);
                slider_value(1) = slider_value(2) - fixed_range;
                message = '>> Passt nicht ganz zum fixierten Bereich! Wird ggf. angepasst!';
                update_status(status, lamp, message, 'warnung');
                pause(1);
            end

            % Slider aktualisieren
            src.Value = slider_value;
        end

        % Fehlermeldung falls der Bereich des Sliders gleich Null ist
        if abs(slider_value(2) - slider_value(1)) == 0
            error('Bereich ungültig!');
        end

        % Gespeicherte obere und untere Grenzen aktualisieren
        range_edit_field.UserData.lower_limit = src.Value(1);
        range_edit_field.UserData.upper_limit = src.Value(2);

        % Wert des Bereiches im Eingabefeld aktualisieren
        range_edit_field.Value = sprintf('%.2f', src.Value(2) - src.Value(1));

        % x-Achse des 1. Graphs aktualisieren
        xlim(backsignal_graph, src.Value);

        % Wenn keine Mode untersucht wurde
        if isempty(backsignal_graph.Children)

            % x-Achse des 2. Graphs einfach an 1. anpassen
            xlim(log_graph, src.Value);

        % Wenn eine Mode untersucht wurde
        else

            % Untersuchte Mode holen
            mode_num = psd_graph2.UserData.mode_num;           

            % Ergebnisse der EFDD holen
            time_recon = app.fig.UserData.cache.modal.efdd_result(mode_num).time_recon; 
            idx_of_peak_in_time = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_of_peak_in_time;

            % Zugehörigen Peak für linke Seite finden
            x_left = src.Value(1);
            [~, idx_left] = min(abs(time_recon - x_left));
            [~, idx_left] = min(abs(idx_of_peak_in_time - idx_left));

            % Zugehörigen Peak für rechte Seite finden
            x_right = src.Value(2);
            [~, idx_right] = min(abs(time_recon - x_right));
            [~, idx_right] = min(abs(idx_of_peak_in_time - idx_right));    

            % x-Achse des 2. Graphs aktualisieren
            xlim(log_graph, [idx_left idx_right]);   
        end

        % Status aktualisieren
        update_status(status, lamp, '>> x-Achse aktualisiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end