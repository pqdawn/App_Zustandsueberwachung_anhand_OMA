%% Callback für Button zum Importieren der Gruppen der Eigenfrequenzen
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function import_eigenfreq_group_button_pushed(app)

    % Nötige Variablen holen
    num_mode = app.num_mode_spinner.Value;                  % Anzahl der Moden
    num_group = app.num_group_spinner.Value;                % Anzahl der Gruppen
    folder_path = app.eigenfreq_path_edit_field.Value;      % Ordnerpfad
    eigenfreq_group_table = app.eigenfreq_group_table;      % Tabelle für Gruppen der Eigenfrequenzen
    eigenfreq_table = app.eigenfreq_table;                  % Tabelle für Eigenfrequenzen
    group_number_dropdown = app.group_number_dropdown;      % Dropdown für Gruppennummer
    eigenvector_group_table = app.eigenvector_group_table;  % Tabelle für Gruppen der Eigenvektoren
    freq_table = app.freq_table_merge;                      % Tabelle für Frequenzen (Tab "Ergebnis")
    eigenform_graph = app.eigenform_graph_merge;            % Graph für Eigenform    
    freq_table2 = app.freq_table2_merge;                    % Tabelle für Frequenzen (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_table3 = app.freq_table3_merge;                    % Tabelle für Frequenzen (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
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
        % der Anzahl der Gruppen übereinstimmt
        if numel(file_list) ~= num_group
            error(['Die Anzahl der Dateien in diesem Ordner stimmt nicht mit der Anzahl ' ...
                'der Gruppen überein!']);
        end

        % Nach Nummern in den Namen sortieren
        names = {file_list.name};
        numbers = cellfun(@(x) str2double(regexp(x,'\d+','match','once')), names);
        [~,idx] = sort(numbers);
        file_list = file_list(idx);

        % Liste für Dateien instanziieren
        file_path_list = cell(num_group,1);
        freq_all_group = NaN(num_group, num_mode); % (Zeile = Gruppe, Spalte = Mode)

        % Alle Gruppen durchlaufen
        for k = 1:num_group
        
            % Pfad konstruieren
            file_path = fullfile(folder_path, file_list(k).name);
        
            % Daten einlesen
            freq_this_group = readmatrix(file_path,'NumHeaderLines',1);

            % Fehlermeldung falls die Datei nicht genau 2 Spalten hat
            if size(freq_this_group,2) ~= 2
                 error('Die Datei für Gruppe %d hat nicht genau 2 Spalten!', k);            
            end

            % Eigenfrequenzen holen
            freq_this_group = freq_this_group(:,2);
    
            % Fehlermeldung falls die Anzahl der Eigenfrequenzen in dieser
            % Datei nicht mit der eingegebenen Anzahl der Moden übereinstimmt
            if length(freq_this_group) ~= num_mode 
                 error(['Die Anzahl der Eigenfrequenzen in Gruppe %d stimmt ' ...
                     'nicht mit der Anzahl der Moden überein!'], k);
            end

            % Pfad und Daten in die Liste hinzufügen
            file_path_list{k} = file_path;
            freq_all_group(k, :) = freq_this_group';
        end

        % Wenn Eigenfrequenzen bereits importiert wurden, den Benutzer warnen
        if ~isempty(app.fig.UserData.cache.merge.eigenfreq)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(app.fig, ['Eigenfrequenzen bereits importiert. Alle Daten ' ...
                'dieses Modus werden gelöscht. Möchten Sie fortfahren?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);

            % Wahl von Benutzer
            switch choice

                % Wenn "nein", Daten beibehalten und weiter
                case 'Nein'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Daten beibehalten', 'erfolg');
                    return;

                % Wenn "ja", Daten löschen und relevante Komponenten zurücksetzen
                case 'Ja'

                    % Tabellen zurücksetzen
                    eigenfreq_group_table.Data = [];
                    eigenfreq_group_table.UserData.row_selected = NaN;
                    eigenfreq_table.Data = [];
                    eigenfreq_table.ColumnName = {'Eigenfrequenzen werden hier angezeigt'};
                    
                    % Betroffene Tabs zurücksetzen
                    app = reset_partial_app(app, 'merge');

                    % Status aktualisieren
                    update_status(status, lamp, '>> Daten dieses Modus gelöscht', 'erfolg');
                    pause(1);

                    % Diesen Callback erneut rufen
                    import_eigenfreq_group_button_pushed(app);
                    return;                    
            end            
        end     

        % Standardabweichung der Frequenzen berechnen
        deviation = std(freq_all_group);

        % Falls Standardabweichung größer als 0.5
        if any(deviation > 0.5)

            % Diese Mode finden
            idx = find(deviation > 0.5, 1, "first");

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(app.fig, compose('Standardabweichung der Eigenfrequenzen der %d. Mode größer als 0,5. Möchten Sie trotzdem fortfahren?', idx),'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);

            % Wahl von Benutzer
            switch choice

                % Wenn "nein", Vorgang abbrechen
                case 'Nein'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Vorgang abgebrochen', 'erfolg');
                    return;

                % Wenn "ja", fortfahren
                case 'Ja'                
            end             
        end        

        % Kategorien für Gruppen und Moden erstellen
        group_option = 1:num_group;
        mode_option = 1:num_mode;

        % Auswahl der Kategorien zuordnen
        group_selected = (1:num_group)';
        group_cat = categorical(group_selected, group_option);

        % Tabelle für Gruppen der Eigenfrequenzen aktualisieren
        status_col = repmat({'Importiert'}, num_group, 1);
        tdata = table(group_cat, file_path_list, status_col);
        eigenfreq_group_table.Data = tdata;        
        eigenfreq_group_table_col_title = {'Gruppe'; 'Pfad zur Datei'; 'Status'};
        eigenfreq_group_table.ColumnName = eigenfreq_group_table_col_title;
        eigenfreq_group_table.ColumnWidth ={'1x', '7x', '1x'};
        eigenfreq_group_table.RowName = 'numbered';
        color_success = uistyle('BackgroundColor','green'); 
        addStyle(eigenfreq_group_table, color_success, 'cell', [ (1:num_group)' , repmat(3,num_group,1) ]);
        eigenfreq_group_table.ColumnEditable = [true false false];

        % Dropdown für Gruppennummer aktualisieren
        group_number_dropdown.Items = string(1:num_group);

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

        % Resultierende Eigenfrequenzen berechnen
        result_eigenfreq = (mean(freq_all_group, 1))';

        % Variablen speichern
        eigenfreq_group_table.UserData.group_config = group_option';
        eigenvector_group_table.UserData.group_config = zeros(num_mode*num_group, 2);
        app.fig.UserData.cache.merge.num_mode = num_mode;
        app.fig.UserData.cache.merge.num_group = num_group;
        app.fig.UserData.cache.merge.eigenfreq = freq_all_group;
        app.fig.UserData.cache.merge.result_eigenfreq = result_eigenfreq;
        app.fig.UserData.cache.merge.eigenvector = cell(num_group, num_mode);     

        % Ergebnisse in restlichen GUI-Komponenten aktualisieren
        update_result_merge(eigenform_graph, result_eigenfreq, freq_table, freq_table2, freq_table3);  

        % Status aktualisieren
        update_status(status, lamp, '>> Eigenfrequenzen importiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end