%% Tab "FDD / EFDD" im Modus "Modalanalyse"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_fdd_tab(app)

    % Größen holen
    y_fig = app.y_fig;
    x_fig = app.x_fig;
    x_boundary = app.x_boundary;
    y_boundary = app.y_boundary;
    x_space = app.x_space;
    y_space = app.y_space;
    x_large = app.x_large;
    x_small = app.x_small;
    y_fix = app.y_fix;

    % Alle Komponenten in diesem Tab löschen
    delete(app.fdd_tab.Children);

    % Subtabs für FDD / EFDD
    app.sub_tab_group_fdd_tab = uitabgroup(app.fdd_tab);
    x_sub_tab4 = x_fig-300-2*x_boundary;
    y_sub_tab4 = y_fig-30-y_boundary-y_space;
    app.sub_tab_group_fdd_tab.Position = [x_boundary y_boundary x_sub_tab4 y_sub_tab4];
    app.psd_sub_tab = uitab(app.sub_tab_group_fdd_tab, 'Title', 'Singulärwerte der PSD');     % Singulärwerte der PSD
    app.sbf_sub_tab = uitab(app.sub_tab_group_fdd_tab, 'Title', 'SBF');                       % SBF
    app.daempfung_sub_tab = uitab(app.sub_tab_group_fdd_tab, 'Title', 'Dämpfung in EFDD');    % Dämpfung in EFDD

    % Graph für 1. Singulärwerte der PSD in [dB]
    app.psd_graph = uiaxes(app.psd_sub_tab);
    app.psd_graph.XGrid = 'on';
    app.psd_graph.YGrid = 'on';
    x_psd_graph = 690;
    y_psd_graph = (y_sub_tab4-60-2*y_space-y_boundary-2*y_fix)/2;
    app.psd_graph.Position = [x_boundary y_boundary+2*y_fix+3*y_space+y_psd_graph x_psd_graph y_psd_graph+10];
    app.psd_graph.Title.String = '\textbf{1. Singul\"arwerte der PSD}';
    app.psd_graph.XLabel.String = 'Frequenz in [Hz]';
    app.psd_graph.YLabel.String = '1. Singul\"arwerte der PSD in [dB]';

    % Graph für 1. Singulärwerte der PSD in [/]
    app.psd_graph2 = uiaxes(app.psd_sub_tab);
    app.psd_graph2.XGrid = 'on';
    app.psd_graph2.YGrid = 'on';
    app.psd_graph2.Position = [x_boundary y_boundary+2*y_fix+2*y_space x_psd_graph y_psd_graph];
    app.psd_graph2.XLabel.String = 'Frequenz in [Hz]';
    app.psd_graph2.YLabel.String = '1. Singul\"arwerte der PSD in [/]';

    % Slider für x-Achse des Graphs für 1. Singulärwerte der PSD
    app.psd_graph_slider = uislider(app.psd_sub_tab, 'range');
    app.psd_graph_slider.Position = [3*x_boundary y_boundary+2*y_fix+y_space x_psd_graph-2.25*x_boundary app.psd_graph_slider.Position(4)];
    app.psd_graph_slider.Limits = [min(app.psd_graph.XTick), max(app.psd_graph.XTick)];
    app.psd_graph_slider.Value = [min(app.psd_graph.XTick), max(app.psd_graph.XTick)];
    app.psd_graph_slider.MajorTicks = app.psd_graph.XTick;

    % Checkbox für fixierten Bereich der x-Achse
    app.psd_graph_range_check = uicheckbox(app.psd_sub_tab, 'Text', 'Bereich der x-Achse fixieren:', 'Value', 0);
    app.psd_graph_range_check.Position = [2.6*x_boundary y_boundary 180 y_fix];

    % Eingabefeld für fixierten Bereich der x-Achse
    app.psd_graph_range_edit_field = uieditfield(app.psd_sub_tab, 'Value', '1','Editable', 0);
    app.psd_graph_range_edit_field.BackgroundColor = [0.80,0.80,0.80];
    app.psd_graph_range_edit_field.Position = [2.6*x_boundary+180 y_boundary 0.5*x_small y_fix];

    % Variablen unter "psd_graph_range_edit_field" speichern
    app.psd_graph_range_edit_field.UserData.lower_limit = 0;
    app.psd_graph_range_edit_field.UserData.upper_limit = 1;

    % Radiobutton-Gruppe für Auswahl des Graphs für Peak-Picking
    app.graph_type_radio_group = uibuttongroup(app.psd_sub_tab);
    app.graph_type_radio_group.Position = [x_boundary+x_psd_graph+x_space y_sub_tab4-90 2.2*x_small y_fix+30];
    app.graph_type_radio_group.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für Graph in [dB]
    app.graph_type_db = uiradiobutton(app.graph_type_radio_group, 'Text', 'Oberen Graph verwenden');
    app.graph_type_db.Position = [0 y_fix+10 2.2*x_small y_fix];

    % Radiobutton für Graph in [/]
    app.graph_type_linear = uiradiobutton(app.graph_type_radio_group, 'Text', 'Unteren Graph verwenden');
    app.graph_type_linear.Position = [0 0 2.2*x_small y_fix];

    % Button für Auswählen der Peaks
    app.choose_peak_button = uibutton(app.psd_sub_tab, 'Text', ...
        'Peak wählen', 'Interruptible', 'off','BusyAction', 'cancel');
    app.choose_peak_button.Position = [x_boundary+x_psd_graph+x_space y_sub_tab4-120 2.2*x_small y_fix];

    % Variablen unter "choose_peak_button" speichern
    app.choose_peak_button.UserData.is_selecting = false;

    % Tabelle für Frequenzen der gewählten Peaks
    app.freq_table2 = uitable(app.psd_sub_tab);
    app.freq_table2.Position = [x_boundary+x_psd_graph+x_space y_boundary+140 2.2*x_small y_sub_tab4-150-5*y_fix-4*y_space];
    app.freq_table2.ColumnName = {'Auswahlen werden hier angezeigt'};

    % Gewählte Zeile unter "freq_table2" speichern
    app.freq_table2.UserData.row_selected = NaN;

    % Button für Entfernen des Peaks
    app.remove_peak_button = uibutton(app.psd_sub_tab, 'Text', 'Peak entfernen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.remove_peak_button.Position = [x_boundary+x_psd_graph+x_space y_boundary+110 2.2*x_small y_fix];  

    % Label für Korrelationsfunktion
    app.correlation_curve_label = uilabel(app.psd_sub_tab, 'Text', 'Berechnung der Korrelationsfunktion: ');
    app.correlation_curve_label.Position = [x_boundary+x_psd_graph+x_space y_boundary+80 2.2*x_small y_fix]; 

    % Radiobutton-Gruppe für Korrelationsfunktion
    app.correlation_type_radio_group = uibuttongroup(app.psd_sub_tab);
    app.correlation_type_radio_group.Position = [x_boundary+x_psd_graph+x_space y_boundary+60 2.2*x_small y_fix]; 
    app.correlation_type_radio_group.BorderColor = [0.94,0.94,0.94];

    % Hilfe für Korrelationsfunktion
    app.correlation_type_help = uilabel(app.psd_sub_tab, 'Text', '(?)');
    app.correlation_type_help.Position = [x_boundary+x_psd_graph+2*x_space+2*x_small y_boundary+60 0.2*x_small y_fix];
    app.correlation_type_help.Tooltip = ['Diese Einstellung wird nur bei benutzerdefinierter FDD aktiviert. IFFT ist geeignet für ' ...
        'FDD mit weniger Fenstern ohne Überlappung. Kosinustransformation ist hingegen geeignet für FDD mit mehreren Fenstern und Überlappung'];

    % Radiobutton für IFFT
    app.correlation_type_ifft = uiradiobutton(app.correlation_type_radio_group, 'Text', 'IFFT', 'Enable', 'off');
    app.correlation_type_ifft.Position = [0 0 x_small y_fix]; 

    % Radiobutton für Kosinustransformation
    app.correlation_type_cos = uiradiobutton(app.correlation_type_radio_group, 'Text', 'Kosinustrans.', 'Enable', 'off');
    app.correlation_type_cos.Position = [x_small 0 x_small y_fix];

    % Label für MAC-Grenze
    app.mac_label2 = uilabel(app.psd_sub_tab, 'Text', 'MAC-Grenze: ');
    app.mac_label2.Position = [x_boundary+x_psd_graph+x_space y_boundary+30 x_small y_fix];    

    % Spinner für MAC-Grenze
    app.mac_spinner2 = uispinner(app.psd_sub_tab, 'Value', 95, ...
        'Step', 1, 'Limits', [0 99], 'ValueDisplayFormat', '%11.4g%%');
    app.mac_spinner2.Position = [x_boundary+x_psd_graph+x_space+x_small y_boundary+30 x_small y_fix]; 

    % Hilfe für MAC-Grenze
    app.mac_help2 = uilabel(app.psd_sub_tab, 'Text', '(?)');
    app.mac_help2.Position = [x_boundary+x_psd_graph+2*x_space+2*x_small y_boundary+30 0.2*x_small y_fix];
    app.mac_help2.Tooltip = ['Sie legt fest, wie ähnlich die Eigenformen benachbarter Frequenzen sein müssen, ' ...
        'damit sie derselben Schwingungsform zugeordnet und in der EFDD-Auswertung berücksichtigt werden'];  

    % Button für Durchführen der EFDD
    app.run_efdd_button = uibutton(app.psd_sub_tab, 'Text', 'EFDD durchführen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.run_efdd_button.Position = [x_boundary+x_psd_graph+x_space y_boundary 2.2*x_small y_fix];    

    % Sub-Tab "SBF"
    app = create_sbf_sub_tab(app);

    % Sub-Tab "Dämpfung in EFDD"
    app = create_damping_sub_tab(app);
end