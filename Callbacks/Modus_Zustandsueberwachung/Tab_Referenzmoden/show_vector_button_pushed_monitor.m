%% Callback für Button zum Anzeigen des Eigenvektors (Modus "Zustandsüberwachung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function show_vector_button_pushed_monitor(app)

    % Nötige Variablen holen
    eigenfreq_table = app.eigenfreq_table_monitor;          % Tabelle für Eigenfrequenzen
    eigenvector_table = app.eigenvector_table_monitor;      % Tabelle für Eigenvektor
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status 
    
    try
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(app.fig.UserData.cache.monitor.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Fehlermeldung falls keine Referenzmoden importiert
        if isempty(app.fig.UserData.cache.monitor.ref_eigenfreq)
            error('Keine Referenzmoden importiert!');
        end        

        % Gewählte Zeile holen
        row_selected = eigenfreq_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(eigenfreq_table.Data, 1)
            error('Keine Zeile gewählt!');
        end

        % Eigenvektor aus den gespeicherten Daten holen (Zeile = Mode)
        eigenvector = app.fig.UserData.cache.monitor.ref_eigenvector{row_selected, 1}; 

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