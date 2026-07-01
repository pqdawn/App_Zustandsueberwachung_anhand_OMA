%% Callback für Button zum Einfügen einer Linie (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       node_table = Tabelle für Knoten
%                       line_table = Tabelle für Linien
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function line_insert_button_pushed(cache, node_table, line_table, lamp, status)

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

        % Fehlermeldung falls keine Knoten vorhanden sind
        if isempty(node_table.Data)
            error('Keine Knoten vorhanden!');
        end

        % Linien aus Tabelle holen
        line_matrix = line_table.Data;

        % Gewählte Linie holen
        line_selected = line_table.UserData.row_selected;

        % Neue Linie erstellen
        line_new = zeros(1, 2);

        % Wenn gar keine Linie in der Tabelle, dann am Anfang einfügen und
        % Titel der Spalten benennen
        if isempty(line_matrix)
            line_matrix = line_new;
            line_col_title = {'1. Knoten', '2. Knoten'};
            line_table.ColumnName = line_col_title;
            line_table.ColumnWidth = repmat({'1x'}, 1, 2);
            line_table.ColumnEditable = true(1, 2);

        % Wenn eine Linie gewählt wurde, dann diese neue Linie davorne einfügen
        elseif ~isnan(line_selected)
            line_matrix = [line_matrix(1:line_selected-1, :); line_new; line_matrix(line_selected:end, :)];

        % Ansonsten ganz am Ende einfügen
        else
            line_matrix = [line_matrix; line_new];
        end

        % Tabelle aktualisieren
        line_table.Data = line_matrix;

        % Status aktualisieren
        update_status(status, lamp,'>> Linie eingefügt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end