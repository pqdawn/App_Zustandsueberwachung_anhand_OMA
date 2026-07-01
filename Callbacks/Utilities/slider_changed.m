%% Callback für Slider der x-Achse
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    src = Slider
%                       graph = Graph
%                       range_tick = Wahl für fixierten Bereich
%                       range_edit_field = Eingabefeld des Bereichs
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function slider_changed(src, graph, range_tick, range_edit_field, lamp, status, graph2)

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

        % Graph aktualisieren
        xlim(graph, src.Value);

        % Falls ein zweiter Graph vom Slider abhängig ist
        if nargin == 7

            % Den zweiten Graph aktualisieren
            xlim(graph2, src.Value);
        end

        % Status aktualisieren
        update_status(status, lamp, '>> x-Achse aktualisiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end