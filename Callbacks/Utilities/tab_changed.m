%% Callback für Änderung der Tabs
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    src = Diese Gruppe von Tabs
%                       event = Ereignis
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function tab_changed(src, event, lamp, status)

    try
        % Wenn die Textfarbe dieses Tabs grau ist
        if isequal(event.NewValue.ForegroundColor, [0.65, 0.65, 0.65])
            
            % Dieser Tab ist gesperrt und auf vorherigen Tab stellen
            src.SelectedTab = event.OldValue;
            drawnow limitrate nocallbacks

            % Fehlermeldung
            error('Tab gesperrt!');
        end

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end    
end