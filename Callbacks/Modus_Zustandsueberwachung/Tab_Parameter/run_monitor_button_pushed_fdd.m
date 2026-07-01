%% Callback für Button zum Durchführen der Zustandsüberwachung (FDD)
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function run_monitor_button_pushed_fdd(fig, app, segment_info)

    % Nötige Variablen holen
    freq_limit = str2double(app.freq_limit_edit_field_monitor.Value);        % Frequenzgrenze
    lowest_freq = str2double(app.lowest_freq_edit_field_monitor.Value);      % Niedrigste zu untersuchende Frequenz
    num_segment = str2double(app.num_segment_edit_field.Value);              % Anzahl der Abschnitte
    freq_threshold = app.damage_freq_spinner.Value;                          % Frequenzgrenze für Modenzuordnung
    mac_threshold = app.damage_mac_spinner.Value;                            % MAC-Grenze für Modenzuordnung
    psd_mode_direct= app.psd_mode_direct_monitor.Value;                      % Radiobutton für direkt
    psd_mode_welch = app.psd_mode_welch_monitor.Value;                       % Radiobutton für Welch
    psd_mode_user_defined = app.psd_mode_user_defined_monitor.Value;         % Radiobutton für benutzerdefiniert    
    window_func = app.window_func_dropdown_monitor.Value;                    % Fensterfunktion
    window_size = app.window_size_dropdown_monitor.Value;                    % Größe eines Fensters  
    overlap = app.overlap_dropdown_monitor.Value;                            % Prozentsatz der Überlappung
    num_fft = app.num_fft_dropdown_monitor.Value;                            % Anzahl der DFT-Punkte        
    mac_valid_peak = app.mac_spinner_valid_peak_monitor.Value;               % MAC-Grenze für validen Peak
    efdd_auto_peak_choice = app.efdd_auto_peak_switch_monitor.Value;         % Wahl für EFDD nach automatischer Peakauswahl
    correlation_type_ifft = app.correlation_type_ifft2_monitor;              % Radiobutton für IFFT
    correlation_type_cos = app.correlation_type_cos2_monitor;                % Radiobutton für Kosinustransformation
    mac_efdd = app.mac_spinner4_monitor.Value;                               % MAC-Grenze für EFDD
    oma_dropdown = app.oma_dropdown2;                                        % Dropdown für OMA-Methoden
    step_table = app.step_table;                                             % Tabelle für Abschnitte
    freq_time_graph = app.freq_time_graph;                                   % Frequenz-Zeit-Plot
    oma_fdd_check2 = app.oma_fdd_check2_monitor;                             % Wahl für FDD (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_efdd_check2 = app.oma_efdd_check2_monitor;                           % Wahl für EFDD (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table = app.freq_damp_table2_monitor;                          % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_fdd_check3 = app.oma_fdd_check3_monitor;                             % Wahl für FDD (Sub-Tab "Freq.-Zeit-Plot", Tab "Export")
    oma_efdd_check3 = app.oma_efdd_check3_monitor;                           % Wahl für EFDD (Sub-Tab "Freq.-Zeit-Plot", Tab "Export")
    lamp = app.status_lamp;                                                  % Licht des Status
    status = app.status_text_area;                                           % Textfeld des Status    

    % Infos holen
    sampling_freq = app.fig.UserData.cache.monitor.sampling_freq;
    num_sensor = app.fig.UserData.cache.monitor.num_sensor;
    direction = app.fig.UserData.cache.monitor.direction;

    % Referenzmoden holen
    ref_eigenfreq = app.fig.UserData.cache.monitor.ref_eigenfreq;
    ref_eigenvector = app.fig.UserData.cache.monitor.ref_eigenvector;

    % Die Eigenformen der Referenzmoden für MAC-Vergleich anpassen
    ref_eigenvector = cellfun(@(x) reshape(x', [], 1), ref_eigenvector, 'UniformOutput', false);

    % Anzahl der Referenzmoden
    num_ref_mode = length(ref_eigenfreq);    
        
    % Falls die Frequenzgrenze die Hälfte der Abtastfrequenz überschreitet,
    % sollte die Hälfte der Abtastfrequenz als Frequenzgrenze übernommen
    % werden, da FDD nur bis Hälfte der Abtastfrequenz auswerten kann
    if freq_limit > sampling_freq/2
        freq_limit = sampling_freq/2;
    end

    % Strukturarray für Ergebnisse instanziieren
    new_fdd_all_segment = struct([]);
    freq_all_segment_for_tracking = cell(1, num_segment);
    mode_shape_all_segment_for_tracking = cell(1, num_segment);
    peak_quality_for_tracking = cell(1, num_segment);

    % Wenn aktuelle Parameter mit benutzten Parametern übereinstimmen
    if isequal(app.fig.UserData.cache.monitor.used_parameter.fdd, app.fig.UserData.cache.monitor.current_parameter.fdd)  

        % Vorherige Ergebnisse holen
        prev_fdd_all_segment = app.fig.UserData.cache.monitor.fdd_result;

        % Status aktualisieren
        update_status(status, lamp, '>> Vorherige Ergebnisse der FDD geholt', 'erfolg');
        pause(1);

    % Sonst
    else

        % Nichts zurückgeben
        prev_fdd_all_segment = [];

        % Status aktualisieren
        update_status(status, lamp, '>> FDD fängt gleich an...', 'warnung');
        pause(1);                   
    end

    % Vorherige Ergebnisse, die von FDD abhängig sind, löschen
    app.fig.UserData.cache.monitor.selected_peak = struct([]);
    app.fig.UserData.cache.monitor.efdd_result = struct([]);    
    app.fig.UserData.cache.monitor.track_freq.fdd = [];

    % Alle Abschnitte durchlaufen
    for k= 1:num_segment    

        % Messdaten dieses Abschnitts
        data_this_segment = segment_info(k).data(:,2:end);        

        % Wenn Ergebnisse der FDD bereits vorhanden ist
        if ~isempty(prev_fdd_all_segment)

            % Ergebnisse dieses Abschnitts holen
            fdd_result_this_segment = prev_fdd_all_segment{k};

        % Sonst
        else

            % Gewählten Modus holen
            if psd_mode_direct
                psd_mode = 'Direkt';
            elseif psd_mode_welch
                psd_mode = 'Welch';
            elseif psd_mode_user_defined
                psd_mode = 'User';
            end                            

            % FDD durchführen
            fdd_result_this_segment = compute_fdd(fig, psd_mode, ...
                data_this_segment, sampling_freq, window_func, window_size, ...
                overlap, num_fft, freq_limit, lowest_freq, k, num_segment);
        end

        % Eingabe für Peakauswahl, wobei die Zielanzahl der Moden 
        % doppelt so viel wie Referenzmoden (weil Eigenfrequenzänderungen 
        % innerhalb eines Abschnitts auftretten könnten) 
        user_input.num_mode_known = true;
        user_input.mac = mac_valid_peak/100;
        user_input.target_num = num_ref_mode*2;
        user_input.target_num_ref = num_ref_mode;

        % Peakauswahl durchführen
        [selected_peak_this_segment, peak_quality_this_segment] = identify_peak_automatic(fdd_result_this_segment, user_input);

        % Ergebnisse speichern
        new_fdd_all_segment(k).fdd_result = fdd_result_this_segment;                    
        new_fdd_all_segment(k).selected_peak = selected_peak_this_segment;
        freq_all_segment_for_tracking{k} = [selected_peak_this_segment.freq];
        peak_quality_for_tracking{k} = peak_quality_this_segment;

        % Falls gemessene Richtungen weniger als 3, müssen die Eigenformen
        % angepasst werden, damit sie für MAC-Vergleich geeignet sind
        if sum(direction) ~= 3        

            % Alle Eigenformen dieses Abschnitts holen
            mode_shape_this_segment = [selected_peak_this_segment.mode_shape];
            
            % Eigenformen in 3D instanziieren
            mode_shape_this_segment_3d = zeros(num_sensor*3, size(mode_shape_this_segment,2));
            
            % Alle Eigenformen durchlaufen
            for j = 1:size(mode_shape_this_segment,2)
            
                % Aktuelle Eigenform holen
                this_mode_shape = mode_shape_this_segment(:,j);
            
                % Eigenform anpassen
                mode_shape_this_segment_3d(:,j) = reshape_eigenform(this_mode_shape, num_sensor, direction);
            end
            
            % Eigenform einordnen
            mode_shape_all_segment_for_tracking{k} = mode_shape_this_segment_3d;       

        % Sonst direkt einordnen
        else
            mode_shape_all_segment_for_tracking{k} = [selected_peak_this_segment.mode_shape];
        end
    end

    % Frequenz über Zeit verfolgen
    [track_freq, track_phi, used_mode] = track_freq_across_time(ref_eigenfreq, ref_eigenvector, freq_all_segment_for_tracking, mode_shape_all_segment_for_tracking, peak_quality_for_tracking, freq_threshold, mac_threshold);

    % Alle Abschnitte durchlaufen
    for k= 1:num_segment

        % Liste der benutzten Moden dieses Abschnitts holen
        used_this_segment = used_mode(k, :);

        % Nur benutzete Moden weiter betrachten
        new_fdd_all_segment(k).selected_peak = new_fdd_all_segment(k).selected_peak(used_this_segment);
    end

    % Parameter speichern
    app.fig.UserData.cache.monitor.used_parameter.fdd = app.fig.UserData.cache.monitor.current_parameter.fdd;  

    % Ergebnisse speichern
    app.fig.UserData.cache.monitor.fdd_result = {new_fdd_all_segment.fdd_result};
    app.fig.UserData.cache.monitor.selected_peak = {new_fdd_all_segment.selected_peak};
    app.fig.UserData.cache.monitor.track_freq.fdd = track_freq;  
    app.fig.UserData.cache.monitor.track_phi.fdd = track_phi;

    % Ergebnisse in restlichen GUI-Komponenten aktualisieren
    update_result_monitor(step_table, segment_info, freq_time_graph, track_freq, ref_eigenfreq, oma_dropdown, ...
        "FDD", freq_damp_table, oma_fdd_check2, oma_fdd_check3);           

    % Falls EFDD nach automatischer Polauswahl angeschaltet ist, dann
    % muss EFDD durchgeführt werden
    if strcmp(efdd_auto_peak_choice, 'An') 

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
            if correlation_type_ifft.Value
                correlation_type = 'IFFT';
            elseif correlation_type_cos.Value
                correlation_type = 'Cos';
            end
        end        

        % MAC-Grenze berechnen
        mac = mac_efdd/100;  

        % Strukturarray für Ergebnisse instanziieren
        efdd_all_segment = cell(num_segment,1);  
        freq_all_segment_for_tracking = cell(1, num_segment);
        mode_shape_all_segment_for_tracking = cell(1, num_segment);        

        % Alle Abschnitte durchlaufen
        for k= 1:num_segment        
    
            % Ergebnisse der FDD dieses Abschnitts holen
            fdd_result = new_fdd_all_segment(k).fdd_result;
            eigenfreq_chosen = [new_fdd_all_segment(k).selected_peak(:).freq]';
            F = fdd_result.F;
            PSD = fdd_result.PSD;
            U = fdd_result.U;

            % Zeitvektor holen
            time_vector = segment_info(k).data(:,1);

            % Strukturarray für Ergebnisse instanziieren
            efdd_result_this_segment = struct([]);
    
            % Alle Eigenfrequenzen durchlaufen
            for i = 1:length(eigenfreq_chosen)
    
                % EFDD durchführen
                [SBF, mode_shape, time_recon, signal_recon, freq_d, peak_info] = compute_efdd(F, PSD, eigenfreq_chosen(i), mac, U, time_vector, sampling_freq, correlation_type);
    
                % Variablen speichern
                efdd_result_this_segment(i).freq_fdd = eigenfreq_chosen(i);
                efdd_result_this_segment(i).mac = mac;
                efdd_result_this_segment(i).SBF = SBF;
                efdd_result_this_segment(i).mode_shape = mode_shape;
                efdd_result_this_segment(i).time_recon = time_recon;
                efdd_result_this_segment(i).signal_recon = signal_recon;
                efdd_result_this_segment(i).freq_d = freq_d;
                efdd_result_this_segment(i).damping_ratio = NaN;
                efdd_result_this_segment(i).peak_info = peak_info;                 
            end

            % Variablen speichern
            efdd_all_segment{k} = efdd_result_this_segment;
            freq_all_segment_for_tracking{k} = [efdd_result_this_segment.freq_d];
    
            % Falls gemessene Richtungen weniger als 3, müssen die Eigenformen
            % angepasst werden, damit sie für MAC-Vergleich geeignet sind
            if sum(direction) ~= 3        
    
                % Alle Eigenformen dieses Abschnitts holen
                mode_shape_this_segment = [efdd_result_this_segment.mode_shape];
                
                % Eigenformen in 3D instanziieren
                mode_shape_this_segment_3d = zeros(num_sensor*3, size(mode_shape_this_segment,2));
                
                % Alle Eigenformen durchlaufen
                for j = 1:size(mode_shape_this_segment,2)
                
                    % Aktuelle Eigenform holen
                    this_mode_shape = mode_shape_this_segment(:,j);
                
                    % Eigenform anpassen
                    mode_shape_this_segment_3d(:,j) = reshape_eigenform(this_mode_shape, num_sensor, direction);
                end
                
                % Eigenform einordnen
                mode_shape_all_segment_for_tracking{k} = mode_shape_this_segment_3d;       
    
            % Sonst direkt einordnen
            else
                mode_shape_all_segment_for_tracking{k} = [efdd_result_this_segment.mode_shape];
            end            
        end

        % Frequenz über Zeit verfolgen
        [track_freq, track_phi, used_mode] = track_freq_across_time(ref_eigenfreq, ref_eigenvector, freq_all_segment_for_tracking, mode_shape_all_segment_for_tracking, peak_quality_for_tracking, freq_threshold, mac_threshold);
    
        % Alle Abschnitte durchlaufen
        for k= 1:num_segment
    
            % Liste der benutzten Moden dieses Abschnitts holen
            used_this_segment = used_mode(k, :);
    
            % Nur benutzete Moden weiter betrachten
            efdd_all_segment{k} = efdd_all_segment{k}(used_this_segment);
        end        

        % Ergebnisse speichern
        app.fig.UserData.cache.monitor.efdd_result = efdd_all_segment;
        app.fig.UserData.cache.monitor.track_freq.efdd = track_freq;   
        app.fig.UserData.cache.monitor.track_phi.efdd = track_phi;

        % Ergebnisse in restlichen GUI-Komponenten aktualisieren
        update_result_monitor(step_table, segment_info, freq_time_graph, track_freq, ref_eigenfreq, oma_dropdown, ...
            "EFDD", freq_damp_table, oma_efdd_check2, oma_efdd_check3);        
    end
end