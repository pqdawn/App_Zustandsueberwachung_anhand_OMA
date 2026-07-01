%% Tab "Eigenvektor" im Modus "Zusammenführung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_eigenvector_tab(app)

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
    delete(app.eigenvector_tab.Children);  

    % Label für Gruppennummer
    app.group_number_label2 = uilabel(app.eigenvector_tab, 'Text', 'Gruppennummer: ');
    app.group_number_label2.Position = [x_boundary y_fig-60 x_large y_fix];

    % Dropdown für Gruppennummer
    app.group_number_dropdown = uidropdown(app.eigenvector_tab);
    app.group_number_dropdown.Position = [x_boundary+1.2*x_small y_fig-60 x_small y_fix];  
    app.group_number_dropdown.Items = {'-'};

    % Label für Pfad
    app.eigenvector_path_label = uilabel(app.eigenvector_tab, 'Text', 'Ordnerpfad: ');
    app.eigenvector_path_label.Position = [x_boundary y_fig-90 1.2*x_small y_fix];

    % Eingabefeld für Pfad
    app.eigenvector_path_edit_field = uieditfield(app.eigenvector_tab, 'Placeholder', 'in Format C:\Ordner');
    app.eigenvector_path_edit_field.Position = [x_boundary+1.2*x_small y_fig-90 x_large y_fix];

    % Hilfe für Pfad
    app.eigenvector_path_help = uilabel(app.eigenvector_tab, 'Text', '(?)');
    app.eigenvector_path_help.Position = [x_boundary+1.2*x_small+x_large+x_space y_fig-90 0.2*x_small y_fix];
    app.eigenvector_path_help.Tooltip =  {'- Dieser Ordner enthält TXT-Dateien der Eigenvektoren für eine Gruppe'
        '- Jede Mode benötigt eine TXT-Datei (z.B. 3 Dateien für 3 Moden)'
        '- Jede Gruppe benötigt einen Ordner (z.B. 3 Ordner für 3 Gruppen)'
        '- Format aus dem Export im Modus "Modalanalyse" wird empfohlen'};

    % Button für Suchen des Ordners
    app.search_file_eigenvector_button = uibutton(app.eigenvector_tab, 'Text', 'Ordner suchen');
    app.search_file_eigenvector_button.Position = [x_boundary+1.2*x_small y_fig-120 x_large y_fix];      

    % Button für Importieren der Gruppen der Eigenvektoren
    app.import_eigenvector_group_button = uibutton(app.eigenvector_tab, 'Text', 'Importieren');
    app.import_eigenvector_group_button.Position = [x_boundary+1.2*x_small y_fig-150 x_large y_fix];    

    % Tabelle für Gruppen der Eigenvektoren
    y_table = 225;
    app.eigenvector_group_table = uitable(app.eigenvector_tab);
    app.eigenvector_group_table.Position = [x_boundary y_boundary+y_table+2*y_space+y_fix 1000-2*x_boundary ...
        y_table+30];
    app.eigenvector_group_table.ColumnName = {'Gruppen der Eigenvektoren wird hier angezeigt'};  
    app.eigenvector_group_table.SelectionType = 'row';

    % Variablen unter "eigenvector_group_table" speichern
    app.eigenvector_group_table.UserData.row_selected = NaN;                 % Gewählte Zeile
    app.eigenvector_group_table.UserData.group_config = [];                  % Zuordnung der Gruppen

    % Button für Anzeigen des Eigenvektors
    app.show_vector_button = uibutton(app.eigenvector_tab, 'Text', 'Eigenvektor anzeigen');
    app.show_vector_button.Position = [x_boundary y_boundary+y_table+y_space x_large y_fix];

    % Button für Aktualisieren der Gruppen der Eigenvektoren
    app.update_eigenvector_group_button = uibutton(app.eigenvector_tab, 'Text', 'Aktualisieren');
    app.update_eigenvector_group_button.Position = [x_boundary+x_large+x_space y_boundary+y_table+y_space x_large y_fix];     

    % Tabelle für Eigenvektor
    app.eigenvector_table = uitable(app.eigenvector_tab);
    app.eigenvector_table.Position = [x_boundary y_boundary x_large y_table];
    app.eigenvector_table.ColumnName = {'Eigenvektor wird hier angezeigt'};  
end