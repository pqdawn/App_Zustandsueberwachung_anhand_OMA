%% Callback für Button zur Untersuchung der Mode
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function examine_mode_button_pushed(app)
    
    % Nötige Variablen holen
    choose_peak_button = app.choose_peak_button;                % Button für Auswahlen der Peaks
    psd_graph = app.psd_graph3;                                 % Graph für 1. Singulärwerte der PSD in [dB]
    backsignal_graph = app.backsignal_graph;                    % Graph für Korrelationsfunktion der 1. Singulärwerte
    log_graph = app.log_graph;                                  % Graph für lineare Regression des logarithmischen Dekrements
    slider = app.backsignal_slider;                             % Slider für x-Achse des Graphs für lineare Regression
    range_check = app.backsignal_range_check;                   % Checkbox für fixierten Bereich der x-Achse
    range_edit_field = app.backsignal_range_edit_field;         % Eingabefeld für fixierten Bereich der x-Achse
    freq_damp_table = app.freq_damp_table_efdd;                 % Tabelle für Ergebisse
    mean_edit_field = app.mean_edit_field;                      % Eingabefeld für Mittelwert
    standard_dev_edit_field = app.standard_dev_edit_field;      % Eingabefeld für Standardabweichung
    cov_edit_field = app.cov_edit_field;                        % Eingabefeld für Variationskoeffizient
    cov_lamp = app.cov_lamp;                                    % Lampe für Variationskoeffizient
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

        % Fehlermeldung falls EFDD noch nicht durchgeführt wurde
        if isempty([app.fig.UserData.cache.modal.efdd_result])
            error('EFDD nicht durchgeführt!');
        end        

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
        end

        % Gewählte Zeile holen
        row_selected = freq_damp_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(freq_damp_table.Data, 1)
            error('Keine Zeile gewählt!');
        end 

        % Ergebnisse der FDD holen
        fdd_result = app.fig.UserData.cache.modal.fdd_result;
        F = app.fig.UserData.cache.modal.fdd_result.F;

        % Ergebnisse der EFDD holen
        freq_d_current = app.fig.UserData.cache.modal.efdd_result(row_selected).freq_d;
        SBF = app.fig.UserData.cache.modal.efdd_result(row_selected).SBF;
        time_recon = app.fig.UserData.cache.modal.efdd_result(row_selected).time_recon;
        signal_recon = app.fig.UserData.cache.modal.efdd_result(row_selected).signal_recon;
        peak_info = app.fig.UserData.cache.modal.efdd_result(row_selected).peak_info;
        idx_peak_start_final = peak_info.idx_peak_start_final;
        idx_peak_end_final = peak_info.idx_peak_end_final;

        % Wenn keine endgültigen Grenzen übernommen wurden, müssen die
        % Grenzen erneut werden
        if isnan(idx_peak_start_final) && isnan(idx_peak_end_final)
            app.fig.UserData.cache.modal.efdd_result(row_selected).peak_info.idx_peak_start = 1;
            app.fig.UserData.cache.modal.efdd_result(row_selected).peak_info.idx_peak_end = length(peak_info.peak_value_log);
        
        % Sonst müssen die endgültigen Grenzen für den Graph eingesetzt
        % werden
        else
            app.fig.UserData.cache.modal.efdd_result(row_selected).peak_info.idx_peak_start = idx_peak_start_final;
            app.fig.UserData.cache.modal.efdd_result(row_selected).peak_info.idx_peak_end = idx_peak_end_final;
        end

        % Grenzen aktualisieren
        peak_info = app.fig.UserData.cache.modal.efdd_result(row_selected).peak_info;

        % Graph für 1. Singulärwerte der PSD
        plot_eigenvalue_psd_db(psd_graph, fdd_result, []);
        hold(psd_graph, 'on');
        plot(psd_graph, F(SBF~=0), mag2db(SBF(SBF~=0)));
        headline = ['\textbf{1. Singul\"arwerte der PSD f\"ur Frequenz ', num2str(freq_d_current), ' Hz}'];
        psd_graph.Title.String = headline;
        hold(psd_graph, 'off');

        % Variable speichern
        psd_graph.UserData.mode_num = row_selected;

        % Graph für Korrelationsfunktion der 1. Singulärwerte
        plot_backsignal(backsignal_graph, time_recon, signal_recon, freq_d_current, peak_info, slider, range_check, range_edit_field);

        % Graph für lineare Regressen des logarithmischen Dekrements
        plot_log(log_graph, freq_d_current, peak_info, true);   

        % Dämpfungsgrad berechnen
        [mu, sigma] = compute_damping_ratio(peak_info.peak_value_signal, peak_info.idx_peak_start, peak_info.idx_peak_end);
        cov = sigma/mu*100;

        % Ergebnisse aktualisieren
        mean_edit_field.Value = sprintf('%.6f', mu);
        standard_dev_edit_field.Value = sprintf('%.6f', sigma);
        cov_edit_field.Value = sprintf('%.2f%%', cov);

        % Lampe aktualisieren
        if cov < 20
            cov_lamp.Color = [0 1 0];       % grün
        elseif cov < 40
            cov_lamp.Color = [1, 0.5, 0];   % orange
        else
            cov_lamp.Color = [1, 0, 0];     % rot
        end

        % Status aktualisieren
        update_status(status, lamp, '>> Graphen aktualisiert', ...
            'erfolg');         

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end         