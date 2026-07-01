%% Tab "Export" im Modus "Zusammenführung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_export_tab_merge_mode(app)

    % Größen holen
    y_fig = app.y_fig;
    x_boundary = app.x_boundary;
    y_boundary = app.y_boundary;
    x_space = app.x_space;
    y_space = app.y_space;
    x_large = app.x_large;
    x_small = app.x_small;
    y_fix = app.y_fix;
    y_sub_tab2 = y_fig-30-y_boundary-y_space;    
    x_sensor_table = x_large+80;
    y_sensor_table = y_sub_tab2-y_boundary-40;    

    % Alle Komponenten in diesem Tab löschen
    delete(app.export_tab_merge_mode.Children);  

    % Subtabs für Export 
    app.sub_tab_group_export_tab_merge = uitabgroup(app.export_tab_merge_mode);
    x_sub_tab2 = 900;
    y_sub_tab2 = y_fig-30-y_boundary-y_space;
    app.sub_tab_group_export_tab_merge.Position = [x_boundary y_fig-y_sub_tab2-40 x_sub_tab2 y_sub_tab2];
    app.geometry_sub_tab_merge = uitab(app.sub_tab_group_export_tab_merge, 'Title', 'Geometrie');             % Geometrie
    app.mod_parameter_sub_tab_merge = uitab(app.sub_tab_group_export_tab_merge, 'Title', 'Mod. Parameter');   % Mod. Parameter
    app.eigenform_sub_tab_merge = uitab(app.sub_tab_group_export_tab_merge, 'Title', 'Eigenform');            % Eigenform

    % Label für Pfad
    app.geometry_path_label_merge = uilabel(app.geometry_sub_tab_merge, 'Text', 'Ordnerpfad: ');
    app.geometry_path_label_merge.Position = [x_boundary y_sub_tab2-2*y_boundary-y_fix 1.5*x_small y_fix];

    % Eingabefeld für Pfad
    app.geometry_path_edit_field_merge = uieditfield(app.geometry_sub_tab_merge, 'Placeholder', 'in Format C:\Ordner');
    app.geometry_path_edit_field_merge.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-y_fix x_large y_fix];

    % Button für Suchen des Ordners
    app.search_file_geometry_button_merge = uibutton(app.geometry_sub_tab_merge, 'Text', 'Ordner suchen');
    app.search_file_geometry_button_merge.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-2*y_fix-y_space x_large y_fix];

    % Label für "Daten zu expotieren"
    app.to_export_label_merge = uilabel(app.geometry_sub_tab_merge, 'Text', 'Daten zu exportieren:');
    app.to_export_label_merge.Position = [x_boundary y_sub_tab2-2*y_boundary-3*y_fix-2*y_space 1.5*x_small y_fix];

    % Checkboxen für Daten
    app.assign_check_merge = uicheckbox(app.geometry_sub_tab_merge, 'Text', 'Zuweisungen', 'Value', 1);
    app.assign_check_merge.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-3*y_fix-2*y_space x_small y_fix];
    app.node_check_merge = uicheckbox(app.geometry_sub_tab_merge, 'Text', 'Knoten', 'Value', 1);
    app.node_check_merge.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-4*y_fix-3*y_space x_small y_fix];
    app.line_check_merge = uicheckbox(app.geometry_sub_tab_merge, 'Text', 'Linien', 'Value', 1);
    app.line_check_merge.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-5*y_fix-4*y_space x_small y_fix];
    app.surface_check_merge = uicheckbox(app.geometry_sub_tab_merge, 'Text', 'Flächen', 'Value', 1);
    app.surface_check_merge.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-6*y_fix-5*y_space x_small y_fix];

    % Button für Exportieren
    app.export_geometry_button_merge = uibutton(app.geometry_sub_tab_merge, 'Text', 'Daten exportieren');
    app.export_geometry_button_merge.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-7*y_fix-6*y_space x_large y_fix];

    % Tabelle für Frequenzen
    app.freq_table2_merge = uitable(app.mod_parameter_sub_tab_merge);
    app.freq_table2_merge.Position = [x_boundary y_sub_tab2-2*y_boundary-y_sensor_table x_sensor_table y_sensor_table];
    app.freq_table2_merge.ColumnName = {'Ergebnisse werden hier angezeigt'};
    app.freq_table2_merge.SelectionType = 'row';

    % Label für Pfad
    app.mod_parameter_path_label_merge = uilabel(app.mod_parameter_sub_tab_merge, 'Text', 'Ordnerpfad: ');
    app.mod_parameter_path_label_merge.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-y_fix 1.5*x_small y_fix];

    % Eingabefeld für Pfad
    app.mod_parameter_path_edit_field_merge = uieditfield(app.mod_parameter_sub_tab_merge, 'Placeholder', 'in Format C:\Ordner');
    app.mod_parameter_path_edit_field_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-y_fix x_large y_fix];

    % Button für Suchen des Ordners
    app.search_file_mod_parameter_button_merge = uibutton(app.mod_parameter_sub_tab_merge, 'Text', 'Ordner suchen');
    app.search_file_mod_parameter_button_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-2*y_fix-y_space x_large y_fix];

    % Label für "Daten zu exportieren"
    app.to_export_label2_merge = uilabel(app.mod_parameter_sub_tab_merge, 'Text', 'Daten zu exportieren:');
    app.to_export_label2_merge.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-3*y_fix-2*y_space 1.5*x_small y_fix];
    
    % Checkbox für Eigenfrequenz
    app.eigenfreq_check_merge = uicheckbox(app.mod_parameter_sub_tab_merge, 'Text', 'Eigenfrequenz', 'Value', 1);
    app.eigenfreq_check_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-3*y_fix-2*y_space x_small y_fix];

    % Checkbox für Eigenvektor
    app.eigenvector_check_merge = uicheckbox(app.mod_parameter_sub_tab_merge, 'Text', 'Eigenvektor', 'Value', 1);
    app.eigenvector_check_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-4*y_fix-3*y_space 1.5*x_small y_fix];

    % Button für Exportieren
    app.export_mod_parameter_button_merge = uibutton(app.mod_parameter_sub_tab_merge, 'Text', 'Daten exportieren');
    app.export_mod_parameter_button_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-5*y_fix-4*y_space x_large y_fix];

    % Tabelle für Frequenzen
    app.freq_table3_merge = uitable(app.eigenform_sub_tab_merge);
    app.freq_table3_merge.Position = [x_boundary y_sub_tab2-2*y_boundary-y_sensor_table x_sensor_table y_sensor_table];
    app.freq_table3_merge.ColumnName = {'Ergebnisse werden hier angezeigt'};
    app.freq_table3_merge.SelectionType = 'row';

    % Label für Pfad
    app.eigenform_path_label_merge = uilabel(app.eigenform_sub_tab_merge, 'Text', 'Ordnerpfad: ');
    app.eigenform_path_label_merge.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-y_fix 1.5*x_small y_fix];

    % Eingabefeld für Pfad
    app.eigenform_path_edit_field_merge = uieditfield(app.eigenform_sub_tab_merge, 'Placeholder', 'in Format C:\Ordner');
    app.eigenform_path_edit_field_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-y_fix x_large y_fix];

    % Button für Suchen des Ordners
    app.search_file_eigenform_button_merge = uibutton(app.eigenform_sub_tab_merge, 'Text', 'Ordner suchen');
    app.search_file_eigenform_button_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-2*y_fix-y_space x_large y_fix];    
    
    % Label für Darstellungsart
    app.display_label3_merge = uilabel(app.eigenform_sub_tab_merge, 'Text', 'Darstellungsart:');
    app.display_label3_merge.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-3*y_fix-2*y_space 1.5*x_small y_fix];
    
    % Checkbox für maximale Auslenkung
    app.displacement_check_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', 'Max. Auslenkung', 'Value', 1);
    app.displacement_check_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-3*y_fix-2*y_space 1.5*x_small y_fix];

    % Checkbox für Animation
    app.animation_check_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', 'Animation', 'Value', 1);
    app.animation_check_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-4*y_fix-3*y_space 1.5*x_small y_fix];

    % Label für Richtungen
    app.direct_label3_merge = uilabel(app.eigenform_sub_tab_merge, 'Text', 'Richtungen: ');
    app.direct_label3_merge.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-5*y_fix-4*y_space 1.5*x_small y_fix];

    % Checkboxen für Richtungen
    app.x_direct_check3_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', 'x', 'Value', 1);
    app.x_direct_check3_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-5*y_fix-4*y_space 50 y_fix];
    app.y_direct_check3_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', 'y', 'Value', 1);
    app.y_direct_check3_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small+50 y_sub_tab2-2*y_boundary-5*y_fix-4*y_space 50 y_fix];
    app.z_direct_check3_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', 'z', 'Value', 1);
    app.z_direct_check3_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small+100 y_sub_tab2-2*y_boundary-5*y_fix-4*y_space 50 y_fix];

    % Label für Skalierungsfaktor
    app.scale_label2_merge = uilabel(app.eigenform_sub_tab_merge, 'Text', 'Skalierungsfaktor: ');
    app.scale_label2_merge.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-6*y_fix-5*y_space 1.5*x_small y_fix];

    % Spinner für Skalierungsfaktor
    app.scale_spinner2_merge = uispinner(app.eigenform_sub_tab_merge, 'Value', 1, ...
        'Step', 1, 'Limits', [1 10]);
    app.scale_spinner2_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-6*y_fix-5*y_space x_small y_fix];

    % Label für Wiedergabegeschwindigkeit
    app.speed_label2_merge = uilabel(app.eigenform_sub_tab_merge, 'Text', 'Wiedergabegeschw.: ');
    app.speed_label2_merge.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-7*y_fix-6*y_space 1.5*x_small y_fix];

    % Dropdown für Wiedergabegeschwindigkeit
    app.speed_dropdown2_merge = uidropdown(app.eigenform_sub_tab_merge);
    app.speed_dropdown2_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-7*y_fix-6*y_space x_small y_fix];
    app.speed_dropdown2_merge.Items = {'0,5x', 'Normal', '1,5x', '2x'};
    app.speed_dropdown2_merge.Value = 'Normal';

    % Hilfe für Wiedergabegechwindigkeit
    app.speed_help_merge = uilabel(app.eigenform_sub_tab_merge, 'Text', '(?)');
    app.speed_help_merge.Position = [2*x_boundary+x_sensor_table+2.5*x_small+x_space y_sub_tab2-2*y_boundary-7*y_fix-6*y_space 0.2*x_small y_fix];
    app.speed_help_merge.Tooltip = 'Nur für Animation relevant';

    % Label für Ansichten
    app.view_label2_merge = uilabel(app.eigenform_sub_tab_merge, 'Text', 'Ansicht: ');
    app.view_label2_merge.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-8*y_fix-7*y_space 1.5*x_small y_fix];

    % Checkbox für alle
    app.view_all_check_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', 'Alle', 'Value', 1);
    app.view_all_check_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-8*y_fix-7*y_space 0.4*x_small y_fix];

    % Hilfe für alle Ansichten
    app.view_all_help_merge = uilabel(app.eigenform_sub_tab_merge, 'Text', '(?)');
    app.view_all_help_merge.Position = [2*x_boundary+x_sensor_table+1.9*x_small+x_space y_sub_tab2-2*y_boundary-8*y_fix-7*y_space 0.2*x_small y_fix];
    app.view_all_help_merge.Tooltip = 'Alle Ansichten werden gleichzeitig in einem Fenster dargestellt';

    % Checkbox für 3D-Ansicht
    app.view_3D_check_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', '3D-Ansicht');
    app.view_3D_check_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-9*y_fix-8*y_space x_small y_fix];

    % Checkbox für Seitenansicht
    app.view_side_check_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', 'Seitenansicht');
    app.view_side_check_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-10*y_fix-9*y_space x_small y_fix];

    % Checkbox für Querschnittsansicht
    app.view_cross_check_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', 'Querschnittsansicht');
    app.view_cross_check_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-11*y_fix-10*y_space 1.5*x_small y_fix];

    % Checkbox für Draufsicht
    app.view_plan_check_merge = uicheckbox(app.eigenform_sub_tab_merge, 'Text', 'Draufsicht');
    app.view_plan_check_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-12*y_fix-11*y_space x_small y_fix];

    % Button für Exportieren
    app.export_eigenform_button_merge = uibutton(app.eigenform_sub_tab_merge, 'Text', 'Plots exportieren');
    app.export_eigenform_button_merge.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-13*y_fix-12*y_space x_large y_fix];
end