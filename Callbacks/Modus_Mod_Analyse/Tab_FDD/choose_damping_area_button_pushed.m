%% Callback für Button zum Auswählen des Bereiches für Dämpfungsgrad
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function choose_damping_area_button_pushed(app, fig)

    % Nötige Variablen holen
    src = app.choose_damping_area_button;                       % Button dieser Funktion
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
        idx_of_peak_in_time = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_of_peak_in_time;
        peak_value_signal = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.peak_value_signal;
        peak_value_log = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.peak_value_log;
        
        % Diesen Button deaktivieren
        src.Enable = 'off';

        % Die Figur der App als aktuelle Figur wählen
        fhv = fig.HandleVisibility;
        fig.HandleVisibility = 'callback';
        set(fig, 'CurrentAxes', backsignal_graph); 

        % Status aktualisieren
        update_status(status, lamp, '----------------------------------------------------------', 'warnung');
        update_status(status, lamp, '2-MAL LINKSKLICK: Grenzen setzen', 'warnung');
        update_status(status, lamp, '----------------------------------------------------------', 'warnung');
        update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');

        % Die anderen Graphen grau färben
        psd_graph.Color = [0.8, 0.8, 0.8];
        log_graph.Color = [0.8, 0.8, 0.8];

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
        selection_num = 1;

        % Solange 2 Grenzen vom Benutzer noch nicht gesetzt werden
        while selection_num <= 2

            % Gewählte Punkt holen
            [x, ~, button] = ginput(1);

            % Wenn Grenze gesetzt wird
            if button == 1

                % Anhand gewählter x-Koordinate Peak finden
                [~, idx] = min(abs(time_recon - x));
                [~, idx] = min(abs(idx_of_peak_in_time - idx));
                idx_of_time_nearest_peak = idx_of_peak_in_time(idx);
                time_of_peak = time_recon(idx_of_time_nearest_peak);
                idx_of_peak = idx;
        
                % Grenze markieren
                xline(backsignal_graph, time_of_peak, 'LineWidth', 2, 'Color', 'r');  
                xline(log_graph, idx_of_peak, 'LineWidth', 2, 'Color', 'r');  

                % Index speichern
                idx_of_peak_array(selection_num) = idx_of_peak;

                % Status aktualisieren
                update_status(status, lamp, '>> Grenze erfolgreich gesetzt', 'erfolg');
                pause(1);

                % Nachricht wenn nur die erste Grenze gewählt wurde
                if selection_num == 1
                    update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');
                end

                % Anzahl der Auswahl aktualisieren
                selection_num = selection_num + 1;

            % Falls andere Taste betätigt werden
            else

                % Status aktualisieren
                update_status(status, lamp, '>> Keine gültige Taste!', 'fehler');
                pause(1);
                update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');
                continue;
            end
        end

        % Die Figur der App nicht mehr wählen
        fig.HandleVisibility = fhv;
        
        % Diesen Button wieder aktivieren
        src.Enable = 'on';

        % Farben der Graphen zurücksetzen
        psd_graph.Color = [1, 1, 1];
        log_graph.Color = [1, 1, 1]; 

        % Fehlermeldung falls die zwei Indizes gleich sind
        if idx_of_peak_array(2) == idx_of_peak_array(1)
            error('Gleiche Grenzen gesetzt!');
        end

        % Wenn der zweite Index kleiner als der erste ist, tauschen
        if idx_of_peak_array(2) < idx_of_peak_array(1)
            idx_of_peak_array = flip(idx_of_peak_array);
        end

        % Variablen speichern
        app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_peak_start = idx_of_peak_array(1);
        app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_peak_end = idx_of_peak_array(2);

        % Graphen aktualisieren
        plot_backsignal(backsignal_graph, time_recon, signal_recon, eigenfreq_current, app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info);
        plot_log(log_graph, eigenfreq_current, app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info, false);

        % Dämpfungsgrad berechnen
        [mu, sigma] = compute_damping_ratio(peak_value_signal, idx_of_peak_array(1), idx_of_peak_array(2));
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
        update_status(status, lamp, '>> Vorgang beendet und Dämpfungsgrad berechnet', ...
            'erfolg');

    % Fehler fangen
    catch ME

        % Diesen Button wieder aktivieren
        src.Enable = 'on';

        % Status aktualisieren
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end        