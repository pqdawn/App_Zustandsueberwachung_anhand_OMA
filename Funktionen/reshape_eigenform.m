%% Funktion zur Anpassung der Eigenform, damit sie für Darstellung und MAC-Vergleich geeignet ist
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    eigenform_selected = Eigenform
%                       num_sensor = Anzahl der Sensoren
%                       direction = Gemessene Richtungen

% Ausgabeparameter:     new_eigenform = angepasste Eigenform

function new_eigenform = reshape_eigenform(eigenform_selected, num_sensor, direction)

    % Richtungen holen
    position_direction = find(direction);
    num_direct = sum(direction);

    % Eigenform abhängig von Richtungen zerlegen
    eigenform_selected = reshape(eigenform_selected, num_sensor, num_direct);

    % Neue Eigenform mit 3 Richtungen instanziieren
    eigenform_selected_3d = zeros(num_sensor, 3);

    % Koordinaten zuordnen
    for i = 1:num_direct
        eigenform_selected_3d(:, position_direction(i)) = eigenform_selected(:, i);
    end

    % Eigenform wieder in eine Spalte einordnen
    new_eigenform = reshape(eigenform_selected_3d.', [], 1);
end