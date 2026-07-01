%% Callback für Button zum Importieren der Knoten (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       node_table = Tabelle für Knoten
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function node_import_button_pushed(cache, node_table, lamp, status)

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

        % Datei auswählen
        [filename,path] = uigetfile('*.txt');

        % Fehlermeldung falls keine Datei ausgewählt wurde
        if isequal(filename,0)
            error('Keine Datei ausgewählt');
        end

        % Dateipfad holen
        path = [path,filename];         
        
        % Daten einlesen
        node_matrix = readmatrix(path, 'NumHeaderLines', 1);

        % Fehlermeldung falls die Datei nicht genau 4 Spalten hat
        if size(node_matrix,2) ~= 4
             error('Die Datei hat nicht genau 4 Spalten!');
        end

        % Tabelle mit eingelesenen Daten aktualisieren
        node_table.Data = node_matrix(:, 2:end);

        % Titel der Spalten benennen
        node_col_title = {'x-Koor', 'y-Koor', 'z-Koor'};
        node_table.ColumnName = node_col_title;
        node_table.ColumnWidth = repmat({'1x'}, 1, 3);
        node_table.ColumnEditable = true(1, 3);    

        % Status aktualisieren
        update_status(status, lamp, '>> Knoten importiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end