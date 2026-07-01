%% Callback für Button zum Durchführen der EFDD
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function run_efdd_button_pushed(fig, app)
    
    % Nötige Variablen holen
    choose_peak_button = app.choose_peak_button;                    % Button für Auswahlen der Peaks
    correlation_type_ifft = app.correlation_type_ifft;              % Radiobutton für IFFT
    correlation_type_cos = app.correlation_type_cos;                % Radiobutton für Kosinustransformation
    mac_spinner = app.mac_spinner2;                                 % Spinner für MAC-Grenze (Sub-Tab "Singulärwerte der PSD", Tab "FDD / EFDD")   
    freq_mac_table = app.freq_mac_table;                            % Tabelle für Frequenzen und MAC-Grenzen
    mac_spinner_sbf = app.mac_spinner3;                             % Spinner für MAC-Grenze (Sub-Tab "SBF", Tab "FDD / EFDD")   
    freq_damp_table_efdd = app.freq_damp_table_efdd;                % Tabelle für Ergebisse (Sub-Tab "Dämpfung in EFDD", Tab "FDD / EFDD")   
    oma_dropdown = app.oma_dropdown;                                % Dropdown für OMA-Methoden
    freq_damp_table = app.freq_damp_table;                          % Tabelle für Ergebnisse (Tab "Ergebnis")
    eigenform_graph = app.eigenform_graph;                          % Graph für Eigenform
    update_eigenform_button = app.update_eigenform_button;          % Button für Darstellen der Eigenform
    oma_efdd_check2 = app.oma_efdd_check2;                          % Wahl für EFDD (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table2 = app.freq_damp_table2;                        % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")  
    oma_efdd_check3 = app.oma_efdd_check3;                          % Wahl für EFDD (Sub-Tab "Eigenform", Tab "Export")
    freq_damp_table3 = app.freq_damp_table3;                        % Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                         % Licht des Status
    status = app.status_text_area;                                  % Textfeld des Status

    try
        % Fehlermeldung falls keine Daten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Messdaten und Infos holen
        data_matrix = app.fig.UserData.cache.modal.data_matrix;
        sampling_freq = app.fig.UserData.cache.modal.sampling_freq;        

        % Fehlermeldung falls FDD nicht durchgeführt
        if isempty(app.fig.UserData.cache.modal.fdd_result)
            error('FDD nicht durchgeführt!');
        end

        % Fehlermeldung falls Peakauswahl noch läuft
        if choose_peak_button.UserData.is_selecting == true
            error('Auwahlen der Peaks erstmal beenden!');
        end        

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
        end

        % Fehlermeldung falls noch kein Peak ausgewählt wurde
        if isempty(app.fig.UserData.cache.modal.selected_peak)
            error('Kein Peak ausgewählt!');
        end

        % Ergebnisse der FDD holen
        F = app.fig.UserData.cache.modal.fdd_result.F;
        PSD = app.fig.UserData.cache.modal.fdd_result.PSD;
        U = app.fig.UserData.cache.modal.fdd_result.U;
        eigenfreq_chosen = [app.fig.UserData.cache.modal.selected_peak.freq];
        efdd_result = [app.fig.UserData.cache.modal.efdd_result];

        % Wenn EFDD schon durchgeführt wurden, den Benutzer warnen
        if ~isempty(efdd_result)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(fig, ['EFDD bereits durchgeführt. Alle EFDD-Ergebnisse ' ...
                'werden gelöscht. Möchten Sie fortfahren?'],'Warnung', ...
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

                    % Daten zurücksetzen
                    app.fig.UserData.cache.modal.efdd_result = struct([]);
                    
                    % Betroffene Tabs zurücksetzen
                    app = reset_partial_app(app, 'efdd');

                    % Status aktualisieren
                    update_status(status, lamp, '>> EFDD-Ergebnisse gelöscht', 'erfolg');
                    pause(1);

                    % Diesen Callback erneut rufen
                    run_efdd_button_pushed(app.fig, app);
                    return;                    
            end            
        end         

        % Einstellung für Korrelationsfunktion holen
        if correlation_type_ifft.Value
            correlation_type = 'IFFT';
        elseif correlation_type_cos.Value
            correlation_type = 'Cos';       
        end        
            
        % MAC-Grenze berechnen
        mac = mac_spinner.Value/100;

        % Zeitvektor holen
        time_vector = data_matrix(:,1);      

        % Alle Eigenfrequenzen durchlaufen
        for i = 1:length(eigenfreq_chosen)

            % EFDD durchführen
            [SBF, mode_shape, time_recon, signal_recon, freq_d, peak_info] = compute_efdd(F, PSD, eigenfreq_chosen(i), mac, U, time_vector, sampling_freq, correlation_type);

            % Variablen speichern
            app.fig.UserData.cache.modal.efdd_result(i).freq_fdd = eigenfreq_chosen(i);
            app.fig.UserData.cache.modal.efdd_result(i).mac = mac;
            app.fig.UserData.cache.modal.efdd_result(i).SBF = SBF;
            app.fig.UserData.cache.modal.efdd_result(i).mode_shape = mode_shape;
            app.fig.UserData.cache.modal.efdd_result(i).time_recon = time_recon;
            app.fig.UserData.cache.modal.efdd_result(i).signal_recon = signal_recon;
            app.fig.UserData.cache.modal.efdd_result(i).freq_d = freq_d;
            app.fig.UserData.cache.modal.efdd_result(i).damping_ratio = NaN;
            app.fig.UserData.cache.modal.efdd_result(i).peak_info = peak_info; 
        end

        % Ergebnisse der EFDD holen
        eigenfreq_chosen = [app.fig.UserData.cache.modal.efdd_result.freq_fdd];
        freq_d_chosen = [app.fig.UserData.cache.modal.efdd_result.freq_d];
        damping_ratio_chosen = [app.fig.UserData.cache.modal.efdd_result.damping_ratio];
        mac_chosen =  [app.fig.UserData.cache.modal.efdd_result.mac];

        % Tabelle aktualisieren
        mac_string = string(compose('%.0f', mac_chosen * 100));      
        freq_mac_table.Data = [eigenfreq_chosen', mac_string'];
        freq_mac_table.ColumnName = {'FDD Freq. [Hz]', 'MAC [%]'};
        freq_mac_table.RowName = 'numbered';  
        freq_damp_table_efdd.Data = [freq_d_chosen', eigenfreq_chosen', damping_ratio_chosen'];
        freq_damp_table_efdd.ColumnName = {'EFDD F. [Hz]', 'FDD F. [Hz]', 'Dämpf. [%]'};
        freq_damp_table_efdd.ColumnWidth = repmat({'1x'}, 1, 2);
        freq_damp_table_efdd.RowName = 'numbered';        

        % Spinner für MAC-Grenze auf dem nächsten Sub-Tab aktualisieren
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

        % Status aktualisieren
        update_status(status, lamp, '>> EFDD durchgeführt und Ergebnisse aktualisiert', ...
            'erfolg');         

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end   