%% Callback für Komponente im Tab "Parameter" (Modus "Zustandsüberwachung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function ui_component_tab_parameter_changed_monitor(app, src, event)

    % Nötige Variablen holen
    oma_fdd_check = app.oma_fdd_check_monitor;                              % Checkbox für FDD
    oma_ssi_cov_check = app.oma_ssi_cov_check_monitor;                      % Checkbox für SSI-COV
    oma_ssi_data_check = app.oma_ssi_data_check_monitor;                    % Checkbox für SSI-DATA
    lowest_freq_edit_field = app.lowest_freq_edit_field_monitor;            % Eingabefeld für niedrigste zu untersuchende Frequenz
    sub_tab_group = app.sub_tab_group_parameter_tab_monitor;                % Gruppe der Subtabs
    fdd_sub_tab = app.fdd_sub_tab_monitor;                                  % Subtab für FDD / EFDD
    ssi_cov_sub_tab = app.ssi_cov_sub_tab_monitor;                          % Subtab für SSI-COV
    ssi_data_sub_tab = app.ssi_data_sub_tab_monitor;                        % Subtab für SSI-DATA
    seg_type_radio_group = app.seg_type_radio_group;                        % Radiobutton-Gruppe für Art der Segmentierung
    seg_num_choice = app.seg_type_num.Value;                                % Wahl für anzahlbasierte Segmentierung
    seg_time_coice = app.seg_type_time.Value;                               % Wahl für zeitbasierte Segmentierung
    num_segment_edit_field = app.num_segment_edit_field;                    % Eingabefeld für Anzahl der Abschnitte
    time_interval_edit_field = app.time_interval_edit_field;                % Eingabefeld für Zeitschrittsgröße
    num_ignore_row_edit_field = app.num_ignore_row_edit_field;              % Eingabefeld für Anzahl der ignorierten Zeilen
    psd_mode_radio_group = app.psd_mode_radio_group_monitor;                % Radiobutton-Gruppe für Modus der FDD
    psd_mode_direct = app.psd_mode_direct_monitor;                          % Radiobutton für direkt
    psd_mode_welch = app.psd_mode_welch_monitor;                            % Radiobutton für Welch
    psd_mode_user_defined = app.psd_mode_user_defined_monitor;              % Radiobutton für benutzerdefiniert
    window_func_dropdown = app.window_func_dropdown_monitor;                % Dropdown für Fensterfunktion
    window_size_dropdown = app.window_size_dropdown_monitor;                % Dropdown für Größe eines Fensters
    overlap_dropdown = app.overlap_dropdown_monitor;                        % Dropdown für Prozentsatz der Überlappung
    num_fft_dropdown = app.num_fft_dropdown_monitor;                        % Dropdown für Anzahl der DFT-Punkte
    efdd_auto_peak_switch = app.efdd_auto_peak_switch_monitor;              % Switch für EFDD nach automatischer Peakauswahl
    correlation_type_ifft = app.correlation_type_ifft2_monitor;             % Radiobutton für IFFT
    correlation_type_cos = app.correlation_type_cos2_monitor;               % Radiobutton für Kosinustransformation
    mac_spinner = app.mac_spinner4_monitor;                                 % Spinner für MAC-Grenze für EFDD
    max_lag_edit_field = app.max_lag_edit_field_monitor;                    % Eingabefeld für maximalen verzögerten Zeitschritt
    max_model_order_edit_field = app.max_model_order_edit_field_monitor;    % Eingabefeld für maximale Model-Order (Sub-Tab "SSI-COV", Tab "Parameter")
    num_row_hankel_edit_field = app.num_row_hankel_edit_field_monitor;      % Eingabefeld für Zeilenanzahl der Hankelmatrix
    num_col_hankel_edit_field = app.num_col_hankel_edit_field_monitor;      % Eingabefeld für Spaltenanzahl der Hankelmatrix
    max_model_order_edit_field2 = app.max_model_order_edit_field2_monitor;  % Eingabefeld für maximale Model-Order (Sub-Tab "SSI-DATA", Tab "Parameter")
    lamp = app.status_lamp;                                                 % Licht des Status
    status = app.status_text_area;                                          % Textfeld des Status

    try
        % Falls gar keine OMA-Methode gewählt wurde
        if ~oma_fdd_check.Value && ...
            ~oma_ssi_cov_check.Value && ~oma_ssi_data_check.Value

            % Zwangsläufig den vorherigen Wert zurücksetzen
            src.Value = event.PreviousValue;

            % Fehlermeldung
            error('Es muss mindestens eine OMA-Methode gewählt werden!')
        end

        % Falls Switch für EFDD nach automatischer Peakauswahl betroffen ist
        if src == efdd_auto_peak_switch

            % Wenn das Switch angeschaltet wurde
            if strcmp(event.Value, 'An')

                % Spinner für MAC-Grenze aktivieren
                mac_spinner.Enable = 'on';

                % Wenn benutzerdefinierte FDD gewählt wurde
                if psd_mode_user_defined.Value

                    % Einstellung für Korrelationsfunktion aktivieren
                    correlation_type_ifft.Enable = 'on';
                    correlation_type_cos.Enable = 'on';
                end                

            % Wenn das Switch ausgeschaltet wurde
            elseif strcmp(event.Value, 'Aus')

                % Spinner für MAC-Grenze deaktivieren
                mac_spinner.Enable = 'off';        

                % Einstellung für Korrelationsfunktion deaktivieren
                correlation_type_ifft.Enable = 'off';
                correlation_type_cos.Enable = 'off';                  
            end  

        % Falls Radiobutton für Modus der FDD betroffen ist
        elseif src == psd_mode_radio_group            

            % Falls Standard oder Welch gewählt wurde
            if psd_mode_direct.Value || psd_mode_welch.Value

                % Relevante Komponente deaktivieren
                window_func_dropdown.Enable = 'off';
                window_size_dropdown.Enable = 'off';
                overlap_dropdown.Enable = 'off';
                num_fft_dropdown.Enable = 'off';     

                % Falls EFDD nach automatischer Peakauswahl angeschaltet ist
                if strcmp(efdd_auto_peak_switch.Value, 'An')

                    % Einstellung für Korrelationsfunktion deaktivieren
                    correlation_type_ifft.Enable = 'off';
                    correlation_type_cos.Enable = 'off';
                end                   

            % Falls benutzerdefiniert gewählt wurde
            elseif psd_mode_user_defined.Value

                % Relevante Komponente aktivieren
                window_func_dropdown.Enable = 'on';
                window_size_dropdown.Enable = 'on';
                overlap_dropdown.Enable = 'on';
                num_fft_dropdown.Enable = 'on'; 

                % Falls EFDD nach automatischer Peakauswahl angeschaltet ist
                if strcmp(efdd_auto_peak_switch.Value, 'An')

                    % Einstellung für Korrelationsfunktion aktivieren
                    correlation_type_ifft.Enable = 'on';
                    correlation_type_cos.Enable = 'on';
                end                
            end            

        % Falls Radionbutton für Art der Segmentierung betroffen sind
        elseif src == seg_type_radio_group

            % Falls zeitbasiert gewählt wurde
            if seg_time_coice

                % Eingabefeld für zeitbasiert aktivieren
                time_interval_edit_field.Editable = 'on';
                time_interval_edit_field.BackgroundColor = [1, 1, 1];                    

                % Eingabefeld für anzahlbasiert deaktivieren
                num_segment_edit_field.Editable = 'off';
                num_segment_edit_field.BackgroundColor = [0.8, 0.8, 0.8];

            % Falls anzahlbasiert gewählt wurde                    
            elseif seg_num_choice

                % Eingabefeld für zeitbasiert deaktivieren
                time_interval_edit_field.Editable = 'off';
                time_interval_edit_field.BackgroundColor = [0.8, 0.8, 0.8];                     

                % Eingabefeld für anzahlbasiert aktivieren
                num_segment_edit_field.Editable = 'on';
                num_segment_edit_field.BackgroundColor = [1, 1, 1];    
            end

        % Falls Eingabefelder für Art der Segmentierung betroffen sind
        elseif src == time_interval_edit_field || src == num_segment_edit_field

            % Messdaten und Infos holen
            data_matrix = app.fig.UserData.cache.monitor.data_matrix;
            sampling_freq = app.fig.UserData.cache.monitor.sampling_freq;
            
            % Wenn keine Messdaten importiert wurden, Callback beenden
            if isnan(sampling_freq)
                return;
            end

            % Anzahl der Zeilen der Messdaten holen
            num_row_total = size(data_matrix, 1);

            % Falls zeitbasiert gewählt wurde
            if seg_time_coice

                % Falls Eingabefeld für Zeitintervall leer ist, Eingaben in
                % anderen Feldern löschen
                if isempty(event.Value)

                    % Eingabefelder aktualisieren
                    num_segment_edit_field.Value = '';
                    num_ignore_row_edit_field.Value = '';

                    % Beenden
                    return;
                end 

                % Zeitintervall holen
                time_interval = str2double(event.Value);

                % Fehlermeldung falls eingegebenes Zeitintervall nicht
                % gültig ist
                if isnan(time_interval)

                    % Eingabefelder aktualisieren
                    num_segment_edit_field.Value = '';
                    num_ignore_row_edit_field.Value = '';

                    % Fehlermeldung
                    error('Zeitintervall nicht gültig!')
                end

                % Fehlermeldung falls eingegebenes Zeitintervall kleiner als 0
                if time_interval <= 0

                    % Eingabefelder aktualisieren
                    num_segment_edit_field.Value = '';
                    num_ignore_row_edit_field.Value = '';

                    % Fehlermeldung
                    error('Zeitintervall nicht gültig! Es muss größer als 0 sein!')
                end

                % Fehlermeldung falls eingegebenes Zeitintervall größer als
                % Messdauer
                if time_interval > data_matrix(end, 1)

                    % Eingabefelder aktualisieren
                    num_segment_edit_field.Value = '';
                    num_ignore_row_edit_field.Value = '';

                    % Fehlermeldung
                    error('Zeitintervall nicht gültig! Es darf nicht größer als Messdauer sein!')
                end                

                % Anzahl der Schritte pro Abschnitt
                num_step_pro_seg = time_interval * sampling_freq;

                % Anzahl der Abschnitte
                num_seg = floor(num_row_total/num_step_pro_seg);

                % Anzahl der ignorierten Zeilen
                num_ignore = num_row_total - num_seg * num_step_pro_seg;

                % Eingabefelder aktualisieren
                num_segment_edit_field.Value = string(num_seg);
                num_ignore_row_edit_field.Value = string(num_ignore);

            % Falls anzahlbasiert gewählt wurde                    
            elseif seg_num_choice

                % Falls Eingabefeld für Anzahl leer ist, Eingaben in
                % anderen Feldern löschen
                if isempty(event.Value)

                    % Eingabefelder aktualisieren
                    time_interval_edit_field.Value = '';
                    num_ignore_row_edit_field.Value = '';

                    % Beenden
                    return;
                end 

                % Anzahld der Abschnitte holen
                num_seg = str2double(event.Value);

                % Fehlermeldung falls eingegebene Anzahl nicht
                % gültig ist
                if isnan(num_seg)

                    % Eingabefelder aktualisieren
                    time_interval_edit_field.Value = '';
                    num_ignore_row_edit_field.Value = '';

                    % Fehlermeldung
                    error('Anzahl der Abschnitte nicht gültig!')
                end

                % Fehlermeldung falls eingegebene Anzahl kleiner als 1
                if num_seg <= 1

                    % Eingabefelder aktualisieren
                    time_interval_edit_field.Value = '';
                    num_ignore_row_edit_field.Value = '';

                    % Fehlermeldung
                    error('Anzahl der Abschnitte nicht gültig! Sie muss größer als 1 sein!')
                end  

                % Fehlermeldung falls eingegebene Anzahl größer als Anzahl
                % der Zeitschritte
                if num_seg > num_row_total

                    % Eingabefelder aktualisieren
                    time_interval_edit_field.Value = '';
                    num_ignore_row_edit_field.Value = '';

                    % Fehlermeldung
                    error('Anzahl der Abschnitte nicht gültig! Sie darf nicht größer als Anzahl der Zeitschritte sein!')
                end                

                % Anzahl der Schritte pro Abschnitt
                num_step_pro_seg = floor(num_row_total/num_seg);

                % Zeitintervall
                time_interval = num_step_pro_seg/sampling_freq;

                % Anzahl der ignorierten Zeilen
                num_ignore = num_row_total - num_seg * num_step_pro_seg;

                % Eingabefelder aktualisieren
                time_interval_edit_field.Value = string(time_interval);
                num_ignore_row_edit_field.Value = string(num_ignore);
            end          

        % Falls Eingabefeld für niedrigste zu untersuchende Frequenz
        % betroffen ist
        elseif src == lowest_freq_edit_field

            % Infos von Messdaten holen
            sampling_freq = app.fig.UserData.cache.monitor.sampling_freq;
            num_sensor = app.fig.UserData.cache.monitor.num_sensor;
            num_direct = sum(app.fig.UserData.cache.monitor.direction);

            % Wenn keine Messdaten importiert wurden, Callback beenden
            if isnan(sampling_freq)
                return;
            end

            % Falls Eingabefeld leer ist, Eingaben in anderen Feldern löschen
            if isempty(event.Value)

                % Eingabefelder aktualisieren
                max_lag_edit_field.Value = '';
                max_model_order_edit_field.Value = '';
                num_row_hankel_edit_field.Value = '';
                num_col_hankel_edit_field.Value = '';
                max_model_order_edit_field2.Value = '';

                % Beenden
                return;
            end 

            % Niedrigste zu untersuchende Frequenz holen
            lowest_freq = str2double(event.Value);

            % Fehlermeldung falls eingegebenes Zeitintervall nicht
            % gültig ist
            if lowest_freq >= sampling_freq/2

                % Eingabefelder aktualisieren
                max_lag_edit_field.Value = '';
                max_model_order_edit_field.Value = '';
                num_row_hankel_edit_field.Value = '';
                num_col_hankel_edit_field.Value = '';
                max_model_order_edit_field2.Value = '';

                % Fehlermeldung
                error('Niedrigste zu untersuchende Frequenz darf nicht größer als Hälfte der Abtastfrequenz!')
            end
    
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

        % Falls Checkboxen für FDD und EFDD betroffen sind
        elseif src == oma_fdd_check

            % Falls FDD gewählt wurde
            if oma_fdd_check.Value

                % Textfarbe des Tabs bearbeiten
                fdd_sub_tab.ForegroundColor = [0,0,0];

            % Falls FDD nicht gewählt wurde
            elseif ~oma_fdd_check.Value

                % Wenn dieses Tab gewählt wurde
                if sub_tab_group.SelectedTab == fdd_sub_tab

                    % Ein anderes Tab wählen
                    find_valid_tab(fdd_sub_tab, sub_tab_group);
                end

                % Textfarbe des Tabs bearbeiten
                fdd_sub_tab.ForegroundColor = [0.65,0.65,0.65];              
            end

        % Falls Checkbox für SSI-COV betroffen ist
        elseif src == oma_ssi_cov_check

            % Falls SSI-COV gewählt wurde
            if oma_ssi_cov_check.Value

                % Textfarbe des Tabs bearbeiten
                ssi_cov_sub_tab.ForegroundColor = [0,0,0];

            % Falls SSI-COV nicht gewählt wurde
            elseif ~oma_ssi_cov_check.Value

                % Wenn dieses Tab gewählt wurde
                if sub_tab_group.SelectedTab == ssi_cov_sub_tab

                    % Ein anderes Tab wählen
                    find_valid_tab(ssi_cov_sub_tab, sub_tab_group);
                end

                % Textfarbe des Tabs bearbeiten
                ssi_cov_sub_tab.ForegroundColor = [0.65,0.65,0.65];              
            end

        % Falls Checkbox für SSI-DATA betroffen ist
        elseif src == oma_ssi_data_check
          
            % Falls SSI-DATA gewählt wurde
            if oma_ssi_data_check.Value

                % Textfarbe des Tabs bearbeiten
                ssi_data_sub_tab.ForegroundColor = [0,0,0];

            % Falls SSI-DATA nicht gewählt wurde
            elseif ~oma_ssi_data_check.Value

                % Wenn dieses Tab gewählt wurde
                if sub_tab_group.SelectedTab == ssi_data_sub_tab

                    % Ein anderes Tab wählen
                    find_valid_tab(ssi_data_sub_tab, sub_tab_group);
                end

                % Textfarbe des Tabs bearbeiten
                ssi_data_sub_tab.ForegroundColor = [0.65,0.65,0.65];              
            end            
        end
        
    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end

%% Funktion zum Wählen eines anderen validen Tabs

% Übergabeparameter:    this_tab = Dieser Tab
%                       sub_tab_group = Gruppe der Subtabs

% Ausgabeparameter:     -

function find_valid_tab(this_tab, sub_tab_group)

    % Zahl instanziieren
    i = 1;

    % Schleife über andere Tabs, bis ein valider Tab gefunden ist
    while i <= numel(sub_tab_group.Children)

        % Wenn dieser Tab valid ist
        if sub_tab_group.Children(i) ~= this_tab && ...
            ~isequal(sub_tab_group.Children(i).ForegroundColor, [0.65, 0.65, 0.65])

            % Ein anderes Tab wählen
            sub_tab_group.SelectedTab = sub_tab_group.Children(i);
            break;
        end
        i = i + 1;
    end
end