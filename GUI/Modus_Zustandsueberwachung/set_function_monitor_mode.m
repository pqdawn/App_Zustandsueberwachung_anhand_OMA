%% Funktionen für UI-Komponenten im Modus "Zustandsüberwachung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function set_function_monitor_mode(app)

    % Button für Suchen der Datei zu Messdaten
    app.search_data_button_monitor.ButtonPushedFcn = @(~, ~) search_data_button_pushed( ...
        app.path_edit_field_monitor, ...                                % Eingabefeld für Dateipfad
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Button für Importieren der Messdaten
    app.import_button_monitor.ButtonPushedFcn = @(~, ~) import_button_pushed_monitor(app);

    % Button für Darstellen des Signalplots
    app.update_signal_button_monitor.ButtonPushedFcn = @(~, ~) update_signal_button_pushed( ...
        app.fig.UserData.cache.monitor, ...                             % Cache-System
        app.sensor_dropdown_monitor, ...                                % Dropdown für Sensoren
        app.time_series_radio_monitor.Value, ...                        % Wahl für Zeitreihe
        app.spectrum_radio_monitor.Value, ...                           % Wahl für Frequenzspektrum
        app.signal_graph_monitor, ...                                   % Graph für Signalplot
        app.signal_slider_monitor, ...                                  % Slider für x-Achse
        app.signal_range_edit_field_monitor, ...                        % Eingabefeld für fixierten Bereich der x-Achse
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Slider für x-Achse des Signalplots
    app.signal_slider_monitor.ValueChangedFcn = @(src, ~) slider_changed( ...
        src, ...                                                        % Slider
        app.signal_graph_monitor, ...                                   % Graph
        app.signal_range_check_monitor.Value, ...                       % Wahl für fixierten Bereich
        app.signal_range_edit_field_monitor, ...                        % Eingabefeld für fixierten Bereich der x-Achse
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Checkbox für fixierten Bereich der x-Achse
    app.signal_range_check_monitor.ValueChangedFcn = @(src, ~) range_check_changed( ...
        src, ...                                                        % Checkbox für fixierten Bereich
        app.signal_range_edit_field_monitor, ...                        % Eingabefeld für fixierten Bereich der x-Achse
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Eingabefeld für fixierten Bereich der x-Achse
    app.signal_range_edit_field_monitor.ValueChangedFcn = @(src, ~)range_edit_field_changed( ...
        src, ...                                                        % Eingabefeld für fixierten Bereich der x-Achse
        app.signal_graph_monitor, ...                                   % Graph
        app.signal_slider_monitor, ...                                  % Slider
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Button für Suchen der Datei zu Eigenfrequenzen
    app.search_data_eigenfreq_button_monitor.ButtonPushedFcn = @(~, ~) search_data_button_pushed( ...
        app.eigenfreq_path_edit_field_monitor, ...                      % Eingabefeld für Dateipfad
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Button für Suchen des Ordners zu Eigenvektoren
    app.search_file_eigenvector_button_monitor.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.eigenvector_path_edit_field_monitor, ...                    % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status     

    % Button für Importieren der Referenzmoden
    app.import_reference_button.ButtonPushedFcn = @(~, ~) import_reference_button_pushed(app);   

    % Auswahl einer Zeile aus der Tabelle für Eigenfrequenzen
    app.eigenfreq_table_monitor.SelectionChangedFcn = @(src, event) row_selected(src, event);     

    % Button für Anzeigen des Eigenvektors
    app.show_vector_button_monitor.ButtonPushedFcn = @(~, ~) show_vector_button_pushed_monitor(app);     

    % Komponente im Tab "Parameter"
    app.oma_fdd_check_monitor.ValueChangedFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.oma_ssi_cov_check_monitor.ValueChangedFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.oma_ssi_data_check_monitor.ValueChangedFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.lowest_freq_edit_field_monitor.ValueChangingFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.seg_type_radio_group.SelectionChangedFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.num_segment_edit_field.ValueChangingFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.time_interval_edit_field.ValueChangingFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.psd_mode_radio_group_monitor.SelectionChangedFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.num_window_dropdown_monitor.ValueChangedFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.num_fft_dropdown_monitor.ValueChangedFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);
    app.efdd_auto_peak_switch_monitor.ValueChangedFcn = ...
        @(src, event) ui_component_tab_parameter_changed_monitor(app, src, event);

    % Subtabs für Parameter verschiedener OMA-Methoden
    app.sub_tab_group_parameter_tab_monitor.SelectionChangedFcn = @(src, event) tab_changed( ...
        src, ...                                                        % Subtabs
        event, ...                                                      % Ereignis
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Button für Durchführen der Zustandsüberwachung
    app.run_monitor_button.ButtonPushedFcn = @(~, ~) run_monitor_button_pushed_pre_check(app.fig, app);

    % Dropdown für Darstellen der Ergebnisse anderer OMA-Methoden
    app.oma_dropdown2.ValueChangedFcn = @(~, ~) oma_result_changed_monitor(app);        

    % Auswahl einer Zeile aus der Tabelle für Abschnitte
    app.step_table.SelectionChangedFcn = @(src, event) row_selected(src, event);

    % Button für Untersuchung des Abschnitts
    app.examine_segment_button.ButtonPushedFcn = @(~, ~) examine_segment_button_pushed(app);

    % Button für Suchen des Ordners
    app.search_file_signal_button_monitor.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.signal_path_edit_field_monitor, ...                         % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status       

    % Button für Exportieren des Signalplots
    app.export_signal_button_monitor.ButtonPushedFcn =  @(~, ~) export_signal_button_pushed( ...
        app.fig.UserData.cache.monitor, ...                             % Cache-System
        app.sensor_dropdown_monitor.UserData.name_sensor_export, ...    % Namen der Sensoren
        app.sensor_table_monitor.Data, ...                              % Tabelle der Sensoren
        app.signal_path_edit_field_monitor.Value, ...                   % Pfad zum Zielordner
        app.time_series_check_monitor.Value, ...                        % Wahl für Zeitreihe
        app.spectrum_check_monitor.Value, ...                           % Wahl für Frequenzspektrum
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status  

    % Checkbox für FDD beim Export der modalen Parameter
    app.oma_fdd_check2_monitor.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                                      % Ereignis
        app.freq_damp_table2_monitor, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Checkbox für EFDD beim Export der modalen Parameter
    app.oma_efdd_check2_monitor.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                                      % Ereignis
        app.freq_damp_table2_monitor, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Checkbox für SSI-COV beim Export der modalen Parameter
    app.oma_ssi_cov_check2_monitor.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                                      % Ereignis
        app.freq_damp_table2_monitor, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Checkbox für SSI-DATA beim Export der modalen Parameter
    app.oma_ssi_data_check2_monitor.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                                      % Ereignis
        app.freq_damp_table2_monitor, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status

    % Button für Suchen des Ordners
    app.search_file_mod_parameter_button_monitor.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.mod_parameter_path_edit_field_monitor, ...                  % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status        

    % Button für Exportieren der modalen Parameter
    app.export_mod_parameter_button_monitor.ButtonPushedFcn = @(~, ~) export_mod_parameter_button_pushed_monitor(app);

    % Button für Suchen des Ordners
    app.search_file_freq_time_button.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.freq_time_path_edit_field, ...                              % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                                            % Licht des Status
        app.status_text_area);                                          % Textfeld des Status  

    % Button für Exportieren der Eigenform
    app.export_freq_time_button.ButtonPushedFcn = @(~, ~) export_freq_time_button_pushed(app);
end