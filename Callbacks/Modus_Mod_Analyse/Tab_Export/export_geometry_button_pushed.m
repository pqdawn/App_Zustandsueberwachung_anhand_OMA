%% Callback für Button zum Exportieren der Geometrie (Modus "Modalanalyse")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function export_geometry_button_pushed(app)
    
    % Nötige Variablen holen
    path = app.geometry_path_edit_field.Value;              % Pfad zum Zielordner
    assign_tick = app.assign_check.Value;                   % Wahl für Zuweisungen
    node_tick = app.node_check.Value;                       % Wahl für Knoten
    line_tick = app.line_check.Value;                       % Wahl für Linien
    surface_tick = app.surface_check.Value;                 % Wahl für Flächen
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Fehlermeldung falls Pfad nicht eingegeben
        if isempty(path)
            error('Pfad nicht eingegeben!');
        end

        % Falls dieser Ordner nicht existiert, einen neuen Ordner erstellen
        if ~exist(path, 'dir')
            mkdir(path);
        end

        % Fehlermeldung falls gar keine Daten gewählt
        num_option = sum([assign_tick, node_tick, line_tick, surface_tick]);
        if num_option == 0
            error('Keine Daten gewählt!');
        end

        % Geometrie holen
        cache_geometry = app.fig.UserData.cache.modal.geometry;

        % Fehlermeldung falls Geometrie nicht aktualisiert
        if isempty(cache_geometry)
            error('Geometrie nicht aktualisiert!');
        end        

        % Zuweisungen gewählt
        if assign_tick

            % Zuweisungen holen
            assign_matrix = cache_geometry.assign;
    
            % Datei erstellen
            file_name = strcat(path, '\Zuweisungen.txt');
            fid = fopen(file_name, 'w+');
            fprintf(fid, 'Sensor          Knoten\n');
            fprintf(fid, '%6.0f        %6.0f\n', assign_matrix');
            fclose all;
        end
        
        % Knoten gewählt
        if node_tick
            
            % Knoten holen
            node_matrix = cache_geometry.node;
            node_matrix = [(1:size(node_matrix,1))', node_matrix];

            % Knoten exportieren falls Knoten vorhanden
            if ~isempty(node_matrix)

                % Datei erstellen
                file_name = strcat(path, '\Knoten.txt');
                fid = fopen(file_name, 'w+');
                fprintf(fid, 'Knoten \t x-Koor \t y-Koor \t z-Koor\n');
                fprintf(fid, '%6.0f %8.3f %15.3f %15.3f\n', node_matrix');
                fclose all;

            % Ansonsten Warnung
            else

                % Status aktualisieren
                update_status(status, lamp, ['>> Keine Knoten definiert, ' ...
                    'sie werden nicht exportiert!'], 'warnung');
                pause(1);
            end
        end

        % Linien gewählt
        if line_tick
        
            % Linien holen
            line_matrix = cache_geometry.line;
            line_matrix = [(1:size(line_matrix,1))', line_matrix];

            % Linien exportieren falls Linien vorhanden
            if ~isempty(line_matrix)

                % Datei erstellen
                file_name = strcat(path, '\Linien.txt');
                fid = fopen(file_name, 'w+');
                fprintf(fid, 'Linie \t 1. Knoten \t 2. Knoten\n');
                fprintf(fid, '%5.0f %12.0f %15.0f\n', line_matrix');
                fclose all;

            % Ansonsten Warnung
            else

                % Status aktualisieren
                update_status(status, lamp, ['>> Keine Linien definiert, ' ...
                    'sie werden nicht exportiert!'], 'warnung');
                pause(1);
            end
        end

        % Flächen gewählt
        if surface_tick
        
            % Flächen holen
            surface_matrix = cache_geometry.surface;
            surface_matrix = [(1:size(surface_matrix,1))', surface_matrix];

            % Flächen exportieren falls Flächen vorhanden
            if ~isempty(surface_matrix)

                % Datei erstellen
                file_name = strcat(path, '\Flaechen.txt');
                fid = fopen(file_name, 'w+');
                fprintf(fid, 'Fläche \t 1. Linie \t 2. Linie \t 3. Linie\n');
                fprintf(fid, '%6.0f %10.0f %15.0f %15.0f\n', surface_matrix');
                fclose all;

            % Ansonsten Warnung
            else

                % Status aktualisieren
                update_status(status, lamp, ['>> Keine Flächen definiert, ' ...
                    'sie werden nicht exportiert!'], 'warnung');
                pause(1);
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