%% Funktionen für UI-Komponenten im Modus "Modalanalyse"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function set_function_modal_mode(app)

    % Button für Suchen der Datei zu Messdaten
    app.search_data_button.ButtonPushedFcn = @(~, ~) search_data_button_pushed( ...
        app.path_edit_field, ...                        % Eingabefeld für Dateipfad
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Importieren der Messdaten
    app.import_button.ButtonPushedFcn = @(~, ~) import_button_pushed(app);

    % Button für Löschen
    app.delete_button.ButtonPushedFcn = @(~, ~) delete_button_pushed(app.fig, app);

    % Button für Importieren der Zuweisungen
    app.assign_import_button.ButtonPushedFcn = @(~, ~) assign_import_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.assign_table, ...                           % Tabelle für Zuweisungen
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Importieren der Knoten
    app.node_import_button.ButtonPushedFcn = @(~, ~) node_import_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.node_table, ...                             % Tabelle für Knoten
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Auswahl einer Zeile aus der Tabelle für Knoten
    app.node_table.SelectionChangedFcn = @(src, event) row_selected(src, event);

    % Button für Einfügen eines Knotens
    app.node_insert_button.ButtonPushedFcn = @(~, ~) node_insert_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.node_table, ...                             % Tabelle für Knoten
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Entfernen eines Knotens
    app.node_remove_button.ButtonPushedFcn = @(~, ~) node_remove_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.node_table, ...                             % Tabelle für Knoten
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Importieren der Linien
    app.line_import_button.ButtonPushedFcn = @(~, ~) line_import_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.node_table, ...                             % Tabelle für Knoten
        app.line_table, ...                             % Tabelle für Linien
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Auswahl einer Zeile aus der Tabelle für Linien
    app.line_table.SelectionChangedFcn = @(src, event) row_selected(src, event);
    
    % Button für Einfügen einer Linie
    app.line_insert_button.ButtonPushedFcn = @(~, ~) line_insert_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.node_table, ...                             % Tabelle für Knoten
        app.line_table, ...                             % Tabelle für Linien
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Entfernen einer Linie
    app.line_remove_button.ButtonPushedFcn = @(~, ~) line_remove_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.line_table, ...                             % Tabelle für Linien
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Importieren der Flächen
    app.surface_import_button.ButtonPushedFcn = @(~, ~) surface_import_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.line_table, ...                             % Tabelle für Linien
        app.surface_table, ...                          % Tabelle für Flächen
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Auswahl einer Zeile aus der Tabelle für Flächen
    app.surface_table.SelectionChangedFcn = @(src, event) row_selected(src, event);

    % Button für Einfügen einer Fläche
    app.surface_insert_button.ButtonPushedFcn = @(~, ~) surface_insert_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.line_table, ...                             % Tabelle für Linien
        app.surface_table, ...                          % Tabelle für Flächen
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Entfernen einer Fläche
    app.surface_remove_button.ButtonPushedFcn = @(~, ~) surface_remove_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.surface_table, ...                          % Tabelle für Flächen
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Aktualisieren der Geometrie
    app.update_geometry_button.ButtonPushedFcn = @(~, ~) update_geometry_button_pushed(app);

    % Button für Darstellen des Signalplots
    app.update_signal_button.ButtonPushedFcn = @(~, ~) update_signal_button_pushed( ...
        app.fig.UserData.cache.modal, ...               % Cache-System
        app.sensor_dropdown, ...                        % Dropdown für Sensoren
        app.time_series_radio.Value, ...                % Wahl für Zeitreihe
        app.spectrum_radio.Value, ...                   % Wahl für Frequenzspektrum
        app.signal_graph, ...                           % Graph für Signalplot
        app.signal_slider, ...                          % Slider für x-Achse
        app.signal_range_edit_field, ...                % Eingabefeld für fixierten Bereich der x-Achse
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Slider für x-Achse des Signalplots
    app.signal_slider.ValueChangedFcn = @(src, ~) slider_changed(src, app.signal_graph, ...
        app.signal_range_check.Value, app.signal_range_edit_field, app.status_lamp, app.status_text_area);

    % Checkbox für fixierten Bereich der x-Achse
    app.signal_range_check.ValueChangedFcn = @(src, ~) activate_component_check_changed(src, ...
        app.signal_range_edit_field, app.status_lamp, app.status_text_area, ...
        '>> Fixierter Bereich der x-Achse aktiviert', ...
        '>> Fixierter Bereich der x-Achse deaktiviert');

    % Eingabefeld für fixierten Bereich der x-Achse
    app.signal_range_edit_field.ValueChangedFcn = @(src, ~)range_edit_field_changed(src, ...
        app.signal_graph, app.signal_slider, app.status_lamp, app.status_text_area);

    % Komponente im Tab "Parameter"
    app.oma_fdd_check.ValueChangedFcn =  @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.oma_ssi_cov_check.ValueChangedFcn =  @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.oma_ssi_data_check.ValueChangedFcn =  @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.lowest_freq_edit_field.ValueChangingFcn = @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.psd_mode_radio_group.SelectionChangedFcn = @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.num_window_dropdown.ValueChangedFcn = @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.num_fft_dropdown.ValueChangedFcn = @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.auto_peak_switch.ValueChangedFcn = @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.num_mode_radio_group_fdd.SelectionChangedFcn = @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.efdd_auto_peak_switch.ValueChangedFcn = @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.auto_pol_switch.ValueChangedFcn =  @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.num_mode_radio_group_ssi_cov.SelectionChangedFcn = @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.auto_pol_switch2.ValueChangedFcn =  @(src, event) ui_component_tab_parameter_changed(app, src, event);
    app.num_mode_radio_group_ssi_data.SelectionChangedFcn = @(src, event) ui_component_tab_parameter_changed(app, src, event);

    % Subtabs für Parameter verschiedener OMA-Methoden
    app.sub_tab_group_parameter_tab.SelectionChangedFcn = @(src, event) tab_changed(src, event, app.status_lamp, app.status_text_area);
    
    % Button für Durchführen der Modalanalyse
    app.run_analysis_button.ButtonPushedFcn = @(~, ~) run_analysis_button_pushed_pre_check(app.fig, app);

    % Slider für x-Achse des Graphs der PSD
    app.psd_graph_slider.ValueChangedFcn = @(src, ~) slider_changed(src, app.psd_graph, ...
        app.psd_graph_range_check.Value, app.psd_graph_range_edit_field, app.status_lamp, app.status_text_area, app.psd_graph2);

    % Checkbox für fixierten Bereich der x-Achse
    app.psd_graph_range_check.ValueChangedFcn = @(src, ~) activate_component_check_changed(src, ...
        app.psd_graph_range_edit_field, app.status_lamp, app.status_text_area, ...
        '>> Fixierter Bereich der x-Achse aktiviert', ...
        '>> Fixierter Bereich der x-Achse deaktiviert');

    % Eingabefeld für fixierten Bereich der x-Achse
    app.psd_graph_range_edit_field.ValueChangedFcn = @(src, ~)range_edit_field_changed(src, ...
        app.psd_graph, app.psd_graph_slider, app.status_lamp, app.status_text_area, app.psd_graph2);

    % Button für Auswählen der Peaks
    app.choose_peak_button.ButtonPushedFcn = @(~, ~)choose_peak_button_pushed(app, app.fig);

    % Auswahl einer Zeile aus der Tabelle für Frequenzen der gewählten Pole
    app.freq_table2.SelectionChangedFcn = @(src, event) row_selected(src, event);

    % Button für Entfernen der Peak
    app.remove_peak_button.ButtonPushedFcn = @(~, ~)remove_peak_button_pushed(app);

    % Button für Durchführen der EFDD
    app.run_efdd_button.ButtonPushedFcn = @(~, ~)run_efdd_button_pushed(app.fig, app);

    % Slider für x-Achse des Graphs für SBF
    app.sbf_slider.ValueChangedFcn = @(src, ~) slider_changed(src, app.sbf_graph, ...
        app.sbf_range_check.Value, app.sbf_range_edit_field, app.status_lamp, app.status_text_area);

    % Checkbox für fixierten Bereich der x-Achse
    app.sbf_range_check.ValueChangedFcn = @(src, ~) activate_component_check_changed(src, ...
        app.sbf_range_edit_field, app.status_lamp, app.status_text_area, ...
        '>> Fixierter Bereich der x-Achse aktiviert', ...
        '>> Fixierter Bereich der x-Achse deaktiviert');

    % Eingabefeld für fixierten Bereich der x-Achse
    app.sbf_range_edit_field.ValueChangedFcn = @(src, ~)range_edit_field_changed(src, ...
        app.sbf_graph, app.sbf_slider, app.status_lamp, app.status_text_area);  

    % Auswahl einer Zeile aus der Tabelle für Frequenzen und MAC-Grenzen
    app.freq_mac_table.SelectionChangedFcn =  @(src, event) freq_mac_table_row_selected(src, event, app);

    % Button für Aktualisieren der SBF
    app.update_sbf_button.ButtonPushedFcn = @(~, ~)update_sbf_button_pushed(app);    

    % Button für Übernehmen der MAC
    app.adopt_mac_button.ButtonPushedFcn = @(~, ~)adopt_mac_button_pushed(app, app.fig);

    % Slider für x-Achse des Graphs für Korrelationsfunktion der 1. Singulärwerte
    app.backsignal_slider.ValueChangedFcn = @(src, ~) backsignal_slider_changed(app);

    % Checkbox für fixierten Bereich der x-Achse
    app.backsignal_range_check.ValueChangedFcn = @(src, ~) activate_component_check_changed(src, ...
        app.backsignal_range_edit_field, app.status_lamp, app.status_text_area, ...
        '>> Fixierter Bereich der x-Achse aktiviert', ...
        '>> Fixierter Bereich der x-Achse deaktiviert');

    % Eingabefeld für fixierten Bereich der x-Achse für Korrelationsfunktion der 1. Singulärwerte
    app.backsignal_range_edit_field.ValueChangedFcn = @(src, ~)backslider_range_edit_field_changed(app);  

    % Auswahl einer Zeile aus der Tabelle für Ergebnissse
    app.freq_damp_table_efdd.SelectionChangedFcn =  @(src, event)row_selected(src, event);

    % Button für Untersuchung der Mode
    app.examine_mode_button.ButtonPushedFcn = @(~, ~)examine_mode_button_pushed(app);

    % Button für Auswählen des Bereiches für Dämpfungsgrad
    app.choose_damping_area_button.ButtonPushedFcn = @(~, ~)choose_damping_area_button_pushed(app, app.fig);  

    % Button für automatisches Auswählen des Bereiches für Dämpfungsgrad
    app.choose_damping_area_auto_button.ButtonPushedFcn = @(~, ~)choose_damping_area_auto_button_pushed(app, app.fig);  

    % Button für Übernehmen des Dämpfungsgrads
    app.adopt_damping_button.ButtonPushedFcn = @(~, ~)adopt_damping_button_pushed(app); 

    % Button für Entfernen der Mode
    app.remove_mode_button.ButtonPushedFcn = @(~, ~)remove_mode_button_pushed(app);

    % Dropdown für Darstellen des Stabilisationsdiagramms anderer SSI
    app.ssi_dropdown.ValueChangedFcn = @(~, ~) ssi_measurement_changed(app);        

    % Dropdown für Darstellen des Stabilisationsdiagramms anderer Messdaten
    app.measurement_dropdown.ValueChangedFcn = @(~, ~) ssi_measurement_changed(app);    

    % Filter für Stabilisationsdiagramm
    app.all_poles_check.ValueChangedFcn = @(~, ~) filter_changed(app);          % Alle berechnete Pole
    app.stable_freq_check.ValueChangedFcn = @(~, ~) filter_changed(app);        % Stabile Frequenz
    app.stable_damp_check.ValueChangedFcn = @(~, ~) filter_changed(app);        % Stabiler Dämpfungsgrad
    app.mac_check.ValueChangedFcn = @(~, ~) filter_changed(app);                % "MAC-Bedingung erfüllt"
    app.filter_radio_group.SelectionChangedFcn = @(~, ~) filter_changed(app);   % "oder" "und"
    app.pole_chosen_switch.ValueChangedFcn = @(~, ~) filter_changed(app);       % Gewählte Pole

    % Slider für x-Achse des Stabilisationsdiagramms
    app.stab_graph_slider.ValueChangedFcn = @(src, ~) slider_changed(src, app.stab_graph, ...
        app.stab_graph_range_check.Value, app.stab_graph_range_edit_field, app.status_lamp, app.status_text_area);

    % Checkbox für fixierten Bereich der x-Achse
    app.stab_graph_range_check.ValueChangedFcn = @(src, ~) activate_component_check_changed(src, ...
        app.stab_graph_range_edit_field, app.status_lamp, app.status_text_area, ...
        '>> Fixierter Bereich der x-Achse aktiviert', ...
        '>> Fixierter Bereich der x-Achse deaktiviert');

    % Eingabefeld für fixierten Bereich der x-Achse
    app.stab_graph_range_edit_field.ValueChangedFcn = @(src, ~)range_edit_field_changed(src, ...
        app.stab_graph, app.stab_graph_slider, app.status_lamp, app.status_text_area);

    % Button für Auswählen der Pole
    app.choose_pole_button.ButtonPushedFcn = @(~, ~) choose_pole_button_pushed_main(app, app.fig);

    % Button für Übertragung der Auswahlen
    app.transfer_choice_button.ButtonPushedFcn = @(~, ~) transfer_choice_button_pushed_main(app, app.fig);

    % Auswahl einer Zeile aus der Tabelle für Frequenzen der gewählten Pole
    app.freq_table.SelectionChangedFcn = @(src, event) row_selected(src, event);

    % Button für Anzeigen der zugehörigen Pole
    app.show_corresp_pole_button.ButtonPushedFcn = @(~, ~) show_corresp_pole_button_pushed(app);

    % Button für Entfernen der Pole
    app.remove_pole_button.ButtonPushedFcn = @(~, ~) remove_pole_button_pushed_main(app);

    % Dropdown für Darstellen der Ergebnisse anderer OMA-Methoden
    app.oma_dropdown.ValueChangedFcn = @(~, ~) oma_result_changed(app);    

    % Auswahl einer Zeile aus der Tabelle für Ergebnisse
    app.freq_damp_table.SelectionChangedFcn = @(src, event) row_selected(src, event);

    % Button für Darstellen der Eigenform
    app.update_eigenform_button.ButtonPushedFcn = @(src, ~) update_eigenform_button_pushed(app, src, app.fig);

    % Button für Stoppen der Animation
    app.stop_button.ButtonPushedFcn = @(~, ~) stop_button_pushed( ...
        app.update_eigenform_button, ...                        % Button für Darstellen der Eigenform
        app.stop_button, ...                                    % Button für Stoppen
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Button für Suchen des Ordners
    app.search_file_geometry_button.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.geometry_path_edit_field, ...                       % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Button für Exportieren der Geometrie
    app.export_geometry_button.ButtonPushedFcn = @(~, ~) export_geometry_button_pushed(app);

    % Button für Suchen des Ordners
    app.search_file_signal_button.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.signal_path_edit_field, ...                         % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status    

    % Button für Exportieren des Signalplots
    app.export_signal_button.ButtonPushedFcn =  @(~, ~) export_signal_button_pushed( ...
        app.fig.UserData.cache.modal, ...                       % Cache-System
        app.sensor_dropdown.UserData.name_sensor_export, ...    % Namen der Sensoren
        app.sensor_table.Data, ...                              % Tabelle der Sensoren
        app.signal_path_edit_field.Value, ...                   % Pfad zum Zielordner
        app.time_series_check.Value, ...                        % Wahl für Zeitreihe
        app.spectrum_check.Value, ...                           % Wahl für Frequenzspektrum
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status        

    % Checkbox für FDD beim Export der modalen Parameter
    app.oma_fdd_check2.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                              % Ereignis
        app.freq_damp_table2, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Checkbox für EFDD beim Export der modalen Parameter
    app.oma_efdd_check2.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                              % Ereignis
        app.freq_damp_table2, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Checkbox für SSI-COV beim Export der modalen Parameter
    app.oma_ssi_cov_check2.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                              % Ereignis
        app.freq_damp_table2, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Checkbox für SSI-DATA beim Export der modalen Parameter
    app.oma_ssi_data_check2.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                              % Ereignis
        app.freq_damp_table2, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Button für Suchen des Ordners
    app.search_file_mod_parameter_button.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.mod_parameter_path_edit_field, ...                  % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status        

    % Button für Exportieren der modalen Parameter
    app.export_mod_parameter_button.ButtonPushedFcn = @(~, ~) export_mod_parameter_button_pushed(app);

    % Checkbox für FDD beim Export der Eigenformen
    app.oma_fdd_check3.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                              % Ereignis
        app.freq_damp_table3, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Checkbox für EFDD beim Export der Eigenformen
    app.oma_efdd_check3.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                              % Ereignis
        app.freq_damp_table3, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Checkbox für SSI-COV beim Export der Eigenformen
    app.oma_ssi_cov_check3.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                              % Ereignis
        app.freq_damp_table3, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Checkbox für SSI-DATA beim Export der Eigenformen
    app.oma_ssi_data_check3.ValueChangedFcn =  @(~, event) oma_export_changed( ...
        event, ...                                              % Ereignis
        app.freq_damp_table3, ...                               % Tabelle für Ergebnisse
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status

    % Button für Suchen des Ordners
    app.search_file_mod_parameter_button.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.mod_parameter_path_edit_field, ...                  % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status     

    % Button für Suchen des Ordners
    app.search_file_eigenform_button.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.eigenform_path_edit_field, ...                      % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                                    % Licht des Status
        app.status_text_area);                                  % Textfeld des Status       

    % Button für Exportieren der Eigenformen
    app.export_eigenform_button.ButtonPushedFcn = @(~, ~) export_eigenform_button_pushed(app);
end