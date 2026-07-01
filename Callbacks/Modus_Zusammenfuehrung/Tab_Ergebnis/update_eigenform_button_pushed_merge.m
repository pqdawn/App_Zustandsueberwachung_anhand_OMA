%% Callback für Button zum Darstellen der Eigenform (Modus "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function update_eigenform_button_pushed_merge(app, src, fig)
    
    % Nötige Variablen holen
    update_eigenform_button = app.update_eigenform_button;                % Button für Darstellen der Eigenform (Modus "Modalanalyse")
    freq_table = app.freq_table_merge;                                    % Tabelle für Ergebnisse
    display_displacement = app.display_displacement_radio_merge.Value;    % Wahl für maximale Auslenkung
    display_animation = app.display_animation_radio_merge.Value;          % Wahl für Animation
    x_tick = app.x_direct_check_merge.Value;                              % Checkbox für x-Richtung
    y_tick = app.y_direct_check_merge.Value;                              % Checkbox für y-Richtung
    z_tick = app.z_direct_check_merge.Value;                              % Checkbox für z-Richtung
    scale = app.scale_spinner_merge.Value;                                % Skalierungsfaktor für die Eigenform
    speed = app.speed_dropdown_merge.Value;                               % Wiedergabegeschwindigkeit
    view_3d = app.view_3D_radio_merge.Value;                              % Wahl für 3D-Ansicht
    view_side = app.view_side_radio_merge.Value;                          % Wahl für Seitenansicht
    view_cross = app.view_cross_radio_merge.Value;                        % Wahl für Querschnittsansicht
    view_plan = app.view_plan_radio_merge.Value;                          % Wahl für Draufsicht
    eigenform_graph = app.eigenform_graph_merge;                          % Graph für Eigenform
    stop_button = app.stop_button_merge;                                  % Button für Stoppen der Animation
    lamp = app.status_lamp;                                               % Licht des Status
    status = app.status_text_area;                                        % Textfeld des Status

    try
        % Fehlermeldung falls keine Eigenfrequenzen importiert
        if isempty(app.fig.UserData.cache.merge.eigenfreq)
            error('Keine Eigenfrequenzen importiert!');
        end

        % Fehlermeldung falls Eigenvektoren nicht vollständig importiert
        if any(cellfun(@isempty, app.fig.UserData.cache.merge.eigenvector))
            error('Eigenvektoren nicht vollständig importiert!');
        end

        % Fehlermeldung falls noch keine Ergebnisse
        if isempty(freq_table.Data)
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

        % Frequenzen und Dämpfungen holen
        freq_damp_matrix = freq_table.Data;

        % Gewählte Zeile holen
        row_selected = freq_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(freq_damp_matrix, 1)
            error('Keine Zeile gewählt!');
        end

        % Zugehörige Eigenfrequenz holen
        eigenfreq_selected = freq_damp_matrix(row_selected, 1);

        % Eigenform holen
        eigenform_selected = cell2mat(app.fig.UserData.cache.merge.result_eigenform(row_selected));

        % Eigenform in eine Spalte einordnen
        eigenform_selected = reshape(eigenform_selected.', [], 1);        

        % Logische Werte der Richtungen
        direction = [x_tick; y_tick; z_tick];

        % Anzahl der gewählten Richtungen
        num_direct_chosen = sum(direction);

        % Fehlermeldung falls gar keine Richtung gewählt
        if num_direct_chosen == 0
            error('Keine Richtung gewählt!');
        end

        % Logische Werte der Ansichten
        view = [view_3d; view_side; view_cross; view_plan];

        % Maximale Auslenkung gewählt
        if display_displacement == 1

            % Plotten
            plot_eigenform(eigenform_graph, eigenform_selected, node_matrix, line_matrix, assign_matrix, surface_matrix, scale, view, direction, eigenfreq_selected);
    
            % Status aktualisieren
            update_status(status, lamp, '>> Eigenform aktualisiert', ...
                'erfolg');

        % Animation gewählt
        elseif display_animation == 1

            % Wenn die Geometrie zu kompliziert (mehr als 10 Knoten) ist, den Benutzer 
            % warnen, weil die App abbricht, wenn die Rechnerleistung unzureichend ist
            if size(node_matrix, 1) > 10
    
                % Warnung
                update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
                choice = uiconfirm(fig, ['Die Geometrie ist möglicherweise zu komplex. ' ...
                    'Bei unzureichender Rechnerleistung könnte die App ' ...
                    'abstürzen! Es wird empfohlen, die Eigenformen direkt zu ' ...
                    'exportieren! Möchten Sie trotzdem fortfahren? '],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 2);
                
                % Wahl von Benutzer
                switch choice
    
                    % Wenn "ja", weiter
                    case 'Ja'
                    
                    % Wenn "nein", Vorgang abbrechen
                    case 'Nein'
    
                        % Status aktualisieren
                        update_status(status, lamp, '>> Vorgang abgebrochen', 'erfolg');
                        return;
                end            
            end
            
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
            
            % Zeitschritt des Timers (Timer wurde unter
            % "update_eigenform_button" gespeichert)
            update_eigenform_button.UserData.time_step = 1;

            % Wiedergabegeschwindigkeit steuern
            % 0,5x gewählt
            if speed == "0,5x"
                update_eigenform_button.UserData.clock.Period = 0.2;

            % Normal gewählt
            elseif speed == "Normal"
                update_eigenform_button.UserData.clock.Period = 0.1;

            % 1.5x gewählt
            elseif speed == "1,5x"
                update_eigenform_button.UserData.clock.Period = 0.067;

            % 2x gewählt
            elseif speed == "2x"
                update_eigenform_button.UserData.clock.Period = 0.05;
            end
            
            % Funktion für Animation mit Timer definieren
            update_eigenform_button.UserData.clock.TimerFcn = @(~,~)animate_mode_shape(eigenform_graph, update_eigenform_button, phi_matrix, node_matrix, line_matrix, assign_matrix, surface_matrix, scale, view, direction, eigenfreq_selected);

            % Animation starten
            start(update_eigenform_button.UserData.clock)

            % Flagge aktualisieren
            update_eigenform_button.UserData.is_animating = true;

            % Diesen Button deaktivieren
            src.Enable = 'off';

            % Button für Stoppen aktivieren
            stop_button.Enable = 'on';
            
            % Status aktualisieren
            update_status(status, lamp, '>> Animation läuft...', ...
            'warnung');
        end   
        
    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end