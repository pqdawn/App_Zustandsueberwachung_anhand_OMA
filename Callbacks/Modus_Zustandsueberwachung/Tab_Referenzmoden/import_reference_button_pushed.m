%% Callback für Button zum Importieren der Referenzmoden
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function import_reference_button_pushed(app)

    % Nötige Variablen holen
    eigenfreq_path = app.eigenfreq_path_edit_field_monitor.Value;       % Pfad zu Eigenfrequenzen
    eigenvector_path = app.eigenvector_path_edit_field_monitor.Value;   % Pfad zu Eigenvektoren
    eigenfreq_table = app.eigenfreq_table_monitor;                      % Tabelle für Eigenfrequenzen
    eigenvector_table = app.eigenvector_table_monitor;                  % Tabelle für Eigenvektor
    target_spinner_fdd = app.target_num_spinner_fdd_monitor;            % Spinner für Zielanzahl (FDD)
    target_spinner_ssi_cov = app.target_num_spinner_ssi_cov_monitor;    % Spinner für Zielanzahl (SSI-COV)
    target_spinner_ssi_data = app.target_num_spinner_ssi_data_monitor;  % Spinner für Zielanzahl (SSI-DATA)
    lamp = app.status_lamp;                                             % Licht des Status
    status = app.status_text_area;                                      % Textfeld des Status

    try
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(app.fig.UserData.cache.monitor.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Fehlermeldung falls Pfad nicht eingegeben
        if isempty(eigenfreq_path)
            error('Dateipfad zu Eigenfrequenzen nicht eingegeben!');
        end
        if isempty(eigenvector_path)
            error('Ordnerpfad zu Eigenvektoren nicht eingegeben!');
        end        

        % Fehlermeldung falls Pfad nicht gültig
        if ~isfile(eigenfreq_path)
            error('Dateipfad zu Eigenfrequenzen nicht gültig!');
        end
        if ~isfolder(eigenvector_path)
            error('Ordnerpfad zu Eigenvektoren nicht gültig!');
        end   
        
        % Eigenfrequenzen einlesen
        freq_matrix = readmatrix(eigenfreq_path,'NumHeaderLines',1);

        % Anzahl der Eigenfrequenzen holen
        num_freq = size(freq_matrix, 1);        

        % Alle TXT-Dateien im Ordner für Eigenvektoren finden
        file_list = dir(fullfile(eigenvector_path,'*.txt'));

        % Fehlermeldung falls Anzahl der gefundenen Dateien nicht mit
        % der Anzahl der Eigenfrequenzen übereinstimmt
        if numel(file_list) ~= num_freq
            error(['Anzahl der gefundenen Dateien für Eigenvektoren stimmt nicht mit der Anzahl ' ...
                'der Eigenfrequenzen überein!']);
        end

        % Nach Nummern in den Namen sortieren
        names = {file_list.name};
        numbers = cellfun(@(x) str2double(regexp(x,'\d+','match','once')), names);
        [~,idx] = sort(numbers);
        file_list = file_list(idx);

        % Zwischenspeicher für alle Eigenvektoren instanziieren (Zeile = Mode)
        eigenvector_matrix_all_mode = cell(num_freq, 1);

        % Alle Eigenfrequenzen durchlaufen
        for k = 1:num_freq
        
            % Pfad konstruieren
            file_path = fullfile(eigenvector_path, file_list(k).name);
        
            % Daten einlesen
            eigenvector_matrix = readmatrix(file_path,'NumHeaderLines',1);
        
            % Fehlermeldung falls die Datei nicht genau 3 Spalten hat
            if size(eigenvector_matrix,2) ~= 3
                 error('Eine Datei hat nicht genau 3 Spalten!');
            end

            % Zwischenspeichern
            eigenvector_matrix_all_mode{k, 1} = eigenvector_matrix;
        end

        % Wenn Referenzmoden bereits importiert wurden, den Benutzer warnen
        if ~isempty(app.fig.UserData.cache.monitor.ref_eigenfreq)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(app.fig, ['Referenzmoden bereits importiert. ' ...
                'Alle Referenzmoden und Ergebnisse werden gelöscht. Möchten Sie fortfahren?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);

            % Wahl von Benutzer
            switch choice

                % Wenn "nein", Referenzmoden und Ergebnisse beibehalten und weiter
                case 'Nein'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Referenzmoden und Ergebnisse beibehalten', 'erfolg');
                    return;

                % Wenn "ja", Referenzmoden und Ergebnisse löschen und relevante Komponenten zurücksetzen
                case 'Ja'

                    % Tabelle zurücksetzen
                    eigenfreq_table.Data = [];
                    eigenfreq_table.UserData.row_selected = NaN;
                    eigenvector_table.Data = [];
                    eigenvector_table.ColumnName = {'Eigenvektoren werden hier angezeigt'};

                    % Daten zurücksetzen
                    app.fig.UserData.cache.monitor.ref_eigenfreq = [];
                    app.fig.UserData.cache.monitor.ref_eigenvector = {};  
                    app.fig.UserData.cache.monitor.segment_info = struct([]);
                    app.fig.UserData.cache.monitor.fdd_result = struct([]);
                    app.fig.UserData.cache.monitor.selected_peak = struct([]);
                    app.fig.UserData.cache.monitor.efdd_result = struct([]);
                    app.fig.UserData.cache.monitor.cov_all_pole = struct([]);
                    app.fig.UserData.cache.monitor.cov_selected_pole = struct([]);
                    app.fig.UserData.cache.monitor.cov_unselected_counter = NaN;
                    app.fig.UserData.cache.monitor.data_all_pole = struct([]);
                    app.fig.UserData.cache.monitor.data_selected_pole = struct([]);
                    app.fig.UserData.cache.monitor.data_unselected_counter = NaN;
                    app.fig.UserData.cache.monitor.track_freq.fdd = [];
                    app.fig.UserData.cache.monitor.track_freq.efdd = [];
                    app.fig.UserData.cache.monitor.track_freq.ssi_cov = [];
                    app.fig.UserData.cache.monitor.track_freq.ssi_data = [];
                    app.fig.UserData.cache.monitor.track_phi.fdd = [];
                    app.fig.UserData.cache.monitor.track_phi.efdd = [];
                    app.fig.UserData.cache.monitor.track_phi.ssi_cov = [];
                    app.fig.UserData.cache.monitor.track_phi.ssi_data = [];    
                    app.fig.UserData.cache.monitor.used_parameter.num_segment = NaN;
                    app.fig.UserData.cache.monitor.used_parameter.fdd = struct([]);
                    app.fig.UserData.cache.monitor.used_parameter.cov = struct([]);
                    app.fig.UserData.cache.monitor.used_parameter.cov_cluster = struct([]);
                    app.fig.UserData.cache.monitor.used_parameter.data = struct([]);
                    app.fig.UserData.cache.monitor.used_parameter.data_cluster = struct([]);   
                    app.fig.UserData.cache.monitor.current_parameter.num_segment = NaN;
                    app.fig.UserData.cache.monitor.current_parameter.fdd = struct([]);
                    app.fig.UserData.cache.monitor.current_parameter.cov = struct([]);
                    app.fig.UserData.cache.monitor.current_parameter.cov_cluster = struct([]);
                    app.fig.UserData.cache.monitor.current_parameter.data = struct([]);
                    app.fig.UserData.cache.monitor.current_parameter.data_cluster = struct([]);                     
                    
                    % Betroffene Tabs zurücksetzen
                    app = reset_partial_app(app, 'reference');

                    % Status aktualisieren
                    update_status(status, lamp, '>> Referenzmoden und Ergebnisse gelöscht', 'erfolg');
                    pause(1);

                    % Diesen Callback erneut rufen
                    import_reference_button_pushed(app);
                    return;                    
            end            
        end        

        % Importierte Daten speichern (Zeile = Mode)
        app.fig.UserData.cache.monitor.ref_eigenfreq = freq_matrix(:,2);
        app.fig.UserData.cache.monitor.ref_eigenvector = eigenvector_matrix_all_mode;         

        % Tabelle aktualisieren
        num_col = string(1:num_freq)';
        eigenfreq_table.Data = [num_col, freq_matrix(:,2)];
        eigenfreq_table_col_title = {'Mode'; 'Frequenz [Hz]'};
        eigenfreq_table.ColumnName = eigenfreq_table_col_title;
        eigenfreq_table.RowName = 'numbered';
        eigenfreq_table.ColumnWidth = repmat({'1x'}, 1, 2);

        % Spinner für Zielanzahl der Moden aktualisieren
        target_spinner_fdd.Value = num_freq;
        target_spinner_ssi_cov.Value = num_freq;
        target_spinner_ssi_data.Value = num_freq;

        % Status aktualisieren
        update_status(status, lamp, '>> Referenzmoden importiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end