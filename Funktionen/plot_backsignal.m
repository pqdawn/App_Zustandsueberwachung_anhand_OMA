%% Funktion zum Plotten der Korrelationsfunktion der 1. Singulärwete
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    graph = Graph für Korrelationsfunktion der 1. Singulärwerte
%                       time_recon = Rekonstruierte Zeit
%                       signal_recon = Korrelationsfunktion
%                       freq = Eigenfrequenz
%                       peak_info = Peaks
%                       slider = Slider für x-Achse des Graphs
%                       range_check = Checkbox für fixierten Bereich der x-Achse
%                       range_edit_field = Eingabefeld für fixierten Bereich der x-Achse

% Ausgabeparameter: -

function plot_backsignal(graph, time_recon, signal_recon, freq, peak_info, slider, range_check, range_edit_field)

    % Daten der Peaks holen
    idx_of_peak_in_time = peak_info.idx_of_peak_in_time;
    peak_value_signal = peak_info.peak_value_signal;
    idx_peak_start = peak_info.idx_peak_start;
    idx_peak_end = peak_info.idx_peak_end;    

    % Alles auf Graph löschen
    cla(graph); 

    % Falls UI-Elemente für x-Achse eingegeben wurden (neue Mode wurde 
    % untersucht), dann müssen sie angepasst werden
    if nargin == 8  

        % Grenze für x-Achse
        xlim(graph, [0 ceil(time_recon(end))]);

        % Slider aktualisieren
        slider.Limits = [0 ceil(time_recon(end))];
        slider.Value = [0 ceil(time_recon(end))];
        slider.MajorTicks = graph.XTick;
    
        % Checkbox aktualisieren
        range_check.Value = 0;
    
        % Gespeicherte obere und untere Grenzen aktualisieren
        range_edit_field.UserData.lower_limit = slider.Value(1);
        range_edit_field.UserData.upper_limit = slider.Value(2);
    
        % Wert des Bereiches im Eingabefeld aktualisieren
        range_edit_field.Value = sprintf('%.2f', slider.Value(2) - slider.Value(1));

        % Titel
        headline = ['\textbf{Korrelationsfunktion der 1. Singul\"arwete f\"ur Frequenz ', num2str(freq), ' Hz}'];
        title(graph, headline);        
    end    

    % Plotten der Korrelationsfunktion
    plot(graph, time_recon, signal_recon);
    hold(graph, 'on');

    % Grenzen des Bereichs finden
    idx_of_peak_in_time_cut = idx_of_peak_in_time(idx_peak_start:idx_peak_end);
    time_recon_cut = time_recon(idx_of_peak_in_time_cut);        

    % Grenzen markieren
    xline(graph, time_recon_cut(1), 'LineWidth', 2, 'Color', 'r');
    xline(graph, time_recon_cut(end), 'LineWidth', 2, 'Color', 'r');

    % Peaks markieren
    plot(graph, time_recon_cut, peak_value_signal(idx_peak_start:idx_peak_end), 'ro', 'MarkerSize', 1);
    hold(graph, 'off');
end