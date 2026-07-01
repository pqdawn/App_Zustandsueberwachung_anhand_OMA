%% Funktion zur Aktualisierung des Status
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 23.05.2025

% Übergabeparameter: status = Textfeld des Status mit alten Nachrichten
%                    lamp = Licht
%                    new_status = neue Nachricht
%                    type = Typ der Nachricht

% Ausgabeparameter: -

function update_status(status, lamp, new_status, type)

    % Alte Nachrichten speichern
    prev_status = status.Value;

    % Alte und neue Nachrichten ausgeben
    status.Value = [new_status ; prev_status];

    % Farbe des Lichtes ändern
    switch lower(type)
        case 'fehler'
            lamp.Color = [1, 0, 0];     % rot für Fehler

        case 'warnung'
            lamp.Color = [1, 0.5, 0];   % orange für Warnung

        case 'erfolg'
            lamp.Color = [0, 1, 0];     % grün für Erfolg

        otherwise
            lamp.Color = [0, 0, 0];     % ansonsten weiß
    end    
end
