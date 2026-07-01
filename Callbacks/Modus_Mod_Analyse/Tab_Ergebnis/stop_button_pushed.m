%% Callback für Button zum Stoppen der Animation (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    update_eigenform_button = Button für Darstellen der Eigenform (Modus "Modalanalyse")
%                       stop_button = Button für Stoppen (Modus "Modalanalyse" oder "Zusammenführung")
%                       lamp = Licht des Status
%                       status = Textfeld des Status
%                       update_eigenform_button_merge = Button für Darstellen der Eigenform (Modus "Zusammenführung")

% Ausgabeparameter: -

function stop_button_pushed(update_eigenform_button, stop_button, lamp, status, update_eigenform_button_merge)

    try
        % Timer stoppen bzw. Animation stoppen (Timer wurde unter
        % "update_eigenform_button" gespeichert)
        stop(update_eigenform_button.UserData.clock);

        % Flagge aktualisieren
        update_eigenform_button.UserData.is_animating = false;

        % Diesen Button deaktivieren
        stop_button.Enable = 'off';

        % Falls Button für Darstellen der Eigenform im Modus 
        % "Zusammenführung" eingegeben wurde, muss er aktiviert werden
        if nargin == 5
            update_eigenform_button_merge.Enable = 'on';

        % Sonst der Button im Modus "Modalanalyse" aktivieren
        else
            update_eigenform_button.Enable = 'on';
        end

        % Status aktualisieren
        update_status(status, lamp, '>> Animation gestoppt', ...
        'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end