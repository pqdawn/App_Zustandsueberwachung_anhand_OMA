%% Tab "Export" im Modus "Zustandsüberwachung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_export_tab_monitor_mode(app)

    % Größen holen
    y_fig = app.y_fig;
    x_boundary = app.x_boundary;
    y_boundary = app.y_boundary;
    y_space = app.y_space;
    x_large = app.x_large;
    x_small = app.x_small;
    y_fix = app.y_fix;
    x_sub_tab2 = 900;
    y_sub_tab2 = y_fig-30-y_boundary-y_space;
    x_sensor_table = x_large+80;
    y_sensor_table = y_sub_tab2-y_boundary-40;

    % Alle Komponenten in diesem Tab löschen
    delete(app.export_tab_monitor_mode.Children)     

    % Subtabs für Export 
    app.sub_tab_group_export_tab_monitor = uitabgroup(app.export_tab_monitor_mode);
    app.sub_tab_group_export_tab_monitor.Position = [x_boundary y_fig-y_sub_tab2-40 x_sub_tab2 y_sub_tab2];
    app.signal_sub_tab_monitor = uitab(app.sub_tab_group_export_tab_monitor, 'Title', 'Signalplot');              % Signalplot
    app.mod_parameter_sub_tab_monitor = uitab(app.sub_tab_group_export_tab_monitor, 'Title', 'Mod. Parameter');   % Mod. Parameter
    app.freq_time_sub_tab = uitab(app.sub_tab_group_export_tab_monitor, 'Title', 'Freq.-Zeit-Plot');              % Freq.-Zeit-Plot

    % Tabelle für Sensoren
    app.sensor_table_monitor = uitable(app.signal_sub_tab_monitor);
    app.sensor_table_monitor.Position = [x_boundary y_boundary x_sensor_table y_sensor_table];
    app.sensor_table_monitor.ColumnName = {'Sensoren werden hier angezeigt'};
    app.sensor_table_monitor.SelectionType = 'row';

    % Label für Pfad
    app.signal_path_label_monitor = uilabel(app.signal_sub_tab_monitor, 'Text', 'Ordnerpfad: ');
    app.signal_path_label_monitor.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-y_fix x_small y_fix];

    % Eingabefeld für Pfad
    app.signal_path_edit_field_monitor = uieditfield(app.signal_sub_tab_monitor, 'Placeholder', 'in Format C:\Ordner');
    app.signal_path_edit_field_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-y_fix x_large y_fix];

    % Button für Suchen des Ordners
    app.search_file_signal_button_monitor = uibutton(app.signal_sub_tab_monitor, 'Text', 'Ordner suchen');
    app.search_file_signal_button_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-2*y_fix-y_space x_large y_fix];

    % Label für Darstellungsart
    app.display_label2_monitor = uilabel(app.signal_sub_tab_monitor, 'Text', 'Darstellungsart:');
    app.display_label2_monitor.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-3*y_fix-2*y_space x_small y_fix];
    
    % Checkbox für Zeitreihe
    app.time_series_check_monitor = uicheckbox(app.signal_sub_tab_monitor, 'Text', 'Zeitreihe', 'Value', 1);
    app.time_series_check_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-3*y_fix-2*y_space x_small y_fix];

    % Checkbox für Frequenzspektrum
    app.spectrum_check_monitor = uicheckbox(app.signal_sub_tab_monitor, 'Text', 'Frequenzspektrum', 'Value', 1);
    app.spectrum_check_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-4*y_fix-3*y_space 1.5*x_small y_fix];

    % Button für Exportieren
    app.export_signal_button_monitor = uibutton(app.signal_sub_tab_monitor, 'Text', 'Plots exportieren');
    app.export_signal_button_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-5*y_fix-4*y_space x_large y_fix];

    % Label für OMA-Methoden
    app.oma_label2_monitor = uilabel(app.mod_parameter_sub_tab_monitor, 'Text', 'OMA-Methoden: ');
    app.oma_label2_monitor.Position = [x_boundary y_sub_tab2-2*y_boundary-y_fix x_small y_fix];

    % Checkboxen für OMA-Methoden
    app.oma_fdd_check2_monitor = uicheckbox(app.mod_parameter_sub_tab_monitor, 'Text', 'FDD', 'Value', 1);
    app.oma_fdd_check2_monitor.Position = [x_boundary+x_small y_sub_tab2-2*y_boundary-y_fix 60 y_fix];
    app.oma_efdd_check2_monitor = uicheckbox(app.mod_parameter_sub_tab_monitor, 'Text', 'EFDD', 'Value', 1);
    app.oma_efdd_check2_monitor.Position = [x_boundary+x_small+60 y_sub_tab2-2*y_boundary-y_fix 60 y_fix];
    app.oma_ssi_cov_check2_monitor = uicheckbox(app.mod_parameter_sub_tab_monitor, 'Text', 'SSI-COV', 'Value', 1);
    app.oma_ssi_cov_check2_monitor.Position = [x_boundary+x_small+120 y_sub_tab2-2*y_boundary-y_fix 80 y_fix];
    app.oma_ssi_data_check2_monitor = uicheckbox(app.mod_parameter_sub_tab_monitor, 'Text', 'SSI-DATA', 'Value', 1);
    app.oma_ssi_data_check2_monitor.Position = [x_boundary+x_small+200 y_sub_tab2-2*y_boundary-y_fix 100 y_fix]; 

    % Tabelle für Frequenzen und Dämpfungsgrade
    app.freq_damp_table2_monitor = uitable(app.mod_parameter_sub_tab_monitor);
    app.freq_damp_table2_monitor.Position = [x_boundary y_sub_tab2-2*y_boundary-y_sensor_table x_sensor_table y_sensor_table-30];
    app.freq_damp_table2_monitor.ColumnName = {'Ergebnisse werden hier angezeigt'};
    app.freq_damp_table2_monitor.SelectionType = 'row';

    % Label für Pfad
    app.mod_parameter_path_label_monitor = uilabel(app.mod_parameter_sub_tab_monitor, 'Text', 'Ordnerpfad: ');
    app.mod_parameter_path_label_monitor.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-y_fix 1.5*x_small y_fix];

    % Eingabefeld für Pfad
    app.mod_parameter_path_edit_field_monitor = uieditfield(app.mod_parameter_sub_tab_monitor, 'Placeholder', 'in Format C:\Ordner');
    app.mod_parameter_path_edit_field_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-y_fix x_large y_fix];

    % Button für Suchen des Ordners
    app.search_file_mod_parameter_button_monitor = uibutton(app.mod_parameter_sub_tab_monitor, 'Text', 'Ordner suchen');
    app.search_file_mod_parameter_button_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-2*y_fix-y_space x_large y_fix];

    % Label für "Daten zu exportieren"
    app.to_export_label2_monitor = uilabel(app.mod_parameter_sub_tab_monitor, 'Text', 'Daten zu exportieren:');
    app.to_export_label2_monitor.Position = [2*x_boundary+x_sensor_table y_sub_tab2-2*y_boundary-3*y_fix-2*y_space 1.5*x_small y_fix];
    
    % Checkbox für Eigenfrequenz
    app.eigenfreq_check_monitor = uicheckbox(app.mod_parameter_sub_tab_monitor, 'Text', 'Eigenfrequenz', 'Value', 1);
    app.eigenfreq_check_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-3*y_fix-2*y_space x_small y_fix];

    % Checkbox für Dämpfungsgrad
    app.damp_check_monitor = uicheckbox(app.mod_parameter_sub_tab_monitor, 'Text', 'Dämpfungsgrad', 'Value', 1);
    app.damp_check_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-4*y_fix-3*y_space 1.5*x_small y_fix];

    % Checkbox für Eigenvektor
    app.eigenvector_check_monitor = uicheckbox(app.mod_parameter_sub_tab_monitor, 'Text', 'Eigenvektor', 'Value', 1);
    app.eigenvector_check_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-5*y_fix-4*y_space 1.5*x_small y_fix];

    % Button für Exportieren
    app.export_mod_parameter_button_monitor = uibutton(app.mod_parameter_sub_tab_monitor, 'Text', 'Daten exportieren');
    app.export_mod_parameter_button_monitor.Position = [2*x_boundary+x_sensor_table+1.5*x_small y_sub_tab2-2*y_boundary-6*y_fix-5*y_space x_large y_fix];

    % Label für Pfad
    app.freq_time_path_label = uilabel(app.freq_time_sub_tab, 'Text', 'Ordnerpfad: ');
    app.freq_time_path_label.Position = [x_boundary y_sub_tab2-2*y_boundary-y_fix 1.5*x_small y_fix];

    % Eingabefeld für Pfad
    app.freq_time_path_edit_field = uieditfield(app.freq_time_sub_tab, 'Placeholder', 'in Format C:\Ordner');
    app.freq_time_path_edit_field.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-y_fix x_large y_fix];

    % Button für Suchen des Ordners
    app.search_file_freq_time_button = uibutton(app.freq_time_sub_tab, 'Text', 'Ordner suchen');
    app.search_file_freq_time_button.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-2*y_fix-y_space x_large y_fix];

    % Label für OMA-Methoden
    app.oma_label3_monitor = uilabel(app.freq_time_sub_tab, 'Text', 'OMA-Methoden:');
    app.oma_label3_monitor.Position = [x_boundary y_sub_tab2-2*y_boundary-3*y_fix-2*y_space 1.5*x_small y_fix];  

    % Checkboxen für OMA-Methoden
    app.oma_fdd_check3_monitor = uicheckbox(app.freq_time_sub_tab, 'Text', 'FDD', 'Value', 1);
    app.oma_fdd_check3_monitor.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-3*y_fix-2*y_space x_small y_fix];
    app.oma_efdd_check3_monitor = uicheckbox(app.freq_time_sub_tab, 'Text', 'EFDD', 'Value', 1);
    app.oma_efdd_check3_monitor.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-4*y_fix-3*y_space x_small y_fix];
    app.oma_ssi_cov_check3_monitor = uicheckbox(app.freq_time_sub_tab, 'Text', 'SSI-COV', 'Value', 1);
    app.oma_ssi_cov_check3_monitor.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-5*y_fix-4*y_space x_small y_fix];
    app.oma_ssi_data_check3_monitor = uicheckbox(app.freq_time_sub_tab, 'Text', 'SSI-DATA', 'Value', 1);
    app.oma_ssi_data_check3_monitor.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-6*y_fix-5*y_space x_small y_fix];    

    % Button für Exportieren
    app.export_freq_time_button = uibutton(app.freq_time_sub_tab, 'Text', 'Plots exportieren');
    app.export_freq_time_button.Position = [x_boundary+1.5*x_small y_sub_tab2-2*y_boundary-7*y_fix-6*y_space x_large y_fix];    
end