%% Tab "Referenzmoden" im Modus "Zustandsüberwachung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_reference_tab(app)

    % Größen holen
    y_fig = app.y_fig;
    x_boundary = app.x_boundary;
    y_boundary = app.y_boundary;
    x_space = app.x_space;
    x_large = app.x_large;
    x_small = app.x_small;
    y_fix = app.y_fix;   

    % Alle Komponenten in diesem Tab löschen
    delete(app.reference_tab.Children);      

    % Label für Dateipfad zu Eigenfrequenzen
    app.eigenfreq_path_label_monitor = uilabel(app.reference_tab, 'Text', 'Dateipfad zu Eigenfrequenzen:');
    app.eigenfreq_path_label_monitor.Position = [x_boundary y_fig-60 2*x_small y_fix];

    % Eingabefeld für Pfad
    app.eigenfreq_path_edit_field_monitor = uieditfield(app.reference_tab, 'Text', ...
        'Placeholder', 'in Format C:\Ordner\Datei.txt');
    app.eigenfreq_path_edit_field_monitor.Position = [x_boundary+2*x_small y_fig-60 x_large y_fix];

    % Hilfe für Pfad
    app.eigenfreq_path_help_monitor = uilabel(app.reference_tab, 'Text', '(?)');
    app.eigenfreq_path_help_monitor.Position = [x_boundary+2*x_small+x_large+x_space y_fig-60 0.2*x_small y_fix];
    app.eigenfreq_path_help_monitor.Tooltip =  {'- Diese Datei enthält Eigenfrequenzen'
        '- Diese Eigenfrequenzen legen die zu verfolgenden Moden fest'
        '- Format aus dem Export im Modus "Modalanalyse" wird empfohlen'};

    % Button für Suchen der Datei zu Eigenfrequenzen
    app.search_data_eigenfreq_button_monitor = uibutton(app.reference_tab, 'Text', 'Datei suchen');
    app.search_data_eigenfreq_button_monitor.Position = [x_boundary+2*x_small y_fig-90 x_large y_fix];

    % Label für Ordnerpfad zu Eigenvektoren
    app.eigenvector_path_label_monitor = uilabel(app.reference_tab, 'Text', 'Ordnerpfad zu Eigenvektoren:');
    app.eigenvector_path_label_monitor.Position = [x_boundary y_fig-120 2*x_small y_fix];

    % Eingabefeld für Pfad
    app.eigenvector_path_edit_field_monitor = uieditfield(app.reference_tab, 'Text', ...
        'Placeholder', 'in Format C:\Ordner');
    app.eigenvector_path_edit_field_monitor.Position = [x_boundary+2*x_small y_fig-120 x_large y_fix];

    % Hilfe für Pfad
    app.eigenvector_path_help_monitor = uilabel(app.reference_tab, 'Text', '(?)');
    app.eigenvector_path_help_monitor.Position = [x_boundary+2*x_small+x_large+x_space y_fig-120 0.2*x_small y_fix];
    app.eigenvector_path_help_monitor.Tooltip =  {'- Dieser Ordner enthält TXT-Dateien der Eigenvektoren'
        '- Jede Mode benötigt eine TXT-Datei (z.B. 3 Dateien für 3 Moden)'
        '- Format aus dem Export im Modus "Modalanalyse" wird empfohlen'};

    % Button für Suchen des Ordners zu Eigenvektoren
    app.search_file_eigenvector_button_monitor = uibutton(app.reference_tab, 'Text', 'Ordner suchen');
    app.search_file_eigenvector_button_monitor.Position = [x_boundary+2*x_small y_fig-150 x_large y_fix];    

    % Button für Importieren der Referenzmoden
    app.import_reference_button = uibutton(app.reference_tab, 'Text', 'Importieren');
    app.import_reference_button.Position = [x_boundary+2*x_small y_fig-180 x_large y_fix];

    % Tabelle für Eigenfrequenzen
    app.eigenfreq_table_monitor = uitable(app.reference_tab);
    app.eigenfreq_table_monitor.Position = [x_boundary y_boundary+30 x_large y_fig-2*y_boundary-200];
    app.eigenfreq_table_monitor.ColumnName = {'Eigenfrequenzen werden hier angezeigt'}; 

    % Variablen unter "eigenfreq_reference_table" speichern
    app.eigenfreq_table_monitor.UserData.row_selected = NaN;              % Gewählte Zeile    

    % Button für Anzeigen des Eigenvektors
    app.show_vector_button_monitor = uibutton(app.reference_tab, 'Text', 'Eigenvektor anzeigen');
    app.show_vector_button_monitor.Position = [x_boundary y_boundary x_large y_fix];

    % Tabelle für Eigenvektoren
    app.eigenvector_table_monitor = uitable(app.reference_tab);
    app.eigenvector_table_monitor.Position = [x_boundary+x_large+2*x_space y_boundary+30 x_large y_fig-2*y_boundary-200];
    app.eigenvector_table_monitor.ColumnName = {'Eigenvektoren werden hier angezeigt'};     
end