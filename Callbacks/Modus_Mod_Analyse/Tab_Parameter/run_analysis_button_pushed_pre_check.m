%% Callback für Vorbereitung vor der Modalanalyse
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function run_analysis_button_pushed_pre_check(fig, app)
    
    % Nötige Variablen holen
    oma_fdd_tick = app.oma_fdd_check.Value;                                 % Wahl für FDD
    oma_ssi_cov_tick = app.oma_ssi_cov_check.Value;                         % Wahl für SSI-COV
    oma_ssi_data_tick = app.oma_ssi_data_check.Value;                       % Wahl für SSI-DATA    
    freq_limit = str2double(app.freq_limit_edit_field.Value);               % Frequenzgrenze
    lowest_freq = str2double(app.lowest_freq_edit_field.Value);             % Niedrigste zu untersuchende Frequenz
    psd_mode_direct= app.psd_mode_direct;                                   % Radiobutton für direkt
    psd_mode_welch = app.psd_mode_welch;                                    % Radiobutton für Welch
    psd_mode_user_defined = app.psd_mode_user_defined;                      % Radiobutton für benutzerdefiniert    
    window_func = app.window_func_dropdown.Value;                           % Fensterfunktion
    window_size = app.window_size_dropdown.Value;                           % Größe eines Fensters  
    overlap = app.overlap_dropdown.Value;                                   % Prozentsatz der Überlappung
    num_fft = app.num_fft_dropdown.Value;                                   % Anzahl der DFT-Punkte        
    max_lag = app.max_lag_edit_field.Value;                                 % Maximaler verzögerter Zeitschritt
    max_model_order = app.max_model_order_edit_field.Value;                 % Maximale Model-Order (Sub-Tab "SSI-COV", Tab "Parameter")
    freq_variation = app.freq_variation_spinner.Value;                      % Grenzwert für stabile Frequenz (Sub-Tab "SSI-COV", Tab "Parameter")
    damping_variation = app.damping_variation_spinner.Value;                % Grenzwert für stabilen Dämpfungsgrad (Sub-Tab "SSI-COV", Tab "Parameter")
    mac_spinner_ssi_cov = app.mac_spinner.Value;                            % Grenzwert für "MAC-Bedingung erfüllt" (Sub-Tab "SSI-COV", Tab "Parameter")
    auto_pol_choice = app.auto_pol_switch.Value;                            % Wahl für automatische Polauswahl (Sub-Tab "SSI-COV", Tab "Parameter")
    crit_stable_freq_tick = app.criteria_stable_freq_check.Value;           % Wahl für stabile Frequenz (Sub-Tab "SSI-COV", Tab "Parameter")
    crit_stable_damp_tick = app.criteria_stable_damp_check.Value;           % Wahl für stabilen Dämpfungsgrad (Sub-Tab "SSI-COV", Tab "Parameter")
    crit_mac_tick = app.criteria_mac_check.Value;                           % Wahl für MAC-Bedingung erfüllt (Sub-Tab "SSI-COV", Tab "Parameter")
    num_mode_known_choice_ssi_cov = app.num_mode_known_ssi_cov.Value;       % Wahl für Anzahl der Moden (Sub-Tab "SSI-COV", Tab "Parameter")
    cluster_distance = app.cluster_distance_spinner.Value;                  % Cluster-Distanzschwelle (Sub-Tab "SSI-COV", Tab "Parameter")
    min_cluster_size = app.min_cluster_size_spinner.Value;                  % Mindestgröße eines Clusters (Sub-Tab "SSI-COV", Tab "Parameter")
    target_num_ssi_cov = app.target_num_spinner_ssi_cov.Value;              % Zielanzahl (Sub-Tab "SSI-COV", Tab "Parameter")
    num_row_hankel = app.num_row_hankel_edit_field.Value;                   % Zeilenanzahl der Hankelmatrix
    num_col_hankel = app.num_col_hankel_edit_field.Value;                   % Spaltenanzahl der Hankelmatrix
    max_model_order2 = app.max_model_order_edit_field2.Value;               % Maximale Model-Order (Sub-Tab "SSI-DATA", Tab "Parameter")
    freq_variation2 = app.freq_variation_spinner2.Value;                    % Grenzwert für stabile Frequenz (Sub-Tab "SSI-DATA", Tab "Parameter")
    damping_variation2 = app.damping_variation_spinner2.Value;              % Grenzwert für stabilen Dämpfungsgrad (Sub-Tab "SSI-DATA", Tab "Parameter")
    mac_spinner_ssi_data = app.mac_spinner5.Value;                          % Grenzwert für "MAC-Bedingung erfüllt" (Sub-Tab "SSI-DATA", Tab "Parameter")
    auto_pol_choice2 = app.auto_pol_switch2.Value;                          % Switch für automatische Polauswahl (Sub-Tab "SSI-DATA", Tab "Parameter")
    crit_stable_freq_tick2 = app.criteria_stable_freq_check2.Value;         % Checkbox für stabile Frequenz (Sub-Tab "SSI-DATA", Tab "Parameter")
    crit_stable_damp_tick2 = app.criteria_stable_damp_check2.Value;         % Checkbox für stabilen Dämpfungsgrad (Sub-Tab "SSI-DATA", Tab "Parameter")
    crit_mac_tick2 = app.criteria_mac_check2.Value;                         % Checkbox für MAC-Bedingung erfüllt (Sub-Tab "SSI-DATA", Tab "Parameter")
    num_mode_known_choice_ssi_data = app.num_mode_known_ssi_data.Value;     % Wahl für Anzahl der Moden (Sub-Tab "SSI-DATA", Tab "Parameter")
    cluster_distance2 = app.cluster_distance_spinner2.Value;                % Cluster-Distanzschwelle (Sub-Tab "SSI-DATA", Tab "Parameter")
    min_cluster_size2 = app.min_cluster_size_spinner2.Value;                % Mindestgröße eines Clusters (Sub-Tab "SSI-DATA", Tab "Parameter")
    target_num_ssi_data = app.target_num_spinner_ssi_data.Value;            % Zielanzahl (Sub-Tab "SSI-DATA", Tab "Parameter")
    update_eigenform_button = app.update_eigenform_button;                  % Button für Darstellen der Eigenform   
    lamp = app.status_lamp;                                                 % Licht des Status
    status = app.status_text_area;                                          % Textfeld des Status
    
    try
        %---------------------------------------------------------------------%
        %                   Gewählte OMA-Methoden sammeln
        %---------------------------------------------------------------------%  
        % Liste für OMA-Methoden
        oma_list = {};  
        ssi_list = {};

        % OMA-Methoden sammeln
        if oma_fdd_tick
            oma_list{end+1} = 'FDD';
        end
        if oma_ssi_cov_tick
            oma_list{end+1} = 'SSI-COV';
            ssi_list{end+1} = 'SSI-COV';
        end        
        if oma_ssi_data_tick
            oma_list{end+1} = 'SSI-DATA';
            ssi_list{end+1} = 'SSI-DATA';
        end

        % Wenn keine SSI gewählt wurde, SSI-COV zwangsläufig hinzufügen
        if isempty(ssi_list)
            ssi_list = {'SSI-COV'};
        end

        %---------------------------------------------------------------------%
        %            Nach fehlenden oder falschen Eingaben prüfen
        %---------------------------------------------------------------------%        
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Messdaten und Infos holen
        data_matrix = app.fig.UserData.cache.modal.data_matrix;
        sampling_freq = app.fig.UserData.cache.modal.sampling_freq;
        num_sensor = app.fig.UserData.cache.modal.num_sensor;
        num_direct = sum(app.fig.UserData.cache.modal.direction);

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
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
                            
                            % Gesamte Messdaten dafür holen
                            window_size = size(data_matrix, 1);

                        % Sonst einfach die gewählte Anzahl holen
                        else
                            window_size = str2double(window_size);
                        end

                        % Fehlermeldung falls Größe eines Fensters größer als
                        % gesamte Messdaten
                        if window_size > size(data_matrix, 1)
                            error(['Größe eines Fensters darf nicht größer ' ...
                                'als gesamte Messdaten sein!']);
                        end

                        % Wenn gesamte Messdaten für Anzahl der DFT-Punkte gewählt wurde
                        if strcmp(num_fft, 'Gesamte Messdaten')
                            
                            % Gesamte Messdaten dafür holen
                            num_fft = size(data_matrix, 1);

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
                    elseif num_col_hankel > length(data_matrix)+1-num_row_hankel/num_sensor
                        error(['Spaltenanzahl der Hankelmatrix nicht gültig! Sie darf nicht größer als N+1-n_row/n_0, wobei: ' ...
                            'N = Anzahl der Zeitschritte; n_row = Zeilenanzahl der Hankelmatrix; n_0 = Anzahl der Ausgangskanäle']);
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

        %---------------------------------------------------------------------%
        %                    Aktuelle Parameter speichern
        %---------------------------------------------------------------------%
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
                        app.fig.UserData.cache.modal.current_parameter.fdd = struct( ...
                            'freq_limit', freq_limit, ...
                            'lowest_freq', lowest_freq, ...                            
                            'fdd_mode', fdd_mode);
    
                    % Wenn Welch gewählt
                    elseif psd_mode_welch.Value
                        fdd_mode = 'Welch';
    
                        % Parameter für FDD speichern
                        app.fig.UserData.cache.modal.current_parameter.fdd = struct( ...
                            'freq_limit', freq_limit, ...
                            'lowest_freq', lowest_freq, ...                            
                            'fdd_mode', fdd_mode);
    
                    % Wenn Benutzerdefiniert gewählt
                    elseif psd_mode_user_defined.Value
                        fdd_mode = 'User';
    
                        % Parameter für FDD speichern
                        app.fig.UserData.cache.modal.current_parameter.fdd = struct( ...
                            'freq_limit', freq_limit, ...
                            'lowest_freq', lowest_freq, ...
                            'fdd_mode', fdd_mode, ...
                            'window_func', window_func, ...
                            'window_size', window_size, ...
                            'overlap', overlap, ...
                            'num_fft', num_fft);
                    end
    
                % Wenn SSI-COV gewählt
                case 'SSI-COV'
    
                    % Parameter für SSI-COV speichern
                    app.fig.UserData.cache.modal.current_parameter.cov = struct( ...
                        'freq_limit', freq_limit, ...
                        'lowest_freq', lowest_freq, ...                        
                        'max_lag', max_lag, ...
                        'max_model_order', max_model_order, ...
                        'freq_variation', freq_variation, ...
                        'damping_variation', damping_variation, ...
                        'mac_variation', mac_spinner_ssi_cov);

                    % Falls automatische Polauswahl angeschaltet ist
                    if strcmp(auto_pol_choice, 'An')                    

                        % Parameter für Cluster-Analyse speichern
                        app.fig.UserData.cache.modal.current_parameter.cov_cluster = struct( ...
                            'freq_limit', freq_limit, ...
                            'lowest_freq', lowest_freq, ...                        
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
                    end

                % Wenn SSI-DATA gewählt
                case 'SSI-DATA'
    
                    % Parameter für SSI-DATA speichern
                    app.fig.UserData.cache.modal.current_parameter.data = struct( ...
                        'freq_limit', freq_limit, ...
                        'lowest_freq', lowest_freq, ...                        
                        'num_row_hankel', num_row_hankel, ...
                        'num_col_hankel', num_col_hankel, ...
                        'max_model_order', max_model_order2, ...
                        'freq_variation', freq_variation2, ...
                        'damping_variation', damping_variation2, ...
                        'mac_variation', mac_spinner_ssi_data);

                    % Falls automatische Polauswahl angeschaltet ist
                    if strcmp(auto_pol_choice2, 'An')                    

                        % Parameter für Cluster-Analyse speichern
                        app.fig.UserData.cache.modal.current_parameter.data_cluster = struct( ...
                            'freq_limit', freq_limit, ...
                            'lowest_freq', lowest_freq, ...                        
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
        end

        %---------------------------------------------------------------------%
        %             Prüfen, ob Ergebnisse schon vorhanden sind
        %---------------------------------------------------------------------% 
        % Ergebnisse holen
        fdd_result = app.fig.UserData.cache.modal.fdd_result;
        cov_all_pole = app.fig.UserData.cache.modal.cov_all_pole;
        data_all_pole = app.fig.UserData.cache.modal.data_all_pole;

        % Wenn Modalanalyse schon durchgeführt wurden, den Benutzer warnen
        if any(~isempty(fdd_result)) || any(~isempty(cov_all_pole)) || ...
            any(~isempty(data_all_pole))

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(fig, ['Modalanalyse bereits durchgeführt. Ergebnisse mit unveränderten ' ...
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
                    app = reset_partial_app(app, 'modal_result');

                    % Status aktualisieren
                    update_status(status, lamp, '>> Relevante Ergebnisse gelöscht', 'erfolg');
                    pause(1);
            end            
        end

        %---------------------------------------------------------------------%
        %                      Modalanalyse durchführen
        %---------------------------------------------------------------------% 
        run_analysis_button_pushed_main(app.fig, app, oma_list, ssi_list);        
        
    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
        return;
    end
end