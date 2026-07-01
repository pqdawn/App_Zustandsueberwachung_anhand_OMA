%% Funktion zum Plotten der 1. Singulärwerte der PSD in [dB]
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    psd_graph_db = Graph für 1. Singulärwerte der PSD in [dB]
%                       fdd_result = Ergebnisse der FDD
%                       idx_peak = Indizes der gewählten Peaks
%                       freq_limit = Frequenzgrenze
%                       slider = Slider für x-Achse des Graphs
%                       range_check = Checkbox für fixierten Bereich der x-Achse
%                       range_edit_field = Eingabefeld für fixierten Bereich der x-Achse

% Ausgabeparameter: -

function plot_eigenvalue_psd_db(psd_graph_db, fdd_result, idx_peak, freq_limit, slider, range_check, range_edit_field)

    % Alles auf Graph löschen
    cla(psd_graph_db);  

    % Falls Frequenzgrenze und UI-Elemente für x-Achse eingegeben wurden 
    % (FDD wurde neu durchgeführt), dann müssen die UI-Elemente und die 
    % Achsengrenzen angepasst werden
    if nargin == 7

        % Grenze für y-Achse
        y_min = min(mag2db(fdd_result.S));
        y_max = max(mag2db(fdd_result.S));
        y_dev = 0.05*abs(y_max-y_min);
        y_min = y_min - y_dev;                      
        y_max = y_max + y_dev;
        ylim(psd_graph_db, [y_min, y_max]);

        % Grenze für x-Achse
        xlim(psd_graph_db, [0 ceil(freq_limit)]);
        
        % Slider aktualisieren
        slider.Limits = [0 ceil(freq_limit)];
        slider.Value = [0 ceil(freq_limit)];
        slider.MajorTicks = psd_graph_db.XTick;

        % Checkbox aktualisieren
        range_check.Value = 0;

        % Gespeicherte obere und untere Grenzen aktualisieren
        range_edit_field.UserData.lower_limit = slider.Value(1);
        range_edit_field.UserData.upper_limit = slider.Value(2);
    
        % Wert des Bereiches im Eingabefeld aktualisieren
        range_edit_field.Value = sprintf('%.2f', slider.Value(2) - slider.Value(1));
    end

    % Daten für Graph
    x_data = fdd_result.F;
    y_data_db = mag2db(fdd_result.S);

    % Plotten der 1. Singulärwerte der PSD in [dB]
    plot(psd_graph_db, x_data, y_data_db,'b');  

    % Wenn gewählte Peaks vorhanden sind
    if ~isempty(idx_peak)

        % Alle Peaks durchlaufen
        for i = 1:length(idx_peak)

            % Position des Peaks holen
            idx = idx_peak(i);

            % x- und y-Koordinate holen
            x_peak = x_data(idx);
            y_peak_db = y_data_db(idx);         
        
            % Peak markieren
            hold(psd_graph_db, 'on');
            plot(psd_graph_db, x_peak, y_peak_db, 'ro', 'MarkerFaceColor', 'r');
        end
    end
end