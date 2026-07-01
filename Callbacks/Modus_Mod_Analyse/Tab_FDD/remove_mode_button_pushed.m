%% Callback für Button zum Entfernen der Mode
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function remove_mode_button_pushed(app)
    
    % Nötige Variablen holen
    choose_peak_button = app.choose_peak_button;            % Button dieser Funktion
    psd_graph = app.psd_graph3;                             % Graph für 1. Singulärwerte der PSD in [dB]
    backsignal_graph = app.backsignal_graph;                % Graph für Korrelationsfunktion des 1. Eigenwertes
    log_graph = app.log_graph;                              % Graph für lineare Regression des logarithmischen Dekrements
    freq_damp_table_efdd = app.freq_damp_table_efdd;        % Tabelle für Ergebisse (Sub-Tab "Dämpfung in EFDD", Tab "FDD / EFDD")   
    mean_edit_field = app.mean_edit_field;                  % Eingabefeld für Mittelwert
    standard_dev_edit_field = app.standard_dev_edit_field;  % Eingabefeld für Standardabweichung
    cov_edit_field = app.cov_edit_field;                    % Eingabefeld für Variationskoeffizient
    cov_lamp = app.cov_lamp;                                % Lampe für Variationskoeffizient    
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

        % Ergebnisse der EFDD holen
        efdd_result = app.fig.UserData.cache.modal.efdd_result;

        % Fehlermeldung falls EFDD noch nicht durchgeführt wurde
        if isempty(efdd_result)
            error('EFDD nicht durchgeführt!');
        end

        % Daten der Tabelle holen
        freq_damp_efdd_matrix = freq_damp_table_efdd.Data;

        % Gewählte Zeile holen
        row_selected = freq_damp_table_efdd.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(freq_damp_efdd_matrix, 1)
            error('Keine Zeile gewählt!');
        end        

        % Mode entfernen
        efdd_result(row_selected) = [];   

        % Variable speichern
        app.fig.UserData.cache.modal.efdd_result = efdd_result;

        % Untersuchte Mode holen
        mode_num = psd_graph.UserData.mode_num;

        % Wenn die untersuchte Mode mit dieser entfernten Mode
        % übereinstimmt
        if mode_num == row_selected

            % Graphen zurücksetzen
            cla(psd_graph);
            title(psd_graph, '\textbf{1. Singul\"arwerte der PSD}');
            cla(backsignal_graph);
            title(backsignal_graph, '\textbf{Korrelationsfunktion der 1. Singul\"arwerte}');
            cla(log_graph);
            title(log_graph, '\textbf{Lineare Regression des logarithmischen Dekrements}');

            % Eingabefelder zurücksetzen
            mean_edit_field.Value = '';
            standard_dev_edit_field.Value = '';
            cov_edit_field.Value = '';
    
            % Lampe zurücksetzen
            cov_lamp.Color = [0 1 0];             
        end

        % Vorgang hier beenden, falls keine Ergebnisse der EFDD vorliegen
        if isempty(efdd_result)

            % Betroffene Tabs zurücksetzen
            reset_partial_app(app, 'efdd');

            % Ergebnisse in restlichen GUI-Komponenten aktualisieren
            update_result(eigenform_graph, [], [], oma_dropdown, ...
                "EFDD", freq_damp_table, freq_damp_table2, freq_damp_table3);             

            % Status aktualisieren
            update_status(status, lamp, '>> Mode entfernt', 'erfolg');

            % Vorgang sofort beenden
            return;
        end

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
        update_status(status, lamp, '>> Mode entfernt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end        