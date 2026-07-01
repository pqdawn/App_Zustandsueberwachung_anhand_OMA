%% Tab "Signalplot" im Modus "Zustandsüberwachung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_signal_tab_monitor_mode(app)

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
    delete(app.signal_tab_monitor_mode.Children);

    % Label für Sensor
    app.sensor_label_monitor = uilabel(app.signal_tab_monitor_mode, ...
        'Text', 'Sensor: ');
    app.sensor_label_monitor.Position = [x_boundary y_fig-60 x_small y_fix];

    % Dropdown für Sensor
    app.sensor_dropdown_monitor = uidropdown(app.signal_tab_monitor_mode);
    app.sensor_dropdown_monitor.Position = [x_boundary+x_small+x_space y_fig-60 x_large y_fix];
    app.sensor_dropdown_monitor.Items = {'-'};

    % Namen der Sensoren für Exportieren unter "sensor_dropdown" speichern
    app.sensor_dropdown_monitor.UserData.name_sensor_export = NaN;

    % Label für Darstellungsart
    app.display_label_monitor = uilabel(app.signal_tab_monitor_mode, 'Text', 'Darstellungsart:');
    app.display_label_monitor.Position = [x_boundary y_fig-90 x_small y_fix];

    % Radiobutton-Gruppe für Darstellungart
    app.display_radio_group_monitor = uibuttongroup(app.signal_tab_monitor_mode);
    app.display_radio_group_monitor.Position = [x_boundary+x_small+x_space y_fig-90 x_large y_fix];
    app.display_radio_group_monitor.BorderColor = [0.94,0.94,0.94];
    
    % Radiobutton für Zeitreihe
    app.time_series_radio_monitor = uiradiobutton(app.display_radio_group_monitor, 'Text', 'Zeitreihe');
    app.time_series_radio_monitor.Position = [0 0 1.5*x_small y_fix];

    % Radiobutton für Frequenzspektrum
    app.spectrum_radio_monitor = uiradiobutton(app.display_radio_group_monitor, 'Text', 'Frequenzspektrum');
    app.spectrum_radio_monitor.Position = [x_small 0 1.5*x_small y_fix];

    % Button für Darstellen des Signalplots
    app.update_signal_button_monitor = uibutton(app.signal_tab_monitor_mode, 'Text', 'Signalplot darstellen');
    app.update_signal_button_monitor.Position = [x_boundary+x_small+x_space y_fig-120 x_large y_fix];

    % Graph für Signalplot 
    app.signal_graph_monitor = uiaxes(app.signal_tab_monitor_mode);
    app.signal_graph_monitor.XGrid = 'on';
    app.signal_graph_monitor.YGrid = 'on';
    app.signal_graph_monitor.ZGrid = 'on';
    app.signal_graph_monitor.Position = [x_boundary y_boundary+2*y_fix+2*y_space 1000-2*x_boundary y_fig-120-3*y_space-y_boundary-2*y_fix];
    app.signal_graph_monitor.Title.String = '\textbf{Zeitreihe}';
    app.signal_graph_monitor.XLabel.String = 'Zeit in [s]';
    app.signal_graph_monitor.YLabel.String = 'Beschleunigung in [m/s$^2$]';

    % Slider für x-Achse des Signalplots 
    app.signal_slider_monitor = uislider(app.signal_tab_monitor_mode, 'range');
    app.signal_slider_monitor.Position = [3*x_boundary y_boundary+2*y_fix+y_space 1000-4.25*x_boundary app.signal_slider.Position(4)];
    app.signal_slider_monitor.Limits = [min(app.signal_graph.XTick), max(app.signal_graph.XTick)];
    app.signal_slider_monitor.Value = [min(app.signal_graph.XTick), max(app.signal_graph.XTick)];
    app.signal_slider_monitor.MajorTicks = app.signal_graph.XTick;

    % Checkbox für fixierten Bereich der x-Achse
    app.signal_range_check_monitor = uicheckbox(app.signal_tab_monitor_mode, 'Text', 'Bereich der x-Achse fixieren:', 'Value', 0);
    app.signal_range_check_monitor.Position = [2.6*x_boundary y_boundary 180 y_fix];

    % Eingabefeld für fixierten Bereich der x-Achse
    app.signal_range_edit_field_monitor = uieditfield(app.signal_tab_monitor_mode, 'Value', '1','Editable', 0);
    app.signal_range_edit_field_monitor.BackgroundColor = [0.80,0.80,0.80];
    app.signal_range_edit_field_monitor.Position = [2.6*x_boundary+180 y_boundary 0.5*x_small y_fix];

    % Variablen unter "signal_range_edit_field" speichern
    app.signal_range_edit_field_monitor.UserData.lower_limit = 0;
    app.signal_range_edit_field_monitor.UserData.upper_limit = 1;
end