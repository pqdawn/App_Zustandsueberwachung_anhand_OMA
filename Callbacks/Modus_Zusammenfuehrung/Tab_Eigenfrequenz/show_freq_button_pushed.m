%% Callback für Button zum Anzeigen der Eigenfrequenzen
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function show_freq_button_pushed(app)

    % Nötige Variablen holen
    eigenfreq_group_table = app.eigenfreq_group_table;      % Tabelle für Gruppen der Eigenfrequenzen
    eigenfreq_table = app.eigenfreq_table;                  % Tabelle für Eigenfrequenzen
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status 
    
    try   
        % Fehlermeldung falls keine Eigenfrequenzen importiert
        if isempty(app.fig.UserData.cache.merge.eigenfreq)
            error('Keine Eigenfrequenzen importiert!');
        end

        % Importierte Daten und Infos holen
        eigenfreq = app.fig.UserData.cache.merge.eigenfreq;
        num_mode = app.fig.UserData.cache.merge.num_mode;

        % Gewählte Zeile holen
        row_selected = eigenfreq_group_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(eigenfreq_group_table.Data, 1)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls keine Datei in dieser Zeile
        if strcmp(string(eigenfreq_group_table.Data{row_selected,3}), "Keine Datei")
            error('Keine Datei!');
        end

        % Fehlermeldung falls Zuordnung noch nicht aktualisiert
        if strcmp(string(eigenfreq_group_table.Data{row_selected,3}), "Geändert")
            error('Zuordnung geändert! Zuordnung erstmal aktualisieren!');
        end

        % Gruppe holen
        group_selected = double(eigenfreq_group_table.Data{row_selected,1});

        % Eigenfrequenzen aus den gespeicherten Daten holen (Zeile = Gruppe, Spalte = Mode)
        freq_matrix = eigenfreq(group_selected, :)';     

        % Tabelle aktualisieren
        num_col = string(1:num_mode)';
        eigenfreq_table.Data = [num_col, freq_matrix];
        eigenfreq_table_col_title = {'Mode'; 'Frequenz [Hz]'};
        eigenfreq_table.ColumnName = eigenfreq_table_col_title;
        eigenfreq_table.RowName = 'numbered';
        eigenfreq_table.ColumnWidth = repmat({'1x'}, 1, 2);

        % Status aktualisieren
        update_status(status, lamp, '>> Eigenfrequenzen angezeigt', 'erfolg');           

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
        return;
    end
end        