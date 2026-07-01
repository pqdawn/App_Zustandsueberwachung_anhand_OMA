%% Funktion zum Aktualisieren der Ergebnisse (Modus "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    eigenform_graph = Graph für Eigenform
%                       eigenfreq = Eigenfrequenzen
%                       freq_table = Tabelle für Ergebnisse (Tab "Ergebnis")
%                       freq_table2 = Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
%                       freq_table3 = Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")

% Ausgabeparameter:     -

function update_result_merge(eigenform_graph, eigenfreq, freq_table, freq_table2, freq_table3)

    % Anzahl der Eigenfrequenzen
    num_freq = size(eigenfreq,1);

    %---------------------------------------------------------------------%
    %                            Tab "Ergebnis"
    %---------------------------------------------------------------------%

    % Graph für Eigenform zurücksetzen
    cla(eigenform_graph);
    eigenform_graph.Title.String = '\textbf{Eigenform}';
    eigenform_graph.View = [-37.5, 30];    

    % Wenn keine Eigenfrequenzen vorhanden sind
    if isempty(eigenfreq)

        % Tabelle zurücksetzen
        freq_table.Data = [];
        freq_table.ColumnName = {'Ergebnisse werden hier angezeigt'};

    % Wenn Eigenfrequenzen vorhanden sind
    else
            % Tabelle aktualisieren
            freq_table.Data = eigenfreq;
            freq_damp_col_title = {'Frequenz [Hz]'};
            freq_table.ColumnName = freq_damp_col_title;
            freq_table.ColumnWidth = repmat({'1x'}, 1, 1);
            freq_table.Selection = [];
            freq_table.UserData.row_selected = NaN;           
    end

    %---------------------------------------------------------------------%
    %               Sub-Tab "Mod. Parameter", Tab "Export"
    %---------------------------------------------------------------------%    
    % Ergebnisse zusammenstellen
    freq_table2_tick = true(num_freq, 1);
    freq_table2_new = table(eigenfreq, freq_table2_tick);

    % Wenn gar keine Ergebnisse vorhanden sind
    if isempty(eigenfreq)

        % Tabelle zurücksetzen
        freq_table2.Data = [];
        freq_table2.ColumnName = {'Ergebnisse werden hier angezeigt'};

    % Wenn Ergebnisse vorhanden sind
    else    

        % Tabelle aktualisieren
        freq_table2.Data = freq_table2_new;
        freq_table2.ColumnName = {'Frequenz [Hz]', 'Zu exportieren'};
        freq_table2.RowName = 'numbered';
        freq_table2.ColumnEditable = logical([0, 1]);
    end    

    %---------------------------------------------------------------------%
    %                 Sub-Tab "Eigenform", Tab "Export"
    %---------------------------------------------------------------------%    
    % Ergebnisse zusammenstellen
    freq_table3_tick = true(num_freq, 1);
    freq_table3_new = table(eigenfreq, freq_table3_tick);

    % Wenn gar keine Ergebnisse vorhanden sind
    if isempty(eigenfreq)

        % Tabelle zurücksetzen
        freq_table3.Data = [];
        freq_table3.ColumnName = {'Ergebnisse werden hier angezeigt'};

    % Wenn Ergebnisse vorhanden sind
    else    

        % Tabelle aktualisieren
        freq_table3.Data = freq_table3_new;
        freq_table3.ColumnName = {'Frequenz [Hz]', 'Zu exportieren'};
        freq_table3.RowName = 'numbered';
        freq_table3.ColumnEditable = logical([0, 1]);
    end
end