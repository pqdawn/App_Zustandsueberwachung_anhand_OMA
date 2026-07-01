%% Callback für Checkboxen der OMA-Methoden beim Export
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    event = Ereignis
%                       table = Tabelle für Ergebnisse
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter:     -

function oma_export_changed(event, table, lamp, status)  

    try
        % Callback beenden falls noch keine Ergebnisse
        if isempty(table.Data)
            return;
        end

        % Inhalt der Tabelle holen
        table_data = table.Data;

        % Betroffene OMA-Methode holen
        oma_checked = event.Source.Text;

        % "Gewählt" oder "nicht gewählt" holen
        check = event.Source.Value;

        % Alle Zeilen durchlaufen
        for i =1:height(table_data)

            % Wenn die OMA-Methode dieser Zeile mit der betroffenen Methode
            % übereinstimmt
            if strcmp(table_data(i,:).oma_column, oma_checked)

                % "Zu exportieren" aktualisieren
                table_data(i,:).tick_column = check;
            end
        end

        % Tabelle aktualisieren
        table.Data = table_data;

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end        