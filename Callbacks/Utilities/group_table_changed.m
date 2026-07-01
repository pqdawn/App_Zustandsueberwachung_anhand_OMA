%% Callback für Änderung der Tabelle für Gruppen der Eigenfrequenzen und Eigenvektoren
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    src = Diese Tabelle
%                       event = Ereignis
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function group_table_changed(src, event, lamp, status)

    try
        % Zeile der Änderung holen
        changed_row = event.DisplaySelection(1);

        % Wenn keine Dateien importiert wurden, Funktion beenden
        if strcmp(string(src.Data{changed_row,end}), "Keine Datei")
            return;
        end        

        % Gespeicherte Zuordnung holen
        prev_config = src.UserData.group_config(changed_row, :);

        % Wenn keine Datei für diese Zeile importiert wurde, Funktion
        % beenden
        if all(prev_config == 0)
            return;
        end

        % Änderung holen
        table_matrix = src.Data;
        table_matrix(:, end-1:end) = [];
        new_config = table_matrix{changed_row, :};
        new_config = double(new_config);

        % Wenn die Änderung der gespeicherten Zuordnung entspricht
        if isequal(new_config, prev_config)

            % Wieder auf "Importiert" zurückstellen
            message = {'Importiert'};
            color = uistyle('BackgroundColor','green');
        
        % Sonst
        else

            % Auf "Geändert" stellen
            message = {'Geändert'};
            color = uistyle('BackgroundColor',[0.9290 0.6940 0.1250]);
        end

        % Tabelle aktualisieren
        last_col = size(src.Data,2);
        src.Data(changed_row, last_col) = message;
        addStyle(src, color, 'cell', [changed_row, last_col]);        

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end