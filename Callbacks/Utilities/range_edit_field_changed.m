%% Callback für Eingabefeld zum fixierten Bereich des x-Achse
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    src = Eingabefeld für fixierten Bereich der x-Achse
%                       graph = Graph
%                       slider = Slider
%                       lamp = Licht des Status
%                       status = Textfeld des Status
%                       graph2 = 2. Graph

% Ausgabeparameter:     -

function range_edit_field_changed(src, graph, slider, lamp, status, graph2)

    try
        % Eingegebenen Bereich holen
        fixed_range = str2double(src.Value);

        % Fehlermeldung falls Eingabe keine gültige Zahl ist
        if isnan(fixed_range)
            error('Eingegebener Bereich ungültig!');
        end

        % Fehlermeldung falls Eingabe größer als Bereich des Sliders ist
        if fixed_range > diff(slider.Limits)
            error('Eingegebener Bereich zu groß!');
        end        

        % Werte aus dem Slider holen
        slider_value = slider.Value;

        % Neuen Wert für die rechte Seite des Sliders berechnen
        slider_value(2) = slider_value(1) + fixed_range;

        % Überprüfen, ob die Werte innerhalb der Grenzen des Sliders
        % passen, wenn nicht, müssen sie ggf. angepasst werden
        limits = slider.Limits;
        if slider_value(1) < limits(1)
            slider_value(1) = limits(1);
            slider_value(2) = slider_value(1) + fixed_range;
        elseif slider_value(2) > limits(2)
            slider_value(2) = limits(2);
            slider_value(1) = slider_value(2) - fixed_range;
        end

        % Slider aktualisieren
        slider.Value = slider_value;

        % Gespeicherte obere und untere Grenzen aktualisieren
        src.UserData.lower_limit = slider.Value(1);
        src.UserData.upper_limit = slider.Value(2);

        % Wert des Bereiches im Eingabefeld aktualisieren
        src.Value = sprintf('%.2f', slider.Value(2) - slider.Value(1));

        % Graph aktualisieren
        xlim(graph, slider.Value);

        % Falls ein zweiter Graph vom Slider abhängig ist
        if nargin == 6

            % Den zweiten Graph aktualisieren
            xlim(graph2, slider.Value);
        end
        
        % Status aktualisieren
        update_status(status, lamp, '>> x-Achse aktualisiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end