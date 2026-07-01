%% Callback für Button zum Einfügen eines Knotens (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       node_table = Tabelle für Knoten
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function node_insert_button_pushed(cache, node_table, lamp, status)

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

        % Knoten aus Tabelle holen
        node_matrix = node_table.Data;

        % Gewählten Knoten holen
        node_selected = node_table.UserData.row_selected;

        % Neuen Knoten erstellen
        node_new = zeros(1, 3);

        % Wenn gar keine Knoten in der Tabelle, dann am Anfang einfügen
        if isempty(node_matrix)
            node_matrix = node_new;
            node_col_title = {'x-Koor', 'y-Koor', 'z-Koor'};
            node_table.ColumnName = node_col_title;
            node_table.ColumnWidth = repmat({'1x'}, 1, 3);
            node_table.ColumnEditable = true(1, 3);            

        % Wenn ein Knoten gewählt wurde, dann diesen neuen Knoten davorne einfügen
        elseif ~isnan(node_selected)
            node_matrix = [node_matrix(1:node_selected-1, :); node_new; node_matrix(node_selected:end, :)];

        % Ansonsten ganz am Ende einfügen
        else
            node_matrix = [node_matrix; node_new];
        end

        % Tabelle aktualisieren
        node_table.Data = node_matrix;

        % Status aktualisieren
        update_status(status, lamp,'>> Knoten eingefügt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end    
end