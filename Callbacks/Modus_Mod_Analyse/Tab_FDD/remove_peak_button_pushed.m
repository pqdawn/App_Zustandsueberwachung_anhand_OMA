%% Callback für Button zum Entfernen des Peaks
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function remove_peak_button_pushed(app)
    
    % Nötige Variablen holen
    psd_graph = app.psd_graph;                                  % Graph für 1. Singulärwerte der PSD in [dB]
    psd_graph2 = app.psd_graph2;                                % Graph für 1. Singulärwerte der PSD in [/]
    freq_table = app.freq_table2;                               % Tabelle für Frequenzen
    oma_dropdown = app.oma_dropdown;                            % Dropdown für OMA-Methoden
    freq_damp_table = app.freq_damp_table;                      % Tabelle für Ergebnisse
    eigenform_graph = app.eigenform_graph;                      % Graph für Eigenform
    update_eigenform_button = app.update_eigenform_button;      % Button für Darstellen der Eigenform
    oma_fdd_check2 = app.oma_fdd_check2;                        % Wahl für FDD (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table2 = app.freq_damp_table2;                    % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_fdd_check3 = app.oma_fdd_check3;                        % Wahl für FDD (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table3 = app.freq_damp_table3;                    % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
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

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
        end

        % Fehlermeldung falls noch kein Peak ausgewählt wurde
        if isempty(app.fig.UserData.cache.modal.selected_peak)
            error('Kein Peak ausgewählt!');
        end

        % Variable von Graph holen
        selected_peak = app.fig.UserData.cache.modal.selected_peak;        

        % Frequenzen des gewählten Peaks holen
        freq_matrix = freq_table.Data;

        % Gewählte Zeile holen
        row_selected = freq_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(freq_matrix, 1)
            error('Keine Zeile gewählt!');
        end        

        % Peak entfernen
        selected_peak(row_selected) = [];

        % Graphen der 1. Singulärwerte der PSD aktualisieren 
        plot_eigenvalue_psd_db(psd_graph, app.fig.UserData.cache.modal.fdd_result, [selected_peak.idx]);
        plot_eigenvalue_psd_lin(psd_graph2, app.fig.UserData.cache.modal.fdd_result, [selected_peak.idx]);        

        % Variable speichern
        app.fig.UserData.cache.modal.selected_peak = selected_peak;

        % Vorgang hier beenden, falls gar keine Peaks gewählt wurden
        if isempty(selected_peak)

            % Tabelle für Frequenzen zurücksetzen
            freq_table.Data = [];
            freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};

            % Ergebnisse in restlichen GUI-Komponenten aktualisieren
            update_result(eigenform_graph, [], [], oma_dropdown, ...
                "FDD", freq_damp_table, freq_damp_table2, freq_damp_table3);             

            % Status aktualisieren
            update_status(status, lamp, '>> Peak entfernt', 'erfolg');

            % Vorgang sofort beenden
            return;
        end

        % Ergebnisse holen
        eigenfreq_chosen = [selected_peak.freq]';

        % Tabelle für Frequenzen aktualisieren
        freq_table.Data = eigenfreq_chosen;        

        % Ergebnisse in restlichen GUI-Komponenten aktualisieren
        update_result(eigenform_graph, eigenfreq_chosen, [], oma_dropdown, ...
            "FDD", freq_damp_table, freq_damp_table2, freq_damp_table3, oma_fdd_check2, oma_fdd_check3);

        % Status aktualisieren
        update_status(status, lamp, '>> Peak entfernt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end        