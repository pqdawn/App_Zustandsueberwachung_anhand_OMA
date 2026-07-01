%% Callback für Button zum Anzeigen des Eigenvektors (Modus "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function show_vector_button_pushed(app)

    % Nötige Variablen holen
    eigenvector_group_table = app.eigenvector_group_table;  % Tabelle für Gruppen der Eigenvektoren
    eigenvector_table = app.eigenvector_table;              % Tabelle für Eigenvektor
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status 
    
    try   
        % Fehlermeldung falls keine Eigenfrequenzen importiert
        if isempty(app.fig.UserData.cache.merge.eigenfreq)
            error('Keine Eigenfrequenzen importiert!');
        end

        % Fehlermeldung falls Eigenvektoren nicht vollständig importiert
        if any(cellfun(@isempty, app.fig.UserData.cache.merge.eigenvector))
            error('Eigenvektoren nicht vollständig importiert!');
        end

        % Gewählte Zeile holen
        row_selected = eigenvector_group_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(eigenvector_group_table.Data, 1)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls keine Datei in dieser Zeile
        if strcmp(string(eigenvector_group_table.Data{row_selected,4}), "Keine Datei")
            error('Keine Datei!');
        end

        % Fehlermeldung falls Zuordnung noch nicht aktualisiert
        if strcmp(string(eigenvector_group_table.Data{row_selected,4}), "Geändert")
            error('Zuordnung geändert! Zuordnung erstmal aktualisieren!');
        end        

        % Gruppe und Mode holen
        group_selected = double(eigenvector_group_table.Data{row_selected,1});
        mode_selected = double(eigenvector_group_table.Data{row_selected,2}); 

        % Eigenvektor aus den gespeicherten Daten holen (Zeile = Gruppe, Spalte = Mode)
        eigenvector = app.fig.UserData.cache.merge.eigenvector{group_selected, mode_selected};           

        % Tabelle aktualisieren
        eigenvector_table.Data = eigenvector;
        eigenvector_table_col_title = {'x'; 'y'; 'z'};
        eigenvector_table.ColumnName = eigenvector_table_col_title;
        eigenvector_table.RowName = 'numbered';
        eigenvector_table.ColumnWidth = repmat({'1x'}, 1, 3); 

        % Status aktualisieren
        update_status(status, lamp, '>> Eigenvektor angezeigt', 'erfolg');           

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
        return;
    end
end        