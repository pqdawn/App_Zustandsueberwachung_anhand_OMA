%% Funktion zum Zurücksetzen eines Teils der App
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    app = Alte App
%                       level = Welche Ergebnisse gelöscht werden sollten

% Ausgabeparameter:     app = Neue App

function app = reset_partial_app(app, level)

    % Abhängig davon, welche Ergebnisse gelöscht werden sollten
    switch level

        % Falls Modus "Modalanalyse" zurückgesetzt werden sollte
        case 'modal'

            % Betroffene Tabs zurücksetzen
            app = create_geometry_tab(app);
            app = create_signal_tab(app);
            app = create_parameter_tab(app);            
            app = create_fdd_tab(app);
            app = create_ssi_tab(app);
            app = create_result_tab(app);
            app = create_export_tab(app);            

            % Cache-System zurücksetzen
            app = initiate_cache_system_modal_mode(app);

        % Falls Ergebnisse der Modalanalyse gelöscht werden sollten
        case 'modal_result'

            % Inhalt der Tabelle für Sensoren holen
            sensor_table_data = app.sensor_table.Data;
            sensor_table_data.sensor_tick(:) = true;
            sensor_table_col_title = app.sensor_table.ColumnName;
            
            % Betroffene Tabs zurücksetzen
            app = create_fdd_tab(app);
            app = create_ssi_tab(app);
            app = create_result_tab(app);
            app = create_export_tab(app);

            % Tabelle der Sensoren zurücksetzen
            app.sensor_table.Data = sensor_table_data;
            app.sensor_table.ColumnName = sensor_table_col_title;
            app.sensor_table.RowName = 'numbered';
            app.sensor_table.ColumnEditable = logical([0, 1]);

            % Infos der Messdaten holen
            measurement_type = app.fig.UserData.cache.modal.measurement_type;
            direction = app.fig.UserData.cache.modal.direction;

            % Zu bearbeitende UI-Komponenten holen
            measurement_dropdown = app.measurement_dropdown;        % Dropdown für Messdaten
            x_tick2 = app.x_direct_check2;	                        % Checkbox für x-Richtung (Tab "Ergebnis")
            y_tick2 = app.y_direct_check2;                          % Checkbox für y-Richtung (Tab "Ergebnis")
            z_tick2 = app.z_direct_check2;                          % Checkbox für z-Richtung (Tab "Ergebnis")
            x_tick3 = app.x_direct_check3;                          % Checkbox für x-Richtung (Sub-Tab "Eigenform", Tab "Export")
            y_tick3 = app.y_direct_check3;                          % Checkbox für y-Richtung (Sub-Tab "Eigenform", Tab "Export")
            z_tick3 = app.z_direct_check3;                          % Checkbox für z-Richtung (Sub-Tab "Eigenform", Tab "Export")

            % Falls Verschiebungsdaten angewendet
            if strcmp(measurement_type, 'displacement')
    
                % Dropdown für Messdaten aktualisieren
                measurement_dropdown.Items = {'Verschiebung (original)', 'Beschleunigung (abgeleitet)'};
                measurement_dropdown.ItemsData = 1:2;
    
            % Falls Geschwindigkeitsdaten angewendet
            elseif strcmp(measurement_type, 'velocity')
    
                % Dropdown für Messdaten aktualisieren
                measurement_dropdown.Items = {'Geschwindigkeit (original)', 'Beschleunigung (abgeleitet)'};
                measurement_dropdown.ItemsData = 1:2;
            end            

            % Mögliche Richtungen für Darstellung bzw. Exportieren der 
            % Eigenformen aktualisieren
            if direction(1) ~= 1
                x_tick2.Value = 0;
                x_tick2.Enable = 'off';
                x_tick3.Value = 0;
                x_tick3.Enable = 'off';
            end
            if direction(2) ~= 1
                y_tick2.Value = 0;
                y_tick2.Enable = 'off';
                y_tick3.Value = 0;
                y_tick3.Enable = 'off';
            end
            if direction(3) ~= 1
                z_tick2.Value = 0;
                z_tick2.Enable = 'off';
                z_tick3.Value = 0;
                z_tick3.Enable = 'off';
            end            

        % Falls EFDD-Ergebnisse gelöscht werden sollten
        case 'efdd'

            % Betroffene Tabs zurücksetzen
            app = create_sbf_sub_tab(app);
            app = create_damping_sub_tab(app);
              
        % Falls Dämpfungsgrad gelöscht werden sollte
        case 'efdd_daempfung'

            % Betroffenene Tabs zurücksetzen
            app = create_damping_sub_tab(app);

        % Falls Modus "Zusammenführung" zurückgesetzt werden sollte
        case 'merge'

            % Betroffenene Tabs zurücksetzen
            app = create_eigenvector_tab(app);
            app = create_geometry_tab_merge_mode(app);
            app = create_result_tab_merge_mode(app);
            app = create_export_tab_merge_mode(app);

            % Cache-System zurücksetzen
            app = initiate_cache_system_merge_mode(app);

        % Falls alle Eigenvektoren und relevante Ergebnisse gelöscht werden sollte
        case 'eigenvector'    

            % Betroffenene Tabs zurücksetzen
            app = create_geometry_tab_merge_mode(app);
            app = create_result_tab_merge_mode(app);
            app = create_export_tab_merge_mode(app);

            % Ergebnisse in restlichen GUI-Komponenten aktualisieren
            result_eigenfreq = app.fig.UserData.cache.merge.result_eigenfreq;
            update_result_merge(app.eigenform_graph_merge, result_eigenfreq, ...
                app.freq_table_merge, app.freq_table2_merge, app.freq_table3_merge);                        

        % Falls Modus "Zustandsüberwachung" zurückgesetzt werden sollte
        case 'monitor'

            % Betroffene Tabs zurücksetzen
            app = create_signal_tab_monitor_mode(app);
            app = create_reference_tab(app);
            app = create_parameter_tab_monitor_mode(app);
            app = create_result_tab_monitor_mode(app);
            app = create_export_tab_monitor_mode(app);

            % Cache-System zurücksetzen
            app = initiate_cache_system_monitor_mode(app);

        % Falls alle Referenzmoden und Ergebnisse gelöscht werden sollten
        case 'reference'

            % Inhalt der Tabelle für Sensoren holen
            sensor_table_data = app.sensor_table_monitor.Data;
            sensor_table_data.sensor_tick(:) = true;
            sensor_table_col_title = app.sensor_table.ColumnName;             

            % Betroffene Tabs zurücksetzen
            app = create_result_tab_monitor_mode(app);
            app = create_export_tab_monitor_mode(app);

            % Tabelle der Sensoren zurücksetzen
            app.sensor_table_monitor.Data = sensor_table_data;
            app.sensor_table_monitor.ColumnName = sensor_table_col_title;
            app.sensor_table_monitor.RowName = 'numbered';
            app.sensor_table_monitor.ColumnEditable = logical([0, 1]);               

        % Falls Ergebnisse der Zustandsüberwachung gelöscht werden sollten
        case 'monitor_result'

            % Inhalt der Tabelle für Sensoren holen
            sensor_table_data = app.sensor_table_monitor.Data;
            sensor_table_data.sensor_tick(:) = true;
            sensor_table_col_title = app.sensor_table.ColumnName;            

            % Betroffene Tabs zurücksetzen
            app = create_result_tab_monitor_mode(app);
            app = create_export_tab_monitor_mode(app);

            % Tabelle der Sensoren zurücksetzen
            app.sensor_table_monitor.Data = sensor_table_data;
            app.sensor_table_monitor.ColumnName = sensor_table_col_title;
            app.sensor_table_monitor.RowName = 'numbered';
            app.sensor_table_monitor.ColumnEditable = logical([0, 1]);            
    end

    % Funktionen erneut definieren
    set_function_modal_mode(app);  
    set_function_merge_mode(app);
    set_function_monitor_mode(app);
end