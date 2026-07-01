%% Callback für Button zum Suchen der Datei
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    edit_field = Eingabefeld für Dateipfad
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function search_data_button_pushed(edit_field, lamp, status)

    try
        % Datei vom Benutzer auswählen lassen
        [filename,path] = uigetfile('*.txt');

        % Fehlermeldung falls keine Datei ausgewählt wurde
        if isequal(filename,0)
            error('Keine Datei ausgewählt');
        end

        % Eingabefeld für Pfad aktualisieren
        edit_field.Value = [path,filename];

        % Status aktualisieren
        update_status(status, lamp, '>> Pfad eingetragen', 'erfolg');        

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end  