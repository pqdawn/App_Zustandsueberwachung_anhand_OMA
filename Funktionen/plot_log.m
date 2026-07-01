%% Funktion zum Plotten der linearen Regressen des logarithmischen Dekrements
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    graph = Graph für lineare Regression des logarithmischen Dekrements
%                       freq = Eigenfrequenz
%                       peak_info = Peaks
%                       new_mode = Boolean, ob es sich um eine neue Mode handelt

% Ausgabeparameter: -

function plot_log(graph, freq, peak_info, new_mode)

    % Daten der Peaks holen
    peak_value_log = peak_info.peak_value_log;
    idx_peak_start = peak_info.idx_peak_start;
    idx_peak_end = peak_info.idx_peak_end;    

    % Alles auf Graph löschen
    cla(graph); 

    % Wenn eine neue Mode untersucht wurde, müssen die Achsen und Titel
    % angepasst werden
    if new_mode
        headline = ['\textbf{Lineare Regression des logarithmischen Dekrements f\"ur Frequenz ', num2str(freq), ' Hz}'];
        title(graph, headline);
        xlim(graph, [1 length(peak_value_log)]);
        ylim(graph, [min(peak_value_log) max(peak_value_log)]); 
    end

    % Plotten der linearen Regression
    plot(graph, peak_value_log, '-o');
    hold(graph, 'on');

    % Grenzen markieren
    xline(graph, idx_peak_start, 'LineWidth', 2, 'Color', 'r');
    xline(graph, idx_peak_end, 'LineWidth', 2, 'Color', 'r');

    % Peaks innerhalb der Grenzen markieren
    plot(graph, idx_peak_start:idx_peak_end, peak_value_log(idx_peak_start:idx_peak_end), 'ro', 'MarkerSize', 1);
    hold(graph, 'off');
end