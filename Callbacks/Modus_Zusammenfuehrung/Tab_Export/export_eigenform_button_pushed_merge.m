%% Callback für Button zum Exportieren der Eigenform (Modus "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function export_eigenform_button_pushed_merge(app)

    % Nötige Variablen holen
    result_eigenform = app.fig.UserData.cache.merge.result_eigenform;       % Ergebnisse der Zusammenführung
    freq_table = app.freq_table3_merge.Data;                                % Tabelle für Ergebnisse
    path = app.eigenform_path_edit_field_merge.Value;                       % Pfad zum Zielordner
    displacement_tick = app.displacement_check_merge.Value;                 % Checkbox für maximale Auslenkung
    animation_tick = app.animation_check_merge.Value;                       % Checkbox für Animation
    x_tick = app.x_direct_check3_merge.Value;                               % Checkbox für x-Richtung
    y_tick = app.y_direct_check3_merge.Value;                               % Checkbox für y-Richtung
    z_tick = app.z_direct_check3_merge.Value;                               % Checkbox für z-Richtung
    scale = app.scale_spinner2_merge.Value;                                 % Skalierungsfaktor für die Eigenform
    speed = app.speed_dropdown2_merge.Value;                                % Wiedergabegeschwindigkeit
    view_all_tick = app.view_all_check_merge.Value;                         % Checkbox für alle Ansichten
    view_3d_tick = app.view_3D_check_merge.Value;                           % Checkbox für 3D-Ansicht
    view_side_tick = app.view_side_check_merge.Value;                       % Checkbox für Seitenansicht
    view_cross_tick = app.view_cross_check_merge.Value;                     % Checkbox für Querschnittsansicht
    view_plan_tick = app.view_plan_check_merge.Value;                       % Checkbox für Draufsicht
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

        % Geometrie holen
        cache_geometry = app.fig.UserData.cache.merge.geometry;

        % Fehlermeldung falls Geometrie nicht aktualisiert
        if isempty(cache_geometry)
            error('Für Eigenform muss Geometrie aktualisiert werden!');
        end

        % Komponenten der Geometrie holen
        assign_matrix = cache_geometry.assign;
        node_matrix = cache_geometry.node;
        line_matrix = cache_geometry.line;
        surface_matrix = cache_geometry.surface;

        % Fehlermeldung falls keine Linie definiert wurde
        if isempty(line_matrix)
            error('Keine Linien definiert!');
        end

        % Zuweisungen für Darstellung der Eigenform anpasssen
        assign_matrix = unique(assign_matrix(:, 3), 'stable');
        assign_matrix = [assign_matrix, assign_matrix, assign_matrix];
        assign_matrix = reshape(assign_matrix', [], 1);

        % Koordinaten für Darstellung der Eigenform anpasssen
        list_num_node = 1:size(node_matrix, 1);
        node_matrix = [list_num_node', node_matrix];   

        % Eigenfrequenzen holen
        freq_matrix = table2array(freq_table(:, 1));

        % Zu exportierende Ergebnisse holen
        to_export =  table2array(freq_table(:, 2));

        % Fehlermeldung falls gar kein Ergebnis gewählt
        if all(to_export == false)
            error('Kein Ergebnis gewählt!');
        end

        % Nur die gewählten Eigenfrequenzen und Eigenformen weiter betrachten
        freq_matrix = freq_matrix(to_export, :);
        result_eigenform = result_eigenform(to_export);

        % Fehlermeldung falls gar keine Darstellungsart gewählt
        num_option = sum([displacement_tick, animation_tick]);
        if num_option == 0
            error('Keine Darstellungsart gewählt!');
        end

        % Logische Werte der Richtungen
        direction = [x_tick; y_tick; z_tick];

        % Anzahl der gewählten Richtungen
        num_direct = sum(direction);

        % Fehlermeldung falls gar keine Richtung gewählt
        if num_direct == 0
            error('Keine Richtung gewählt!');
        end        

        % Logische Werte der Ansichten
        view = [view_all_tick; view_3d_tick; view_side_tick; view_cross_tick; view_plan_tick];

        % Anzahl der gewählten Ansichten
        num_view = sum(view);

        % Fehlermeldung falls gar keine Ansicht gewählt
        if num_view == 0
            error('Keine Ansicht gewählt!');
        end

        % Status aktualisieren
        update_status(status, lamp, '>> Bitte warten und das Fenster NICHT schließen...', ...
            'warnung');

        % Alle gewählten Eigenformen durchlaufen
        for i = 1:size(freq_matrix,1)

            % Aktuelle Eigenfrequenz
            eigenfreq_selected = freq_matrix(i);

            % Aktuelle Eigenform
            eigenform_selected = result_eigenform{i};

            % Eigenform wieder in eine Spalte einordnen
            eigenform_selected = reshape(eigenform_selected.', [], 1);            

            % Maximale Auslenkung gewählt
            if displacement_tick
    
                % Alle Ansichten gewählt
                if view_all_tick

                    % Plotten und als PDF exportieren
                    export_displacement_all_views(path, eigenform_selected, node_matrix, line_matrix, assign_matrix, surface_matrix, scale, direction, eigenfreq_selected);
                end

                % 3D-Ansicht gewählt
                if view_3d_tick

                    % Logische Werte der Ansichten
                    view = [true; false; false; false];

                    % Pfad konstruieren
                    file_name = strcat(path, '\Eigenform_', string(freq_matrix(i,1)), '_Hz_3D.pdf');

                    % Plotten
                    fig = figure;
                    ax = axes;
                    plot_eigenform(ax, eigenform_selected, node_matrix, line_matrix, assign_matrix, surface_matrix, scale, view, direction, eigenfreq_selected);
                    xlabel(ax, '\textit{x}');
                    ylabel(ax, '\textit{y}');
                    zlabel(ax, '\textit{z}');

                    % Als PDF exportieren
                    exportgraphics(fig, file_name, 'ContentType', 'vector');

                    % Figur schließen
                    close(fig);
                end

                % Seitenansicht gewählt
                if view_side_tick

                    % Logische Werte der Ansichten
                    view = [false; true; false; false];

                    % Pfad konstruieren
                    file_name = strcat(path, '\Eigenform_', string(freq_matrix(i,1)), '_Hz_Seite.pdf');

                    % Plotten
                    fig = figure;
                    ax = axes;
                    plot_eigenform(ax, eigenform_selected, node_matrix, line_matrix, assign_matrix, surface_matrix, scale, view, direction, eigenfreq_selected);
                    xlabel(ax, '\textit{x}');
                    ylabel(ax, '\textit{y}');
                    zlabel(ax, '\textit{z}');

                    % Als PDF exportieren
                    exportgraphics(fig, file_name, 'ContentType', 'vector');

                    % Figur schließen
                    close(fig);
                end 

                % Querschnittsansicht gewählt
                if view_cross_tick

                    % Logische Werte der Ansichten
                    view = [false; false; true; false];

                    % Pfad konstruieren
                    file_name = strcat(path, '\Eigenform_', string(freq_matrix(i,1)), '_Hz_Querschnitt.pdf');

                    % Plotten
                    fig = figure;
                    ax = axes;
                    plot_eigenform(ax, eigenform_selected, node_matrix, line_matrix, assign_matrix, surface_matrix, scale, view, direction, eigenfreq_selected);
                    xlabel(ax, '\textit{x}');
                    ylabel(ax, '\textit{y}');
                    zlabel(ax, '\textit{z}');

                    % Als PDF exportieren
                    exportgraphics(fig, file_name, 'ContentType', 'vector');
        
                    % Figur schließen
                    close(fig);
                end

                % Draufsicht gewählt
                if view_plan_tick

                    % Logische Werte der Ansichten
                    view = [false; false; false; true];

                    % Pfad konstruieren
                    file_name = strcat(path, '\Eigenform_', string(freq_matrix(i,1)), '_Hz_Drauf.pdf');

                    % Plotten
                    fig = figure;
                    ax = axes;
                    plot_eigenform(ax, eigenform_selected, node_matrix, line_matrix, assign_matrix, surface_matrix, scale, view, direction, eigenfreq_selected);
                    xlabel(ax, '\textit{x}');
                    ylabel(ax, '\textit{y}');
                    zlabel(ax, '\textit{z}');

                    % Als PDF exportieren
                    exportgraphics(fig, file_name, 'ContentType', 'vector');
        
                    % Figur schließen
                    close(fig);
                end
            end

            % Animation gewählt
            if animation_tick

                % ------------------------------------------------------------------------------ %
                % Dieser Abschnitt stammt aus FDD-Algorithmus von Philipp Kähler, ggf. angepasst
    
                % Um Videos erstellen zu können, müssen viele Bilder erstellt 
                % werden, welche zu einem Videofile zusammengefügt werden.
                % Diese unterschiedlichen Bilder entstehen bei verschiedenen
                % Skalierungen der Eigenform. Dementsprechend müssen 
                % verschiedene Skalierungsstufen der Eigenformen berechnet 
                % werden und in einen Vektor geschrieben werden
    
                % Eigenform holen
                phi_uebergeben = eigenform_selected;
    
                % Um die Eigenform in ein bewegtes Bild zu bekommen, muss sie 
                % von 1 bis -1 skaliert werden und von -1 wieder zurück zu 1 
                % (also ein Weg von 4). Zuerst muss die Eigenform auf 1 
                % skaliert werden
                anzBilder = 100;
                maximalwert = max(abs(phi_uebergeben));
                skalier = 1/maximalwert;
                phi_uebergeben = phi_uebergeben*skalier;
    
                % Jeder Wert der Eigenform bekommt einen eigenen 
                % Addierungsfaktor, um am Ende auf genau -1*Eigenform zu kommen
                addfaktor = (abs(phi_uebergeben)*2)/(anzBilder/2-1);
    
                % Stellen finden, an denen phi_test kleiner und größer 0 ist
                stelle_gr = phi_uebergeben > 0;
                stelle_kl = phi_uebergeben < 0;
    
                % Erstellen der Matrix mit den verschiedenskalierten Eigenformen
                phi_matrix = zeros(length(phi_uebergeben),anzBilder);

                % Berechnen der Einträge
                for j=1:anzBilder/2
                    phi_matrix(stelle_gr,j) = phi_uebergeben(stelle_gr)-(j-1)*addfaktor(stelle_gr);
                    phi_matrix(stelle_kl,j) = phi_uebergeben(stelle_kl)+(j-1)*addfaktor(stelle_kl);
                end
    
                % Die zweite Hälfte der Matrix kann durch Spiegelung erzeugt werden
                phi_matrix(:,anzBilder/2+1:end) = fliplr(phi_matrix(:,1:anzBilder/2));
                % ------------------------------------------------------------------------------ %                

                % Wiedergabegeschwindigkeit steuern
                % 0,5x gewählt
                if speed == "0,5x"
                    frame_rate = 5;
    
                % Normal gewählt
                elseif speed == "Normal"
                    frame_rate = 10;
    
                % 1.5x gewählt
                elseif speed == "1,5x"
                    frame_rate = 15;
    
                % 2x gewählt
                elseif speed == "2x"
                    frame_rate = 20;
                end
    
                % Logische Werte der Ansichten
                view = [view_3d_tick; view_side_tick; view_cross_tick; view_plan_tick];

                % Animieren und als AVI-Datei exportieren
                export_animation_diff_views(path, phi_matrix, node_matrix, line_matrix, assign_matrix, surface_matrix, scale, frame_rate, view, direction, eigenfreq_selected);

                % Alle Ansichten gewählt
                if view_all_tick

                    % Animieren und und als AVI-Datei exportieren
                    export_animation_all_views(path, phi_matrix, node_matrix, line_matrix, assign_matrix, surface_matrix, scale, frame_rate, direction, eigenfreq_selected);
                end
            end
        end

        % Status aktualisieren
        update_status(status, lamp, '>> Plots exportiert', 'erfolg');

    % Fehler fangen
    catch ME

        % Spezifische Fehlermeldung wenn eine neue Datei nicht exportiert
        % werden kann, weil eine Datei mit dem gleichen Namen geöffnet ist 
        if contains(ME.message, "Permission")
            update_status(status, lamp, '>> Fehler: Eine Datei mit dem gleichen Namen ist geöffnet! Zugang verweigert!', 'fehler');
        
        % Ansonsten normale Fehlermeldung
        else
            update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
        end
    end
end