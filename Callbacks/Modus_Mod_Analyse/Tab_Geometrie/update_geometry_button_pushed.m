%% Callback für Button zum Aktualisieren der Geometrie (Modus "Modalanalyse")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function update_geometry_button_pushed(app)

    % Nötige Variablen holen
    assign_table = app.assign_table;                        % Tabelle für Zuweisungen
    node_table = app.node_table;                            % Tabelle für Knoten
    line_table = app.line_table;                            % Tabelle für Linien
    surface_table = app.surface_table;                      % Tabelle für Flächen
    graph = app.geometry_graph;                             % Graph für Geometrie
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
            error('Keine Messdaten importiert!');
        end      

        % Zuweisungen aus Tabelle holen
        assign_matrix = assign_table.Data;

        % Knoten aus Tabelle holen
        node_matrix = node_table.Data;

        % Linien aus Tabelle holen
        line_matrix = line_table.Data;

        % Flächen aus Tabelle holen
        surface_matrix = surface_table.Data;        

        % Prüfen, ob die Geometrie gültig ist
        check_valid_geometry(assign_matrix, node_matrix, line_matrix, surface_matrix);     

        % Geometrie speichern
        geometry.assign = assign_matrix;
        geometry.node = node_matrix;
        geometry.line = line_matrix;
        geometry.surface = surface_matrix;
        app.fig.UserData.cache.modal.geometry = geometry;
    
        % Graph aktualisieren
        plot_geometry(assign_matrix, node_matrix, line_matrix, surface_matrix, graph);

        % Status aktualisieren
        update_status(status, lamp,'>> Geometrie aktualisiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end