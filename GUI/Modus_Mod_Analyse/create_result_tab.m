%% Tab "Ergebnis" im Modus "Modalanalyse"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_result_tab(app)  

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
    delete(app.result_tab.Children);

    % Label für OMA-Methoden
    app.oma_label2 = uilabel(app.result_tab, 'Text', 'Ergebnisse für: ');
    app.oma_label2.Position = [x_boundary y_fig-60 1.8*x_small y_fix];

    % Dropdown für OMA-Methoden
    app.oma_dropdown = uidropdown(app.result_tab);
    app.oma_dropdown.Position = [x_boundary+x_space+1.2*x_small y_fig-60 1.3*x_small y_fix];
    app.oma_dropdown.Items = {'-'};   

    % Tabelle für Frequenzen und Dämpfungsgrade
    app.freq_damp_table = uitable(app.result_tab);
    y_freq_damp_table = 280;
    app.freq_damp_table.Position = [x_boundary y_fig-y_freq_damp_table-70 x_large y_freq_damp_table];
    app.freq_damp_table.ColumnName = {'Ergebnisse werden hier angezeigt'};
    app.freq_damp_table.SelectionType = 'row';

    % Gewählte Zeile unter "freq_damp_table" speichern
    app.freq_damp_table.UserData.row_selected = NaN;

    % Label für Darstellungsart
    app.display_label2 = uilabel(app.result_tab, 'Text', 'Darstellungsart: ');
    app.display_label2.Position = [x_boundary y_fig-y_freq_damp_table-100 1.2*x_small y_fix];

    % Radiobutton-Gruppe für Darstellungsart
    app.display_radio_group = uibuttongroup(app.result_tab);
    app.display_radio_group.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table-130 1.3*x_small y_fix+30];
    app.display_radio_group.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für maximale Auslenkung
    app.display_displacement_radio = uiradiobutton(app.display_radio_group, 'Text', 'Max. Auslenkung');
    app.display_displacement_radio.Position = [0 y_fix+10 1.5*x_small y_fix];

    % Radiobutton für Animation
    app.display_animation_radio = uiradiobutton(app.display_radio_group, 'Text', 'Animation');
    app.display_animation_radio.Position = [0 0 1.5*x_small y_fix];

    % Label für Richtungen
    app.direct_label2 = uilabel(app.result_tab, 'Text', 'Richtungen: ');
    app.direct_label2.Position = [x_boundary y_fig-y_freq_damp_table-160 1.2*x_small y_fix];

    % Checkboxen für Richtungen
    app.x_direct_check2 = uicheckbox(app.result_tab, 'Text', 'x', 'Value', 1);
    app.x_direct_check2.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table-160 50 y_fix];
    app.y_direct_check2 = uicheckbox(app.result_tab, 'Text', 'y', 'Value', 1);
    app.y_direct_check2.Position = [x_boundary+x_space+1.2*x_small+50 y_fig-y_freq_damp_table-160 50 y_fix];
    app.z_direct_check2 = uicheckbox(app.result_tab, 'Text', 'z', 'Value', 1);
    app.z_direct_check2.Position = [x_boundary+x_space+1.2*x_small+100 y_fig-y_freq_damp_table-160 50 y_fix];

    % Label für Skalierungsfaktor
    app.scale_label = uilabel(app.result_tab, 'Text', 'Skalierungsfaktor: ');
    app.scale_label.Position = [x_boundary y_fig-y_freq_damp_table-190 1.2*x_small y_fix];

    % Spinner für Skalierungsfaktor
    app.scale_spinner = uispinner(app.result_tab, 'Value', 1, ...
        'Step', 1, 'Limits', [1 10]);
    app.scale_spinner.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table-190 x_small y_fix];

    % Label für Wiedergabegeschwindigkeit
    app.speed_label = uilabel(app.result_tab, 'Text', 'Wiedergabegeschw.: ');
    app.speed_label.Position = [x_boundary y_fig-y_freq_damp_table-220 1.2*x_small y_fix];

    % Dropdown für Wiedergabegeschwindigkeit
    app.speed_dropdown = uidropdown(app.result_tab);
    app.speed_dropdown.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table-220 x_small y_fix];
    app.speed_dropdown.Items = {'0,5x', 'Normal', '1,5x', '2x'};
    app.speed_dropdown.Value = 'Normal';

    % Hilfe für Wiedergabegeschwindigkeit
    app.speed_help = uilabel(app.result_tab, 'Text', '(?)');
    app.speed_help.Position = [x_boundary+2*x_space+2.2*x_small y_fig-y_freq_damp_table-220 x_small y_fix];
    app.speed_help.Tooltip = 'Nur für Animation relevant';

    % Label für Ansichten
    app.view_label = uilabel(app.result_tab, 'Text', 'Ansicht: ');
    app.view_label.Position = [x_boundary y_fig-y_freq_damp_table-250 1.2*x_small y_fix];

    % Radiobutton-Gruppe für Ansichten
    app.view_radio_group = uibuttongroup(app.result_tab);
    app.view_radio_group.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table-340 1.3*x_small 4*y_fix+30];
    app.view_radio_group.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für 3D-Ansicht
    app.view_3D_radio = uiradiobutton(app.view_radio_group, 'Text', '3D-Ansicht');
    app.view_3D_radio.Position = [0 3*y_fix+30 1.5*x_small y_fix];

    % Radiobutton für Seitenansicht
    app.view_side_radio = uiradiobutton(app.view_radio_group, 'Text', 'Seitenansicht');
    app.view_side_radio.Position = [0 2*y_fix+20 1.5*x_small y_fix];

    % Radiobutton für Querschnittsansicht
    app.view_cross_radio = uiradiobutton(app.view_radio_group, 'Text', 'Querschnittsansicht');
    app.view_cross_radio.Position = [0 y_fix+10 1.5*x_small y_fix];

    % Radiobutton für Draufsicht
    app.view_plan_radio = uiradiobutton(app.view_radio_group, 'Text', 'Draufsicht');
    app.view_plan_radio.Position = [0 0 1.5*x_small y_fix];

    % Button für Darstellen der Eigenform
    app.update_eigenform_button = uibutton(app.result_tab, 'Text', 'Eigenform aktualisieren');
    app.update_eigenform_button.Position = [x_boundary y_boundary+y_fix+y_space x_large y_fix];

    % Variablen unter "update_eigenform_button" speichern
    app.update_eigenform_button.UserData.clock = timer('ExecutionMode', 'fixedRate', 'Period', 0.05);   % Timer
    app.update_eigenform_button.UserData.time_step = 1;                                                 % Zeitschritt
    app.update_eigenform_button.UserData.is_animating = false;                                          % Flagge

    % Button für Stoppen
    app.stop_button = uibutton(app.result_tab, 'Text', 'Animation stoppen');
    app.stop_button.Position = [x_boundary y_boundary x_large y_fix];
    app.stop_button.Enable = 'off';

    % Graph für Eigenform
    app.eigenform_graph = uiaxes(app.result_tab);
    app.eigenform_graph.XGrid = 'on';
    app.eigenform_graph.YGrid = 'on';
    app.eigenform_graph.ZGrid = 'on';
    x_eigenform_graph = 660;
    app.eigenform_graph.Position = [x_boundary+x_large+2*x_space y_boundary x_eigenform_graph y_fig-60];
    app.eigenform_graph.Title.String = '\textbf{Eigenform}';
    app.eigenform_graph.XLabel.String = '$x$';
    app.eigenform_graph.YLabel.String = '$y$';
    app.eigenform_graph.ZLabel.String = '$z$';
    app.eigenform_graph.View = [-37.5, 30];
end