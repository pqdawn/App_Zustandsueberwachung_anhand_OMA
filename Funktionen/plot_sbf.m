%% Funktion zum Plotten der SBF
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    sbf_graph = Graph für SBF
%                       F = Frequenzen
%                       SBF = Spectral-Bell-Function
%                       slider = Slider für x-Achse des Graphs
%                       range_check = Checkbox für fixierten Bereich der x-Achse
%                       range_edit_field = Eingabefeld für fixierten Bereich der x-Achse
%                       freq = Eigenfrequenz
%                       mac = MAC-Grenze für diese SBF

% Ausgabeparameter: -

function plot_sbf(sbf_graph, F, SBF, slider, range_check, range_edit_field, freq, mac)

    % Alles auf Graph löschen
    cla(sbf_graph);  

    % Plotten der SBF
    plot(sbf_graph, F, SBF,'b');     

    % Grenzen finden
    x_lower = find(SBF ~= 0,1,'first');
    x_upper = find(SBF ~= 0,1,'last');

    % Grenze für x-Achse
    xlim(sbf_graph, [floor(F(x_lower)) ceil(F(x_upper))]);    

    % Grenze für y-Achse
    y_max = max(SBF);
    y_dev = 0.05*abs(y_max);                      
    y_max = y_max + y_dev;
    ylim(sbf_graph, [0 y_max]);

    % Slider aktualisieren
    slider.Limits = [floor(F(x_lower)) ceil(F(x_upper))];
    slider.Value = [floor(F(x_lower)) ceil(F(x_upper))];
    slider.MajorTicks = sbf_graph.XTick;

    % Checkbox aktualisieren
    range_check.Value = 0;

    % Gespeicherte obere und untere Grenzen aktualisieren
    range_edit_field.UserData.lower_limit = slider.Value(1);
    range_edit_field.UserData.upper_limit = slider.Value(2);

    % Wert des Bereiches im Eingabefeld aktualisieren
    range_edit_field.Value = sprintf('%.2f', slider.Value(2) - slider.Value(1));

    % Titel
    head_line = ['\textbf{Spectral-Bell-Function f\"ur Frequenz ', num2str(freq), ' Hz mit MAC ', num2str(mac*100), '\%}'];
    title(sbf_graph, head_line);    
end