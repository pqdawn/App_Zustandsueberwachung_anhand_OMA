%% Sub-Tab "SBF" im Tab "FDD / EFDD"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_sbf_sub_tab(app)

    % Größen holen
    y_fig = app.y_fig;
    x_boundary = app.x_boundary;
    y_boundary = app.y_boundary;
    x_space = app.x_space;
    y_space = app.y_space;
    x_small = app.x_small;
    y_fix = app.y_fix;

    % Alle Komponenten in diesem Tab löschen
    delete(app.sbf_sub_tab.Children)    

    % Graph für SBF
    app.sbf_graph = uiaxes(app.sbf_sub_tab);
    app.sbf_graph.XGrid = 'on';
    app.sbf_graph.YGrid = 'on';
    x_sbf_graph = 690;
    y_sbf_graph = 400;
    y_sub_tab4 = y_fig-30-y_boundary-y_space;
    app.sbf_graph.Position = [x_boundary y_sub_tab4-y_sbf_graph-40 x_sbf_graph y_sbf_graph];
    app.sbf_graph.Title.String = '\textbf{Spectral-Bell-Function}';
    app.sbf_graph.XLabel.String = 'Frequenz in [Hz]';
    app.sbf_graph.YLabel.String = '1. Singul\"arwerte der PSD'; 

    % Variablen unter "sbf_graph" speichern
    app.sbf_graph.UserData.mode_num = NaN;
    app.sbf_graph.UserData.mac = NaN;

    % Slider für x-Achse der SBF 
    app.sbf_slider = uislider(app.sbf_sub_tab, 'range');
    app.sbf_slider.Position = [3*x_boundary y_sub_tab4-y_sbf_graph-50 x_sbf_graph-2.25*x_boundary app.sbf_slider.Position(4)];
    app.sbf_slider.Limits = [min(app.sbf_graph.XTick), max(app.sbf_graph.XTick)];
    app.sbf_slider.Value = [min(app.sbf_graph.XTick), max(app.sbf_graph.XTick)];
    app.sbf_slider.MajorTicks = app.sbf_graph.XTick;

    % Checkbox für fixierten Bereich der x-Achse
    app.sbf_range_check = uicheckbox(app.sbf_sub_tab, 'Text', 'Bereich der x-Achse fixieren:', 'Value', 0);
    app.sbf_range_check.Position = [2.6*x_boundary y_sub_tab4-y_sbf_graph-100 180 y_fix];

    % Eingabefeld für fixierten Bereich der x-Achse
    app.sbf_range_edit_field = uieditfield(app.sbf_sub_tab, 'Value', '1','Editable', 0);
    app.sbf_range_edit_field.BackgroundColor = [0.80,0.80,0.80];
    app.sbf_range_edit_field.Position = [2.6*x_boundary+180 y_sub_tab4-y_sbf_graph-100 0.5*x_small y_fix];    

    % Variablen unter "sbf_range_edit_field" speichern
    app.sbf_range_edit_field.UserData.lower_limit = 0;
    app.sbf_range_edit_field.UserData.upper_limit = 1;    

    % Tabelle für Frequenzen und MAC-Grenzen
    app.freq_mac_table = uitable(app.sbf_sub_tab);
    y_freq_mac_table = y_sbf_graph-3*y_fix-3*y_space+60;
    app.freq_mac_table.Position = [x_boundary+x_sbf_graph+x_space y_sub_tab4-y_freq_mac_table-40 2.2*x_small y_freq_mac_table];
    app.freq_mac_table.ColumnName = {'Ergebnisse werden hier angezeigt'};
    app.freq_mac_table.SelectionType = 'row';

    % Gewählte Zeile unter "freq_mac_table" speichern
    app.freq_mac_table.UserData.row_selected = NaN;

    % Label für MAC-Grenze
    app.mac_label3 = uilabel(app.sbf_sub_tab, 'Text', 'MAC-Grenze: ');
    app.mac_label3.Position = [x_boundary+x_sbf_graph+x_space y_sub_tab4-y_freq_mac_table-40-y_fix-y_space x_small y_fix];  

    % Spinner für MAC-Grenze
    app.mac_spinner3 = uispinner(app.sbf_sub_tab, 'Value', 95, ...
        'Step', 1, 'Limits', [0 99], 'ValueDisplayFormat', '%11.4g%%');
    app.mac_spinner3.Position = [x_boundary+x_sbf_graph+x_space+x_small y_sub_tab4-y_freq_mac_table-40-y_fix-y_space x_small y_fix];   

    % Hilfe für MAC-Grenze
    app.mac_help3 = uilabel(app.sbf_sub_tab, 'Text', '(?)');
    app.mac_help3.Position = [x_boundary+x_sbf_graph+2*x_space+2*x_small y_sub_tab4-y_freq_mac_table-40-y_fix-y_space 0.2*x_small y_fix];
    app.mac_help3.Tooltip = 'Hier lässt sich die MAC-Grenze für jede Mode einzeln steuern';     

    % Button für Aktualisieren der SBF
    app.update_sbf_button = uibutton(app.sbf_sub_tab, 'Text', 'SBF darstellen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.update_sbf_button.Position = [x_boundary+x_sbf_graph+x_space y_sub_tab4-y_freq_mac_table-40-2*y_fix-2*y_space 2.2*x_small y_fix]; 

    % Button für Übernehmen der MAC
    app.adopt_mac_button = uibutton(app.sbf_sub_tab, 'Text', 'MAC übernehmen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.adopt_mac_button.Position = [x_boundary+x_sbf_graph+x_space y_sub_tab4-y_freq_mac_table-40-3*y_fix-3*y_space 2.2*x_small y_fix];
end