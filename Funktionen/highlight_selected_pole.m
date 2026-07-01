%% Funktion zum Markieren der Pole im Stabilisationsdiagramm
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    graph = Graph für Stabilisationsdiagramm
%                       corresp_pole = Zu markierende Pole

% Ausgabeparameter: -

function highlight_selected_pole(graph, corresp_pole)
    
    % x- und y-Koordinaten holen
    model_order = corresp_pole(:, 1);
    eigenfreq = corresp_pole(:, 2);

    % Pole markieren
    hold(graph, 'on');
    hBlink = plot(graph, eigenfreq, model_order, 'ro', ...
        'MarkerSize', 9, 'LineWidth', 2, 'DisplayName', 'Zugehörige Pole');
    
    % Markierung blinken
    for i = 1:5
        hBlink.Visible = 'off';
        pause(0.2);
        hBlink.Visible = 'on';
        pause(0.2);
    end

    % Markierung entfernen 
    delete(hBlink);
end