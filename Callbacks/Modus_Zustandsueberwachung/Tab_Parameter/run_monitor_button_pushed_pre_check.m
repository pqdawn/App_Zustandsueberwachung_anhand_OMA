%% Callback für Vorbereitung vor der Zustandsüberwachung
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function run_monitor_button_pushed_pre_check(fig, app)
    
    % Nötige Variablen holen
    oma_fdd_tick = app.oma_fdd_check_monitor.Value;                                 % Wahl für FDD
    oma_ssi_cov_tick = app.oma_ssi_cov_check_monitor.Value;                         % Wahl für SSI-COV
    oma_ssi_data_tick = app.oma_ssi_data_check_monitor.Value;                       % Wahl für SSI-DATA    
    freq_limit = str2double(app.freq_limit_edit_field_monitor.Value);               % Frequenzgrenze
    lowest_freq = str2double(app.lowest_freq_edit_field_monitor.Value);             % Niedrigste zu untersuchende Frequenz
    seg_num_choice = app.seg_type_num.Value;                                        % Wahl für anzahlbasierte Segmentierung
    seg_time_coice = app.seg_type_time.Value;                                       % Wahl für zeitbasierte Segmentierung
    num_segment = app.num_segment_edit_field.Value;                                 % Anzahl der Abschnitte
    time_interval = app.time_interval_edit_field.Value;                             % Zeitschrittsgröße
    num_ignore_row = app.num_ignore_row_edit_field.Value;                           % Anzahl der ignorierten Zeilen    
    freq_threshold = app.damage_freq_spinner.Value;                                 % Frequenzgrenze für Modenzuordnung
    mac_threshold = app.damage_mac_spinner.Value;                                   % MAC-Grenze für Modenzuordnung
    psd_mode_direct= app.psd_mode_direct_monitor;                                   % Radiobutton für direkt
    psd_mode_welch = app.psd_mode_welch_monitor;                                    % Radiobutton für Welch
    psd_mode_user_defined = app.psd_mode_user_defined_monitor;                      % Radiobutton für benutzerdefiniert    
    window_func = app.window_func_dropdown_monitor.Value;                           % Fensterfunktion
    window_size = app.window_size_dropdown_monitor.Value;                           % Größe eines Fensters  
    overlap = app.overlap_dropdown_monitor.Value;                                   % Prozentsatz der Überlappung
    num_fft = app.num_fft_dropdown_monitor.Value;                                   % Anzahl der DFT-Punkte        
    efdd_auto_peak_choice = app.efdd_auto_peak_switch_monitor.Value;                % Wahl für EFDD nach automatischer Peakauswahl
    max_lag = app.max_lag_edit_field_monitor.Value;                                 % Maximaler verzögerter Zeitschritt
    max_model_order = app.max_model_order_edit_field_monitor.Value;                 % Maximale Model-Order (Sub-Tab "SSI-COV", Tab "Parameter")
    freq_variation = app.freq_variation_spinner_monitor.Value;                      % Grenzwert für stabile Frequenz (Sub-Tab "SSI-COV", Tab "Parameter")
    damping_variation = app.damping_variation_spinner_monitor.Value;                % Grenzwert für stabilen Dämpfungsgrad (Sub-Tab "SSI-COV", Tab "Parameter")
    mac_spinner_ssi_cov = app.mac_spinner_monitor.Value;                            % Grenzwert für "MAC-Bedingung erfüllt" (Sub-Tab "SSI-COV", Tab "Parameter")
    crit_stable_freq_tick = app.criteria_stable_freq_check_monitor.Value;           % Wahl für stabile Frequenz (Sub-Tab "SSI-COV", Tab "Parameter")
    crit_stable_damp_tick = app.criteria_stable_damp_check_monitor.Value;           % Wahl für stabilen Dämpfungsgrad (Sub-Tab "SSI-COV", Tab "Parameter")
    crit_mac_tick = app.criteria_mac_check_monitor.Value;                           % Wahl für MAC-Bedingung erfüllt (Sub-Tab "SSI-COV", Tab "Parameter")
    num_mode_known_choice_ssi_cov = app.num_mode_known_ssi_cov_monitor.Value;       % Wahl für Anzahl der Moden (Sub-Tab "SSI-COV", Tab "Parameter")
    cluster_distance = app.cluster_distance_spinner_monitor.Value;                  % Cluster-Distanzschwelle (Sub-Tab "SSI-COV", Tab "Parameter")
    min_cluster_size = app.min_cluster_size_spinner_monitor.Value;                  % Mindestgröße eines Clusters (Sub-Tab "SSI-COV", Tab "Parameter")
    target_num_ssi_cov = app.target_num_spinner_ssi_cov_monitor.Value;              % Zielanzahl (Sub-Tab "SSI-COV", Tab "Parameter")
    num_row_hankel = app.num_row_hankel_edit_field_monitor.Value;                   % Zeilenanzahl der Hankelmatrix
    num_col_hankel = app.num_col_hankel_edit_field_monitor.Value;                   % Spaltenanzahl der Hankelmatrix
    max_model_order2 = app.max_model_order_edit_field2_monitor.Value;               % Maximale Model-Order (Sub-Tab "SSI-DATA", Tab "Parameter")
    freq_variation2 = app.freq_variation_spinner2_monitor.Value;                    % Grenzwert für stabile Frequenz (Sub-Tab "SSI-DATA", Tab "Parameter")
    damping_variation2 = app.damping_variation_spinner2_monitor.Value;              % Grenzwert für stabilen Dämpfungsgrad (Sub-Tab "SSI-DATA", Tab "Parameter")
    mac_spinner_ssi_data = app.mac_spinner5_monitor.Value;                          % Grenzwert für "MAC-Bedingung erfüllt" (Sub-Tab "SSI-DATA", Tab "Parameter")
    crit_stable_freq_tick2 = app.criteria_stable_freq_check2_monitor.Value;         % Checkbox für stabile Frequenz (Sub-Tab "SSI-DATA", Tab "Parameter")
    crit_stable_damp_tick2 = app.criteria_stable_damp_check2_monitor.Value;         % Checkbox für stabilen Dämpfungsgrad (Sub-Tab "SSI-DATA", Tab "Parameter")
    crit_mac_tick2 = app.criteria_mac_check2_monitor.Value;                         % Checkbox für MAC-Bedingung erfüllt (Sub-Tab "SSI-DATA", Tab "Parameter")
    num_mode_known_choice_ssi_data = app.num_mode_known_ssi_data_monitor.Value;     % Wahl für Anzahl der Moden (Sub-Tab "SSI-DATA", Tab "Parameter")
    cluster_distance2 = app.cluster_distance_spinner2_monitor.Value;                % Cluster-Distanzschwelle (Sub-Tab "SSI-DATA", Tab "Parameter")
    min_cluster_size2 = app.min_cluster_size_spinner2_monitor.Value;                % Mindestgröße eines Clusters (Sub-Tab "SSI-DATA", Tab "Parameter")
    target_num_ssi_data = app.target_num_spinner_ssi_data_monitor.Value;            % Zielanzahl (Sub-Tab "SSI-DATA", Tab "Parameter")
    lamp = app.status_lamp;                                                         % Licht des Status
    status = app.status_text_area;                                                  % Textfeld des Status
    
    try
        %---------------------------------------------------------------------%
        %                   Gewählte OMA-Methoden sammeln
        %---------------------------------------------------------------------%  
        % Liste für OMA-Methoden
        oma_list = {};  

        % OMA-Methoden sammeln
        if oma_fdd_tick
            oma_list{end+1} = 'FDD';
        end
        if oma_ssi_cov_tick
            oma_list{end+1} = 'SSI-COV';
        end        
        if oma_ssi_data_tick
            oma_list{end+1} = 'SSI-DATA';
        end        

        %---------------------------------------------------------------------%
        %            Nach fehlenden oder falschen Eingaben prüfen
        %---------------------------------------------------------------------%        
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(app.fig.UserData.cache.monitor.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Messdaten und Infos holen
        data_matrix = app.fig.UserData.cache.monitor.data_matrix;
        sampling_freq = app.fig.UserData.cache.monitor.sampling_freq;
        num_sensor = app.fig.UserData.cache.monitor.num_sensor;
        num_direct = sum(app.fig.UserData.cache.monitor.direction);        

        % Fehlermeldung falls keine Referenzmoden importiert
        if isempty(app.fig.UserData.cache.monitor.ref_eigenfreq)
            error('Keine Referenzmoden importiert!');
        end

        % Referenzmoden holen
        ref_eigenfreq = app.fig.UserData.cache.monitor.ref_eigenfreq;

        % Fehlermeldung falls Frequenzgrenze kleiner als die größte
        % Eigenfrequenz der Referenzmoden ist
        if freq_limit <= max(ref_eigenfreq)
            error('Frequenzgrenze ist kleiner als die größte Eigenfrequenz der Referenzmoden!');
        end        
        
        % Fehlermeldung falls Frequenzgrenze nicht eingegeben wurde
        if isnan(freq_limit)
            error('Frequenzgrenze nicht eingegeben!');
        end

        % Fehlermeldung falls Frequenzgrenze größer als Abtastfrequenz
        if freq_limit > sampling_freq
            error('Frequenzgrenze größer als Abtastfrequenz!');
        end

        % Fehlermeldung falls niedrigste zu untersuchende Frequenz nicht 
        % eingegeben wurde
        if isnan(lowest_freq)
            error('Niedrigste zu untersuchende Frequenz nicht eingegeben!');
        end

        % Zeitbasierte Segmentierung wurde gewählt
        if seg_time_coice

            % Fehlermeldung falls kein Zeitintervall eingegeben wurde
            if isempty(time_interval)
                error('Zeitintervall nicht eingegeben!');

            % Fehlermeldung falls Zeitintervall nicht gültig ist
            elseif isnan(str2double(time_interval))
                error('Zeitintervall nicht gültig!');

            % Fehlermeldung falls Zeitintervall kleiner als 0 ist
            elseif str2double(time_interval) <= 0
                error('Zeitintervall nicht gültig! Es muss größer als 0 sein!');       
            end

        % Anzahlbasierte Segmentierung wurde gewählt
        elseif seg_num_choice

            % Fehlermeldung falls keine Anzahl eingegeben wurde
            if isempty(num_segment)
                error('Anzahl der Abschnitte nicht eingegeben!');

            % Fehlermeldung falls Anzahl nicht gültig ist
            elseif isnan(str2double(num_segment))
                error('Anzahl der Abschnitte nicht gültig!');    

            % Fehlermeldung falls Anzahl kleiner als 1 ist
            elseif str2double(num_segment) <= 1
                error('Anzahl der Abschnitte nicht gültig! Sie muss größer als 1 sein!');                 
            end
        end       

        % Alle gewählten OMA-Methoden durchlaufen
        for j = 1:numel(oma_list)

            % Aktuelle OMA-Methode holen
            oma_current = oma_list{j};
            switch oma_current

                % Wenn FDD gewählt
                case 'FDD'

                    % Wenn benutzerdefinierten Modus gewählt wurde, müssen
                    % die gewählten Parameter überprüft werden
                    if psd_mode_user_defined.Value

                        % Wenn gesamte Messdaten für Größe eines Fensters gewählt wurde
                        if strcmp(window_size, 'Gesamte Messdaten')
                            
                            % Gesamte Messdaten pro Abschnitt dafür holen
                            window_size = str2double(time_interval)*sampling_freq;

                        % Sonst einfach die gewählte Anzahl holen
                        else
                            window_size = str2double(window_size);
                        end

                        % Fehlermeldung falls Größe eines Fensters größer als
                        % gesamte Messdaten pro Abschnitt
                        if window_size > length(data_matrix)/str2double(num_segment)
                            error(['Größe eines Fensters darf nicht größer ' ...
                                'als gesamte Messdaten pro Abschnitt sein!']);
                        end

                        % Wenn gesamte Messdaten für Anzahl der DFT-Punkte gewählt wurde
                        if strcmp(num_fft, 'Gesamte Messdaten')
                            
                            % Gesamte Messdaten pro Abschnitt dafür holen
                            num_fft = str2double(time_interval)*sampling_freq;

                        % Sonst einfach die gewählte Anzahl holen
                        else
                            num_fft = str2double(num_fft);
                        end                     
    
                        % Fehlermeldung falls Anzahl der DFT-Punkte kleiner als
                        % Größe eines Fensters
                        if num_fft < window_size
                            error(['Anzahl der DFT-Punkte darf nicht kleiner ' ...
                                'als Größe eines Fensters sein!']);
                        end
                    end

                % Wenn SSI-COV gewählt
                case 'SSI-COV'
    
                    % Fehlermeldung falls maximaler verzögerter Zeitschritt nicht eingegeben
                    if isempty(max_lag)
                        error('Maximaler verzögerter Zeitschritt nicht eingegeben!');
                    end
            
                    % Fehlermeldung falls maximaler verzögerter Zeitschritt nicht gültig
                    max_lag = str2double(max_lag);
                    if max_lag == 0
                        error(['Maximaler verzögerter Zeitschritt nicht gültig! Er muss größer ' ...
                            'als 0 sein!'])
                    end
            
                    % Fehlermeldung falls maximale Model-Order nicht eingegeben
                    if isempty(max_model_order)
                        error('Maxiamale Model-Order nicht eingegeben!');
                    end
            
                    % Fehlermeldung falls maximale Model-Order nicht gültig
                    max_model_order = str2double(max_model_order);
                    if max_model_order == 0
                        error(['Maximale Model-Order nicht gültig! Sie muss größer ' ...
                            'als 0 sein!'])
                    elseif max_model_order > num_direct*num_sensor*max_lag
                        error(['Maximale Model-Order nicht gültig! Sie darf nicht größer als n_0*j, wobei: ' ...
                            'n_0 = Anzahl der Ausgangskanäle; j = maximaler verzögerter Zeitschritt']);
                    end

                % Wenn SSI-DATA gewählt
                case 'SSI-DATA'

                    % Fehlermeldung falls Zeilenanzahl der Hankelmatrix
                    % nicht eingegeben
                    if isempty(num_row_hankel)
                        error('Zeilenanzahl der Hankelmatrix nicht eingegeben!');
                    end
            
                    % Fehlermeldung falls Zeilenanzahl der Hankelmatrix nicht gültig
                    num_row_hankel = str2double(num_row_hankel);
                    if num_row_hankel == 0
                        error(['Zeilenanzahl der Hankelmatrix nicht gültig! Sie muss größer ' ...
                            'als 0 sein!'])
                    end      

                    % Fehlermeldung falls Spaltenanzahl der Hankelmatrix
                    % nicht eingegeben
                    if isempty(num_col_hankel)
                        error('Spaltenanzahl der Hankelmatrix nicht eingegeben!');
                    end
            
                    % Fehlermeldung falls Spaltenanzahl der Hankelmatrix nicht gültig
                    num_col_hankel = str2double(num_col_hankel);
                    if num_col_hankel == 0
                        error(['Spaltenanzahl der Hankelmatrix nicht gültig! Sie muss größer ' ...
                            'als 0 sein!'])
                    elseif num_col_hankel > length(data_matrix)/str2double(num_segment)+1-num_row_hankel/num_sensor
                        error(['Spaltenanzahl der Hankelmatrix nicht gültig! Sie darf nicht größer als N+1-n_row/n_0, wobei: ' ...
                            'N = Anzahl der Zeitschritte pro Abschnitt; n_row = Zeilenanzahl der Hankelmatrix; ' ...
                            'n_0 = Anzahl der Ausgangskanäle']);
                    end            

                    % Fehlermeldung falls maximale Model-Order nicht eingegeben
                    if isempty(max_model_order2)
                        error('Maxiamale Model-Order nicht eingegeben!');
                    end
            
                    % Fehlermeldung falls maximale Model-Order nicht gültig
                    max_model_order2 = str2double(max_model_order2);
                    num_output = num_direct*num_sensor;
                    num_block=fix(num_row_hankel/num_output);
                    if mod(num_block,2) ~= 0
                        num_block = num_block - 1;
                    end
                    if max_model_order2 == 0
                        error(['Maximale Model-Order nicht gültig! Sie muss größer ' ...
                            'als 0 sein!'])
                    elseif max_model_order2 > num_output*num_block/2
                        error(['Maximale Model-Order nicht gültig! Sie darf nicht größer als (n_0*n_block)/2, wobei: ' ...
                            'n_0 = Anzahl der Ausgangskanäle; n_block = n_row/n_0 auf GERADE Zahl abgerundet; n_row = Zeilenanzahl der Hankelmatrix']);                        
                    end                                       
            end
        end

        % Wenn der Anteil der ignorierten Zeilen mehr als 5% der gesamten
        % Messdaten überschreitet, den Benutzer warnen
        percentage = str2double(num_ignore_row) / size(data_matrix,1)*100;
        if (percentage > 5)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(fig, ['Der Anteil der ignorierten Zeilen überschreitet ' ...
                '5% der gesamten Messdaten. Möchten Sie trotzdem fortfahren?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);

            % Wahl von Benutzer
            switch choice

                % Wenn "nein", Vorgang abbrechen
                case 'Nein'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Vorgang abgebrochen ', 'erfolg');
                    return;

                % Wenn "ja", weiter
                case 'Ja'
            end
        end

        %---------------------------------------------------------------------%
        %                    Aktuelle Parameter speichern
        %---------------------------------------------------------------------%
        % Anzahl der Abschnitte speichern
        app.fig.UserData.cache.monitor.current_parameter.num_segment = num_segment;

        % Alle gewählten OMA-Methoden durchlaufen
        for j = 1:numel(oma_list)

            % Aktuelle OMA-Methode holen
            oma_current = oma_list{j};
            switch oma_current

                % Wenn FDD gewählt
                case 'FDD'  

                    % Wenn Direkt gewählt
                    if psd_mode_direct.Value
                        fdd_mode = 'Direkt';

                        % Parameter für FDD speichern
                        app.fig.UserData.cache.monitor.current_parameter.fdd = struct( ...
                            'freq_limit', freq_limit, ...
                            'lowest_freq', lowest_freq, ...    
                            'num_segment', num_segment, ...
                            'freq_threshold', freq_threshold, ...
                            'mac_threshold', mac_threshold, ...
                            'fdd_mode', fdd_mode);

                    % Wenn Welch gewählt
                    elseif psd_mode_welch.Value
                        fdd_mode = 'Welch';

                        % Parameter für FDD speichern
                        app.fig.UserData.cache.monitor.current_parameter.fdd = struct( ...
                            'freq_limit', freq_limit, ...
                            'lowest_freq', lowest_freq, ...  
                            'num_segment', num_segment, ...  
                            'freq_threshold', freq_threshold, ...
                            'mac_threshold', mac_threshold, ...
                            'fdd_mode', fdd_mode);

                    % Wenn Benutzerdefiniert gewählt
                    elseif psd_mode_user_defined.Value
                        fdd_mode = 'User';

                        % Parameter für FDD speichern
                        app.fig.UserData.cache.monitor.current_parameter.fdd = struct( ...
                            'freq_limit', freq_limit, ...
                            'lowest_freq', lowest_freq, ...
                            'num_segment', num_segment, ...
                            'freq_threshold', freq_threshold, ...
                            'mac_threshold', mac_threshold, ...
                            'fdd_mode', fdd_mode, ...
                            'window_func', window_func, ...
                            'window_size', window_size, ...
                            'overlap', overlap, ...
                            'num_fft', num_fft);
                    end

                % Wenn SSI-COV gewählt
                case 'SSI-COV'

                    % Parameter für SSI-COV speichern
                    app.fig.UserData.cache.monitor.current_parameter.cov = struct( ...
                        'freq_limit', freq_limit, ...
                        'lowest_freq', lowest_freq, ...  
                        'num_segment', num_segment, ...  
                        'freq_threshold', freq_threshold, ...
                        'mac_threshold', mac_threshold, ...
                        'max_lag', max_lag, ...
                        'max_model_order', max_model_order, ...
                        'freq_variation', freq_variation, ...
                        'damping_variation', damping_variation, ...
                        'mac_variation', mac_spinner_ssi_cov);               

                    % Parameter für Cluster-Analyse speichern
                    app.fig.UserData.cache.monitor.current_parameter.cov_cluster = struct( ...
                        'freq_limit', freq_limit, ...
                        'lowest_freq', lowest_freq, ...  
                        'num_segment', num_segment, ...    
                        'freq_threshold', freq_threshold, ...
                        'mac_threshold', mac_threshold, ...
                        'max_lag', max_lag, ...
                        'max_model_order', max_model_order, ...
                        'freq_variation', freq_variation, ...
                        'damping_variation', damping_variation, ...
                        'mac_variation', mac_spinner_ssi_cov, ...                            
                        'crit_stable_freq_tick', crit_stable_freq_tick, ...
                        'crit_stable_damp_tick', crit_stable_damp_tick, ...
                        'crit_mac_tick', crit_mac_tick, ...
                        'num_mode_known_choice_ssi_cov', num_mode_known_choice_ssi_cov, ...
                        'cluster_distance', cluster_distance, ...
                        'min_cluster_size', min_cluster_size, ...
                        'target_num_ssi_cov', target_num_ssi_cov);                    

                % Wenn SSI-DATA gewählt
                case 'SSI-DATA'

                    % Parameter für SSI-DATA speichern
                    app.fig.UserData.cache.monitor.current_parameter.data = struct( ...
                        'freq_limit', freq_limit, ...
                        'lowest_freq', lowest_freq, ...    
                        'num_segment', num_segment, ...  
                        'freq_threshold', freq_threshold, ...
                        'mac_threshold', mac_threshold, ...
                        'num_row_hankel', num_row_hankel, ...
                        'num_col_hankel', num_col_hankel, ...
                        'max_model_order', max_model_order2, ...
                        'freq_variation', freq_variation2, ...
                        'damping_variation', damping_variation2, ...
                        'mac_variation', mac_spinner_ssi_data);                  

                    % Parameter für Cluster-Analyse speichern
                    app.fig.UserData.cache.monitor.current_parameter.data_cluster = struct( ...
                        'freq_limit', freq_limit, ...
                        'lowest_freq', lowest_freq, ...  
                        'num_segment', num_segment, ... 
                        'freq_threshold', freq_threshold, ...
                        'mac_threshold', mac_threshold, ...
                        'num_row_hankel', num_row_hankel, ...
                        'num_col_hankel', num_col_hankel, ...
                        'max_model_order', max_model_order2, ...
                        'freq_variation', freq_variation2, ...
                        'damping_variation', damping_variation2, ...
                        'mac_variation', mac_spinner_ssi_data, ...                            
                        'crit_stable_freq_tick', crit_stable_freq_tick2, ...
                        'crit_stable_damp_tick', crit_stable_damp_tick2, ...
                        'crit_mac_tick', crit_mac_tick2, ...
                        'num_mode_known_choice_ssi_cov', num_mode_known_choice_ssi_data, ...
                        'cluster_distance', cluster_distance2, ...
                        'min_cluster_size', min_cluster_size2, ...
                        'target_num_ssi_cov', target_num_ssi_data);                                    
            end
        end

        %---------------------------------------------------------------------%
        %             Prüfen, ob Ergebnisse schon vorhanden sind
        %---------------------------------------------------------------------% 
        % Ergebnisse holen
        fdd_result = app.fig.UserData.cache.monitor.fdd_result;
        cov_all_pole = app.fig.UserData.cache.monitor.cov_all_pole;
        data_all_pole = app.fig.UserData.cache.monitor.data_all_pole;

        % Wenn Zustandsüberwachung schon durchgeführt wurden, den Benutzer warnen
        if any(~isempty(fdd_result)) || any(~isempty(cov_all_pole)) || ...
            any(~isempty(data_all_pole))

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(fig, ['Zustandsüberwachung bereits durchgeführt. Ergebnisse mit unveränderten ' ...
                'Parametern werden beibehalten, während andere Ergebnisse gelöscht und neu ' ...
                'berechnet werden. Möchten Sie fortfahren?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);
            
            % Wahl von Benutzer
            switch choice

                % Wenn "nein", Ergebnisse beibehalten und weiter
                case 'Nein'
                    
                    % Status aktualisieren
                    update_status(status, lamp, '>> Ergebnisse beibehalten ', 'erfolg');
                    return;
                
                % Wenn "ja", Ergebnisse löschen und relevante Komponenten zurücksetzen
                case 'Ja'

                    % Betroffene Tabs zurücksetzen
                    app = reset_partial_app(app, 'monitor_result');

                    % Status aktualisieren
                    update_status(status, lamp, '>> Relevante Ergebnisse gelöscht', 'erfolg');
                    pause(1);
            end            
        end

        % Falls EFDD nach automatischer Polauswahl angeschaltet ist,
        % dann muss EFDD in die Liste hinzugefügt werden
        if oma_fdd_tick && strcmp(efdd_auto_peak_choice, 'An') 
            oma_list = [oma_list(1), 'EFDD', oma_list(2:end)];
        end        

        %---------------------------------------------------------------------%
        %                  Zustandsüberwachung durchführen
        %---------------------------------------------------------------------% 
        run_monitor_button_pushed_main(app.fig, app, oma_list);        
        
    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
        return;
    end
end