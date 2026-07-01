%% Callback für Button zum Durchführen der Modalanalyse (FDD)
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function run_analysis_button_pushed_fdd(fig, app)

    % Nötige Variablen holen
    freq_limit = str2double(app.freq_limit_edit_field.Value);                   % Frequenzgrenze
    lowest_freq = str2double(app.lowest_freq_edit_field.Value);                 % Niedrigste zu untersuchende Frequenz
    psd_mode_direct = app.psd_mode_direct.Value;                                % Radiobutton für direkt
    psd_mode_welch = app.psd_mode_welch.Value;                                  % Radiobutton für Welch
    psd_mode_user_defined = app.psd_mode_user_defined.Value;                    % Radiobutton für benutzerdefiniert      
    window_func = app.window_func_dropdown.Value;                               % Fensterfunktion
    window_size = app.window_size_dropdown.Value;                               % Größe eines Fensters  
    overlap = app.overlap_dropdown.Value;                                       % Prozentsatz der Überlappung
    num_fft = app.num_fft_dropdown.Value;                                       % Anzahl der DFT-Punkte    
    auto_peak_choice = app.auto_peak_switch.Value;                              % Wahl für automatische Peakauswahl
    num_mode_known_choice = app.num_mode_known_fdd.Value;                       % Radiobutton für bekannt
    bandwidth_peak = app.bandwidth_peak_spinner.Value;                          % Bandbreite um den Peak
    mac_valid_peak = app.mac_spinner_valid_peak.Value;                          % MAC-Grenze für validen Peak
    target_num = app.target_num_spinner_fdd.Value;                              % Zielanzahl
    efdd_auto_peak_choice = app.efdd_auto_peak_switch.Value;                    % Wahl für EFDD nach automatischer Peakauswahl
    correlation_type_ifft2 = app.correlation_type_ifft2;                        % Radiobutton für IFFT (Sub-Tab "FDD / EFDD", Tab "Parameter")
    correlation_type_cos2 = app.correlation_type_cos2;                          % Radiobutton für Kosinustransformation (Sub-Tab "FDD / EFDD", Tab "Parameter")
    mac_efdd = app.mac_spinner4.Value;                                          % MAC-Grenze für EFDD (Sub-Tab "FDD / EFDD", Tab "Parameter")
    psd_graph_db = app.psd_graph;                                               % Graph für 1. Singulärwerte der PSD in [dB]
    psd_graph_lin = app.psd_graph2;                                             % Graph für 1. Singulärwerte der PSD in [/]
    slider = app.psd_graph_slider;                                              % Slider für x-Achse des Graphs für 1. Singulärwerte der PSD
    range_check = app.psd_graph_range_check;                                    % Checkbox für fixierten Bereich der x-Achse
    range_edit_field = app.psd_graph_range_edit_field;                          % Eingabefeld für fixierten Bereich der x-Achse
    freq_table = app.freq_table2;                                               % Tabelle für Frequenzen
    correlation_type_ifft = app.correlation_type_ifft;                          % Radiobutton für IFFT (Sub-Tab "Singulärwerte der PSD", Tab "FDD / EFDD")
    correlation_type_cos = app.correlation_type_cos;                            % Radiobutton für Kosinustransformation (Sub-Tab "Singulärwerte der PSD", Tab "FDD / EFDD")
    mac_spinner_efdd = app.mac_spinner2;                                        % Spinner für MAC-Grenze (Sub-Tab "Singulärwerte der PSD", Tab "FDD / EFDD")
    freq_mac_table = app.freq_mac_table;                                        % Tabelle für Frequenzen und MAC-Grenzen
    mac_spinner_sbf = app.mac_spinner3;                                         % Spinner für MAC-Grenze (Sub-Tab "SBF", Tab "FDD / EFDD")
    freq_damp_table_efdd = app.freq_damp_table_efdd;                            % Tabelle für Ergebisse (Sub-Tab "Dämpfung in EFDD", Tab "FDD / EFDD")
    oma_dropdown = app.oma_dropdown;                                            % Dropdown für OMA-Methoden
    freq_damp_table = app.freq_damp_table;                                      % Tabelle für Ergebnisse (Tab "Ergebnis")
    eigenform_graph = app.eigenform_graph;                                      % Graph für Eigenform
    oma_fdd_check2 = app.oma_fdd_check2;                                        % Wahl für FDD (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_efdd_check2 = app.oma_efdd_check2;                                      % Wahl für EFDD (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table2 = app.freq_damp_table2;                                    % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_fdd_check3 = app.oma_fdd_check3;                                        % Wahl für FDD (Sub-Tab "Eigenform", Tab "Export")
    oma_efdd_check3 = app.oma_efdd_check3;                                      % Wahl für EFDD (Sub-Tab "Eigenform", Tab "Export")
    freq_damp_table3 = app.freq_damp_table3;                                    % Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                                     % Licht des Status
    status = app.status_text_area;                                              % Textfeld des Status

    % Messdaten und Infos holen
    data_matrix = app.fig.UserData.cache.modal.data_matrix;
    sampling_freq = app.fig.UserData.cache.modal.sampling_freq;    
        
    % Falls die Frequenzgrenze die Hälfte der Abtastfrequenz überschreitet,
    % sollte die Hälfte der Abtastfrequenz als Frequenzgrenze übernommen
    % werden, da FDD nur bis Hälfte der Abtastfrequenz auswerten kann
    if freq_limit >= sampling_freq/2
        freq_limit = sampling_freq/2;
    end

    % Zeitvektor holen
    time_vector = data_matrix(:,1);     
    
    % Messdaten der Sensoren
    data_matrix = data_matrix(:, 2:end);

    % Wenn aktuelle Parameter mit benutzten Parametern nicht
    % übereinstimmen, FDD durchführen
    if ~isequal(app.fig.UserData.cache.modal.used_parameter.fdd, app.fig.UserData.cache.modal.current_parameter.fdd)

        % Status aktualisieren
        update_status(status, lamp, '>> FDD fängt gleich an...', 'warnung');
        pause(1);        

        % Gewählten Modus holen
        if psd_mode_direct
            psd_mode = 'Direkt';
        elseif psd_mode_welch
            psd_mode = 'Welch';
        elseif psd_mode_user_defined
            psd_mode = 'User';       
        end
        
        % FDD durchführen
        fdd_result = compute_fdd(fig, psd_mode, data_matrix, sampling_freq, window_func, window_size, overlap, num_fft, freq_limit, lowest_freq);

        % Variable speichern
        app.fig.UserData.cache.modal.fdd_result = fdd_result;

        % Parameter für FDD speichern
        app.fig.UserData.cache.modal.used_parameter.fdd = app.fig.UserData.cache.modal.current_parameter.fdd;   

        % Nachricht für Status
        message = '>> FDD durchgeführt und Singulärwerte der PSD aktualisiert';          
    
    % Sonst
    else

        % Vorherige Ergebnisse holen
        fdd_result = app.fig.UserData.cache.modal.fdd_result;

        % Nachricht für Status
        message = '>> Vorherige Ergebnisse der FDD geholt und Singulärwerte der PSD aktualisiert';  
    end

    % Vorherige Ergebnisse, die von FDD abhängig sind, löschen
    app.fig.UserData.cache.modal.selected_peak = struct([]);
    app.fig.UserData.cache.modal.efdd_result = struct([]);

    % Nachricht für Status
    update_status(status, lamp, message, 'erfolg');
    pause(1);      

    % Plotten der 1. Singulärwerte der PSD
    plot_eigenvalue_psd_db(psd_graph_db, fdd_result, [], freq_limit, slider, range_check, range_edit_field);
    plot_eigenvalue_psd_lin(psd_graph_lin, fdd_result, [], freq_limit);

    % Einstellung für Korrelationsfunktion abhängig vom Modus der FDD
    % aktualisieren
    if psd_mode_direct
        correlation_type_ifft.Value = true;
    elseif psd_mode_welch
        correlation_type_cos.Value = true;
    elseif psd_mode_user_defined
        correlation_type_ifft.Enable = 'on';
        correlation_type_cos.Enable = 'on';
        correlation_type_ifft.Value = true;
    end

    % Falls automatische Peakauswahl angeschaltet ist, dann müssen
    % Peaks ausgewählt werden
    if strcmp(auto_peak_choice, 'An')    

        % Eingabe für Peakauswahl als Structure zusammenfassen   
        user_input.num_mode_known = num_mode_known_choice;
        user_input.mac = mac_valid_peak/100;
        if num_mode_known_choice
            user_input.target_num = target_num;
        else
            user_input.bandwidth = bandwidth_peak;
        end

        % Peakauswahl durchführen
        selected_peak = identify_peak_automatic(fdd_result, user_input);

        % Variable speichern
        app.fig.UserData.cache.modal.selected_peak = selected_peak;  

        % Fehlermeldung falls keine Peaks gefunden wurden
        if isempty(selected_peak)
            error('Keine Peaks gefunden, die alle Kriterien erfüllen!');                
        end        

        % Plotten der 1. Singulärwerte der PSD       
        plot_eigenvalue_psd_db(psd_graph_db, fdd_result, [selected_peak.idx]);
        plot_eigenvalue_psd_lin(psd_graph_lin, fdd_result, [selected_peak.idx]);
        
        % Ergebnisse holen
        eigenfreq_chosen = [selected_peak.freq]';
        damping_ratio_chosen = [];

        % Tabelle aktualisieren
        title = {'Frequenz [Hz]'};
        freq_table.ColumnName = title;
        freq_table.Data = eigenfreq_chosen;        

        % Ergebnisse in restlichen GUI-Komponenten aktualisieren
        update_result(eigenform_graph, eigenfreq_chosen, damping_ratio_chosen, oma_dropdown, ...
            "FDD", freq_damp_table, freq_damp_table2, freq_damp_table3, oma_fdd_check2, oma_fdd_check3); 

        % Status aktualisieren
        message_num_peak = sprintf('Anzahl der identifizierten Peaks: %d\n', (length(eigenfreq_chosen)));
        update_status(status, lamp, '----------------------------------------------------------', 'erfolg');
        update_status(status, lamp, message_num_peak, 'erfolg');
        update_status(status, lamp, '----------------------------------------------------------', 'erfolg');    

         % Nachricht für Status
        message = '>> Peaks automatisch ausgewählt';    

        % Falls EFDD nach automatischer Peakauswahl angeschaltet ist, dann
        % muss EFDD durchgeführt werden
        if strcmp(efdd_auto_peak_choice, 'An') 
        
            % MAC-Grenze berechnen
            mac = mac_efdd/100;   

            % Ergebnisse der FDD holen
            F = fdd_result.F;
            PSD = fdd_result.PSD;
            U = fdd_result.U; 

            % Wenn Direkt-FDD gewählt wurde, dann wird IFFT zwangsläufig
            % für Berechnung der Korrelationsfunktion angewendet
            if psd_mode_direct
                correlation_type = 'IFFT';

            % Wenn Welch gewählt wurde, dann wird Kosinustransformation 
            % zwangsläufig für Berechnung der Korrelationsfunktion angewendet                
            elseif psd_mode_welch
                correlation_type = 'Cos';

            % Wenn benutzerdefinierte FDD gewählt wurde, dann muss die
            % gewählte Einstellung geholt werden
            elseif psd_mode_user_defined
                if correlation_type_ifft2.Value
                    correlation_type = 'IFFT';
                    correlation_type_ifft.Value = true;
                elseif correlation_type_cos2.Value
                    correlation_type = 'Cos';
                    correlation_type_cos.Value = true;
                end
            end

            % Möglichkeit zur späteren Einstellung für EFDD sperren
            correlation_type_ifft.Enable = 'off';
            correlation_type_cos.Enable = 'off';    
            mac_spinner_efdd.Enable = 'off';

            % Strukturarray für Ergebnisse instanziieren
            efdd_result = struct([]);
    
            % Alle Eigenfrequenzen durchlaufen
            for i = 1:length(eigenfreq_chosen)
    
                % EFDD durchführen
                [SBF, mode_shape, time_recon, signal_recon, freq_d, peak_info] = compute_efdd(F, PSD, eigenfreq_chosen(i), mac, U, time_vector, sampling_freq, correlation_type);
    
                % Variablen speichern
                efdd_result(i).freq_fdd = eigenfreq_chosen(i);
                efdd_result(i).mac = mac;
                efdd_result(i).SBF = SBF;
                efdd_result(i).mode_shape = mode_shape;
                efdd_result(i).time_recon = time_recon;
                efdd_result(i).signal_recon = signal_recon;
                efdd_result(i).freq_d = freq_d;
                efdd_result(i).damping_ratio = NaN;
                efdd_result(i).peak_info = peak_info; 
            end

            % Variable speichern
            app.fig.UserData.cache.modal.efdd_result = efdd_result;
    
            % Ergebnisse der EFDD holen
            eigenfreq_chosen = [efdd_result.freq_fdd];
            freq_d_chosen = [efdd_result.freq_d];
            damping_ratio_chosen = [efdd_result.damping_ratio];
            mac_chosen =  [efdd_result.mac];
    
            % Tabelle aktualisieren
            mac_string = string(compose('%.0f', mac_chosen * 100));      
            freq_mac_table.Data = [eigenfreq_chosen', mac_string'];
            freq_mac_table.ColumnName = {'FDD Freq. [Hz]', 'MAC [%]'};
            freq_mac_table.RowName = 'numbered';  
            freq_damp_table_efdd.Data = [freq_d_chosen', eigenfreq_chosen', damping_ratio_chosen'];
            freq_damp_table_efdd.ColumnName = {'EFDD F. [Hz]', 'FDD F. [Hz]', 'Dämpf. [%]'};
            freq_damp_table_efdd.ColumnWidth = repmat({'1x'}, 1, 2);
            freq_damp_table_efdd.RowName = 'numbered';        
    
            % Spinner für MAC-Grenze auf dem nächsten Subtab aktualisieren
            mac_spinner_sbf.Value = mac*100;        
    
            % EFDD in Dropdown für OMA-Methoden hinzufügen wenn noch nicht
            % vorhanden
            oma_list = oma_dropdown.Items;
            if ~ismember('EFDD', oma_list)
                oma_list{end+1} = 'EFDD';
                oma_dropdown.Items = oma_list;
            end    
    
            % Ergebnisse in restlichen GUI-Komponenten aktualisieren
            update_result(eigenform_graph, freq_d_chosen', damping_ratio_chosen', oma_dropdown, ...
                "EFDD", freq_damp_table, freq_damp_table2, freq_damp_table3, oma_efdd_check2, oma_efdd_check3);
    
             % Nachricht für Status
            message = '>> Peaks automatisch ausgewählt und EFDD durchgeführt';  
        end
    
        % Nachricht für Status
        update_status(status, lamp, message, 'erfolg');        
    end
end