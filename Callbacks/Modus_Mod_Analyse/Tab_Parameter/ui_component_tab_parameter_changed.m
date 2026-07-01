%% Callback für Komponente im Tab "Parameter" (Modus "Modalanalyse")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function ui_component_tab_parameter_changed(app, src, event)

    % Nötige Variablen holen
    oma_fdd_check = app.oma_fdd_check;                                      % Checkbox für FDD
    oma_ssi_cov_check = app.oma_ssi_cov_check;                              % Checkbox für SSI-COV
    oma_ssi_data_check = app.oma_ssi_data_check;                            % Checkbox für SSI-DATA
    lowest_freq_edit_field = app.lowest_freq_edit_field;                    % Eingabefeld für niedrigste zu untersuchende Frequenz
    sub_tab_group = app.sub_tab_group_parameter_tab;                        % Gruppe der Subtabs
    fdd_sub_tab = app.fdd_sub_tab;                                          % Subtab für FDD / EFDD
    ssi_cov_sub_tab = app.ssi_cov_sub_tab;                                  % Subtab für SSI-COV
    ssi_data_sub_tab = app.ssi_data_sub_tab;                                % Subtab für SSI-DATA
    psd_mode_radio_group = app.psd_mode_radio_group;                        % Radiobutton-Gruppe für Modus der FDD
    psd_mode_direct = app.psd_mode_direct;                                  % Radiobutton für direkt
    psd_mode_welch = app.psd_mode_welch;                                    % Radiobutton für Welch
    psd_mode_user_defined = app.psd_mode_user_defined;                      % Radiobutton für benutzerdefiniert
    window_func_dropdown = app.window_func_dropdown;                        % Dropdown für Fensterfunktion
    window_size_dropdown = app.window_size_dropdown;                        % Dropdown für Größe eines Fensters
    overlap_dropdown = app.overlap_dropdown;                                % Dropdown für Prozentsatz der Überlappung
    num_fft_dropdown = app.num_fft_dropdown;                                % Dropdown für Anzahl der DFT-Punkte
    auto_peak_switch = app.auto_peak_switch;                                % Switch für automatische Peakauswahl
    num_mode_radio_group_fdd = app.num_mode_radio_group_fdd;                % Radiobutton-Gruppe für Anzahl der Moden (Sub-Tab "FDD / EFDD", Tab "Parameter")
    num_mode_unknown_radio_fdd = app.num_mode_unknown_fdd;                  % Radiobutton für unbekannt (Sub-Tab "FDD / EFDD", Tab "Parameter")
    num_mode_known_radio_fdd = app.num_mode_known_fdd;                      % Radiobutton für bekannt (Sub-Tab "FDD / EFDD", Tab "Parameter")
    target_num_spinner_fdd = app.target_num_spinner_fdd;                    % Spinner für Zielanzahl (Sub-Tab "FDD / EFDD", Tab "Parameter")
    bandwidth_peak_spinner = app.bandwidth_peak_spinner;                    % Spinner für Bandbreite um den Peak
    mac_spinner_valid_peak = app.mac_spinner_valid_peak;                    % Spinner für MAC-Grenze für validen Peak
    efdd_auto_peak_switch = app.efdd_auto_peak_switch;                      % Switch für EFDD nach automatischer Peakauswahl
    correlation_type_ifft = app.correlation_type_ifft2;                     % Radiobutton für IFFT (Sub-Tab "FDD / EFDD", Tab "Parameter")
    correlation_type_cos = app.correlation_type_cos2;                       % Radiobutton für Kosinustransformation (Sub-Tab "FDD / EFDD", Tab "Parameter")
    mac_spinner = app.mac_spinner4;                                         % Spinner für MAC-Grenze (Sub-Tab "FDD / EFDD", Tab "Parameter")
    max_lag_edit_field = app.max_lag_edit_field;                            % Eingabefeld für maximalen verzögerten Zeitschritt
    max_model_order_edit_field = app.max_model_order_edit_field;            % Eingabefeld für maximale Model-Order (Sub-Tab "SSI-COV", Tab "Parameter")
    auto_pol_switch = app.auto_pol_switch;                                  % Switch für automatische Polauswahl (Sub-Tab "SSI-COV", Tab "Parameter")
    criteria_stable_freq_checkbox = app.criteria_stable_freq_check;         % Checkbox für stabile Frequenz (Sub-Tab "SSI-COV", Tab "Parameter")
    criteria_stable_damp_checkbox = app.criteria_stable_damp_check;         % Checkbox für stabilen Dämpfungsgrad (Sub-Tab "SSI-COV", Tab "Parameter")
    criteria_mac_checkbox = app.criteria_mac_check;                         % Checkbox für MAC-Bedingung erfüllt (Sub-Tab "SSI-COV", Tab "Parameter")
    num_mode_radio_group_ssi_cov = app.num_mode_radio_group_ssi_cov;        % Radiobutton-Gruppe für Anzahl der Moden (Sub-Tab "SSI-COV", Tab "Parameter")
    num_mode_unknown_radio_ssi_cov = app.num_mode_unknown_ssi_cov;          % Radiobutton für unbekannt (Sub-Tab "SSI-COV", Tab "Parameter")
    num_mode_known_radio_ssi_cov = app.num_mode_known_ssi_cov;              % Radiobutton für bekannt (Sub-Tab "SSI-COV", Tab "Parameter")
    cluster_distance_spinner = app.cluster_distance_spinner;                % Spinner für Cluster-Distanzschwelle (Sub-Tab "SSI-COV", Tab "Parameter")
    min_cluster_size_spinner = app.min_cluster_size_spinner;                % Spinner für Mindestgröße eines Clusters (Sub-Tab "SSI-COV", Tab "Parameter")
    target_num_spinner_ssi_cov = app.target_num_spinner_ssi_cov;            % Spinner für Zielanzahl (Sub-Tab "SSI-COV", Tab "Parameter")
    num_row_hankel_edit_field = app.num_row_hankel_edit_field;              % Eingabefeld für Zeilenanzahl der Hankelmatrix
    num_col_hankel_edit_field = app.num_col_hankel_edit_field;              % Eingabefeld für Spaltenanzahl der Hankelmatrix
    max_model_order_edit_field2 = app.max_model_order_edit_field2;          % Eingabefeld für maximale Model-Order (Sub-Tab "SSI-DATA", Tab "Parameter")
    auto_pol_switch2 = app.auto_pol_switch2;                                % Switch für automatische Polauswahl (Sub-Tab "SSI-DATA", Tab "Parameter")
    criteria_stable_freq_checkbox2 = app.criteria_stable_freq_check2;       % Checkbox für stabile Frequenz (Sub-Tab "SSI-DATA", Tab "Parameter")
    criteria_stable_damp_checkbox2 = app.criteria_stable_damp_check2;       % Checkbox für stabilen Dämpfungsgrad (Sub-Tab "SSI-DATA", Tab "Parameter")
    criteria_mac_checkbox2 = app.criteria_mac_check2;                       % Checkbox für MAC-Bedingung erfüllt (Sub-Tab "SSI-DATA", Tab "Parameter")
    num_mode_radio_group_ssi_data = app.num_mode_radio_group_ssi_data;      % Radiobutton-Gruppe für Anzahl der Moden (Sub-Tab "SSI-DATA", Tab "Parameter")
    num_mode_unknown_radio_ssi_data = app.num_mode_unknown_ssi_data;        % Radiobutton für unbekannt (Sub-Tab "SSI-DATA", Tab "Parameter")
    num_mode_known_radio_ssi_data = app.num_mode_known_ssi_data;            % Radiobutton für bekannt (Sub-Tab "SSI-DATA", Tab "Parameter")
    cluster_distance_spinner2 = app.cluster_distance_spinner2;              % Spinner für Cluster-Distanzschwelle (Sub-Tab "SSI-DATA", Tab "Parameter")
    min_cluster_size_spinner2 = app.min_cluster_size_spinner2;              % Spinner für Mindestgröße eines Clusters (Sub-Tab "SSI-DATA", Tab "Parameter")
    target_num_spinner_ssi_data = app.target_num_spinner_ssi_data;          % Spinner für Zielanzahl (Sub-Tab "SSI-DATA", Tab "Parameter")
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

        % Falls Switch für automatische Polauswahl betroffen ist (SSI-COV)
        if src == auto_pol_switch

            % Wenn das Switch angeschaltet wurde
            if strcmp(event.Value, 'An')

                % Relevante Komponente aktivieren
                criteria_stable_freq_checkbox.Enable = 'on';
                criteria_stable_damp_checkbox.Enable = 'on';
                criteria_mac_checkbox.Enable = 'on';
                num_mode_unknown_radio_ssi_cov.Enable = 'on';
                num_mode_known_radio_ssi_cov.Enable = 'on';

                % Falls die Anzahl unbekannt ist
                if num_mode_unknown_radio_ssi_cov.Value
    
                    % Relevante Komponente de- bzw. aktivieren
                    cluster_distance_spinner.Enable = 'on';
                    min_cluster_size_spinner.Enable = 'on';  
                    target_num_spinner_ssi_cov.Enable = 'off';
    
                % Falls die Anzahl bekannt ist
                elseif num_mode_known_radio_ssi_cov.Value
    
                    % Relevante Komponente de- bzw. aktivieren
                    cluster_distance_spinner.Enable = 'on';
                    min_cluster_size_spinner.Enable = 'off'; 
                    target_num_spinner_ssi_cov.Enable = 'on'; 
                end

            % Wenn das Switch ausgeschaltet wurde
            elseif strcmp(event.Value, 'Aus')

                % Relevante Komponente deaktivieren
                criteria_stable_freq_checkbox.Enable = 'off';
                criteria_stable_damp_checkbox.Enable = 'off';
                criteria_mac_checkbox.Enable = 'off';
                num_mode_unknown_radio_ssi_cov.Enable = 'off';
                num_mode_known_radio_ssi_cov.Enable = 'off';
                cluster_distance_spinner.Enable = 'off';
                min_cluster_size_spinner.Enable = 'off'; 
                target_num_spinner_ssi_cov.Enable = 'off';
            end

        % Falls Switch für automatische Polauswahl betroffen ist (SSI-DATA)
        elseif src == auto_pol_switch2

            % Wenn das Switch angeschaltet wurde
            if strcmp(event.Value, 'An')

                % Relevante Komponente aktivieren
                criteria_stable_freq_checkbox2.Enable = 'on';
                criteria_stable_damp_checkbox2.Enable = 'on';
                criteria_mac_checkbox2.Enable = 'on';
                num_mode_unknown_radio_ssi_data.Enable = 'on';
                num_mode_known_radio_ssi_data.Enable = 'on';

                % Falls die Anzahl unbekannt ist
                if num_mode_unknown_radio_ssi_data.Value
    
                    % Relevante Komponente de- bzw. aktivieren
                    cluster_distance_spinner2.Enable = 'on';
                    min_cluster_size_spinner2.Enable = 'on';  
                    target_num_spinner_ssi_data.Enable = 'off';
    
                % Falls die Anzahl bekannt ist
                elseif num_mode_known_radio_ssi_data.Value
    
                    % Relevante Komponente de- bzw. aktivieren
                    cluster_distance_spinner2.Enable = 'on';
                    min_cluster_size_spinner2.Enable = 'off'; 
                    target_num_spinner_ssi_data.Enable = 'on'; 
                end

            % Wenn das Switch ausgeschaltet wurde
            elseif strcmp(event.Value, 'Aus')

                % Relevante Komponente deaktivieren
                criteria_stable_freq_checkbox2.Enable = 'off';
                criteria_stable_damp_checkbox2.Enable = 'off';
                criteria_mac_checkbox2.Enable = 'off';
                num_mode_unknown_radio_ssi_data.Enable = 'off';
                num_mode_known_radio_ssi_data.Enable = 'off';
                cluster_distance_spinner2.Enable = 'off';
                min_cluster_size_spinner2.Enable = 'off'; 
                target_num_spinner_ssi_data.Enable = 'off';
            end            

        % Falls Switch für automatische Peakauswahl betroffen ist
        elseif src == auto_peak_switch            

            % Wenn das Switch angeschaltet wurde
            if strcmp(event.Value, 'An')

                % Relevante Komponente aktivieren
                num_mode_unknown_radio_fdd.Enable = 'on';
                num_mode_known_radio_fdd.Enable = 'on';

                % Falls die Anzahl unbekannt ist
                if num_mode_unknown_radio_fdd.Value
    
                    % Relevante Komponente de- bzw. aktivieren
                    bandwidth_peak_spinner.Enable = 'on';
                    mac_spinner_valid_peak.Enable = 'on';
                    target_num_spinner_fdd.Enable = 'off';
    
                % Falls die Anzahl bekannt ist
                elseif num_mode_known_radio_fdd.Value
    
                    % Relevante Komponente de- bzw. aktivieren
                    bandwidth_peak_spinner.Enable = 'off';
                    mac_spinner_valid_peak.Enable = 'on';
                    target_num_spinner_fdd.Enable = 'on';                
                end

                % Switch für EFDD nach automatischer Peakauswahl aktivieren
                efdd_auto_peak_switch.Enable = 'on';                       

            % Wenn das Switch ausgeschaltet wurde
            elseif strcmp(event.Value, 'Aus')

                % Relevante Komponente deaktivieren
                num_mode_unknown_radio_fdd.Enable = 'off';
                num_mode_known_radio_fdd.Enable = 'off';    
                bandwidth_peak_spinner.Enable = 'off';
                mac_spinner_valid_peak.Enable = 'off';
                target_num_spinner_fdd.Enable = 'off';                
                efdd_auto_peak_switch.Value = 'Aus';  
                efdd_auto_peak_switch.Enable = 'off';   
                correlation_type_ifft.Enable = 'off';
                correlation_type_cos.Enable = 'off';                
                mac_spinner.Enable = 'off';                 
            end    

        % Falls Switch für EFDD nach automatischer Peakauswahl betroffen ist
        elseif src == efdd_auto_peak_switch

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

        % Falls Radiobutton für Anzahl der Moden betroffen ist (FDD / EFDD)
        elseif src == num_mode_radio_group_fdd

            % Falls die Anzahl unbekannt ist
            if num_mode_unknown_radio_fdd.Value

                % Relevante Komponente de- bzw. aktivieren
                bandwidth_peak_spinner.Enable = 'on';
                mac_spinner_valid_peak.Enable = 'on';
                target_num_spinner_fdd.Enable = 'off';

            % Falls die Anzahl bekannt ist
            elseif num_mode_known_radio_fdd.Value

                % Relevante Komponente de- bzw. aktivieren
                bandwidth_peak_spinner.Enable = 'off';
                mac_spinner_valid_peak.Enable = 'on';
                target_num_spinner_fdd.Enable = 'on';               
            end

        % Falls Radiobutton für Anzahl der Moden betroffen ist (SSI-COV)
        elseif src == num_mode_radio_group_ssi_cov

            % Falls die Anzahl unbekannt ist
            if num_mode_unknown_radio_ssi_cov.Value

                % Relevante Komponente de- bzw. aktivieren
                cluster_distance_spinner.Enable = 'on';
                min_cluster_size_spinner.Enable = 'on';  
                target_num_spinner_ssi_cov.Enable = 'off';

            % Falls die Anzahl bekannt ist
            elseif num_mode_known_radio_ssi_cov.Value

                % Relevante Komponente de- bzw. aktivieren
                cluster_distance_spinner.Enable = 'on';
                min_cluster_size_spinner.Enable = 'off';  
                target_num_spinner_ssi_cov.Enable = 'on';                
            end       

        % Falls Radiobutton für Anzahl der Moden betroffen ist (SSI-DATA)
        elseif src == num_mode_radio_group_ssi_data

            % Falls die Anzahl unbekannt ist
            if num_mode_unknown_radio_ssi_data.Value

                % Relevante Komponente de- bzw. aktivieren
                cluster_distance_spinner2.Enable = 'on';
                min_cluster_size_spinner2.Enable = 'on';
                target_num_spinner_ssi_data.Enable = 'off';

            % Falls die Anzahl bekannt ist
            elseif num_mode_known_radio_ssi_data.Value

                % Relevante Komponente de- bzw. aktivieren
                cluster_distance_spinner2.Enable = 'on';
                min_cluster_size_spinner2.Enable = 'off'; 
                target_num_spinner_ssi_data.Enable = 'on';                
            end

        % Falls Eingabefeld für niedrigste zu untersuchende Frequenz
        % betroffen ist
        elseif src == lowest_freq_edit_field

            % Infos von Messdaten holen
            sampling_freq = app.fig.UserData.cache.modal.sampling_freq;
            num_sensor = app.fig.UserData.cache.modal.num_sensor;
            num_direct = sum(app.fig.UserData.cache.modal.direction);

            % Wenn keine Messdaten importiert wurden, Callback beenden
            if isnan(sampling_freq)
                return;
            end

            % Falls Eingabefeld leer ist
            if isempty(event.Value)

                % Eingaben in anderen Feldern löschen
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

            % Fehlermeldung falls niedrigste zu untersuchende Frequenz
            % größer als Hälft der Abtastfrequenz ist
            if lowest_freq >= sampling_freq/2

                % Eingaben in anderen Feldern löschen
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