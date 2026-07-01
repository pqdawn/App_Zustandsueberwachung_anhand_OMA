%% Callback für Button zum Entfernen einer Fläche (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       surface_table = Tabelle für Flächen
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function surface_remove_button_pushed(cache, surface_table, lamp, status)

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

        % Fehlermeldung falls keine Flächen vorhanden sind
        if isempty(surface_table.Data)
            error('Keine Flächen vorhanden!');
        end

        % Flächen aus Tabelle holen
        surface_matrix = surface_table.Data;

        % Gewählte Fläche holen
        surface_to_remove = surface_table.UserData.row_selected;

        % Fehlermeldung falls keine Fläche gewählt wurde
        if any(isnan(surface_to_remove), 'all') || isempty(surface_to_remove)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Fäche "out of range"
        if surface_to_remove > size(surface_matrix, 1)
            error('Keine Zeile gewählt!');
        end

        % Daten dieser gewählten Fläche entfernen
        surface_matrix(surface_to_remove, :) = [];

        % Tabelle aktualisieren
        surface_table.Data = surface_matrix;

        % Wenn Tabelle leer ist
        if isempty(surface_table.Data)

            % Tabelle zurücksetzen
            surface_table.Data = [];
            surface_table.ColumnName = {'Flächen werden hier eingestellt'};
        end        

        % Status aktualisieren
        update_status(status, lamp,'>> Fläche entfernt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end    
end