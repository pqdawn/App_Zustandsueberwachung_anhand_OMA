%% Tab "Geometrie" im Modus "Modalanalyse"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_geometry_tab(app)

    % Größen holen
    y_fig = app.y_fig;
    x_boundary = app.x_boundary;
    y_boundary = app.y_boundary;
    x_space = app.x_space;
    y_space = app.y_space;
    x_large = app.x_large;
    x_small = app.x_small;
    y_fix = app.y_fix;

    % Alle Komponenten in diesem Tab löschen
    delete(app.geometry_tab.Children);    

    % Subtabs für Geometrie 
    app.sub_tab_group_geometry_tab = uitabgroup(app.geometry_tab);
    x_sub_tab = 320;
    y_sub_tab = y_fig-3*y_boundary-y_space-y_fix;
    app.sub_tab_group_geometry_tab.Position = [x_boundary y_boundary+y_space+y_fix x_sub_tab y_sub_tab];
    app.assign_sub_tab = uitab(app.sub_tab_group_geometry_tab, 'Title', 'Zuweisungen');                     % Zuweisungen
    app.node_sub_tab = uitab(app.sub_tab_group_geometry_tab, 'Title', 'Knoten');                            % Knoten
    app.line_sub_tab = uitab(app.sub_tab_group_geometry_tab, 'Title', 'Linien');                            % Linien
    app.surface_sub_tab = uitab(app.sub_tab_group_geometry_tab, 'Title', 'Flächen');                        % Flächen

    % Button für Importieren
    app.assign_import_button = uibutton(app.assign_sub_tab, 'Text', 'Datei importieren');
    app.assign_import_button.Position = [x_boundary y_sub_tab-60 x_sub_tab-2*x_boundary-0.2*x_small-x_space y_fix];    

    % Hilfe für Pfad
    app.assign_path_help = uilabel(app.assign_sub_tab, 'Text', '(?)');
    app.assign_path_help.Position = [x_boundary+0.5*x_small+0.7*x_large y_sub_tab-60 0.2*x_small y_fix];
    app.assign_path_help.Tooltip = {'Entweder importieren oder manuell bearbeiten'};

    % Tabelle für Zuweisungen
    app.assign_table = uitable(app.assign_sub_tab);
    x_assign_table = x_sub_tab-2*x_boundary;
    y_assign_table = y_sub_tab-60-y_fix-y_space;
    app.assign_table.Position = [x_boundary y_boundary x_assign_table y_assign_table];
    app.assign_table.ColumnName = {'Zuweisungen werden hier eingestellt'};

    % Button für Importieren
    app.node_import_button = uibutton(app.node_sub_tab, 'Text', 'Datei importieren');
    app.node_import_button.Position = [x_boundary y_sub_tab-60 x_sub_tab-2*x_boundary-0.2*x_small-x_space y_fix];    

    % Hilfe für Pfad
    app.node_path_help = uilabel(app.node_sub_tab, 'Text', '(?)');
    app.node_path_help.Position = [x_boundary+0.5*x_small+0.7*x_large y_sub_tab-60 0.2*x_small y_fix];
    app.node_path_help.Tooltip = {'Entweder importieren oder manuell bearbeiten'};

    % Tabelle für Knoten
    app.node_table = uitable(app.node_sub_tab);
    y_node_table = y_assign_table-y_fix-y_space;
    app.node_table.Position = [x_boundary y_boundary+y_fix+y_space x_assign_table y_node_table];
    app.node_table.ColumnName = {'Knoten werden hier eingestellt'};
    app.node_table.SelectionType = 'row';

    % Gewählte Zeile unter "node_table" speichern
    app.node_table.UserData.row_selected = NaN;

    % Button für Einfügen eines Knotens
    x_node_insert_button = (x_assign_table-2*x_space-0.2*x_small)/2;
    app.node_insert_button = uibutton(app.node_sub_tab, 'Text', 'Einfügen');
    app.node_insert_button.Position = [x_boundary y_boundary x_node_insert_button y_fix];

    % Button für Entfernen eines Knotens
    app.node_remove_button = uibutton(app.node_sub_tab, 'Text', 'Entfernen');
    app.node_remove_button.Position = [x_boundary+x_node_insert_button+x_space y_boundary x_node_insert_button y_fix];

    % Hilfe für Einfügen und Entfernen
    app.node_insert_help = uilabel(app.node_sub_tab, 'Text', '(?)');
    app.node_insert_help.Position = [x_boundary+2*x_node_insert_button+2*x_space y_boundary x_node_insert_button y_fix];
    app.node_insert_help.Tooltip = {'- Knoten ohne Zuweisung sind feste Punkte';
        '- Eine neue Zeile wird vor der gewälten Zeile eingefügt';
        '- Wenn keine Zeile gewählt wurde, wird sie am Ende eingefügt';
        '- Beim Löschen muss eine Zeile gewählt werden'};

    % Button für Importieren
    app.line_import_button = uibutton(app.line_sub_tab, 'Text', 'Datei importieren');
    app.line_import_button.Position = [x_boundary y_sub_tab-60 x_sub_tab-2*x_boundary-0.2*x_small-x_space y_fix];    

    % Hilfe für Pfad
    app.line_path_help = uilabel(app.line_sub_tab, 'Text', '(?)');
    app.line_path_help.Position = [x_boundary+0.5*x_small+0.7*x_large y_sub_tab-60 0.2*x_small y_fix];
    app.line_path_help.Tooltip = {'Entweder importieren oder manuell bearbeiten'};

    % Tabelle für Linien
    app.line_table = uitable(app.line_sub_tab);
    app.line_table.Position = [x_boundary y_boundary+y_fix+y_space x_assign_table y_node_table];
    app.line_table.ColumnName = {'Linien werden hier eingestellt'};
    app.line_table.SelectionType = 'row';

    % Button für Einfügen einer Linie
    app.line_insert_button = uibutton(app.line_sub_tab, 'Text', 'Einfügen');
    app.line_insert_button.Position = [x_boundary y_boundary x_node_insert_button y_fix];

    % Button für Entfernen einer Linie
    app.line_remove_button = uibutton(app.line_sub_tab, 'Text', 'Entfernen');
    app.line_remove_button.Position = [x_boundary+x_node_insert_button+x_space y_boundary x_node_insert_button y_fix];

    % Hilfe für Einfügen und Entfernen
    app.line_insert_help = uilabel(app.line_sub_tab, 'Text', '(?)');
    app.line_insert_help.Position = [x_boundary+2*x_node_insert_button+2*x_space y_boundary x_node_insert_button y_fix];
    app.line_insert_help.Tooltip = {'- Eine neue Zeile wird vor der gewälten Zeile eingefügt';
        '- Wenn keine Zeile gewählt wurde, wird sie am Ende eingefügt';
        '- Beim Löschen muss eine Zeile gewählt werden'};

    % Gewählte Zeile unter "line_table" speichern
    app.line_table.UserData.row_selected = NaN;

    % Button für Importieren
    app.surface_import_button = uibutton(app.surface_sub_tab, 'Text', 'Datei importieren');
    app.surface_import_button.Position = [x_boundary y_sub_tab-60 x_sub_tab-2*x_boundary-0.2*x_small-x_space y_fix];    

    % Hilfe für Pfad
    app.surface_path_help = uilabel(app.surface_sub_tab, 'Text', '(?)');
    app.surface_path_help.Position = [x_boundary+0.5*x_small+0.7*x_large y_sub_tab-60 0.2*x_small y_fix];
    app.surface_path_help.Tooltip = {'Entweder importieren oder manuell bearbeiten'};

    % Tabelle für Flächen
    app.surface_table = uitable(app.surface_sub_tab);
    app.surface_table.Position = [x_boundary y_boundary+y_fix+y_space x_assign_table y_node_table];
    app.surface_table.ColumnName = {'Flächen werden hier eingestellt'};
    app.surface_table.SelectionType = 'row';

    % Button für Einfügen einer Fläche
    app.surface_insert_button = uibutton(app.surface_sub_tab, 'Text', 'Einfügen');
    app.surface_insert_button.Position = [x_boundary y_boundary x_node_insert_button y_fix];

    % Button für Entfernen einer Fläche
    app.surface_remove_button = uibutton(app.surface_sub_tab, 'Text', 'Entfernen');
    app.surface_remove_button.Position = [x_boundary+x_node_insert_button+x_space y_boundary x_node_insert_button y_fix];

    % Hilfe für Einfügen und Entfernen
    app.surface_insert_help = uilabel(app.surface_sub_tab, 'Text', '(?)');
    app.surface_insert_help.Position = [x_boundary+2*x_node_insert_button+2*x_space y_boundary x_node_insert_button y_fix];
    app.surface_insert_help.Tooltip = {'- Eine neue Zeile wird vor der gewälten Zeile eingefügt';
        '- Wenn keine Zeile gewählt wurde, wird sie am Ende eingefügt';
        '- Beim Löschen muss eine Zeile gewählt werden'};

    % Gewählte Zeile unter "surface_table" speichern
    app.surface_table.UserData.row_selected = NaN;

    % Button für Aktualisieren der Geometrie
    app.update_geometry_button = uibutton(app.geometry_tab, 'Text', 'Geometrie aktualisieren');
    app.update_geometry_button.Position = [x_boundary y_boundary x_sub_tab y_fix];

    % Graph für Geometrie 
    app.geometry_graph = uiaxes(app.geometry_tab);
    app.geometry_graph.XGrid = 'on';
    app.geometry_graph.YGrid = 'on';
    app.geometry_graph.ZGrid = 'on';
    app.geometry_graph.Position = [x_boundary+x_sub_tab+x_space y_boundary 1000-x_sub_tab-x_boundary-2*x_space y_sub_tab+30];
    app.geometry_graph.Title.String = '\textbf{Geometrie}';
    app.geometry_graph.XLabel.String = 'x';
    app.geometry_graph.YLabel.String = 'y';
    app.geometry_graph.ZLabel.String = 'z';
    app.geometry_graph.View = [-37.5, 30];
end