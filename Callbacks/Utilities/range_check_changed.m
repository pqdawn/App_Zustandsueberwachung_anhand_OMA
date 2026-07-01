%% Callback für Checkbox für fixierten Bereich der x-Achse
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    src = Diese Checkbox
%                       edit_field = Eingabefeld für fixierten Bereich der x-Achse
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function range_check_changed(src, edit_field, lamp, status)

    try
        % Falls fixierter Bereich angeschaltet ist
        if src.Value

            % Eingabefeld aktivieren
            edit_field.Editable = 1;

            % Hintergrundfarbe bearbeiten
            edit_field.BackgroundColor = [1,1,1];

            % Status aktualisieren
            update_status(status, lamp, '>> Fixierter Bereich der x-Achse aktiviert', 'erfolg');

        % Falls fixierter Bereich ausgeschaltet ist
        else

            % Eingabefeld deaktivieren
            edit_field.Editable = 0;

            % Hintergrundfarbe bearbeiten
            edit_field.BackgroundColor = [0.80,0.80,0.80];

            % Status aktualisieren
            update_status(status, lamp, '>> Fixierter Bereich der x-Achse deaktiviert', 'erfolg');
        end

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end