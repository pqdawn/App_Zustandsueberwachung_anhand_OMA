%% Funktion zum Plotten der 1. Singulärwerte der PSD in [/]
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    psd_graph_lin = Graph für 1. Singulärwerte der PSD in [/]
%                       fdd_result = Ergebnisse der FDD
%                       idx_peak = Indizes der gewählten Peaks
%                       freq_limit = Frequenzgrenze

% Ausgabeparameter: -

function plot_eigenvalue_psd_lin(psd_graph_lin, fdd_result, idx_peak, freq_limit)

    % Alles auf Graph löschen
    cla(psd_graph_lin);   

    % Falls Frequenzgrenze eingegeben wurden (FDD wurde neu durchgeführt), 
    % dann müssen die Achsengrenzen angepasst werden
    if nargin == 4

        % Grenze für y-Achse
        y_min = min(fdd_result.S);
        y_max = max(fdd_result.S);  
        y_dev = 0.05*abs(y_max-y_min);
        y_max = y_max + y_dev;
        ylim(psd_graph_lin, [y_min, y_max]);

        % Grenze für x-Achse
        xlim(psd_graph_lin, [0 freq_limit]);
    end

    % Daten für Graph
    x_data = fdd_result.F;
    y_data_lin = fdd_result.S;

    % Plotten der 1. Singulärwerte der PSD in [/]
    plot(psd_graph_lin, x_data, y_data_lin,'b'); 

    % Wenn gewählte Peaks vorhanden sind
    if ~isempty(idx_peak)

        % Alle Peaks durchlaufen
        for i = 1:length(idx_peak)

            % Position des Peaks holen
            idx = idx_peak(i);

            % x- und y-Koordinate holen
            x_peak = x_data(idx);
            y_peak_lin = y_data_lin(idx);
                
            % Peak markieren
            hold(psd_graph_lin, 'on');
            plot(psd_graph_lin, x_peak, y_peak_lin, 'ro', 'MarkerFaceColor', 'r');
        end
    end
end