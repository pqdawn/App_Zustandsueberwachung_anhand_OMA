%% Callback für Button zum Einfügen einer Fläche (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       line_table = Tabelle für Linien
%                       surface_table = Tabelle für Flächen
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function surface_insert_button_pushed(cache, line_table, surface_table, lamp, status)

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

        % Flächen aus Tabelle holen
        surface_matrix = surface_table.Data;

        % Gewählte Fläche holen
        row = surface_table.UserData.row_selected;

        % Neue Fläche erstellen
        surface_new = zeros(1, 3);

        % Wenn gar keine Fläche in der Tabelle, dann am Anfang einfügen und
        % Titel der Spalten benennen
        if isempty(surface_matrix)
            surface_matrix = surface_new;
            line_col_title = {'1. Linie', '2. Linie', '3. Linie'};
            surface_table.ColumnName = line_col_title;
            surface_table.ColumnWidth = repmat({'1x'}, 1, 3);
            surface_table.ColumnEditable = true(1, 3);

        % Wenn eine Fläche gewählt wurde, dann diese neue Fläche davorne einfügen
        elseif ~isnan(row)
            surface_matrix = [surface_matrix(1:row-1, :); surface_new; surface_matrix(row:end, :)];

        % Ansonsten ganz am Ende einfügen
        else
            surface_matrix = [surface_matrix; surface_new];
        end

        % Tabelle aktualisieren
        surface_table.Data = surface_matrix;

        % Status aktualisieren
        update_status(status, lamp,'>> Fläche eingefügt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end