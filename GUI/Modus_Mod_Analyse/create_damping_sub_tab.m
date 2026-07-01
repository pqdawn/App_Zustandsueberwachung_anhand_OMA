%% Sub-Tab "Dämpfung in EFDD" im Tab "FDD / EFDD"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_damping_sub_tab(app)

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
    delete(app.daempfung_sub_tab.Children)    

    % Graph für 1. Singulärwerte der PSD in [dB]
    app.psd_graph3 = uiaxes(app.daempfung_sub_tab);
    app.psd_graph3.XGrid = 'on';
    app.psd_graph3.YGrid = 'on';
    app.psd_graph3.ZGrid = 'on';
    x_psd_graph2 = 610;
    y_sub_tab4 = y_fig-30-y_boundary-y_space;
    y_psd_graph2 = (y_sub_tab4-60-3*y_space-y_boundary-2*y_fix)/3;
    app.psd_graph3.Position = [x_boundary y_boundary+2*y_fix+4*y_space+2*y_psd_graph2 x_psd_graph2 y_psd_graph2+10];
    app.psd_graph3.Title.String = '\textbf{1. Singul\"arwerte der PSD}';
    app.psd_graph3.XLabel.String = 'Frequenz in [Hz]';
    app.psd_graph3.YLabel.String = '1. Singul\"arwerte der PSD in [dB]';

    % Variable unter "psd_graph3" speichern
    app.psd_graph3.UserData.mode_num = NaN;

    % Graph für Korrelationsfunktion der 1. Singulärwerte
    app.backsignal_graph = uiaxes(app.daempfung_sub_tab);
    app.backsignal_graph.XGrid = 'on';
    app.backsignal_graph.YGrid = 'on';
    app.backsignal_graph.Position = [x_boundary y_boundary+2*y_fix+3*y_space+y_psd_graph2 x_psd_graph2 y_psd_graph2];
    app.backsignal_graph.Title.String = '\textbf{Korrelationsfunktion der 1. Singul\"arwerte}';
    app.backsignal_graph.XLabel.String = 'Zeit in [s]';
    app.backsignal_graph.YLabel.String = 'Normalisierte Amplitude'; 

    % Slider für x-Achse des Graphs für Korrelationsfunktion der 1. Singulärwerte
    app.backsignal_slider = uislider(app.daempfung_sub_tab, 'range');
    app.backsignal_slider.Position = [3*x_boundary y_boundary+y_psd_graph2+2*y_fix+2*y_space x_psd_graph2-2.25*x_boundary app.backsignal_slider.Position(4)];
    app.backsignal_slider.Limits = [min(app.backsignal_graph.XTick), max(app.backsignal_graph.XTick)];
    app.backsignal_slider.Value = [min(app.backsignal_graph.XTick), max(app.backsignal_graph.XTick)];
    app.backsignal_slider.MajorTicks = app.backsignal_graph.XTick;

    % Checkbox für fixierten Bereich der x-Achse
    app.backsignal_range_check = uicheckbox(app.daempfung_sub_tab, 'Text', 'Bereich der x-Achse fixieren:', 'Value', 0);
    app.backsignal_range_check.Position = [2.6*x_boundary y_boundary+y_psd_graph2+y_space 180 y_fix];

    % Eingabefeld für fixierten Bereich der x-Achse
    app.backsignal_range_edit_field = uieditfield(app.daempfung_sub_tab, 'Value', '1', 'Editable', 0);
    app.backsignal_range_edit_field.BackgroundColor = [0.80,0.80,0.80];
    app.backsignal_range_edit_field.Position = [2.6*x_boundary+180 y_boundary+y_psd_graph2+y_space 0.5*x_small y_fix];

    % Variablen unter "backsignal_range_edit_field" speichern
    app.backsignal_range_edit_field.UserData.lower_limit = 0;
    app.backsignal_range_edit_field.UserData.upper_limit = 1;    

    % Graph für lineare Regression des logarithmischen Dekrements
    app.log_graph = uiaxes(app.daempfung_sub_tab);
    app.log_graph.XGrid = 'on';
    app.log_graph.YGrid = 'on';
    app.log_graph.Position = [x_boundary y_boundary x_psd_graph2 y_psd_graph2];
    app.log_graph.Title.String = '\textbf{Lineare Regression des logarithmischen Dekrements}';
    app.log_graph.XLabel.String = 'Peak $k$';
    app.log_graph.YLabel.String = '$2 \mathrm{ln}(r_k)$';      
    
    % Tabelle für Frequenzen und Dämpfungsgrade
    app.freq_damp_table_efdd = uitable(app.daempfung_sub_tab);
    y_freq_damp_table = 400-5*y_fix-5*y_space+60;
    app.freq_damp_table_efdd.Position = [x_boundary+x_psd_graph2+x_space y_sub_tab4-y_freq_damp_table-70 x_large y_freq_damp_table+30];
    app.freq_damp_table_efdd.ColumnName = {'Ergebnisse werden hier angezeigt'};
    app.freq_damp_table_efdd.SelectionType = 'row';

    % Gewählte Zeile unter "freq_damp_table_efdd" speichern
    app.freq_damp_table_efdd.UserData.row_selected = NaN;

    % Button für Untersuchung der Mode
    app.examine_mode_button = uibutton(app.daempfung_sub_tab, 'Text', 'Mode untersuchen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.examine_mode_button.Position = [x_boundary+x_psd_graph2+x_space y_boundary+7*y_fix+7*y_space 0.91*x_large y_fix];      

    % Button für Auswählen des Bereiches für Dämpfungsgrad
    app.choose_damping_area_button = uibutton(app.daempfung_sub_tab, 'Text', 'Bereich für Dämpfungsgrad wählen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.choose_damping_area_button.Position = [x_boundary+x_psd_graph2+x_space y_boundary+6*y_fix+6*y_space 0.91*x_large y_fix];   

    % Hilfe für Auswählen des Bereiches für Dämpfungsgrad
    app.choose_damping_area_help = uilabel(app.daempfung_sub_tab, 'Text', '(?)');
    app.choose_damping_area_help.Position = [x_boundary+x_psd_graph2+2*x_space+0.91*x_large y_boundary+6*y_fix+6*y_space 0.2*x_small y_fix];
    app.choose_damping_area_help.Tooltip = ['Die Peaks innerhalb dieses gewählten Bereichs liefern Dämpfungsgrade, ' ...
        'die in eine Normalverteilung gefittet werden. Es wird empfohlen, den Bereich so zu wählen, dass die lineare Regression ' ...
        'möglichst gut durch eine Gerade beschrieben wird.'];

    % Button für automatisches Auswählen des Bereiches für Dämpfungsgrad
    app.choose_damping_area_auto_button = uibutton(app.daempfung_sub_tab, 'Text', 'Bereich automatisch wählen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.choose_damping_area_auto_button.Position = [x_boundary+x_psd_graph2+x_space y_boundary+5*y_fix+5*y_space 0.91*x_large y_fix];   

    % Hilfe für automatisches Auswählen des Bereiches für Dämpfungsgrad
    app.choose_damping_area_auto_help = uilabel(app.daempfung_sub_tab, 'Text', '(?)');
    app.choose_damping_area_auto_help.Position = [x_boundary+x_psd_graph2+2*x_space+0.91*x_large y_boundary+5*y_fix+5*y_space 0.2*x_small y_fix];
    app.choose_damping_area_auto_help.Tooltip = ['Verschiedene Kombinationen von Peaks zwischen 20% und 90% der max. Amplitude werden untersucht ' ...
        'und die Kombination mit dem kleinsten Variationskoeffizient wird gewählt.'];    

    % Label für Mittelwert
    app.mean_label = uilabel(app.daempfung_sub_tab, 'Text', 'Mittelwert: ');
    app.mean_label.Position = [x_boundary+x_psd_graph2+x_space y_boundary+4*y_fix+4*y_space 1.3*x_small y_fix]; 

    % Eingabefeld für Mittelwert
    app.mean_edit_field = uieditfield(app.daempfung_sub_tab, 'Editable', 0);
    app.mean_edit_field.BackgroundColor = [0.80,0.80,0.80];
    app.mean_edit_field.Position = [x_boundary+x_psd_graph2+x_space+1.3*x_small y_boundary+4*y_fix+4*y_space x_small y_fix];     

    % Label für Standardabweichung
    app.standard_dev_label = uilabel(app.daempfung_sub_tab, 'Text', 'Standardabweichung: ');
    app.standard_dev_label.Position = [x_boundary+x_psd_graph2+x_space y_boundary+3*y_fix+3*y_space 1.3*x_small y_fix]; 

    % Eingabefeld für Standardabweichung
    app.standard_dev_edit_field = uieditfield(app.daempfung_sub_tab, 'Editable', 0);
    app.standard_dev_edit_field.BackgroundColor = [0.80,0.80,0.80];
    app.standard_dev_edit_field.Position = [x_boundary+x_psd_graph2+x_space+1.3*x_small y_boundary+3*y_fix+3*y_space x_small y_fix];     

    % Label für Variationskoeffizient
    app.cov_label = uilabel(app.daempfung_sub_tab, 'Text', 'Variationskoeffizient: ');
    app.cov_label.Position = [x_boundary+x_psd_graph2+x_space y_boundary+2*y_fix+2*y_space 1.3*x_small y_fix]; 

    % Eingabefeld für Variationskoeffizient
    app.cov_edit_field = uieditfield(app.daempfung_sub_tab, 'Editable', 0);
    app.cov_edit_field.BackgroundColor = [0.80,0.80,0.80];
    app.cov_edit_field.Position = [x_boundary+x_psd_graph2+x_space+1.3*x_small y_boundary+2*y_fix+2*y_space x_small y_fix]; 

    % Lampe für Variationskoeffizient
    app.cov_lamp = uilamp(app.daempfung_sub_tab);
    app.cov_lamp.Position = [x_boundary+x_psd_graph2+x_space+2.4*x_small y_boundary+2*y_fix+2*y_space y_fix y_fix];    

    % Button für Übernehmen des Dämpfungsgrads
    app.adopt_damping_button = uibutton(app.daempfung_sub_tab, 'Text', 'Dämpfungsgrad übernehmen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.adopt_damping_button.Position = [x_boundary+x_psd_graph2+x_space y_boundary+y_fix+y_space 0.91*x_large y_fix];  

    % Hilfe für Übernehmen des Dämpfungsgrads
    app.adopt_damping_help = uilabel(app.daempfung_sub_tab, 'Text', '(?)');
    app.adopt_damping_help.Position = [x_boundary+x_psd_graph2+2*x_space+0.91*x_large y_boundary+y_fix+y_space 0.2*x_small y_fix];
    app.adopt_damping_help.Tooltip = ['Der Mittelwert wird als endgültiger Dämpfungsgrad übernommen. Ein kleiner ' ...
        'Variationskoeffizient weist auf geringe Streuung der Schätzungen und damit auf eine robuste Bestimmung hin.'];      

    % Button für Entfernen der Mode
    app.remove_mode_button = uibutton(app.daempfung_sub_tab, 'Text', 'Mode entfernen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.remove_mode_button.Position = [x_boundary+x_psd_graph2+x_space y_boundary 0.91*x_large y_fix]; 
end