%% Callback für Button zum Importieren der Gruppen der Eigenvektoren
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function import_eigenvector_group_button_pushed(app)

    % Nötige Variablen holen
    group_number_dropdown = app.group_number_dropdown;              % Dropdown für Gruppennummer
    path_edit_field = app.eigenvector_path_edit_field;              % Eingabefeld für Pfad
    eigenvector_group_table = app.eigenvector_group_table;          % Tabelle für Gruppen der Eigenvektoren
    eigenvector_table = app.eigenvector_table;                      % Tabelle für Eigenvektor
    assign_table = app.assign_table_merge;                          % Tabelle für Zuweisungen
    node_table = app.node_table_merge;                              % Tabelle für Knoten
    geometry_graph = app.geometry_graph_merge;                      % Graph für Geometrie 
    lamp = app.status_lamp;                                         % Licht des Status
    status = app.status_text_area;                                  % Textfeld des Status

    try
        % Fehlermeldung falls keine Eigenfrequenzen importiert
        if isempty(app.fig.UserData.cache.merge.eigenfreq)
            error('Keine Eigenfrequenzen importiert!');
        end

        % Importierte Daten und Infos holen
        num_mode = app.fig.UserData.cache.merge.num_mode;
        num_group = app.fig.UserData.cache.merge.num_group; 

        % Pfad holen
        folder_path = path_edit_field.Value;

        % Fehlermeldung falls Pfad nicht eingegeben
        if isempty(folder_path)
            error('Ordnerpfad nicht eingegeben!');
        end         

        % Fehlermeldung falls Pfad nicht gültig
        if ~isfolder(folder_path)
            error('Ordnerpfad nicht gültig!');
        end         

        % Alle TXT-Dateien in diesem Ordner finden
        file_list = dir(fullfile(folder_path,'*.txt'));

        % Fehlermeldung falls keine Datei gefunden
        if numel(file_list) == 0
            error('Keine Datei in diesem Ordner gefunden!');
        end        

        % Fehlermeldung falls Anzahl der gefundenen Dateien nicht mit
        % der Anzahl der Moden übereinstimmt
        if numel(file_list) ~= num_mode
            error(['Die Anzahl der Dateien in diesem Ordner stimmt nicht mit der Anzahl ' ...
                'der Moden überein!']);
        end

        % Nach Nummern in den Namen sortieren
        names = {file_list.name};
        numbers = cellfun(@(x) str2double(regexp(x,'\d+','match','once')), names);
        [~,idx] = sort(numbers);
        file_list = file_list(idx);

        % Liste für Dateien instanziieren
        file_path_list = cell(num_group,1);
        eigenvector_all_mode = cell(1, num_mode); % (Spalte = Mode)
        num_sensor_all_mode = zeros(1, num_mode); % (Spalte = Mode)

        % Gewählte Gruppennummer holen
        current_group = str2double(group_number_dropdown.Value);

        % Leere Gruppen aus gespeicherten Daten finden
        empty_group = all(cellfun(@isempty, app.fig.UserData.cache.merge.eigenvector), 2);

        % Wenn diese Gruppe nicht die erste Gruppe ist
        if current_group ~= 1

            % Prüfen, ob Eigenvektoren für die vorherigen Gruppen 
            % importiert wurden (um Fehler bei Erstellung der
            % Zuweisungen zu vermeiden)
            group_to_check = (1:(current_group-1))';
            empty_group_check = empty_group(group_to_check);
            if any(empty_group_check)

                % Dropdown auf kleinste zu behandelnde Gruppe stellen
                smallest_empty = find(empty_group_check, 1,'first');
                group_number_dropdown.Value = string(smallest_empty);
    
                % Eingabefeld zurücksetzen
                path_edit_field.Value = '';

                % Fehlermeldung
                error('Eigenvektoren für vorherige Gruppen noch nicht importiert!');
            end
        end        

        % Alle Moden durchlaufen
        for k = 1:num_mode
        
            % Pfad konstruieren
            file_path = fullfile(folder_path, file_list(k).name);
        
            % Daten einlesen
            eigenvector_this_mode = readmatrix(file_path,'NumHeaderLines',1);
        
            % Fehlermeldung falls die Datei nicht genau 3 Spalten hat
            if size(eigenvector_this_mode,2) ~= 3
                 error('Eine Datei hat nicht genau 3 Spalten!');
            end

            % Gruppe zwangsläufig zuordnen
            eigenvector_group_table.Data{(current_group-1)*num_mode+k, 1} = string(current_group);

            % Mode zwamgsläufig zuordnen
            eigenvector_group_table.Data{(current_group-1)*num_mode+k, 2} = string(k);

            % Pfad und Daten in die Liste hinzufügen
            file_path_list{k} = file_path;
            eigenvector_all_mode{1, k} = eigenvector_this_mode;
            num_sensor_all_mode(1, k) = size(eigenvector_this_mode,1);
        end

        % Fehlermeldung falls Anzahl der Sensoren innerhalb der Gruppe
        % abweicht
        if ~all(num_sensor_all_mode==num_sensor_all_mode(1))
            error('Anzahl der Sensoren innerhalb der Gruppe abweicht!');
        end

        % Fehlermeldung falls Anzahl der Sensoren größer als 9
        if num_sensor_all_mode(1) > 9
            error('Diese App kann nur maximal 9 Sensoren pro Gruppe behandeln!');
        end        

        % Wenn Eigevektoren für diese Gruppe bereits importiert wurden, den Benutzer warnen
        if ~empty_group(current_group)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(app.fig, ['Eigenvektoren bereits importiert. ' ...
                'Alle Eigenvektoren und relevante Ergebnisse werden gelöscht. Möchten Sie fortfahren?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);

            % Wahl von Benutzer
            switch choice

                % Wenn "nein", Daten beibehalten und weiter
                case 'Nein'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Eigenvektoren und Ergebnisse beibehalten', 'erfolg');
                    return;

                % Wenn "ja", Daten löschen und relevante Komponenten zurücksetzen
                case 'Ja'

                    % Tabellen zurücksetzen
                    eigenvector_group_table.Data = [];
                    eigenvector_group_table.UserData.row_selected = NaN;
                    eigenvector_table.Data = [];
                    eigenvector_table.ColumnName = {'Eigenvektor wird hier angezeigt'};
            
                    % Kategorien für Gruppen und Moden erstellen
                    group_option = 1:num_group;
                    mode_option = 1:num_mode;                    

                    % Auswahl der Kategorien zuordnen
                    group_selected2 = repelem(1:num_group, num_mode)';
                    mode_selected2 = repmat((1:num_mode)', num_group, 1);
                    group_cat2 = categorical(group_selected2, group_option);
                    mode_cat2 = categorical(mode_selected2, mode_option);        
            
                    % Tabelle für Gruppen der Eigenvektoren aktualisieren
                    num_row = num_mode*num_group;
                    nan_vector2 = num2cell(NaN(num_row,1));
                    status_col2 = repmat({'Keine Datei'}, num_row, 1);
                    tdata = table(group_cat2, mode_cat2, nan_vector2, status_col2);
                    eigenvector_group_table.Data = tdata;
                    eigenvector_group_table_col_title = {'Gruppe','Mode', 'Pfad zur Datei', 'Status'};
                    eigenvector_group_table.ColumnName = eigenvector_group_table_col_title;
                    eigenvector_group_table.ColumnWidth ={'1x', '1x', '6x', '1x'};
                    eigenvector_group_table.RowName = 'numbered';
                    color_error = uistyle('BackgroundColor','red');
                    addStyle(eigenvector_group_table, color_error, 'cell', [ (1:num_row)' , repmat(4,num_row,1) ]);
                    eigenvector_group_table.ColumnEditable = [true true false false];                       

                    % Daten zurücksetzen
                    app.fig.UserData.cache.merge.eigenvector = cell(num_group, num_mode);     % Eigenvektoren (Zeile = Gruppe, Spalte = Mode)
                    app.fig.UserData.cache.merge.result_eigenform = [];                       % Ergebnisse der Eigenformen (Zeile = Mode)
                    app.fig.UserData.cache.merge.geometry = struct([]);                       % Geometrie

                    % Betroffene Tabs zurücksetzen
                    app = reset_partial_app(app, 'eigenvector');                       

                    % Status aktualisieren
                    update_status(status, lamp, '>> Eigenvektoren und relevante Ergebnisse gelöscht', 'erfolg');
                    pause(1);

                    % Diesen Callback erneut rufen
                    import_eigenvector_group_button_pushed(app);
                    return;                    
            end            
        end         

        % Tabelle für Gruppen der Eigenvektoren aktualisieren
        file_paths = cellfun(@fullfile, {file_list.folder}, {file_list.name}, 'UniformOutput', false);
        eigenvector_group_table.Data(((current_group-1)*num_mode+1 : current_group*num_mode), 3) = file_paths';
        eigenvector_group_table.Data(((current_group-1)*num_mode+1 : current_group*num_mode), 4) = {'Importiert'};
        color_success = uistyle('BackgroundColor','green'); 
        addStyle(eigenvector_group_table, color_success, 'cell', [ ((current_group-1)*num_mode+1 : current_group*num_mode)' , repmat(4,num_mode,1) ]);

        % Anzahl der Sensoren
        num_sensor = num_sensor_all_mode(1);
    
        % Tabelle für Zuweisungen aktualisieren
        num_sensor_prev_group = size(assign_table.Data,1);
        assign_node_vector = num_sensor_prev_group + (1:num_sensor)';
        assign_sensor_vector = current_group*10 + (1:num_sensor)';
        assign_matrix = [repmat(current_group, num_sensor, 1), assign_sensor_vector, assign_node_vector];
        assign_table.Data = [assign_table.Data; assign_matrix];
        assign_col_title = {'Gruppe', 'Sensor', 'Knoten'};
        assign_table.ColumnName = assign_col_title;
        assign_table.ColumnWidth = repmat({'1x'}, 1, 3);
        assign_table.ColumnEditable = logical([0, 0, 1]);

        % Tabelle für Knoten aktualisieren
        node_matrix = zeros(num_sensor, 3);
        node_table.Data = [node_table.Data; node_matrix];  
        node_col_title = {'x-Koor', 'y-Koor', 'z-Koor'};
        node_table.ColumnName = node_col_title;
        node_table.ColumnWidth = repmat({'1x'}, 1, 3);
        node_table.ColumnEditable = true(1, 3);                

        % Graph für Geometrie aktualisieren
        assign_matrix = assign_table.Data(:, 2:3);
        node_matrix = node_table.Data;
        plot_geometry(assign_matrix, node_matrix, [], [], geometry_graph);           

        % Variablen speichern (Zeile = Gruppe, Spalte = Mode)
        app.fig.UserData.cache.merge.eigenvector(current_group, :) = eigenvector_all_mode;
        eigenvector_group_table.UserData.group_config((current_group-1)*num_mode+1:(current_group-1)*num_mode+num_mode, 1) = current_group;
        eigenvector_group_table.UserData.group_config((current_group-1)*num_mode+1:(current_group-1)*num_mode+num_mode, 2) = 1:num_mode;

        % Wenn diese Gruppe nicht die letzte Gruppe ist
        if current_group < num_group

            % Dropdown auf nächste Gruppe stellen
            group_number_dropdown.Value = string(current_group+1);

            % Eingabefeld zurücksetzen
            path_edit_field.Value = '';
        end

        % Status aktualisieren
        update_status(status, lamp, '>> Eigenvektoren importiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end