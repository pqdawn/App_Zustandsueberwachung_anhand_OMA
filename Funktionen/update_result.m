%% Funktion zum Aktualisieren der Ergebnisse (Modus "Modalanalyse")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    eigenform_graph = Graph für Eigenform
%                       eigenfreq = Eigenfrequenzen
%                       damping_ratio = Dämpfungsgrade
%                       oma_dropdown = Dropdown für OMA-Methoden
%                       oma_current = Aktuelle OMA-Methode
%                       freq_damp_table = Tabelle für Ergebnisse (Tab "Ergebnis")
%                       freq_damp_table2 = Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
%                       freq_damp_table3 = Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")
%                       oma_check1 = Wahl für OMA-Methode (Sub-Tab "Mod. Parameter", Tab "Export")
%                       oma_check2 = Wahl für OMA-Methode (Sub-Tab "Eigenform", Tab "Export")

% Ausgabeparameter: -

function update_result(eigenform_graph, eigenfreq, damping_ratio, oma_dropdown, ...
    oma_current, freq_damp_table, freq_damp_table2, freq_damp_table3, oma_check1, oma_check2)

    % Wenn Checkboxen eingegeben wurden, Checkboxen beim Export aktivieren
    if nargin == 10
        oma_check1.Enable = 'on';
        oma_check2.Enable = 'on';          
        oma_check1.Value = 1;
        oma_check2.Value = 1;
    end

    % Anzahl der Eigenfrequenzen
    num_freq = size(eigenfreq,1);

    %---------------------------------------------------------------------%
    %                           Tab "Ergebnis"
    %---------------------------------------------------------------------%
    % Dropdown aktualisieren
    oma_dropdown.Value = oma_current;

    % Graph für Eigenform zurücksetzen
    cla(eigenform_graph);
    eigenform_graph.Title.String = '\textbf{Eigenform}';
    eigenform_graph.View = [-37.5, 30];    

    % Wenn keine Eigenfrequenzen vorhanden sind
    if isempty(eigenfreq)

        % Tabelle zurücksetzen
        freq_damp_table.Data = [];
        freq_damp_table.ColumnName = {'Ergebnisse werden hier angezeigt'};

    % Wenn Eigenfrequenzen vorhanden sind
    else

        % Wenn die aktuelle OMA-Methode FDD ist
        if strcmp(oma_current, "FDD")

            % Tabelle aktualisieren
            freq_damp_table.Data = eigenfreq;
            freq_damp_col_title = {'Frequenz [Hz]'};
            freq_damp_table.ColumnName = freq_damp_col_title;
            freq_damp_table.ColumnWidth = repmat({'1x'}, 1, 1);
            freq_damp_table.Selection = [];
            freq_damp_table.UserData.row_selected = NaN;           

        % Wenn die aktuelle OMA-Methode EFDD ist
        elseif strcmp(oma_current, "EFDD")

            % Tabelle aktualisieren
            freq_damp_table.Data = [eigenfreq, damping_ratio];
            freq_damp_col_title = {'Frequenz [Hz]', 'Dämpfungsgrad [%]'};
            freq_damp_table.ColumnName = freq_damp_col_title;
            freq_damp_table.ColumnWidth = repmat({'1x'}, 1, 2);
            freq_damp_table.Selection = [];
            freq_damp_table.UserData.row_selected = NaN;               

        % Wenn die aktuelle OMA-Methode SSI-COV oder SSI-DATA ist
        elseif strcmp(oma_current, "SSI-COV") || strcmp(oma_current, "SSI-DATA")

            % Tabelle aktualisieren
            freq_damp_table.Data = [eigenfreq, damping_ratio.*100];
            freq_damp_col_title = {'Frequenz [Hz]', 'Dämpfungsgrad [%]'};
            freq_damp_table.ColumnName = freq_damp_col_title;
            freq_damp_table.ColumnWidth = repmat({'1x'}, 1, 2);
            freq_damp_table.Selection = [];
            freq_damp_table.UserData.row_selected = NaN;         
        end
    end

    %---------------------------------------------------------------------%
    %               Sub-Tab "Mod. Parameter", Tab "Export"
    %---------------------------------------------------------------------%
    % Vorherige Ergebnisse holen und alle Daten von der aktuellen 
    % OMA-Methode löschen
    if isempty(freq_damp_table2.Data)
        freq_damp_table2_prev = {};
    else
        freq_damp_table2_prev = freq_damp_table2.Data;
        rowsToRemove2 = freq_damp_table2_prev.oma_column == oma_current;
        freq_damp_table2_prev(rowsToRemove2, :) = [];            
    end
    
    % Neue Ergebnisse zusammenstellen
    oma_column = repmat(oma_current, num_freq, 1);
    tick_column = true(num_freq, 1);
    freq_damp_table2_new = table(oma_column, eigenfreq, tick_column);

    % Wenn gar keine Ergebnisse vorhanden sind
    if isempty(freq_damp_table2_prev) && isempty(eigenfreq)

        % Tabelle zurücksetzen
        freq_damp_table2.Data = [];
        freq_damp_table2.ColumnName = {'Ergebnisse werden hier angezeigt'};

    % Wenn Ergebnisse vorhanden sind
    else    

        % Tabelle aktualisieren
        freq_damp_table2.Data = [freq_damp_table2_prev; freq_damp_table2_new];
        freq_damp_table2.ColumnName = {'OMA', 'Frequenz [Hz]', 'Zu exportieren'};
        freq_damp_table2.RowName = 'numbered';
        freq_damp_table2.ColumnEditable = logical([0, 0, 1]);
    end

    %---------------------------------------------------------------------%
    %                 Sub-Tab "Eigenform", Tab "Export"
    %---------------------------------------------------------------------%
    % Wenn gar keine Ergebnisse vorhanden sind
    if isempty(freq_damp_table2.Data) && isempty(eigenfreq)

        % Tabelle zurücksetzen
        freq_damp_table3.Data = [];
        freq_damp_table3.ColumnName = {'Ergebnisse werden hier angezeigt'};

    % Wenn Ergebnisse vorhanden sind
    else   
        % Tabelle aktualisieren
        freq_damp_table3.Data = [freq_damp_table2_prev; freq_damp_table2_new];
        freq_damp_table3.ColumnName = {'OMA', 'Frequenz [Hz]', 'Zu exportieren'};
        freq_damp_table3.RowName = 'numbered';
        freq_damp_table3.ColumnEditable = logical([0, 0, 1]); 
    end
end