%% Tab "Messdaten" im Modus "Zustandsüberwachung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_data_tab_monitor_mode(app)

    % Größen holen
    y_fig = app.y_fig;
    x_boundary = app.x_boundary;
    y_boundary = app.y_boundary;
    x_space = app.x_space;
    y_space = app.y_space;
    x_large = app.x_large;
    x_small = app.x_small;
    y_fix = app.y_fix;

    % Label für Pfad
    app.path_label_monitor = uilabel(app.data_tab_monitor_mode, ...
        'Text', 'Dateipfad:');
    app.path_label_monitor.Position = [x_boundary y_fig-60 1.5*x_small y_fix];

    % Eingabefeld für Pfad
    app.path_edit_field_monitor = uieditfield(app.data_tab_monitor_mode, 'Text', ...
        'Placeholder', 'in Format C:\Ordner\Datei.txt');
    app.path_edit_field_monitor.Position = [x_boundary+1.5*x_small y_fig-60 x_large y_fix];

    % Hilfe für Pfad
    app.path_help_monitor = uilabel(app.data_tab_monitor_mode, 'Text', '(?)');
    app.path_help_monitor.Position = [x_boundary+1.5*x_small+x_large+x_space y_fig-60 0.2*x_small y_fix];
    app.path_help_monitor.Tooltip =  {'- Titel und Spaltenüberschriften werden nicht eingelesen'
        '- Dezimaltrennung erfolgt mit einem Punkt (.)'
        '- Reihenfolge der Richtungen: x, y, z'
        '- Durch den Import wird der erste Zeitschritt immer auf 0 gesetzt'
        '- TXT-Format wird empfohlen; bei anderen Formaten muss die importierte Datei sorgfältig überprüft werden!'};

    % Button für Suchen der Datei zu Messdaten
    app.search_data_button_monitor = uibutton(app.data_tab_monitor_mode, 'Text', 'Datei suchen');
    app.search_data_button_monitor.Position = [x_boundary+1.5*x_small y_fig-90 x_large y_fix];

    % Label für gemessene Größe
    app.type_label_monitor = uilabel(app.data_tab_monitor_mode, 'Text', 'Gemessene Größe:');
    app.type_label_monitor.Position = [x_boundary y_fig-120 1.5*x_small y_fix];

    % Radiobutton-Gruppe für gemessene Größe
    app.type_radio_group_monitor = uibuttongroup(app.data_tab_monitor_mode);
    app.type_radio_group_monitor.Position = [x_boundary+1.5*x_small y_fig-120 3.3*x_small+2*x_space y_fix];
    app.type_radio_group_monitor.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für Verschiebung
    app.type_displacement_radio_monitor = uiradiobutton(app.type_radio_group_monitor, 'Text', 'Verschiebung');
    app.type_displacement_radio_monitor.Position = [0 0 x_small y_fix];

    % Radiobutton für Geschwindigkeit
    app.type_velocity_radio_monitor = uiradiobutton(app.type_radio_group_monitor, 'Text', 'Geschwindigkeit');
    app.type_velocity_radio_monitor.Position = [x_small+x_space 0 1.15*x_small y_fix];

    % Radiobutton für Beschleunigung
    app.type_acceleration_radio_monitor = uiradiobutton(app.type_radio_group_monitor, 'Text', 'Beschleunigung');
    app.type_acceleration_radio_monitor.Position = [2.15*x_small+2*x_space 0 1.15*x_small y_fix];
    app.type_acceleration_radio_monitor.Value = 1;    

    % Label für Richtungen
    app.direct_label_monitor = uilabel(app.data_tab_monitor_mode, ...
        'Text', 'Richtungen: ');
    app.direct_label_monitor.Position = [x_boundary y_fig-150 1.5*x_small y_fix];

    % Checkboxen für Richtungen
    app.x_direct_check_monitor = uicheckbox(app.data_tab_monitor_mode, 'Text', 'x', 'Value', 1);
    app.x_direct_check_monitor.Position = [x_boundary+1.5*x_small y_fig-150 50 y_fix];
    app.y_direct_check_monitor = uicheckbox(app.data_tab_monitor_mode, 'Text', 'y', 'Value', 1);
    app.y_direct_check_monitor.Position = [x_boundary+1.5*x_small+50 y_fig-150 50 y_fix];
    app.z_direct_check_monitor = uicheckbox(app.data_tab_monitor_mode, 'Text', 'z', 'Value', 1);
    app.z_direct_check_monitor.Position = [x_boundary+1.5*x_small+100 y_fig-150 50 y_fix];

    % Label für Abtastfrequenz
    app.sampling_freq_label_monitor = uilabel(app.data_tab_monitor_mode, ...
        'Text', 'Abtastfrequenz: ');
    app.sampling_freq_label_monitor.Position = [x_boundary y_fig-180 1.5*x_small y_fix];

    % Eingabefeld für Abtastfrequenz
    app.sampling_freq_edit_field_monitor = uieditfield(app.data_tab_monitor_mode, 'InputType', 'Digits', ...
        'Placeholder', 'in Einheit [Hz]');
    app.sampling_freq_edit_field_monitor.Position = [x_boundary+1.5*x_small y_fig-180 x_small y_fix];

    % Button für Importieren
    app.import_button_monitor = uibutton(app.data_tab_monitor_mode, 'Text', 'Importieren');
    app.import_button_monitor.Position = [x_boundary+1.5*x_small y_fig-210 x_large y_fix];

    % Tabelle für Messdaten
    app.data_matrix_table_monitor = uitable(app.data_tab_monitor_mode);
    app.data_matrix_table_monitor.Position = [x_boundary y_boundary 1000-2*x_boundary ...
        y_fig-210-y_space-y_boundary];
    app.data_matrix_table_monitor.ColumnName = {'Messdaten werden hier angezeigt'};
end