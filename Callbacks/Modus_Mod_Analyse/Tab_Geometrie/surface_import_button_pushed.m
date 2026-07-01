%% Callback für Button zum Importieren der Flächen (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       line_table = Tabelle für Linien
%                       surface_table = Tabelle für Flächen
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function surface_import_button_pushed(cache, line_table, surface_table, lamp, status)

    try
        % Für Modus "Modalanalyse"
        if isfield(cache, 'data_matrix')

            % Fehlermeldung falls keine Messdaten importiert
            if isnan(cache.data_matrix)
                error('Keine Messdaten importiert!');
            end

        % Für Modus "Zusammenführung"
        elseif isfield(cache, 'eigenfreq')

            % Fehlermeldung falls keine Eigenfrequenzen importiert
            if isempty(cache.eigenfreq)
                error('Keine Eigenfrequenzen importiert!');
            end
    
            % Fehlermeldung falls Eigenvektoren nicht vollständig importiert
            if any(cellfun(@isempty, cache.eigenvector))
                error('Eigenvektoren nicht vollständig importiert!');
            end   
        end

        % Fehlermeldung falls keine Linien vorhanden sind
        if isempty(line_table.Data)
            error('Keine Linien vorhanden!');
        end

        % Datei auswählen
        [filename,path] = uigetfile('*.txt');

        % Fehlermeldung falls keine Datei ausgewählt wurde
        if isequal(filename,0)
            error('Keine Datei ausgewählt');
        end

        % Dateipfad holen
        path = [path,filename];         
        
        % Daten einlesen
        surface_matrix = readmatrix(path, 'NumHeaderLines', 1);

        % Fehlermeldung falls die Datei nicht genau 4 Spalten hat
        if size(surface_matrix,2) ~= 4
             error('Die Datei hat nicht genau 4 Spalten!');
        end

        % Tabelle mit eingelesenen Daten aktualisieren
        surface_table.Data = surface_matrix(:, 2:end);

        % Titel der Spalten benennen
        line_col_title = {'1. Linie', '2. Linie', '3. Linie'};
        surface_table.ColumnName = line_col_title;
        surface_table.ColumnWidth = repmat({'1x'}, 1, 3);
        surface_table.ColumnEditable = true(1, 3);

        % Status aktualisieren
        update_status(status, lamp, '>> Flächen importiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end