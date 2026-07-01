%% Callback für Dropdown für Gruppennummer
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function group_number_dropdown_changed(app)

    % Nötige Variablen holen
    path_edit_field = app.eigenvector_path_edit_field;      % Eingabefeld für Pfad
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status    

    try
        % Eingabefeld zurücksetzen
        path_edit_field.Value = '';

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end