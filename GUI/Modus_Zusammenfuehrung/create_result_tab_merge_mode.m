%% Tab "Ergebnis" im Modus "Zusammenführung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_result_tab_merge_mode(app)

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
    delete(app.result_tab_merge_mode.Children);  

    % Tabelle für Frequenzen
    app.freq_table_merge = uitable(app.result_tab_merge_mode);
    y_freq_damp_table_merge = 310;
    app.freq_table_merge.Position = [x_boundary y_fig-y_freq_damp_table_merge-40 x_large y_freq_damp_table_merge];
    app.freq_table_merge.ColumnName = {'Ergebnisse werden hier angezeigt'};
    app.freq_table_merge.SelectionType = 'row';

    % Gewählte Zeile unter "freq_damp_table" speichern
    app.freq_table_merge.UserData.row_selected = NaN;

    % Label für Darstellungsart
    app.display_label_merge = uilabel(app.result_tab_merge_mode, 'Text', 'Darstellungsart: ');
    app.display_label_merge.Position = [x_boundary y_fig-y_freq_damp_table_merge-70 1.2*x_small y_fix];

    % Radiobutton-Gruppe für Darstellungsart
    app.display_radio_group_merge = uibuttongroup(app.result_tab_merge_mode);
    app.display_radio_group_merge.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table_merge-100 1.3*x_small y_fix+30];
    app.display_radio_group_merge.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für maximale Auslenkung
    app.display_displacement_radio_merge = uiradiobutton(app.display_radio_group_merge, 'Text', 'Max. Auslenkung');
    app.display_displacement_radio_merge.Position = [0 y_fix+10 1.5*x_small y_fix];

    % Radiobutton für Animation
    app.display_animation_radio_merge = uiradiobutton(app.display_radio_group_merge, 'Text', 'Animation');
    app.display_animation_radio_merge.Position = [0 0 1.5*x_small y_fix];

    % Label für Richtungen
    app.direct_label_merge = uilabel(app.result_tab_merge_mode, 'Text', 'Richtungen: ');
    app.direct_label_merge.Position = [x_boundary y_fig-y_freq_damp_table_merge-130 1.2*x_small y_fix];

    % Checkboxen für Richtungen
    app.x_direct_check_merge = uicheckbox(app.result_tab_merge_mode, 'Text', 'x', 'Value', 1);
    app.x_direct_check_merge.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table_merge-130 50 y_fix];
    app.y_direct_check_merge = uicheckbox(app.result_tab_merge_mode, 'Text', 'y', 'Value', 1);
    app.y_direct_check_merge.Position = [x_boundary+x_space+1.2*x_small+50 y_fig-y_freq_damp_table_merge-130 50 y_fix];
    app.z_direct_check_merge = uicheckbox(app.result_tab_merge_mode, 'Text', 'z', 'Value', 1);
    app.z_direct_check_merge.Position = [x_boundary+x_space+1.2*x_small+100 y_fig-y_freq_damp_table_merge-130 50 y_fix];

    % Label für Skalierungsfaktor
    app.scale_label_merge = uilabel(app.result_tab_merge_mode, 'Text', 'Skalierungsfaktor: ');
    app.scale_label_merge.Position = [x_boundary y_fig-y_freq_damp_table_merge-160 1.2*x_small y_fix];

    % Spinner für Skalierungsfaktor
    app.scale_spinner_merge = uispinner(app.result_tab_merge_mode, 'Value', 1, ...
        'Step', 1, 'Limits', [1 10]);
    app.scale_spinner_merge.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table_merge-160 x_small y_fix];

    % Label für Wiedergabegeschwindigkeit
    app.speed_label_merge = uilabel(app.result_tab_merge_mode, 'Text', 'Wiedergabegeschw.: ');
    app.speed_label_merge.Position = [x_boundary y_fig-y_freq_damp_table_merge-190 1.2*x_small y_fix];

    % Dropdown für Wiedergabegeschwindigkeit
    app.speed_dropdown_merge = uidropdown(app.result_tab_merge_mode);
    app.speed_dropdown_merge.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table_merge-190 x_small y_fix];
    app.speed_dropdown_merge.Items = {'0,5x', 'Normal', '1,5x', '2x'};
    app.speed_dropdown_merge.Value = 'Normal';

    % Hilfe für Wiedergabegeschwindigkeit
    app.speed_help_merge = uilabel(app.result_tab_merge_mode, 'Text', '(?)');
    app.speed_help_merge.Position = [x_boundary+2*x_space+2.2*x_small y_fig-y_freq_damp_table_merge-190 x_small y_fix];
    app.speed_help_merge.Tooltip = 'Nur für Animation relevant';

    % Label für Ansichten
    app.view_label_merge = uilabel(app.result_tab_merge_mode, 'Text', 'Ansicht: ');
    app.view_label_merge.Position = [x_boundary y_fig-y_freq_damp_table_merge-220 1.2*x_small y_fix];

    % Radiobutton-Gruppe für Ansichten
    app.view_radio_group_merge = uibuttongroup(app.result_tab_merge_mode);
    app.view_radio_group_merge.Position = [x_boundary+x_space+1.2*x_small y_fig-y_freq_damp_table_merge-310 1.3*x_small 4*y_fix+30];
    app.view_radio_group_merge.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für 3D-Ansicht
    app.view_3D_radio_merge = uiradiobutton(app.view_radio_group_merge, 'Text', '3D-Ansicht');
    app.view_3D_radio_merge.Position = [0 3*y_fix+30 1.5*x_small y_fix];

    % Radiobutton für Seitenansicht
    app.view_side_radio_merge = uiradiobutton(app.view_radio_group_merge, 'Text', 'Seitenansicht');
    app.view_side_radio_merge.Position = [0 2*y_fix+20 1.5*x_small y_fix];

    % Radiobutton für Querschnittsansicht
    app.view_cross_radio_merge = uiradiobutton(app.view_radio_group_merge, 'Text', 'Querschnittsansicht');
    app.view_cross_radio_merge.Position = [0 y_fix+10 1.5*x_small y_fix];

    % Radiobutton für Draufsicht
    app.view_plan_radio_merge = uiradiobutton(app.view_radio_group_merge, 'Text', 'Draufsicht');
    app.view_plan_radio_merge.Position = [0 0 1.5*x_small y_fix];

    % Button für Darstellen der Eigenform
    app.update_eigenform_button_merge = uibutton(app.result_tab_merge_mode, 'Text', 'Eigenform aktualisieren');
    app.update_eigenform_button_merge.Position = [x_boundary y_boundary+y_fix+y_space x_large y_fix];

    % Button für Stoppen
    app.stop_button_merge = uibutton(app.result_tab_merge_mode, 'Text', 'Animation stoppen');
    app.stop_button_merge.Position = [x_boundary y_boundary x_large y_fix];
    app.stop_button_merge.Enable = 'off';

    % Graph für Eigenform
    app.eigenform_graph_merge = uiaxes(app.result_tab_merge_mode);
    app.eigenform_graph_merge.XGrid = 'on';
    app.eigenform_graph_merge.YGrid = 'on';
    app.eigenform_graph_merge.ZGrid = 'on';
    x_eigenform_graph = 660;
    app.eigenform_graph_merge.Position = [x_boundary+x_large+2*x_space y_boundary x_eigenform_graph y_fig-60];
    app.eigenform_graph_merge.Title.String = '\textbf{Eigenform}';
    app.eigenform_graph_merge.XLabel.String = '$x$';
    app.eigenform_graph_merge.YLabel.String = '$y$';
    app.eigenform_graph_merge.ZLabel.String = '$z$';
    app.eigenform_graph_merge.View = [-37.5, 30];
end