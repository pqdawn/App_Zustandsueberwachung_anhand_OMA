%% Tab "Messdaten" im Modus "Modalanalyse"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_data_tab(app)

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
    app.path_label = uilabel(app.data_tab, ...
        'Text', 'Dateipfad:');
    app.path_label.Position = [x_boundary y_fig-60 1.5*x_small y_fix];

    % Eingabefeld für Pfad
    app.path_edit_field = uieditfield(app.data_tab, 'Text', ...
        'Placeholder', 'in Format C:\Ordner\Datei.txt');
    app.path_edit_field.Position = [x_boundary+1.5*x_small y_fig-60 x_large y_fix];

    % Hilfe für Pfad
    app.path_help = uilabel(app.data_tab, 'Text', '(?)');
    app.path_help.Position = [x_boundary+1.5*x_small+x_large+x_space y_fig-60 0.2*x_small y_fix];
    app.path_help.Tooltip =  {'- Titel und Spaltenüberschriften werden nicht eingelesen'
        '- Dezimaltrennung erfolgt mit einem Punkt (.)'
        '- Reihenfolge der Richtungen: x, y, z'
        '- TXT-Format wird empfohlen'};

    % Button für Suchen der Datei zu Messdaten
    app.search_data_button = uibutton(app.data_tab, 'Text', 'Datei suchen');
    app.search_data_button.Position = [x_boundary+1.5*x_small y_fig-90 x_large y_fix];

    % Label für gemessene Größe
    app.type_label = uilabel(app.data_tab, 'Text', 'Gemessene Größe:');
    app.type_label.Position = [x_boundary y_fig-120 1.5*x_small y_fix];

    % Radiobutton-Gruppe für gemessene Größe
    app.type_radio_group = uibuttongroup(app.data_tab);
    app.type_radio_group.Position = [x_boundary+1.5*x_small y_fig-120 3.3*x_small+2*x_space y_fix];
    app.type_radio_group.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für Verschiebung
    app.type_displacement_radio = uiradiobutton(app.type_radio_group, 'Text', 'Verschiebung');
    app.type_displacement_radio.Position = [0 0 x_small y_fix];

    % Radiobutton für Geschwindigkeit
    app.type_velocity_radio = uiradiobutton(app.type_radio_group, 'Text', 'Geschwindigkeit');
    app.type_velocity_radio.Position = [x_small+x_space 0 1.15*x_small y_fix];

    % Radiobutton für Beschleunigung
    app.type_acceleration_radio = uiradiobutton(app.type_radio_group, 'Text', 'Beschleunigung');
    app.type_acceleration_radio.Position = [2.15*x_small+2*x_space 0 1.15*x_small y_fix];
    app.type_acceleration_radio.Value = 1;

    % Hilfe für gemessene Größe
    app.type_help = uilabel(app.data_tab, 'Text', '(?)');
    app.type_help.Position = [x_boundary+4.8*x_small+2*x_space y_fig-120 0.2*x_small y_fix];
    app.type_help.Tooltip = {['Das Stabilisationsdiagramm basierend auf Beschleunigungsdaten ist oft ' ...
        'aussagekräftiger. Wenn Verschiebungs- oder Geschwindigkeitsdaten verwendet wurden, ' ...
        'ist es möglich, Stabilisationsdiagramm basierend auf originalen Messdaten ' ...
        'oder auf Beschleunigungsdaten (abegeleitet) darzustellen. WICHTIG: Die Berechnung der modalen ' ...
        'Parameter erfolgt ausschließlich mit den originalen Messdaten! Im Modus "Zustandsüberwachung" ist ' ...
        'diese Alternative nicht verfügbar!']};

    % Label für Richtungen
    app.direct_label = uilabel(app.data_tab, ...
        'Text', 'Richtungen: ');
    app.direct_label.Position = [x_boundary y_fig-150 1.5*x_small y_fix];

    % Checkboxen für Richtungen
    app.x_direct_check = uicheckbox(app.data_tab, 'Text', 'x', 'Value', 1);
    app.x_direct_check.Position = [x_boundary+1.5*x_small y_fig-150 50 y_fix];
    app.y_direct_check = uicheckbox(app.data_tab, 'Text', 'y', 'Value', 1);
    app.y_direct_check.Position = [x_boundary+1.5*x_small+50 y_fig-150 50 y_fix];
    app.z_direct_check = uicheckbox(app.data_tab, 'Text', 'z', 'Value', 1);
    app.z_direct_check.Position = [x_boundary+1.5*x_small+100 y_fig-150 50 y_fix];

    % Label für Abtastfrequenz
    app.sampling_freq_label = uilabel(app.data_tab, ...
        'Text', 'Abtastfrequenz: ');
    app.sampling_freq_label.Position = [x_boundary y_fig-180 1.5*x_small y_fix];

    % Eingabefeld für Abtastfrequenz
    app.sampling_freq_edit_field = uieditfield(app.data_tab, 'InputType', 'Digits', ...
        'Placeholder', 'in Einheit [Hz]');
    app.sampling_freq_edit_field.Position = [x_boundary+1.5*x_small y_fig-180 x_small y_fix];

    % Button für Importieren
    app.import_button = uibutton(app.data_tab, 'Text', 'Importieren');
    app.import_button.Position = [x_boundary+1.5*x_small y_fig-210 x_large y_fix];

    % Tabelle für Messdaten
    app.data_matrix_table = uitable(app.data_tab);
    app.data_matrix_table.Position = [x_boundary y_boundary 1000-2*x_boundary ...
        y_fig-210-y_space-y_boundary];
    app.data_matrix_table.ColumnName = {'Messdaten werden hier angezeigt'};
end