%% Callback für Button zum Übernehmen der MAC
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function adopt_mac_button_pushed(app, fig)
    
    % Nötige Variablen holen
    choose_peak_button = app.choose_peak_button;            % Button für Auswahlen der Peaks
    correlation_type_ifft = app.correlation_type_ifft;      % Radiobutton für IFFT
    correlation_type_cos = app.correlation_type_cos;        % Radiobutton für Kosinustransformation
    sbf_graph = app.sbf_graph;                              % Graph für SBF
    freq_mac_table = app.freq_mac_table;                    % Tabelle für Frequenzen und MAC-Grenzen
    mac_spinner = app.mac_spinner3;                         % Spinner für MAC-Grenze
    psd_graph3 = app.psd_graph3;                            % Graph für 1. Singulärwerte der PSD in [dB]
    freq_damp_table_efdd = app.freq_damp_table_efdd;        % Tabelle für Ergebisse (Sub-Tab "Dämpfung in EFDD", Tab "FDD / EFDD")  
    oma_dropdown = app.oma_dropdown;                        % Dropdown für OMA-Methoden
    freq_damp_table = app.freq_damp_table;                  % Tabelle für Ergebnisse (Tab "Ergebnis")
    eigenform_graph = app.eigenform_graph;                  % Graph für Eigenform
    update_eigenform_button = app.update_eigenform_button;  % Button für Darstellen der Eigenform
    oma_efdd_check2 = app.oma_efdd_check2;                  % Wahl für EFDD (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table2 = app.freq_damp_table2;                % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_efdd_check3 = app.oma_efdd_check3;                  % Wahl für EFDD (Sub-Tab "Eigenform", Tab "Export")
    freq_damp_table3 = app.freq_damp_table3;                % Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

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

        % Fehlermeldung falls EFDD noch nicht durchgeführt wurde
        if isempty([app.fig.UserData.cache.modal.efdd_result])
            error('EFDD nicht durchgeführt!');
        end

        % Dargestellte Mode und MAC holen
        mode_num = sbf_graph.UserData.mode_num;
        mac_on_graph = sbf_graph.UserData.mac;

        % Fehlermeldung falls keine SBF dargestellt wurde
        if isnan(mode_num)
            error('Keine SBF dargestellt!');
        end

        % MAC-Grenze holen
        mac_new = mac_spinner.Value/100;   

        % Gewählte Zeile holen
        row_selected = freq_mac_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(freq_mac_table.Data, 1)
            error('Keine Zeile gewählt!');
        end         

        % Fehlermeldung falls SBF für diese MAC noch nicht dargestellt
        % wurde
        if mac_new ~= mac_on_graph || row_selected ~= mode_num
            error('SBF dafür noch nicht dargestellt!');
        end

        % Wenn eine Mode bereits untersucht wurde, muss der Tab erneut
        % erstellt werden
        if ~isnan(psd_graph3.UserData.mode_num)

            % Betroffene Tabs zurücksetzen
            app = reset_partial_app(app, 'efdd_daempfung'); 

            % Diesen Callback erneut rufen
            adopt_mac_button_pushed(app, app.fig);
            return;  
        end

        % Ergebnisse der FDD holen
        F = app.fig.UserData.cache.modal.fdd_result.F;
        PSD = app.fig.UserData.cache.modal.fdd_result.PSD;
        U = app.fig.UserData.cache.modal.fdd_result.U;
        eigenfreq_current = app.fig.UserData.cache.modal.efdd_result(mode_num).freq_fdd;
        damping_ratio = app.fig.UserData.cache.modal.efdd_result(mode_num).damping_ratio;

        % Wenn Dämpfungsgrad für diese Mode bereits ermittelt wurde, den Benutzer warnen
        if ~isnan(damping_ratio)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(fig, ['Dämpfungsgrad für diese Mode bereits ermittelt. ' ...
                'Dieser wird gelöscht. Möchten Sie fortfahren?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);

            % Wahl von Benutzer
            switch choice

                % Wenn "nein", Ergebnisse beibehalten und weiter
                case 'Nein'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Ergebnisse beibehalten ', 'erfolg');
                    return;

                % Wenn "ja", Dämpfungsgrad löschen
                case 'Ja'

                    % Daten zurücksetzen
                    app.fig.UserData.cache.modal.efdd_result(mode_num).damping_ratio = NaN;

                    % Status aktualisieren
                    update_status(status, lamp, '>> Dämpfungsgrad gelöscht', 'erfolg');
                    pause(1);
            end            
        end 

        % Zeitvektor holen
        time_vector = data_matrix(:,1);

        % Einstellung für Korrelationsfunktion holen
        if correlation_type_ifft.Value
            correlation_type = 'IFFT';
        elseif correlation_type_cos.Value
            correlation_type = 'Cos';       
        end         

        % EFDD durchführen
        [SBF, mode_shape, time_recon, signal_recon, freq_d, peak_info] = compute_efdd(F, PSD, eigenfreq_current, mac_new, U, time_vector, sampling_freq, correlation_type);

        % Variablen speichern
        app.fig.UserData.cache.modal.efdd_result(mode_num).freq_fdd = eigenfreq_current;
        app.fig.UserData.cache.modal.efdd_result(mode_num).mac = mac_new;
        app.fig.UserData.cache.modal.efdd_result(mode_num).SBF = SBF;
        app.fig.UserData.cache.modal.efdd_result(mode_num).mode_shape = mode_shape;
        app.fig.UserData.cache.modal.efdd_result(mode_num).time_recon = time_recon;
        app.fig.UserData.cache.modal.efdd_result(mode_num).signal_recon = signal_recon;
        app.fig.UserData.cache.modal.efdd_result(mode_num).freq_d = freq_d;
        app.fig.UserData.cache.modal.efdd_result(mode_num).damping_ratio = NaN;
        app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info = peak_info; 

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

        % Ergebnisse in restlichen GUI-Komponenten aktualisieren
        update_result(eigenform_graph, freq_d_chosen', damping_ratio_chosen', oma_dropdown, ...
            "EFDD", freq_damp_table, freq_damp_table2, freq_damp_table3, oma_efdd_check2, oma_efdd_check3);              

        % Status aktualisieren
        update_status(status, lamp, '>> MAC übernommen', ...
            'erfolg');         

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end           