%% Callback für Button zum Entfernen einer Linie (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       line_table = Tabelle für Linien
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function line_remove_button_pushed(cache, line_table, lamp, status)

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

        % Linie aus Tabelle holen
        line_matrix = line_table.Data;

        % Gewählte Linie holen
        line_to_remove = line_table.UserData.row_selected;

        % Fehlermeldung falls keine Linie gewählt wurde
        if any(isnan(line_to_remove), 'all') || isempty(line_to_remove)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Linie "out of range"
        if line_to_remove > size(line_matrix, 1)
            error('Keine Zeile gewählt!');
        end

        % Daten dieser gewählten Linie entfernen
        line_matrix(line_to_remove, :) = [];

        % Tabelle aktualisieren
        line_table.Data = line_matrix;

        % Wenn Tabelle leer ist
        if isempty(line_table.Data)

            % Tabelle zurücksetzen
            line_table.Data = [];
            line_table.ColumnName = {'Linien werden hier eingestellt'};
        end        

        % Status aktualisieren
        update_status(status, lamp,'>> Linie entfernt', 'erfolg');        

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end    
end