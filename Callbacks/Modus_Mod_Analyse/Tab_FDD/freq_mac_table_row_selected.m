%% Callback für Auswahl einer Zeile aus der Tabelle für Frequenzen und MAC-Grenzen
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function freq_mac_table_row_selected(src, event, app)

    % Nötige Variablen holen
    mac_spinner = app.mac_spinner3;                         % Spinner für MAC-Grenze
    freq_mac_table = app.freq_mac_table;                    % Tabelle für Frequenzen und MAC-Grenzen

    % Wenn keine Zeile gewählt wird, NaN zurückgeben
    if isempty(event.Selection)
        src.UserData.row_selected = NaN;
        return;
    end

    % Prüfen, dass nur die gewählte Zeile geholt wird (bei 'cell' wird die
    % gewählte Spalte auch geholt)
    if strcmp(event.SelectionType, 'cell')
        row = event.Selection(1);
    elseif strcmp(event.SelectionType, 'row')
        row = event.Selection;
    end

    % Gewählte Zeile speichern
    src.UserData.row_selected = row;

    % Frequenzen und MAC-Grenzen der gewählten Peaks holen
    freq_mac_matrix = freq_mac_table.Data;

    % Gewählte Zeile holen
    row_selected = freq_mac_table.UserData.row_selected;    

    % MAC-Grenze holen
    mac_str = freq_mac_matrix(row_selected, 2);    
    mac_value = str2double(erase(mac_str, "%"));

    % Spinner für MAC-Grenze aktualisieren
    mac_spinner.Value = mac_value;
end