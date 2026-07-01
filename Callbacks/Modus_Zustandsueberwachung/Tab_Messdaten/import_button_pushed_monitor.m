%% Callback für Button zum Importieren der Messdaten (Modus "Zustandsüberwachung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function import_button_pushed_monitor(app)

    % Nötige Variablen holen
    path = app.path_edit_field_monitor.Value;                                   % Pfad zu Messdaten
    displacement_tick = app.type_displacement_radio_monitor.Value;              % Wahl für Verschiebungsdaten
    velocity_tick = app.type_velocity_radio_monitor.Value;                      % Wahl für Geschwindigkeitsdaten
    x_tick = app.x_direct_check_monitor.Value;                                  % Checkbox für x-Richtung (Tab "Messdaten)
    y_tick = app.y_direct_check_monitor.Value;                                  % Checkbox für y-Richtung (Tab "Messdaten)
    z_tick = app.z_direct_check_monitor.Value;                                  % Checkbox für z-Richtung (Tab "Messdaten)
    sampling_freq = app.sampling_freq_edit_field_monitor.Value;                 % Abtastfrequenz
    data_matrix_table = app.data_matrix_table_monitor;                          % Tabelle für Messdaten
    sensor_dropdown = app.sensor_dropdown_monitor;                              % Dropdown für Sensoren
    signal_graph = app.signal_graph_monitor;                                    % Graph für Signalplot
    freq_limit_edit_field = app.freq_limit_edit_field_monitor;                  % Eingabefeld für Frequenzgrenze
    lowest_freq_edit_field = app.lowest_freq_edit_field_monitor;                % Eingabefeld für niedrigste zu untersuchende Frequenz
    num_segment_edit_field = app.num_segment_edit_field;                        % Eingabefeld für Anzahl der Abschnitte
    time_interval_edit_field = app.time_interval_edit_field;                    % Eingabefeld für Zeitschrittsgröße
    num_ignore_row_edit_field = app.num_ignore_row_edit_field;                  % Eingabefeld für Anzahl der ignorierten Zeilen
    max_lag_edit_field = app.max_lag_edit_field_monitor;                        % Eingabefeld für maximalen verzögerten Zeitschritt
    max_model_order_edit_field = app.max_model_order_edit_field_monitor;        % Eingabefeld für maximale Model-Order (Sub-Tab "SSI-COV", Tab "Parameter")
    num_row_hankel_edit_field = app.num_row_hankel_edit_field_monitor;          % Eingabefeld für Zeilenanzahl der Hankelmatrix
    num_col_hankel_edit_field = app.num_col_hankel_edit_field_monitor;          % Eingabefeld für Spaltenanzahl der Hankelmatrix
    max_model_order_edit_field2 = app.max_model_order_edit_field2_monitor;      % Eingabefeld für maximale Model-Order (Sub-Tab "SSI-DATA", Tab "Parameter")
    sensor_table = app.sensor_table_monitor;                                    % Tabelle für Sensoren
    lamp = app.status_lamp;                                                     % Licht des Status
    status = app.status_text_area;                                              % Textfeld des Status

    try
        % Fehlermeldung falls Pfad nicht eingegeben
        if isempty(path)
            error('Pfad nicht eingegeben!');
        end

        % Fehlermeldung falls Pfad nicht gültig
        if ~isfile(path)
            error('Pfad nicht gültig!');
        end

        % Anzahl der Richtungen
        num_direct = sum([x_tick, y_tick, z_tick]);

        % Fehlermeldung falls gar keine Richtung gewählt
        if num_direct == 0
            error('Keine Richtung gewählt!');
        end

        % Fehlermeldung falls Abtastfrequenz nicht eingegeben
        if isempty(sampling_freq)
            error('Abtastfrequenz nicht eingegeben!');
        end

        % Fehlermeldung falls Abstastfrequenz gleich 0
        sampling_freq = str2double(sampling_freq);
        if sampling_freq == 0
            error(['Abtastfrequenz nicht gültig! Es muss größer ' ...
                'als 0 sein!'])
        end
        
        % Messdaten einlesen
        data_matrix = readmatrix(path);
        
        % Fehlermeldung falls die Datei nicht richtig eingelesen wurde,
        % bzw. die Matrix NaN-Werte enthält
        if any(isnan(data_matrix), 'all')
            error('NaN-Werte vorhanden. Das Format ist wahrscheinlich ungeeignet!');
        end

        % Fehlermeldung falls die Anzahl der Spalten der Messdaten mit der
        % eingegeben Anzahl der Richtungen nicht übereinstimmt
        [~, num_column] = size(data_matrix);
        if ~(rem(num_column-1, num_direct) == 0)
            error(['Größe der eingegebenen Messdaten stimmt nicht mit der ' ...
                'Anzahl der Richtungen überein!']);
        end

        % Zeitschritt aus Messdaten einlesen
        dt_read = data_matrix(2,1) - data_matrix(1,1);

        % Abtastrate von Messdaten berechnen
        sampling_freq_read = 1/dt_read;

        % Fehlermeldung falls eingegebene Abtastfrequenz mit Zeitschritten
        % aus Messdaten nicht übereinstimmt
        if abs(sampling_freq_read - sampling_freq) > 1e-6
            error(['Eingegebene Abtastfrequenz stimmt nicht mit der Frequenz ' ...
                'in Messdaten überein!']);
        end

        % Wenn Messdaten bereits importiert wurden, den Benutzer warnen
        if ~isnan(app.fig.UserData.cache.monitor.data_matrix)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(app.fig, ['Messdaten bereits importiert. Alle Daten ' ...
                'dieses Modus werden gelöscht. Möchten Sie fortfahren?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);

            % Wahl von Benutzer
            switch choice

                % Wenn "nein", Daten beibehalten und weiter
                case 'Nein'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Daten beibehalten', 'erfolg');
                    return;

                % Wenn "ja", Daten löschen und Modus zurücksetzen
                case 'Ja'

                    % Tabelle zurücksetzen
                    data_matrix_table.Data = [];
                    
                    % Betroffene Tabs zurücksetzen
                    app = reset_partial_app(app, 'monitor');

                    % Status aktualisieren
                    update_status(status, lamp, '>> Daten dieses Modus gelöscht', 'erfolg');
                    pause(1);

                    % Diesen Callback erneut rufen
                    import_button_pushed_monitor(app);
                    return;                    
            end            
        end     

        % Wenn der erste Zeitschritt ungleich 0 ist, wird der Zeitvektor
        % verschoben, damit er mit 0 anfängt
        time_vector = data_matrix(:,1);
        if time_vector(1) ~= 0
            time_vector = (0:size(data_matrix, 1)-1)' / sampling_freq;
            data_matrix(:,1) = time_vector;
        end
        
        % Messdaten und Infos speichern
        app.fig.UserData.cache.monitor.data_matrix = data_matrix;
        app.fig.UserData.cache.monitor.sampling_freq = sampling_freq;
        app.fig.UserData.cache.monitor.direction = [x_tick, y_tick, z_tick]; 

        % Falls Verschiebungsdaten angewendet
        if displacement_tick

            % Graph für Signalplot aktualisieren
            ylabel = 'Verschiebung in [m]';
            signal_graph.YLabel.String = ylabel;            

            % Einheit für Darstellung
            unit = '[m]';

            % Gemessene Größe speichern
            app.fig.UserData.cache.monitor.measurement_type = 'displacement';
        
        % Falls Geschwindigkeitsdaten angewendet
        elseif velocity_tick

            % Graph für Signalplot aktualisieren
            ylabel = 'Geschwindigkeit in [m/s]';
            signal_graph.YLabel.String = ylabel;            

            % Einheit für Darstellung
            unit = '[m/s]';         

            % Gemessene Größe speichern
            app.fig.UserData.cache.monitor.measurement_type = 'velocity';            

        % Falls Beschleunigungsdaten angewendet
        else

            % Einheit für Darstellung
            unit = '[m/s²]';

            % Gemessene Größe speichern
            app.fig.UserData.cache.monitor.measurement_type = 'acceleration';            
        end

        % Anzahl der Sensoren
        num_sensor = (num_column-1)/num_direct;

        % Anzahl der Sensoren speichern
        app.fig.UserData.cache.monitor.num_sensor = num_sensor;

        % Namen der Sensoren generieren
        name_sensor_signal_list = cell(1, num_sensor*num_direct);
        name_sensor_signal_list_w_unit = cell(1, num_sensor*num_direct);
        name_sensor_export_list = strings(1, num_sensor*num_direct);

        % Schleife durch die Richtungen und Sensoren
        i = 1;
        for j=1:num_sensor
            if x_tick
                name_sensor_signal_list{i} = sprintf('Sensor %d (x-Richtung)', j);
                name_sensor_signal_list_w_unit_input = ['Sensor %d (x-Richtung) ', unit];
                name_sensor_signal_list_w_unit{i} = sprintf(name_sensor_signal_list_w_unit_input, j);
                name_sensor_export_list(i) = 'Sensor_' + string(j) + '_x';
                i = i+1;
            end
            if y_tick
                name_sensor_signal_list{i} = sprintf('Sensor %d (y-Richtung)', j);
                name_sensor_signal_list_w_unit_input = ['Sensor %d (y-Richtung) ', unit];
                name_sensor_signal_list_w_unit{i} = sprintf(name_sensor_signal_list_w_unit_input, j);
                name_sensor_export_list(i) = 'Sensor_' + string(j) + '_y';
                i = i+1;
            end
            if z_tick
                name_sensor_signal_list{i} = sprintf('Sensor %d (z-Richtung)', j);
                name_sensor_signal_list_w_unit_input = ['Sensor %d (z-Richtung) ', unit];
                name_sensor_signal_list_w_unit{i} = sprintf(name_sensor_signal_list_w_unit_input, j);
                name_sensor_export_list(i) = 'Sensor_' + string(j) + '_z';
                i = i+1;
            end
        end

        % Dropdown für Sensoren aktualisieren
        sensor_dropdown.Items = name_sensor_signal_list;
        sensor_list_value = 1:num_sensor*num_direct;
        sensor_dropdown.ItemsData = sensor_list_value;

        % Namen der Sensoren für Exportieren speichern
        sensor_dropdown.UserData.name_sensor_export = name_sensor_export_list;

        % Tabelle für Signalplot im Tab "Export" aktualisieren
        sensor_tick = true(num_sensor*num_direct, 1);
        sensor_table.Data = table(name_sensor_signal_list', sensor_tick);
        sensor_table.ColumnName = {'Sensor', 'Zu exportieren'};
        sensor_table.RowName = 'numbered';
        sensor_table.ColumnEditable = logical([0, 1]);

        % Tabelle für Messdaten aktualisieren
        data_matrix_table.Data = app.fig.UserData.cache.monitor.data_matrix;
        data_matrix_col_title = ['Zeit [s]', name_sensor_signal_list_w_unit];
        data_matrix_table.ColumnName = data_matrix_col_title;

        % Frequenzgrenze aktualisieren
        freq_limit_edit_field.Value = string(sampling_freq); 

        % Niedrigste zu untersuchende Frequenz aktualisieren
        lowest_freq = 1;
        lowest_freq_edit_field.Value = string(lowest_freq);

        % Anzahl der Abschnitte aktualisieren
        num_segment_edit_field.Value = string(2);

        % Anzahl der Schritte pro Abschnitt berechnen
        num_row_total = size(data_matrix, 1);        
        num_step_pro_seg = floor(num_row_total/2);

        % Zeitintervall berechnen
        time_interval = num_step_pro_seg/sampling_freq;

        % Anzahl der ignorierten Zeilen berechnen
        num_ignore = num_row_total - 2 * num_step_pro_seg;

        % Eingabefelder aktualisieren
        time_interval_edit_field.Value = string(time_interval);
        num_ignore_row_edit_field.Value = string(num_ignore);       

        % Parameter für SSI-COV gemäß Empfehlung aktualisieren
        max_lag = ceil(sampling_freq/(2*lowest_freq));
        max_lag_edit_field.Value = string(max_lag);
        max_model_order_edit_field.Value = string(ceil(max_lag/2));

        % Parameter für SSI-DATA gemäß Empfehlung aktualisieren
        num_row_hankel = 2*max_lag;
        num_row_hankel_edit_field.Value = string(num_row_hankel);
        num_col_hankel_edit_field.Value = string(num_row_hankel*num_sensor*num_direct);
        max_model_order2 = num_row_hankel/2;
        num_output = num_direct*num_sensor;
        num_block=fix(num_row_hankel/num_output);
        if mod(num_block,2) ~= 0
            num_block = num_block - 1;
        end        
        if max_model_order2 > num_output*num_block/2
            max_model_order2 = num_output*num_block/2;
        end
        max_model_order_edit_field2.Value = string(floor(max_model_order2));
        
        % Status aktualisieren
        update_status(status, lamp, '>> Messdaten importiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end