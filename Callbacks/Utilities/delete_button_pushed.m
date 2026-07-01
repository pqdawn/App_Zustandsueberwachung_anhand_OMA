%% Callback für Button zum Löschen aller Daten
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function delete_button_pushed(fig, app)

    % Nötige Variablen holen
    lamp = app.status_lamp;             % Licht des Status
    status = app.status_text_area;      % Textfeld des Status

    try
        % Falls irgendwelche Daten importiert wurden, den Benutzer warnen
        if any(~isnan(app.fig.UserData.cache.modal.data_matrix(:))) || ~isempty(app.fig.UserData.cache.merge.eigenfreq) ...
            || any(~isnan(app.fig.UserData.cache.monitor.data_matrix(:)))

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(fig, ['Alle Daten werden gelöscht und App wird ' ...
                'zurückgesetzt. Möchten Sie fortfahren?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);
            
            % Wahl von Benutzer
            switch choice
    
                % Wenn "ja", alles löschen und App zurücksetzen
                case 'Ja'
        
                    % App schließen
                    delete(app.fig);
    
                    % App neu starten
                    Main_App;
                
                % Wenn "nein", alle Daten beibehalten und Vorgang abbrechen
                case 'Nein'
    
                    % Status aktualisieren
                    update_status(status, lamp, '>> Alle Daten beibehalten', 'erfolg');
                    return;
            end
        
        % Falls noch keine Messdaten importiert wurden, direkt löschen
        else
            
            % App schließen
            delete(app.fig);

            % App neu starten
            Main_App;
        end

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end