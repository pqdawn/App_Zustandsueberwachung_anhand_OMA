%% Callback für Button zum Übernehmen des Dämpfungsgrads
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function adopt_damping_button_pushed(app)

    % Nötige Variablen holen
    choose_peak_button = app.choose_peak_button;                % Button für Auswahlen der Peaks
    psd_graph2 = app.psd_graph3;                                % Graph für 1. Singulärwerte der PSD in [dB]
    backsignal_graph = app.backsignal_graph;                    % Graph für Korrelationsfunktion der 1. Singulärwerte
    freq_damp_table_efdd = app.freq_damp_table_efdd;            % Tabelle für Ergebisse (Sub-Tab "Dämpfung in EFDD", Tab "FDD / EFDD")   
    mean_edit_field = app.mean_edit_field;                      % Eingabefeld für Mittelwert
    oma_dropdown = app.oma_dropdown;                            % Dropdown für OMA-Methoden
    freq_damp_table = app.freq_damp_table;                      % Tabelle für Ergebnisse (Tab "Ergebnis")
    eigenform_graph = app.eigenform_graph;                      % Graph für Eigenform
    update_eigenform_button = app.update_eigenform_button;      % Button für Darstellen der Eigenform
    oma_efdd_check2 = app.oma_efdd_check2;                      % Wahl für EFDD (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table2 = app.freq_damp_table2;                    % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_efdd_check3 = app.oma_efdd_check3;                      % Wahl für EFDD (Sub-Tab "Eigenform", Tab "Export")
    freq_damp_table3 = app.freq_damp_table3;                    % Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")
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

        % Fehlermeldung falls keine Mode untersucht wurde
        if isempty(backsignal_graph.Children)
            error('Keine Mode untersucht!')
        end

        % Fehlermeldung falls Dämpfungsgrad noch nicht berechnet wurde
        if isnan(str2double(mean_edit_field.Value))
            error('Kein Dämpfungsgrad berechnet!');
        end

        % Untersuchte Mode holen
        mode_num = psd_graph2.UserData.mode_num;  

        % Ergebnisse der EFDD holen
        peak_value_signal = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.peak_value_signal;
        idx_peak_start = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_peak_start;
        idx_peak_end = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_peak_end;

        % Dämpfungsgrad berechnen
        [damping_ratio, ~] = compute_damping_ratio(peak_value_signal, idx_peak_start, idx_peak_end); 
        damping_ratio = damping_ratio*100;

        % Dämpfungsgrad speichern
        app.fig.UserData.cache.modal.efdd_result(mode_num).damping_ratio = damping_ratio;

        % Grenzen speichern
        app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_peak_start_final = idx_peak_start;
        app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_peak_end_final = idx_peak_end;

        % Ergebnisse der EFDD holen
        eigenfreq_chosen = [app.fig.UserData.cache.modal.efdd_result.freq_fdd];
        freq_d_chosen = [app.fig.UserData.cache.modal.efdd_result.freq_d];
        damping_ratio_chosen = [app.fig.UserData.cache.modal.efdd_result.damping_ratio];

        % Tabelle aktualisieren
        freq_damp_table_efdd.Data = [freq_d_chosen', eigenfreq_chosen', damping_ratio_chosen'];
        freq_damp_table_efdd.ColumnName = {'EFDD F. [Hz]', 'FDD F. [Hz]', 'Dämpf. [%]'};
        freq_damp_table_efdd.ColumnWidth = repmat({'1x'}, 1, 2);
        freq_damp_table_efdd.RowName = 'numbered';            

        % Ergebnisse in restlichen GUI-Komponenten aktualisieren
        update_result(eigenform_graph, freq_d_chosen', damping_ratio_chosen', oma_dropdown, ...
            "EFDD", freq_damp_table, freq_damp_table2, freq_damp_table3, oma_efdd_check2, oma_efdd_check3);       

        % Status aktualisieren
        update_status(status, lamp, '>> Dämpfungsgrad übernommen', ...
            'erfolg');

    % Fehler fangen
    catch ME

        % Status aktualisieren
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end                