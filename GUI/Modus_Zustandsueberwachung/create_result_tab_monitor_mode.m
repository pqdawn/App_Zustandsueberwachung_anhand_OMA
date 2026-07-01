%% Tab "Zustandsüberwachung" im Modus "Zustandsüberwachung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_result_tab_monitor_mode(app)

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
    delete(app.result_tab_monitor_mode.Children);   

    % Label für OMA-Methoden
    app.oma_label3 = uilabel(app.result_tab_monitor_mode, 'Text', 'Ergebnisse für: ');
    app.oma_label3.Position = [x_boundary y_fig-60 1.8*x_small y_fix];

    % Dropdown für OMA-Methoden
    app.oma_dropdown2 = uidropdown(app.result_tab_monitor_mode);
    app.oma_dropdown2.Position = [x_boundary+x_space+1.2*x_small y_fig-60 1.3*x_small y_fix];
    app.oma_dropdown2.Items = {'-'};        

    % Tabelle für Abschnitte
    app.step_table = uitable(app.result_tab_monitor_mode);
    y_step_table = 285;
    app.step_table.Position = [x_boundary y_fig-y_step_table-70 x_large y_step_table];
    app.step_table.ColumnName = {'Zeitabschnitte werden hier angezeigt'};
    app.step_table.SelectionType = 'row';

    % Gewählte Zeile unter "step_table" speichern
    app.step_table.UserData.row_selected = NaN;    

    % Button für Untersuchung des Abschnitts
    app.examine_segment_button = uibutton(app.result_tab_monitor_mode, 'Text', 'Abschnitt untersuchen');
    app.examine_segment_button.Position = [x_boundary y_fig-y_step_table-70-y_space-y_fix x_large y_fix];

    % Tabelle für Ergebnisse des Abschnitts
    app.freq_damp_table4 = uitable(app.result_tab_monitor_mode);
    app.freq_damp_table4.Position = [x_boundary y_boundary x_large y_step_table];
    app.freq_damp_table4.ColumnName = {'Ergebnisse werden hier angezeigt'};
    app.freq_damp_table4.SelectionType = 'row';

    % Gewählte Zeile unter "freq_damp_table4" speichern
    app.freq_damp_table4.UserData.row_selected = NaN;    

    % Graph für Frequenz-Zeit-Plot
    app.freq_time_graph = uiaxes(app.result_tab_monitor_mode);
    app.freq_time_graph.XGrid = 'on';
    app.freq_time_graph.YGrid = 'on';
    app.freq_time_graph.ZGrid = 'on';
    x_freq_time_graph = 650;
    y_freq_time_graph = y_step_table+y_fix+y_space;
    app.freq_time_graph.Position = [x_boundary+x_large+x_space y_fig-y_freq_time_graph-40 x_freq_time_graph y_freq_time_graph];
    app.freq_time_graph.Title.String = '\textbf{Frequenz-Zeit-Plot}';
    app.freq_time_graph.XLabel.String = 'Zeit in [s]';
    app.freq_time_graph.YLabel.String = 'Frequenz in [Hz]';

    % Graph für Diagramm zur Untersuchung
    app.examine_graph = uiaxes(app.result_tab_monitor_mode);
    app.examine_graph.XGrid = 'on';
    app.examine_graph.YGrid = 'on';
    app.examine_graph.ZGrid = 'on';
    app.examine_graph.Position = [x_boundary+x_large+x_space y_fig-2*y_freq_time_graph-40-y_space x_freq_time_graph y_freq_time_graph];
    app.examine_graph.Title.String = '\textbf{1. Singul\"arwerte der PSD}';
    app.examine_graph.XLabel.String = 'Frequenz in [Hz]';
    app.examine_graph.YLabel.String = '1. Singul\"arwerte der PSD in [/]'; 
end