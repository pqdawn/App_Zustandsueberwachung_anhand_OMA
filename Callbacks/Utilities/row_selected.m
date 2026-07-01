%% Callback für Auswahl einer Zeile aus der Tabelle
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    src = Diese Tabelle
%                       event = Ereignis

% Ausgabeparameter: -

function row_selected(src, event)

    % Wenn keine Zeile gewählt wird, NaN zurückgeben
    if isempty(event.Selection)
        src.UserData.row_selected = NaN;
        return;
    end

    % Prüfen, dass nur die gewählte Zeile geholt wird (bei 'cell' wird die
    % gewählte Zeile auch geholt)
    if strcmp(event.SelectionType, 'cell')
        row = event.Selection(1);
    elseif strcmp(event.SelectionType, 'row')
        row = event.Selection;
    end

    % Gewählte Zeile speichern
    src.UserData.row_selected = row;
end