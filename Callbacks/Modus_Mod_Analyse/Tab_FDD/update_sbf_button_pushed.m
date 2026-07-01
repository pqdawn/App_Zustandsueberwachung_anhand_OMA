%% Callback für Button zum Aktualisieren der SBF
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function update_sbf_button_pushed(app)
    
    % Nötige Variablen holen
    choose_peak_button = app.choose_peak_button;                % Button für Auswahlen der Peaks
    sbf_graph = app.sbf_graph;                                  % Graph für SBF    
    sbf_slider = app.sbf_slider;                                % Slider für x-Achse des Graphs für SBF
    sbf_range_check = app.sbf_range_check;                      % Checkbox für fixierten Bereich der x-Achse
    sbf_range_edit_field = app.sbf_range_edit_field;            % Eingabefeld für fixierten Bereich der x-Achse
    freq_mac_table = app.freq_mac_table;                        % Tabelle für Frequenzen und MAC-Grenzen
    mac_spinner = app.mac_spinner3;                             % Spinner für MAC-Grenze  
    update_eigenform_button = app.update_eigenform_button;      % Button für Darstellen der Eigenform
    lamp = app.status_lamp;                                     % Licht des Status
    status = app.status_text_area;                              % Textfeld des Status

    try
        % Fehlermeldung falls keine Daten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
            error('Keine Messdaten importiert!');
        end

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

        % Frequenzen und MAC-Grenzen der gewählten Peaks holen
        freq_mac_matrix = freq_mac_table.Data;

        % Gewählte Zeile holen
        row_selected = freq_mac_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(freq_mac_matrix, 1)
            error('Keine Zeile gewählt!');
        end        

        % Ergebnisse der FDD holen
        F = app.fig.UserData.cache.modal.fdd_result.F;
        PSD = app.fig.UserData.cache.modal.fdd_result.PSD;
        SBF = app.fig.UserData.cache.modal.efdd_result(row_selected).SBF;
        eigenfreq_current = app.fig.UserData.cache.modal.efdd_result(row_selected).freq_fdd;

        % MAC-Grenzen holen
        mac_prev = app.fig.UserData.cache.modal.efdd_result(row_selected).mac;
        mac_new = mac_spinner.Value/100;      

        % Wenn MAC von Spinner anders ist, muss SBF erneut durchgeführt werden
        if mac_prev ~= mac_new
        
            % SBF berechnen
            SBF = compute_sbf(F, PSD, eigenfreq_current, mac_new); 
        end

        % Graph aktualisieren
        plot_sbf(sbf_graph, F, SBF, sbf_slider, sbf_range_check, sbf_range_edit_field, eigenfreq_current, mac_new);

        % Variablen speichern
        sbf_graph.UserData.mode_num = row_selected;
        sbf_graph.UserData.mac = mac_new;

        % Status aktualisieren
        update_status(status, lamp, '>> SBF aktualisiert', ...
            'erfolg');         

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end   