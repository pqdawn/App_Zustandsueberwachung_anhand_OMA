%% Callback für Button zum Exportieren der modalen Parameter (Modus "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function export_mod_parameter_button_pushed_merge(app)

    % Nötige Variablen holen
    result_eigenform = app.fig.UserData.cache.merge.result_eigenform;       % Ergebnisse der Zusammenführung
    freq_table = app.freq_table2_merge.Data;                                % Tabelle für Ergebnisse
    path = app.mod_parameter_path_edit_field_merge.Value;                   % Pfad zum Zielordner
    eigenfreq_tick = app.eigenfreq_check_merge.Value;                       % Checkbox für Eigenfrequenz
    eigenvector_tick = app.eigenvector_check_merge.Value;                   % Checkbox für Eigenvektor
    lamp = app.status_lamp;                                                 % Licht des Status
    status = app.status_text_area;                                          % Textfeld des Status

    try
        % Fehlermeldung falls keine Eigenfrequenzen importiert
        if isempty(app.fig.UserData.cache.merge.eigenfreq)
            error('Keine Eigenfrequenzen importiert!');
        end

        % Fehlermeldung falls Eigenvektoren nicht vollständig importiert
        if any(cellfun(@isempty, app.fig.UserData.cache.merge.eigenvector))
            error('Eigenvektoren nicht vollständig importiert!');
        end

        % Fehlermeldung falls Pfad nicht eingegeben
        if isempty(path)
            error('Pfad nicht eingegeben!');
        end

        % Falls dieser Ordner nicht existiert, einen neuen Ordner erstellen
        if ~exist(path, 'dir')
            mkdir(path);
        end

        % Fehlermeldung falls noch keine Ergebnisse
        if isempty(freq_table)
            error('Keine Ergebnisse!')
        end

        % Eigenvektor gewählt
        if eigenvector_tick        

            % Geometrie holen
            cache_geometry = app.fig.UserData.cache.merge.geometry;
    
            % Fehlermeldung falls Geometrie nicht aktualisiert
            if isempty(cache_geometry)
                error('Für Eigenvektor muss Geometrie aktualisiert werden!');
            end  
        end

        % Eigenfrequenzen holen
        freq_matrix = table2array(freq_table(:, 1));

        % Zu exportierende Ergebnisse holen
        to_export =  table2array(freq_table(:, 2));

        % Fehlermeldung falls gar kein Ergebnis gewählt
        if all(to_export == false)
            error('Kein Ergebnis gewählt!');
        end

        % Fehlermeldung falls gar keine Daten gewählt
        num_option = sum([eigenfreq_tick, eigenvector_tick]);
        if num_option == 0
            error('Keine Daten gewählt!');
        end

        % Nur die gewählten Eigenfrequenzen weiter betrachten
        freq_matrix = freq_matrix(to_export, :);        

        % Eigenfrequenz gewählt
        if eigenfreq_tick

            % Eigenfrequenzen holen
            num_freq = [(1:size(freq_matrix,1))', freq_matrix];
    
            % Datei erstellen
            file_name = strcat(path, '\Eigenfrequenz.txt');
            fid = fopen(file_name, 'w+');
            fprintf(fid, 'Nummer     Frequenz [Hz]\n');
            fprintf(fid, '%6.0f        %10.4f\n', num_freq');
            fclose all;
        end

        % Eigenvektor gewählt
        if eigenvector_tick
            
            % Nur die gewählten Eigenformen weiter betrachten
            result_eigenform = result_eigenform(to_export);            

            % Knoten holen
            node_all_group = cache_geometry.assign(:,3);
            unique_node = unique(node_all_group, 'stable');

            % Alle Eigenvektoren durchlaufen
            for i=1:size(result_eigenform, 2)

                % Aktuellen Eigenvektor holen
                phi = result_eigenform{i};

                % Eigenform wieder in eine Spalte einordnen
                phi = reshape(phi.', [], 1);                      
        
                % Skalieren der Eigenvektoren auf die Maximalamplitude von 1
                maximalwert = max(abs(phi));
                skalier = 1/maximalwert;
                phi = phi*skalier;
                phi = reshape(phi, 3, []).';
                node_phi = [unique_node, phi];

                % Datei erstellen
                file_name = strcat(path, '\Eigenvektor_', string(freq_matrix(i)), '_Hz.txt');
                fid = fopen(file_name, 'w+');
                fprintf(fid, 'Knoten      x-Koor      y-Koor      z-Koor\n');
                fprintf(fid, '%6.0f %10.4f %10.4f %10.4f\n', node_phi');
                fclose all;
            end
        end

        % Status aktualisieren
        update_status(status, lamp, '>> Daten exportiert', ...
        'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end