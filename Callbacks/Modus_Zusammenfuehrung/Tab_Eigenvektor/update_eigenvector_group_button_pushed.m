%% Callback für Button zum Aktualisieren der Gruppen der Eigenvektoren
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function update_eigenvector_group_button_pushed(app)

    % Nötige Variablen holen
    eigenvector_group_table = app.eigenvector_group_table;  % Tabelle für Gruppen der Eigenvektoren
    assign_table = app.assign_table_merge;                  % Tabelle für Zuweisungen
    eigenform_graph = app.eigenform_graph_merge;            % Graph für Eigenform    
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

        % Importierte Daten und Infos holen
        num_mode = app.fig.UserData.cache.merge.num_mode;
        num_group = app.fig.UserData.cache.merge.num_group;         

        % Gruppen und Moden in der Tabelle für Gruppen der Eigenvektoren holen
        new_config = eigenvector_group_table.Data{:,1:2};
        new_config = double(new_config);

        % Gespeicherte Zuordnung holen
        prev_config = eigenvector_group_table.UserData.group_config;        

        % Warnung falls die Änderungen der gespeicherten Zuordnung
        % entsprechen
        if isequal(new_config, prev_config)

            % Status aktualisieren
            update_status(status, lamp, '>> Zuordnung unverändert', 'warnung'); 
            pause(1);
            update_status(status, lamp, '>> Befehl ignoriert', 'erfolg'); 

            % Callback beenden
            return;
        end        

        % Zelle für Eigenvektoren instanziieren
        eigenvector_all_mode_all_group = cell(num_group, num_mode); % (Zeile = Gruppe, Spalte = Mode)    
        num_sensor_all_mode_all_group = zeros(num_group, num_mode); % (Zeile = Gruppe, Spalte = Mode)  

        % Alle Zeilen durchlaufen
        num_row = num_group*num_mode;
        for i = 1:num_row

            % Gruppe und Mode in dieser Zeile holen
            group_current = new_config(i, 1);
            mode_current = new_config(i, 2);        

            % Fehlermeldung falls Eigenvektor dieser Gruppe und dieser Mode 
            % zugeordnet wurde
            if ~isempty(eigenvector_all_mode_all_group{group_current, mode_current})
                error('%d. Gruppe und %d. Mode wurde mehrmals zugeordnet!', group_current, mode_current);
            end            

            % Pfad zur Datei holen
            path = string(eigenvector_group_table.Data{i,3});

            % Daten einlesen
            eigenvector_this_mode = readmatrix(path,'NumHeaderLines',1);

            % Eigenvektor in die Liste hinzufügen (Zeile = Gruppe, Spalte = Mode)
            eigenvector_all_mode_all_group{group_current, mode_current} = eigenvector_this_mode;
            num_sensor_all_mode_all_group(group_current, mode_current) = size(eigenvector_this_mode,1);
        end

        % Zuweisungen holen
        assign_matrix = assign_table.Data;

        % Alle Gruppen durchlaufen
        for i = 1:num_group

            % Fehlermeldung falls Anzahl der Sensoren innerhalb der Gruppe
            % abweicht
            num_sensor_all_mode = num_sensor_all_mode_all_group(i, :);
            if ~all(num_sensor_all_mode==num_sensor_all_mode(1))
                error('Anzahl der Sensoren innerhalb %d. Gruppe abweicht!', i);
            end

            % Fehlermeldung falls die Anzahl der Sensoren für diese Gruppe
            % nicht mit den Zuweisungen übereinstimmt
            assign_this_group = assign_matrix(:,1)==i;
            if num_sensor_all_mode(1) ~= sum(assign_this_group)
                error(['Anzahl der Sensoren für %d. Gruppe stimmt nicht mit den Zuweisungen überein! ' ...
                    'Importieren Sie Eigenvektoren erneut!'], i);
            end
        end

        % Geometrie holen
        cache_geometry = app.fig.UserData.cache.merge.geometry;

        % Wenn Geometrie bereits aktualisiert wurde
        if ~isempty(cache_geometry)

            % Komponenten der Geometrie holen
            assign_matrix = cache_geometry.assign;     

            % Eigenformen zusammenführen
            result_eigenform = merge_eigenform(assign_matrix, eigenvector_all_mode_all_group);

            % Ergebnisse speichern
            app.fig.UserData.cache.merge.result_eigenform = result_eigenform;  

            % Graph für Eigenform zurücksetzen
            cla(eigenform_graph);
            eigenform_graph.Title.String = '\textbf{Eigenform}';
            eigenform_graph.XLabel.String = '$x$';
            eigenform_graph.YLabel.String = '$y$';
            eigenform_graph.ZLabel.String = '$z$';
            eigenform_graph.View = [-37.5, 30];            
        end

        % Tabelle aktualisieren
        status_col = repmat({"Importiert"}, num_row, 1);
        eigenvector_group_table.Data{:,4} = status_col;
        color_success = uistyle('BackgroundColor','green'); 
        addStyle(eigenvector_group_table, color_success, 'cell', [ (1:num_row)' , repmat(4,num_row,1) ]);         

        % Variablen speichern
        eigenvector_group_table.UserData.group_config = new_config;
        app.fig.UserData.cache.merge.eigenvector = eigenvector_all_mode_all_group;        

        % Status aktualisieren
        update_status(status, lamp, '>> Zuordnung aktualisiert', 'erfolg');           

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
        return;
    end
end        