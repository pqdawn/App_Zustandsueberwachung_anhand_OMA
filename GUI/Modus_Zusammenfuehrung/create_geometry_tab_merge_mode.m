%% Tab "Geometrie" im Modus "Zusammenführung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_geometry_tab_merge_mode(app) 

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
    delete(app.geometry_tab_merge_mode.Children);  

    % Subtabs für Geometrie 
    app.sub_tab_group_geometry_tab_merge = uitabgroup(app.geometry_tab_merge_mode);
    x_sub_tab = 320;
    y_sub_tab = y_fig-3*y_boundary-y_space-y_fix;
    app.sub_tab_group_geometry_tab_merge.Position = [x_boundary y_boundary+y_space+y_fix x_sub_tab y_sub_tab];
    app.assign_sub_tab_merge = uitab(app.sub_tab_group_geometry_tab_merge, 'Title', 'Zuweisungen');                     % Zuweisungen
    app.node_sub_tab_merge = uitab(app.sub_tab_group_geometry_tab_merge, 'Title', 'Knoten');                            % Knoten
    app.line_sub_tab_merge = uitab(app.sub_tab_group_geometry_tab_merge, 'Title', 'Linien');                            % Linien
    app.surface_sub_tab_merge = uitab(app.sub_tab_group_geometry_tab_merge, 'Title', 'Flächen');                        % Flächen

    % Button für Importieren
    app.assign_import_button_merge = uibutton(app.assign_sub_tab_merge, 'Text', 'Datei importieren');
    app.assign_import_button_merge.Position = [x_boundary y_sub_tab-60 x_sub_tab-2*x_boundary-0.2*x_small-x_space y_fix];    

    % Hilfe für Pfad
    app.assign_path_help_merge = uilabel(app.assign_sub_tab_merge, 'Text', '(?)');
    app.assign_path_help_merge.Position = [x_boundary+0.5*x_small+0.7*x_large y_sub_tab-60 0.2*x_small y_fix];
    app.assign_path_help_merge.Tooltip = {'Entweder importieren oder manuell bearbeiten'};

    % Tabelle für Zuweisungen
    app.assign_table_merge = uitable(app.assign_sub_tab_merge);
    x_assign_table_merge = x_sub_tab-2*x_boundary;
    y_assign_table_merge = y_sub_tab-60-y_fix-y_space;
    app.assign_table_merge.Position = [x_boundary y_boundary x_assign_table_merge y_assign_table_merge];
    app.assign_table_merge.ColumnName = {'Zuweisungen werden hier eingestellt'};

    % Button für Importieren
    app.node_import_button_merge = uibutton(app.node_sub_tab_merge, 'Text', 'Datei importieren');
    app.node_import_button_merge.Position = [x_boundary y_sub_tab-60 x_sub_tab-2*x_boundary-0.2*x_small-x_space y_fix];    

    % Hilfe für Pfad
    app.node_path_help_merge = uilabel(app.node_sub_tab_merge, 'Text', '(?)');
    app.node_path_help_merge.Position = [x_boundary+0.5*x_small+0.7*x_large y_sub_tab-60 0.2*x_small y_fix];
    app.node_path_help_merge.Tooltip = {'Entweder importieren oder manuell bearbeiten'};

    % Tabelle für Knoten
    app.node_table_merge = uitable(app.node_sub_tab_merge);
    y_node_table_merge = y_assign_table_merge-y_fix-y_space;
    app.node_table_merge.Position = [x_boundary y_boundary+y_fix+y_space x_assign_table_merge y_node_table_merge];
    app.node_table_merge.ColumnName = {'Knoten werden hier eingestellt'};
    app.node_table_merge.SelectionType = 'row';

    % Gewählte Zeile unter "node_table" speichern
    app.node_table_merge.UserData.row_selected = NaN;

    % Button für Einfügen eines Knotens
    x_node_insert_button_merge = (x_assign_table_merge-2*x_space-0.2*x_small)/2;
    app.node_insert_button_merge = uibutton(app.node_sub_tab_merge, 'Text', 'Einfügen');
    app.node_insert_button_merge.Position = [x_boundary y_boundary x_node_insert_button_merge y_fix];

    % Button für Entfernen eines Knotens
    app.node_remove_button_merge = uibutton(app.node_sub_tab_merge, 'Text', 'Entfernen');
    app.node_remove_button_merge.Position = [x_boundary+x_node_insert_button_merge+x_space y_boundary x_node_insert_button_merge y_fix];

    % Hilfe für Einfügen und Entfernen
    app.node_insert_help_merge = uilabel(app.node_sub_tab_merge, 'Text', '(?)');
    app.node_insert_help_merge.Position = [x_boundary+2*x_node_insert_button_merge+2*x_space y_boundary x_node_insert_button_merge y_fix];
    app.node_insert_help_merge.Tooltip = {'- Knoten ohne Zuweisung sind feste Punkte';
        '- Eine neue Zeile wird vor der gewälten Zeile eingefügt';
        '- Wenn keine Zeile gewählt wurde, wird sie am Ende eingefügt';
        '- Beim Löschen muss eine Zeile gewählt werden'};

    % Button für Importieren
    app.line_import_button_merge = uibutton(app.line_sub_tab_merge, 'Text', 'Datei importieren');
    app.line_import_button_merge.Position = [x_boundary y_sub_tab-60 x_sub_tab-2*x_boundary-0.2*x_small-x_space y_fix];    

    % Hilfe für Pfad
    app.line_path_help_merge = uilabel(app.line_sub_tab_merge, 'Text', '(?)');
    app.line_path_help_merge.Position = [x_boundary+0.5*x_small+0.7*x_large y_sub_tab-60 0.2*x_small y_fix];
    app.line_path_help_merge.Tooltip = {'Entweder importieren oder manuell bearbeiten'};

    % Tabelle für Linien
    app.line_table_merge = uitable(app.line_sub_tab_merge);
    app.line_table_merge.Position = [x_boundary y_boundary+y_fix+y_space x_assign_table_merge y_node_table_merge];
    app.line_table_merge.ColumnName = {'Linien werden hier eingestellt'};
    app.line_table_merge.SelectionType = 'row';

    % Button für Einfügen einer Linie
    app.line_insert_button_merge = uibutton(app.line_sub_tab_merge, 'Text', 'Einfügen');
    app.line_insert_button_merge.Position = [x_boundary y_boundary x_node_insert_button_merge y_fix];

    % Button für Entfernen einer Linie
    app.line_remove_button_merge = uibutton(app.line_sub_tab_merge, 'Text', 'Entfernen');
    app.line_remove_button_merge.Position = [x_boundary+x_node_insert_button_merge+x_space y_boundary x_node_insert_button_merge y_fix];

    % Hilfe für Einfügen und Entfernen
    app.line_insert_help_merge = uilabel(app.line_sub_tab_merge, 'Text', '(?)');
    app.line_insert_help_merge.Position = [x_boundary+2*x_node_insert_button_merge+2*x_space y_boundary x_node_insert_button_merge y_fix];
    app.line_insert_help_merge.Tooltip = {'- Eine neue Zeile wird vor der gewälten Zeile eingefügt';
        '- Wenn keine Zeile gewählt wurde, wird sie am Ende eingefügt';
        '- Beim Löschen muss eine Zeile gewählt werden'};

    % Gewählte Zeile unter "line_table" speichern
    app.line_table_merge.UserData.row_selected = NaN;

    % Button für Importieren
    app.surface_import_button_merge = uibutton(app.surface_sub_tab_merge, 'Text', 'Datei importieren');
    app.surface_import_button_merge.Position = [x_boundary y_sub_tab-60 x_sub_tab-2*x_boundary-0.2*x_small-x_space y_fix];    

    % Hilfe für Pfad
    app.surface_path_help_merge = uilabel(app.surface_sub_tab_merge, 'Text', '(?)');
    app.surface_path_help_merge.Position = [x_boundary+0.5*x_small+0.7*x_large y_sub_tab-60 0.2*x_small y_fix];
    app.surface_path_help_merge.Tooltip = {'Entweder importieren oder manuell bearbeiten'};

    % Tabelle für Flächen
    app.surface_table_merge = uitable(app.surface_sub_tab_merge);
    app.surface_table_merge.Position = [x_boundary y_boundary+y_fix+y_space x_assign_table_merge y_node_table_merge];
    app.surface_table_merge.ColumnName = {'Flächen werden hier eingestellt'};
    app.surface_table_merge.SelectionType = 'row';

    % Button für Einfügen einer Fläche
    app.surface_insert_button_merge = uibutton(app.surface_sub_tab_merge, 'Text', 'Einfügen');
    app.surface_insert_button_merge.Position = [x_boundary y_boundary x_node_insert_button_merge y_fix];

    % Button für Entfernen einer Fläche
    app.surface_remove_button_merge = uibutton(app.surface_sub_tab_merge, 'Text', 'Entfernen');
    app.surface_remove_button_merge.Position = [x_boundary+x_node_insert_button_merge+x_space y_boundary x_node_insert_button_merge y_fix];

    % Hilfe für Einfügen und Entfernen
    app.surface_insert_help_merge = uilabel(app.surface_sub_tab_merge, 'Text', '(?)');
    app.surface_insert_help_merge.Position = [x_boundary+2*x_node_insert_button_merge+2*x_space y_boundary x_node_insert_button_merge y_fix];
    app.surface_insert_help_merge.Tooltip = {'- Eine neue Zeile wird vor der gewälten Zeile eingefügt';
        '- Wenn keine Zeile gewählt wurde, wird sie am Ende eingefügt';
        '- Beim Löschen muss eine Zeile gewählt werden'};

    % Gewählte Zeile unter "surface_table" speichern
    app.surface_table_merge.UserData.row_selected = NaN;

    % Button für Aktualisieren der Geometrie
    app.update_geometry_button_merge = uibutton(app.geometry_tab_merge_mode, 'Text', 'Geometrie aktualisieren');
    app.update_geometry_button_merge.Position = [x_boundary y_boundary x_sub_tab y_fix];

    % Graph für Geometrie 
    app.geometry_graph_merge = uiaxes(app.geometry_tab_merge_mode);
    app.geometry_graph_merge.XGrid = 'on';
    app.geometry_graph_merge.YGrid = 'on';
    app.geometry_graph_merge.ZGrid = 'on';
    app.geometry_graph_merge.Position = [x_boundary+x_sub_tab+x_space y_boundary 1000-x_sub_tab-x_boundary-2*x_space y_sub_tab+30];
    app.geometry_graph_merge.Title.String = '\textbf{Geometrie}';
    app.geometry_graph_merge.XLabel.String = 'x';
    app.geometry_graph_merge.YLabel.String = 'y';
    app.geometry_graph_merge.ZLabel.String = 'z';
    app.geometry_graph_merge.View = [-37.5, 30];
end