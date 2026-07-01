%% Callback für Button zum Importieren der Messdaten (Modus "Modalanalyse")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function import_button_pushed(app)

    % Nötige Variablen holen
    path = app.path_edit_field.Value;                                   % Pfad zu Messdaten
    displacement_tick = app.type_displacement_radio.Value;              % Wahl für Verschiebungsdaten
    velocity_tick = app.type_velocity_radio.Value;                      % Wahl für Geschwindigkeitsdaten
    x_tick = app.x_direct_check.Value;                                  % Checkbox für x-Richtung (Tab "Messdaten)
    y_tick = app.y_direct_check.Value;                                  % Checkbox für y-Richtung (Tab "Messdaten)
    z_tick = app.z_direct_check.Value;                                  % Checkbox für z-Richtung (Tab "Messdaten)
    sampling_freq = app.sampling_freq_edit_field.Value;                 % Abtastfrequenz
    data_matrix_table = app.data_matrix_table;                          % Tabelle für Messdaten
    assign_table = app.assign_table;                                    % Tabelle für Zuweisungen
    node_table = app.node_table;                                        % Tabelle für Knoten
    geometry_graph = app.geometry_graph;                                % Graph für Geometrie
    sensor_dropdown = app.sensor_dropdown;                              % Dropdown für Sensoren
    signal_graph = app.signal_graph;                                    % Graph für Signalplot
    freq_limit_edit_field = app.freq_limit_edit_field;                  % Eingabefeld für Frequenzgrenze
    lowest_freq_edit_field = app.lowest_freq_edit_field;                % Eingabefeld für niedrigste zu untersuchende Frequenz
    max_lag_edit_field = app.max_lag_edit_field;                        % Eingabefeld für maximalen verzögerten Zeitschritt
    max_model_order_edit_field = app.max_model_order_edit_field;        % Eingabefeld für maximale Model-Order (Sub-Tab "SSI-COV", Tab "Parameter")
    num_row_hankel_edit_field = app.num_row_hankel_edit_field;          % Eingabefeld für Zeilenanzahl der Hankelmatrix
    num_col_hankel_edit_field = app.num_col_hankel_edit_field;          % Eingabefeld für Spaltenanzahl der Hankelmatrix
    max_model_order_edit_field2 = app.max_model_order_edit_field2;      % Eingabefeld für maximale Model-Order (Sub-Tab "SSI-DATA", Tab "Parameter")
    measurement_dropdown = app.measurement_dropdown;                    % Dropdown für Messdaten
    x_tick2 = app.x_direct_check2;	                                    % Checkbox für x-Richtung (Tab "Ergebnis")
    y_tick2 = app.y_direct_check2;                                      % Checkbox für y-Richtung (Tab "Ergebnis")
    z_tick2 = app.z_direct_check2;                                      % Checkbox für z-Richtung (Tab "Ergebnis")
    sensor_table = app.sensor_table;                                    % Tabelle für Sensoren
    x_tick3 = app.x_direct_check3;                                      % Checkbox für x-Richtung (Sub-Tab "Eigenform", Tab "Export")
    y_tick3 = app.y_direct_check3;                                      % Checkbox für y-Richtung (Sub-Tab "Eigenform", Tab "Export")
    z_tick3 = app.z_direct_check3;                                      % Checkbox für z-Richtung (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                             % Licht des Status
    status = app.status_text_area;                                      % Textfeld des Status

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
        if ~isnan(app.fig.UserData.cache.modal.data_matrix)

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
                    app = reset_partial_app(app, 'modal');

                    % Status aktualisieren
                    update_status(status, lamp, '>> Daten dieses Modus gelöscht', 'erfolg');
                    pause(1);

                    % Diesen Callback erneut rufen
                    import_button_pushed(app);
                    return;                    
            end            
        end        

        % Messdaten und Infos speichern
        app.fig.UserData.cache.modal.data_matrix = data_matrix;
        app.fig.UserData.cache.modal.sampling_freq = sampling_freq;
        app.fig.UserData.cache.modal.direction = [x_tick, y_tick, z_tick];        

        % Zeitschritt berechnen
        dt = 1/sampling_freq;

        % Falls die gemessene Größe keine Beschleunigung ist, müssen die
        % Messdaten ggf. abgeleitet werden
        % Falls Verschiebungsdaten angewendet
        if displacement_tick

            % Messdaten ableiten -> Geschwindigkeit
            velocity = diff(data_matrix(:, 2:end)) / dt;

            % Eine Größe am Anfang einfügen, damit die Größe der Messdaten
            % gleich bleibt
            velocity = [velocity(1, :); velocity];

            % Messdaten ableiten -> Beschleunigung
            acceleration = diff(velocity) / dt;

            % Eine Größe am Anfang einfügen, damit die Größe der Messdaten
            % gleich bleibt
            acceleration = [acceleration(1, :); acceleration];

            % Ableitung verstärkt das Rauschen im höheren Frequenzbereich
            % Um dieses Rauschen zu verringern, wird ein Filter angewendet
            % Für Bauingenieurwesen reicht 100 Hz völlig aus
            f_cut = 100;

            % D.h. Filter muss nur auf Messdaten angewendet werden, falls
            % deren Nyquist-Frequenz größer als 100 Hz ist
            f_nyquist = sampling_freq/2;
            if f_nyquist > f_cut
                [b, a] = butter(2, f_cut / (0.5 / dt), 'low');      % Low-Pass-Filter
                acceleration = filtfilt(b, a, acceleration);        % Zero-Phase-Filter
            end

            % Zurück in "data_matrix" speichern
            data_matrix(:, 2:end) = [];
            data_matrix = [data_matrix, acceleration];

            % Abgeleitete Messdaten speichern
            app.fig.UserData.cache.modal.data_matrix_diff = data_matrix;

            % Einheit für Darstellung
            unit = '[m]';

            % Gemessene Größe speichern
            app.fig.UserData.cache.modal.measurement_type = 'displacement';
        
        % Falls Geschwindigkeitsdaten angewendet
        elseif velocity_tick

            % Messdaten ableiten -> Beschleunigung
            acceleration = diff(data_matrix(:, 2:end)) / dt;

            % Eine Größe am Anfang einfügen, damit die Größe der Messdaten
            % gleich bleibt
            acceleration = [acceleration(1, :); acceleration];

            % Ableitung verstärkt das Rauschen im höheren Frequenzbereich
            % Um dieses Rauschen zu verringern, wird ein Filter angewendet
            % Für Bauingenieurwesen reicht 100 Hz völlig aus
            f_cut = 100;

            % D.h. Filter muss nur auf Messdaten angewendet werden, falls
            % deren Nyquist-Frequenz größer als 100 Hz ist
            f_nyquist = sampling_freq/2;
            if f_nyquist > f_cut
                [b, a] = butter(2, f_cut / (0.5 / dt), 'low');      % Low-Pass-Filter
                acceleration = filtfilt(b, a, acceleration);        % Zero-Phase-Filter
            end

            % Zurück in "data_matrix" speichern
            data_matrix(:, 2:end) = [];
            data_matrix = [data_matrix, acceleration];

            % Abgeleitete Messdaten speichern
            app.fig.UserData.cache.modal.data_matrix_diff = data_matrix;

            % Einheit für Darstellung
            unit = '[m/s]';         

            % Gemessene Größe speichern
            app.fig.UserData.cache.modal.measurement_type = 'velocity';            

        % Falls Beschleunigungsdaten angewendet
        else

            % Einheit für Darstellung
            unit = '[m/s²]';

            % Gemessene Größe speichern
            app.fig.UserData.cache.modal.measurement_type = 'acceleration';            
        end

        % Anzahl der Sensoren
        num_sensor = (num_column-1)/num_direct;

        % Anzahl der Sensoren speichern
        app.fig.UserData.cache.modal.num_sensor = num_sensor;

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

        % Weitere Komponenten abhängig von der gemessenen Größe
        % Falls Verschiebungsdaten angewendet
        if displacement_tick

            % Graph für Signalplot aktualisieren
            ylabel = 'Verschiebung in [m]';
            signal_graph.YLabel.String = ylabel;

            % Dropdown für Messdaten aktualisieren
            measurement_dropdown.Items = {'Verschiebung (original)', 'Beschleunigung (abgeleitet)'};
            measurement_dropdown.ItemsData = 1:2;

        % Falls Geschwindigkeitsdaten angewendet
        elseif velocity_tick

            % Graph für Signalplot aktualisieren
            ylabel = 'Geschwindigkeit in [m/s]';
            signal_graph.YLabel.String = ylabel;

            % Dropdown für Messdaten aktualisieren
            measurement_dropdown.Items = {'Geschwindigkeit (original)', 'Beschleunigung (abgeleitet)'};
            measurement_dropdown.ItemsData = 1:2;
        end

        % Tabelle für Messdaten aktualisieren
        data_matrix_table.Data = app.fig.UserData.cache.modal.data_matrix;
        data_matrix_col_title = ['Zeit [s]', name_sensor_signal_list_w_unit];
        data_matrix_table.ColumnName = data_matrix_col_title;

        % Tabelle für Zuweisungen aktualisieren
        assign_vector = (1:num_sensor)';
        assign_matrix = [assign_vector, assign_vector];
        assign_table.Data = assign_matrix;
        assign_col_title = {'Sensor', 'Knoten'};
        assign_table.ColumnName = assign_col_title;
        assign_table.ColumnWidth = repmat({'1x'}, 1, 2);
        assign_table.ColumnEditable = logical([0, 1]);

        % Tabelle für Knoten aktualisieren
        node_matrix = zeros(num_sensor, 3);
        node_table.Data = node_matrix;
        node_col_title = {'x-Koor', 'y-Koor', 'z-Koor'};
        node_table.ColumnName = node_col_title;
        node_table.ColumnWidth = repmat({'1x'}, 1, 3);
        node_table.ColumnEditable = true(1, 3);

        % Graph für Geometrie aktualisieren
        plot_geometry(assign_matrix, node_matrix, [], [], geometry_graph);  

        % Frequenzgrenze aktualisieren
        freq_limit_edit_field.Value = string(sampling_freq); 

        % Niedrigste zu untersuchende Frequenz aktualisieren
        lowest_freq = 1;
        lowest_freq_edit_field.Value = string(lowest_freq);

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

        % Mögliche Richtungen für Darstellung bzw. Exportieren der 
        % Eigenformen aktualisieren
        if x_tick ~= 1
            x_tick2.Value = 0;
            x_tick2.Enable = 'off';
            x_tick3.Value = 0;
            x_tick3.Enable = 'off';
        end
        if y_tick ~= 1
            y_tick2.Value = 0;
            y_tick2.Enable = 'off';
            y_tick3.Value = 0;
            y_tick3.Enable = 'off';
        end
        if z_tick ~= 1
            z_tick2.Value = 0;
            z_tick2.Enable = 'off';
            z_tick3.Value = 0;
            z_tick3.Enable = 'off';
        end
        
        % Status aktualisieren
        update_status(status, lamp, '>> Messdaten importiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end