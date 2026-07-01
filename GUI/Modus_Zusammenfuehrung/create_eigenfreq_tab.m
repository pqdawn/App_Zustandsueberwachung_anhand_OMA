%% Tab "Eigenfrequenz" im Modus "Zusammenführung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_eigenfreq_tab(app)

    % Größen holen
    y_fig = app.y_fig;
    x_boundary = app.x_boundary;
    y_boundary = app.y_boundary;
    x_space = app.x_space;
    y_space = app.y_space;
    x_large = app.x_large;
    x_small = app.x_small;
    y_fix = app.y_fix;   

    % Label für Anzahl der Moden
    app.num_mode_label_merge = uilabel(app.eigenfreq_tab, 'Text', 'Anzahl der Moden: ');
    app.num_mode_label_merge.Position = [x_boundary y_fig-60 x_large y_fix];

    % Spinner für Anzahl der Moden
    app.num_mode_spinner = uispinner(app.eigenfreq_tab, 'Value', 3, ...
        'Step', 1, 'Limits', [1 20]);
    app.num_mode_spinner.Position = [x_boundary+1.2*x_small y_fig-60 x_small y_fix];    

    % Hilfe für Anzahl der Moden
    app.num_mode_help = uilabel(app.eigenfreq_tab, 'Text', '(?)');
    app.num_mode_help.Position = [x_boundary+2.2*x_small+x_space y_fig-60 0.2*x_small y_fix];
    app.num_mode_help.Tooltip =  {'Anhand dieses Modus lassen sich Eigenvektoren darstellen. Anzahl der Gruppen auf "1" einstellen'};

    % Label für Anzahl der Gruppen
    app.num_group_label = uilabel(app.eigenfreq_tab, 'Text', 'Anzahl der Gruppen: ');
    app.num_group_label.Position = [x_boundary y_fig-90 x_large y_fix];

    % Spinner für Anzahl der Gruppen
    app.num_group_spinner = uispinner(app.eigenfreq_tab, 'Value', 3, ...
        'Step', 1, 'Limits', [1 20]);
    app.num_group_spinner.Position = [x_boundary+1.2*x_small y_fig-90 x_small y_fix];  

    % Label für Pfad
    app.eigenfreq_path_label = uilabel(app.eigenfreq_tab, 'Text', 'Ordnerpfad: ');
    app.eigenfreq_path_label.Position = [x_boundary y_fig-120 1.2*x_small y_fix];

    % Eingabefeld für Pfad
    app.eigenfreq_path_edit_field = uieditfield(app.eigenfreq_tab, 'Placeholder', 'in Format C:\Ordner');
    app.eigenfreq_path_edit_field.Position = [x_boundary+1.2*x_small y_fig-120 x_large y_fix];

    % Hilfe für Pfad
    app.eigenfreq_path_help = uilabel(app.eigenfreq_tab, 'Text', '(?)');
    app.eigenfreq_path_help.Position = [x_boundary+1.2*x_small+x_large+x_space y_fig-120 0.2*x_small y_fix];
    app.eigenfreq_path_help.Tooltip =  {'- Dieser Ordner enthält TXT-Dateien der Eigenfrequenzen'
        '- Jede Gruppe benötigt eine TXT-Datei (z.B. 3 Dateien für 3 Gruppen)'
        '- Dateien werden nach Gruppennummer bennant (z.B. "Frequenz_1")'
        '- Format aus dem Export im Modus "Modalanalyse" wird empfohlen'};

    % Button für Suchen des Ordners
    app.search_file_eigenfreq_button = uibutton(app.eigenfreq_tab, 'Text', 'Ordner suchen');
    app.search_file_eigenfreq_button.Position = [x_boundary+1.2*x_small y_fig-150 x_large y_fix];    

    % Button für Importieren der Gruppen der Eigenfrequenzen
    app.import_eigenfreq_group_button = uibutton(app.eigenfreq_tab, 'Text', 'Importieren');
    app.import_eigenfreq_group_button.Position = [x_boundary+1.2*x_small y_fig-180 x_large y_fix];       

    % Tabelle für Gruppen der Eigenfrequenzen
    y_table = 225;
    app.eigenfreq_group_table = uitable(app.eigenfreq_tab);
    app.eigenfreq_group_table.Position = [x_boundary y_boundary+y_table+2*y_space+y_fix 1000-2*x_boundary ...
        y_table];
    app.eigenfreq_group_table.ColumnName = {'Gruppen der Eigenfrequenzen werden hier angezeigt'};  

    % Variablen unter "eigenfreq_group_table" speichern
    app.eigenfreq_group_table.UserData.row_selected = NaN;       % Gewählte Zeile
    app.eigenfreq_group_table.UserData.group_config = [];        % Zuordnung der Gruppen

    % Button für Anzeigen der Eigenfrequenzen
    app.show_freq_button = uibutton(app.eigenfreq_tab, 'Text', 'Eigenfrequenzen anzeigen');
    app.show_freq_button.Position = [x_boundary y_boundary+y_table+y_space x_large y_fix]; 

    % Button für Aktualisieren der Gruppen der Eigenfrequenzen
    app.update_eigenfreq_group_button = uibutton(app.eigenfreq_tab, 'Text', 'Aktualisieren');
    app.update_eigenfreq_group_button.Position = [x_boundary+x_large+x_space y_boundary+y_table+y_space x_large y_fix];    

    % Tabelle für Eigenfrequenzen
    app.eigenfreq_table = uitable(app.eigenfreq_tab);
    app.eigenfreq_table.Position = [x_boundary y_boundary x_large y_table];
    app.eigenfreq_table.ColumnName = {'Eigenfrequenzen werden hier angezeigt'};
end    