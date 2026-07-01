%% Tab "Signalplot" im Modus "Modalanalyse"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_signal_tab(app)

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
    delete(app.signal_tab.Children);

    % Label für Sensor
    app.sensor_label = uilabel(app.signal_tab, ...
        'Text', 'Sensor: ');
    app.sensor_label.Position = [x_boundary y_fig-60 x_small y_fix];

    % Dropdown für Sensor
    app.sensor_dropdown = uidropdown(app.signal_tab);
    app.sensor_dropdown.Position = [x_boundary+x_small+x_space y_fig-60 x_large y_fix];
    app.sensor_dropdown.Items = {'-'};

    % Namen der Sensoren für Exportieren unter "sensor_dropdown" speichern
    app.sensor_dropdown.UserData.name_sensor_export = NaN;

    % Label für Darstellungsart
    app.display_label = uilabel(app.signal_tab, 'Text', 'Darstellungsart:');
    app.display_label.Position = [x_boundary y_fig-90 x_small y_fix];

    % Radiobutton-Gruppe für Darstellungart
    app.display_radio_group = uibuttongroup(app.signal_tab);
    app.display_radio_group.Position = [x_boundary+x_small+x_space y_fig-90 x_large y_fix];
    app.display_radio_group.BorderColor = [0.94,0.94,0.94];
    
    % Radiobutton für Zeitreihe
    app.time_series_radio = uiradiobutton(app.display_radio_group, 'Text', 'Zeitreihe');
    app.time_series_radio.Position = [0 0 1.5*x_small y_fix];

    % Radiobutton für Frequenzspektrum
    app.spectrum_radio = uiradiobutton(app.display_radio_group, 'Text', 'Frequenzspektrum');
    app.spectrum_radio.Position = [x_small 0 1.5*x_small y_fix];

    % Button für Darstellen des Signalplots
    app.update_signal_button = uibutton(app.signal_tab, 'Text', 'Signalplot darstellen');
    app.update_signal_button.Position = [x_boundary+x_small+x_space y_fig-120 x_large y_fix];

    % Graph für Signalplot 
    app.signal_graph = uiaxes(app.signal_tab);
    app.signal_graph.XGrid = 'on';
    app.signal_graph.YGrid = 'on';
    app.signal_graph.ZGrid = 'on';
    app.signal_graph.Position = [x_boundary y_boundary+2*y_fix+2*y_space 1000-2*x_boundary y_fig-120-3*y_space-y_boundary-2*y_fix];
    app.signal_graph.Title.String = '\textbf{Zeitreihe}';
    app.signal_graph.XLabel.String = 'Zeit in [s]';
    app.signal_graph.YLabel.String = 'Beschleunigung in [m/s$^2$]';

    % Slider für x-Achse des Signalplots 
    app.signal_slider = uislider(app.signal_tab, 'range');
    app.signal_slider.Position = [3*x_boundary y_boundary+2*y_fix+y_space 1000-4.25*x_boundary app.signal_slider.Position(4)];
    app.signal_slider.Limits = [min(app.signal_graph.XTick), max(app.signal_graph.XTick)];
    app.signal_slider.Value = [min(app.signal_graph.XTick), max(app.signal_graph.XTick)];
    app.signal_slider.MajorTicks = app.signal_graph.XTick;

    % Checkbox für fixierten Bereich der x-Achse
    app.signal_range_check = uicheckbox(app.signal_tab, 'Text', 'Bereich der x-Achse fixieren:', 'Value', 0);
    app.signal_range_check.Position = [2.6*x_boundary y_boundary 180 y_fix];

    % Eingabefeld für fixierten Bereich der x-Achse
    app.signal_range_edit_field = uieditfield(app.signal_tab, 'Value', '1','Editable', 0);
    app.signal_range_edit_field.BackgroundColor = [0.80,0.80,0.80];
    app.signal_range_edit_field.Position = [2.6*x_boundary+180 y_boundary 0.5*x_small y_fix];

    % Variablen unter "signal_range_edit_field" speichern
    app.signal_range_edit_field.UserData.lower_limit = 0;
    app.signal_range_edit_field.UserData.upper_limit = 1;
end