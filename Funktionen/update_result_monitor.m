%% Funktion zum Aktualisieren der Ergebnisse (Modus "Zustandsüberwachung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    step_table = Tabelle für Abschnitte
%                       segment_info = Info der Abschnitte
%                       freq_time_graph = Graph für Frequenz-Zeit-Plot
%                       track_result = Ergebnisse der Modenverfolgung
%                       ref_eigenfreq = Eigenfrequenzen der Referenzmoden
%                       oma_dropdown = Dropdown für OMA-Methoden
%                       oma_current = Aktuelle OMA-Methode
%                       freq_damp_table = Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
%                       oma_check1 = Wahl für OMA-Methode (Sub-Tab "Mod. Parameter", Tab "Export")
%                       oma_check2 = Wahl für OMA-Methode (Sub-Tab "Freq.-Zeit-Plot", Tab "Export")

% Ausgabeparameter: -

function update_result_monitor(step_table, segment_info, freq_time_graph, ...
    track_result, ref_eigenfreq, oma_dropdown, oma_current, freq_damp_table, ...
    oma_check1, oma_check2)

    % Wenn Checkboxen eingegeben wurden, Checkboxen beim Export aktivieren
    if nargin == 10
        oma_check1.Enable = 'on';
        oma_check2.Enable = 'on';          
        oma_check1.Value = 1;
        oma_check2.Value = 1;
    end

    % Anzahl der Eigenfrequenzen
    num_freq = size(ref_eigenfreq,1);

    %---------------------------------------------------------------------%
    %                           Tab "Ergebnis"
    %---------------------------------------------------------------------%
    % Dropdown aktualisieren
    oma_dropdown.Value = oma_current;    

    % Tabelle der Abschnitte aktualisieren
    column_name = {'Startzeit [s]', 'Schritte [/]'};
    step_table.ColumnName = column_name;
    step_table.Data = [[segment_info.first_time_step]', [segment_info.num_step]'];    

    % Frequenz-Zeit-Plot aktualisieren
    cla(freq_time_graph);
    start_time_of_segment = [segment_info.first_time_step];
    hold(freq_time_graph, 'on');
    for t = 1:numel(track_result)
        plot(freq_time_graph, start_time_of_segment, track_result{t}, 'o-', 'LineWidth', 2);
    end
    hold(freq_time_graph, 'off');
    head_line = ['\textbf{Frequenz-Zeit-Plot (', char(oma_current), ')}'];
    title(freq_time_graph, head_line);
    legend(freq_time_graph, compose('%d. Mode', 1:numel(track_result)), 'Location', 'northeast');

    %---------------------------------------------------------------------%
    %                Sub-Tab "Mod. Parameter", Tab "Export"
    %---------------------------------------------------------------------%
    % Vorherige Ergebnisse holen und alle Daten von der aktuellen 
    % OMA-Methode löschen
    if isempty(freq_damp_table.Data)
        freq_damp_table_prev = {};
    else
        freq_damp_table_prev = freq_damp_table.Data;
        rowsToRemove = freq_damp_table_prev.oma_column == oma_current;
        freq_damp_table_prev(rowsToRemove, :) = [];            
    end
    
    % Neue Ergebnisse zusammenstellen
    oma_column = repmat(oma_current, num_freq, 1);
    tick_column = true(num_freq, 1);
    freq_damp_table_new = table(oma_column, ref_eigenfreq, tick_column); 

    % Tabelle aktualisieren
    freq_damp_table.Data = [freq_damp_table_prev; freq_damp_table_new];
    freq_damp_table.ColumnName = {'OMA', 'Frequenz (Ref.) [Hz]', 'Zu exportieren'};
    freq_damp_table.RowName = 'numbered';
    freq_damp_table.ColumnEditable = logical([0, 0, 1]);
end