%% Callback für Button zum Entfernen eines Knotens (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       node_table = Tabelle für Knoten
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function node_remove_button_pushed(cache, node_table, lamp, status)

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

        % Knoten aus Tabelle holen
        node_matrix = node_table.Data;

        % Gewählten Knoten holen
        node_to_remove = node_table.UserData.row_selected;

        % Fehlermeldung falls kein Knoten gewählt wurde
        if any(isnan(node_to_remove), 'all') || isempty(node_to_remove)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls der gewählte Knoten "out of range"
        if node_to_remove > size(node_matrix, 1)
            error('Keine Zeile gewählt!');
        end

        % Daten dieses gewählten Knotens entfernen
        node_matrix(node_to_remove, :) = [];

        % Tabelle aktualisieren
        node_table.Data = node_matrix;

        % Wenn Tabelle leer ist
        if isempty(node_table.Data)

            % Tabelle zurücksetzen
            node_table.Data = [];
            node_table.ColumnName = {'Knoten werden hier eingestellt'};
        end

        % Status aktualisieren
        update_status(status, lamp,'>> Knoten entfernt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end    
end