%% Callback für Button zum Suchen des Ordners
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    edit_field = Eingabefeld für Ordnerpfad
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function search_file_button_pushed(edit_field, lamp, status)

    try
        % Ordner vom Benutzer auswählen lassen
        folder = uigetdir(pwd,'Ordner auswählen');
        
        % Fehlermeldung falls kein Ordner ausgewählt wurde
        if folder == 0
            error('Kein Ordner ausgewählt');
        end

        % Eingabefeld für Pfad aktualisieren
        edit_field.Value = folder;

        % Status aktualisieren
        update_status(status, lamp, '>> Pfad eingetragen', 'erfolg');        

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end  