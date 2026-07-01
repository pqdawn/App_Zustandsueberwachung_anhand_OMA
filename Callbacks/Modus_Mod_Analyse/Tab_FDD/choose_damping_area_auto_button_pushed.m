%% Callback für Button zum automatischen Auswählen des Bereiches für Dämpfungsgrad
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function choose_damping_area_auto_button_pushed(app, fig)

    % Nötige Variablen holen
    choose_peak_button = app.choose_peak_button;                % Button für Auswahlen der Peaks
    psd_graph = app.psd_graph3;                                 % Graph für 1. Singulärwerte der PSD in [dB]
    backsignal_graph = app.backsignal_graph;                    % Graph für Korrelationsfunktion der 1. Singulärwerte
    log_graph = app.log_graph;                                  % Graph für lineare Regression des logarithmischen Dekrements
    freq_damp_table_efdd = app.freq_damp_table_efdd;            % Tabelle für Ergebisse
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
        if isempty(app.fig.UserData.cache.modal.efdd_result)
            error('EFDD nicht durchgeführt!');
        end          

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
        end

        % Fehlermeldung falls keine Mode untersucht wurde
        if isempty(backsignal_graph.Children)
            error('Keine Mode untersucht!')
        end

        % Untersuchte Mode holen
        mode_num = psd_graph.UserData.mode_num;

        % Gewählte Zeile holen
        row_selected = freq_damp_table_efdd.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(freq_damp_table_efdd.Data, 1)
            error('Keine Zeile gewählt!');
        end         

        % Fehlermeldung falls diese Mode noch nicht untersucht wurde
        if row_selected ~= mode_num
            error('Mode noch nicht untersucht!');
        end        

        % Ergebnisse der EFDD holen
        eigenfreq_current = app.fig.UserData.cache.modal.efdd_result(mode_num).freq_fdd;
        time_recon = app.fig.UserData.cache.modal.efdd_result(mode_num).time_recon; 
        signal_recon = app.fig.UserData.cache.modal.efdd_result(mode_num).signal_recon;
        peak_value_signal = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.peak_value_signal;
        peak_value_log = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.peak_value_log;

        % Graphen zurücksetzen
        plot(backsignal_graph, time_recon, signal_recon);
        plot(log_graph, peak_value_log, '-o');

        % Eingabefelder zurücksetzen
        mean_edit_field.Value = '';
        standard_dev_edit_field.Value = '';
        cov_edit_field.Value = '';

        % Lampe zurücksetzen
        cov_lamp.Color = [0 1 0];        

        % Indizes der Peaks instanziieren
        idx_of_peak_array = zeros(2,1);

        % Peak mit Amplitude = 0,9 finden
        idx = find(abs(peak_value_signal - 0.9) < 0.01, 1, 'first');

        % Wenn kein Wert der die Bedingung erfüllt, dann einfach den
        % ersten Wert holen
        if isempty(idx)
            idx = 1;
        end
        idx_of_peak_array(1) = idx;

        % Peak mit Amplitude = 0,2 finden
        idx = find(abs(peak_value_signal - 0.2) < 0.01, 1, 'last');

        % Wenn kein Wert der die Bedingung erfüllt, dann einfach den
        % letzten Wert holen
        if isempty(idx)
            idx = length(peak_value_signal);
        end
        idx_of_peak_array(2) = idx;

        % Besten Bereich für Ermittlung des Dämpfungsgrads finden
        best_result = find_best_damping_area_auto(fig, ...
            peak_value_signal, ...
            idx_of_peak_array(1), ...
            idx_of_peak_array(2));

        % Variablen speichern
        app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_peak_start = best_result.idx_start;
        app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_peak_end = best_result.idx_end;

        % Graphen aktualisieren
        plot_backsignal(backsignal_graph, time_recon, signal_recon, eigenfreq_current, app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info);
        plot_log(log_graph, eigenfreq_current, app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info, false);          

        % Ergebnisse aktualisieren
        mean_edit_field.Value = sprintf('%.6f', best_result.mu);
        standard_dev_edit_field.Value = sprintf('%.6f', best_result.sigma);
        cov = best_result.cov*100;
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
        update_status(status, lamp, '>> Bereich automatisch gewählt und Dämpfungsgrad berechnet', ...
            'erfolg');

    % Fehler fangen
    catch ME

        % Status aktualisieren
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end        