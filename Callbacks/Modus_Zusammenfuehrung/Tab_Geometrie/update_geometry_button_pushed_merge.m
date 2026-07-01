%% Callback für Button zum Aktualisieren der Geometrie (Modus "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function update_geometry_button_pushed_merge(app)

    % Nötige Variablen holen
    assign_table = app.assign_table_merge;                      % Tabelle für Zuweisungen
    node_table = app.node_table_merge;                          % Tabelle für Knoten
    line_table = app.line_table_merge;                          % Tabelle für Linien
    surface_table = app.surface_table_merge;                    % Tabelle für Flächen
    graph = app.geometry_graph_merge;                           % Graph für Geometrie
    lamp = app.status_lamp;                                     % Licht des Status
    status = app.status_text_area;                              % Textfeld des Status

    try
        % Fehlermeldung falls keine Eigenfrequenzen importiert
        if isempty(app.fig.UserData.cache.merge.eigenfreq)
            error('Keine Eigenfrequenzen importiert!');
        end

        % Fehlermeldung falls Eigenvektoren nicht vollständig importiert
        if any(cellfun(@isempty, app.fig.UserData.cache.merge.eigenvector))
            error('Eigenvektoren nicht vollständig importiert!');
        end        

        % Importierte Daten und Infos holen
        num_group = app.fig.UserData.cache.merge.num_group;         

        % Zuweisungen ohne Gruppen aus Tabelle holen
        assign_matrix_w_out_group = assign_table.Data(:, 2:3);

        % Knoten aus Tabelle holen
        node_matrix = node_table.Data;

        % Linien aus Tabelle holen
        line_matrix = line_table.Data;

        % Flächen aus Tabelle holen
        surface_matrix = surface_table.Data;        

        % Prüfen, ob die Geometrie gültig ist
        check_valid_geometry(assign_matrix_w_out_group, node_matrix, line_matrix, surface_matrix);

        % Eigenvektoren holen
        eigenvector_matrix = app.fig.UserData.cache.merge.eigenvector;

        % Zuweisungen mit Gruppen aus Tabelle holen
        assign_matrix_w_group = assign_table.Data;

        % Wenn mehr als eine Gruppe vorhanden ist
        if num_group > 1

            % Eigenformen zusammenführen
            result_eigenform = merge_eigenform(assign_matrix_w_group, eigenvector_matrix);
            
        % Sonst
        else
            % Importierte Eigenvektoren übernehmen
            result_eigenform = eigenvector_matrix;
        end

        % Geometrie speichern
        geometry.assign = assign_matrix_w_group;
        geometry.node = node_matrix;
        geometry.line = line_matrix;
        geometry.surface = surface_matrix;
        app.fig.UserData.cache.merge.geometry = geometry;      

        % Ergebnisse speichern
        app.fig.UserData.cache.merge.result_eigenform = result_eigenform;        

        % Graph aktualisieren
        plot_geometry(assign_matrix_w_out_group, node_matrix, line_matrix, surface_matrix, graph); 

        % Status aktualisieren
        update_status(status, lamp,'>> Geometrie aktualisiert und Eigenformen zusammengeführt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end