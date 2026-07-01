%% Callback für Button zum Aktualisieren der Gruppen der Eigenfrequenzen
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function update_eigenfreq_group_button_pushed(app)

    % Nötige Variablen holen
    eigenfreq_group_table = app.eigenfreq_group_table;      % Tabelle für Gruppen der Eigenfrequenzen
    freq_table = app.freq_table_merge;                      % Tabelle für Frequenzen (Tab "Ergebnis")
    eigenform_graph = app.eigenform_graph_merge;            % Graph für Eigenform
    freq_table2 = app.freq_table2_merge;                    % Tabelle für Frequenzen (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_table3 = app.freq_table3_merge;                    % Tabelle für Frequenzen (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status 
    
    try
        % Fehlermeldung falls keine Eigenfrequenzen importiert
        if isempty(app.fig.UserData.cache.merge.eigenfreq)
            error('Keine Eigenfrequenzen importiert!');
        end

        % Importierte Daten und Infos holen
        num_mode = app.fig.UserData.cache.merge.num_mode;
        num_group = app.fig.UserData.cache.merge.num_group;    

        % Moden in der Tabelle für Gruppen der Eigenfrequenzen holen
        new_config = eigenfreq_group_table.Data{:,1};
        new_config = double(new_config);

        % Gespeicherte Zuordnung holen
        prev_config = eigenfreq_group_table.UserData.group_config;        

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

        % Array für Eigenfrequenzen instanziieren
        freq_all_group = NaN(num_group, num_mode); % (Zeile = Gruppe, Spalte = Mode)        

        % Alle Zeilen durchlaufen
        for i = 1:length(new_config)

            % Gruppe in dieser Zeile holen
            group_current = new_config(i);        

            % Fehlermeldung falls diese Gruppe bereits zugeordnet wurde
            if any(~isnan(freq_all_group(group_current,:)))
                error('%d. Gruppe wurde mehrmals zugeordnet!', group_current);
            end            

            % Pfad zur Datei holen
            path = string(eigenfreq_group_table.Data{i,2});

            % Daten einlesen
            freq_this_group = readmatrix(path, 'NumHeaderLines', 1);    
            freq_this_group = freq_this_group(:,2);            

            % Eigenfrequenzen in die Liste hinzufügen (Zeile = Gruppe, Spalte = Mode)
            freq_all_group(group_current,:) = freq_this_group;            
        end        

        % Tabelle aktualisieren
        status_col = repmat({"Importiert"}, num_group, 1);
        eigenfreq_group_table.Data{:,3} = status_col;
        color_success = uistyle('BackgroundColor','green'); 
        addStyle(eigenfreq_group_table, color_success, 'cell', [ (1:num_group)' , repmat(3,num_group,1) ]);   

        % Resultierende Eigenfrequenzen berechnen
        result_eigenfreq = (mean(freq_all_group, 1))';

        % Variablen speichern
        eigenfreq_group_table.UserData.group_config = new_config;
        app.fig.UserData.cache.merge.eigenfreq = freq_all_group;
        app.fig.UserData.cache.merge.result_eigenfreq = result_eigenfreq;

        % Ergebnisse in restlichen GUI-Komponenten aktualisieren
        update_result_merge(eigenform_graph, result_eigenfreq, freq_table, freq_table2, freq_table3);        

        % Status aktualisieren
        update_status(status, lamp, '>> Zuordnung aktualisiert', 'erfolg');           

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
        return;
    end
end        