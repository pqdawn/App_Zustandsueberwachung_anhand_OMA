%% Funktion zum Exportieren der Animation einer Eigenform (Verschiedene Ansichten)
% Author: Philipp Kähler, Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Stammt aus FDD-Algorithmus von Philipp Kähler, ggf. angepasst

% Übergabeparameter:    path = Pfad zum Zielordner
%                       phi = Eigenform
%                       knotenkoord = Koordinaten der Punkte
%                       balkenkoord = Anfangs- und Endknoten der Linien
%                       dof_data = Zuweisungen der Sensoren zu den Knoten
%                       surfaca_matrix = Linien der Flächen
%                       scale = Skalierungsfaktor für die Eigenform
%                       frame_rate = Wiedergabegeschwindigkeit
%                       ansicht = gewählte Ansicht
%                       direction = gewählte Richtungen
%                       freq = Eigenfrequenz
%                       oma = OMA-Methode

% Ausgabeparameter: -

function export_animation_diff_views(path, phi, knotenkoord, balkenkoord, ...
    dof_data, surface_matrix, scale, frame_rate, ansicht, direction, freq, oma)

    % Titel für verschiedene Ansichten
    name_view = {'3D', 'Seite', 'Querschnitt', 'Drauf'};

    % Winkel für verschiedene Ansichten
    angle = [-37.5, 30; % 3D-Ansicht
               0,  0;   % Seitenansicht
             -90,  0;   % Querschnittansicht
               0, 90];  % Draufsicht

    % Alle Ansichten durchlaufen
    for k = 1:4

        % Wenn diese Ansicht gewählt wurde
        if ansicht(k)

            % Erstellen eines Bildfensters, welches geupdated wird
            figure('units','normalized','outerposition',[0 0 1 1]); 

            % Wenn die OMA-Methode eingegeben wurde, muss sie in den Titel 
            % und Pfad angezeigt werden
            if nargin == 12
                head_line = ['\textbf{Eigenform f\"ur Frequenz ', num2str(freq), ' Hz anhand ', char(oma), '}'];
                file_name = strcat('Eigenform_', num2str(freq), '_Hz_', char(name_view(k)), '_', oma, '.avi');
        
            % Sonst Titel und Pfad ohne OMA-Methode anzeigen
            else
                head_line = ['\textbf{Eigenform f\"ur Frequenz ', num2str(freq), ' Hz}'];
                file_name = strcat('Eigenform_', num2str(freq), '_Hz_', char(name_view(k)), '.avi');
            end            

            % Pfad konstruieren
            full_path = fullfile(path, file_name);

            % Bildobjekt erstellen
            myVideo = VideoWriter(full_path);

            % Bilder pro Sekunde
            myVideo.FrameRate = frame_rate;
            
            % Videodatei öffnen
            open(myVideo); 
            
            % Ansicht wählen
            angle_selected = angle(k, :);
    
            % Schleife über alle Skalierungsstufen
            for j=1:size(phi,2)
        
                % Ansicht
                axis equal;
                view(angle_selected);
                hold on;
        
                % Titel
                title(head_line);
        
                % Grid
                grid on;
            
                %---------------------------------------------------------------------%
                %             Plotten des ursprünglichen Objekts (unbewegt)
                %---------------------------------------------------------------------%
                % Plotten der Knoten
                scatter3(knotenkoord(:,2),knotenkoord(:,3),knotenkoord(:,4),'+');
            
                % Maximalwert herauslesen für die Fensterdarstellung
                fensterskal = max(abs(phi(:,1)));
            
                % Festlegen des Bildausschnittes (sollte für das Video immer gleich
                % bleiben)
                xlim([min(knotenkoord(:,2)-scale*fensterskal),max(knotenkoord(:,2)+scale*fensterskal)]);
                ylim([min(knotenkoord(:,3)-scale*fensterskal),max(knotenkoord(:,3)+scale*fensterskal)]);
                zlim([min(knotenkoord(:,4)-scale*fensterskal),max(knotenkoord(:,4)+scale*fensterskal)]);

                % Label
                xlabel('\textit{x}');
                ylabel('\textit{y}');
                zlabel('\textit{z}');                
            
                % Beschriften der Knoten mit den entsprechenden Nummern
                for i=1:size(knotenkoord, 1)
                    text(knotenkoord(i,2),knotenkoord(i,3),knotenkoord(i,4),num2str(knotenkoord(i,1)));
                end
            
                % Plotten der Linien
                for i=1:size(balkenkoord, 1)
                
                    % Anfangsknoten der Linie
                    zeile_anfang = balkenkoord(i,1);
                
                    % Anfangsknoten der Linie in [x_koord,y_koord,z_koord]
                    anfang = [knotenkoord(zeile_anfang,2),knotenkoord(zeile_anfang,3),knotenkoord(zeile_anfang,4)];
                
                    % Endknoten der Linie
                    zeile_ende = balkenkoord(i,2);
                    ende = [knotenkoord(zeile_ende,2),knotenkoord(zeile_ende,3),knotenkoord(zeile_ende,4)];
                
                    % Speichern der Daten in entsprechende Arrays zum Plotten
                    x_koord = [anfang(1,1), ende(1,1)];
                    y_koord = [anfang(1,2), ende(1,2)];
                    z_koord = [anfang(1,3), ende(1,3)];
                
                    % Plotten der Linie zwischen Anfangs- und Endknoten
                    plot3(x_koord,y_koord,z_koord,'--b','LineWidth',0.5);
                end
            
                %---------------------------------------------------------------------%
                %         Zuweisen der Eigenformen zu den jeweiligen Knoten
                %---------------------------------------------------------------------%
                % instanziieren von einer neuen Koordiantenvektormatrix
                knotenkoord2 = knotenkoord;
            
                % Relevante Richtungen durchlaufen und zugehörige Verschiebungen zuordnen
                % x-Richtung gewählt
                if direction(1)
                
                    % Zuweisen der Freiheitsgrade an die entsprechenden Knoten
                    for i=1:3:length(dof_data)
                           
                        % Holen der Knotennummer aus den Zuweisungen
                        knotennr = dof_data(i,1);
                
                        % Holen der x-Koordinaten des Knotens
                        x_koord = knotenkoord(knotennr,2);
                
                        % Eigenform mit der j-ten Skalierungsstufe dazu addieren
                        knotenkoord2(knotennr,2) = x_koord+scale*phi(i,j);
                    end
                end
            
                % y-Richtung gewählt
                if direction(2)
                
                    % Zuweisen der Freiheitsgrade an die entsprechenden Knoten
                    for i=1:3:length(dof_data)
                           
                        % Holen der Knotennummer aus den Zuweisungen
                        knotennr = dof_data(i,1);
                
                        % Holen der y-Koordinaten des Knotens
                        y_koord = knotenkoord(knotennr,3);
                
                        % Eigenform mit der j-ten Skalierungsstufe dazu addieren
                        knotenkoord2(knotennr,3) = y_koord+scale*phi(i+1,j);
                    end
                end
                
                % z-Richtung gewählt
                if direction(3)
                
                    % Zuweisen der Freiheitsgrade an die entsprechenden Knoten
                    for i=1:3:length(dof_data)
                           
                        % Holen der Knotennummer aus den Zuweisungen
                        knotennr = dof_data(i,1);
                
                        % Holen der z-Koordinaten des Knotens
                        z_koord = knotenkoord(knotennr,4);
                
                        % Eigenform mit der j-ten Skalierungsstufe dazu addieren
                        knotenkoord2(knotennr,4) = z_koord+scale*phi(i+2,j);
                    end
                end
            
                %---------------------------------------------------------------------%
                %                       Plotten der Eigenform
                %---------------------------------------------------------------------% 
                % Plotten der verschobenen Knoten
                scatter3(knotenkoord2(:,2),knotenkoord2(:,3),knotenkoord2(:,4),'+r');
            
                % Plotten der Linien
                for i=1:size(balkenkoord, 1)
                
                    % Anfangsknoten der Linie
                    zeile_anfang = balkenkoord(i,1);
                
                    % Anfangsknoten der Linie in [x_koord,y_koord,z_koord]
                    anfang = [knotenkoord2(zeile_anfang,2),knotenkoord2(zeile_anfang,3),knotenkoord2(zeile_anfang,4)];
                
                    % Endknoten der Linie
                    zeile_ende = balkenkoord(i,2);
                    ende = [knotenkoord2(zeile_ende,2),knotenkoord2(zeile_ende,3),knotenkoord2(zeile_ende,4)];
                
                    % Speichern der Daten in entsprechende Arrays zum Plotten
                    x_koord = [anfang(1,1), ende(1,1)];
                    y_koord = [anfang(1,2), ende(1,2)];
                    z_koord = [anfang(1,3), ende(1,3)];
                
                    % Plotten der Linie zwischen Anfangs- und Endknoten
                    plot3(x_koord,y_koord,z_koord,'-r','LineWidth',2);
                end

                % Alle Flächen durchlaufen
                for i = 1:size(surface_matrix, 1)
                
                    % Linien holen
                    line1 = surface_matrix(i, 1);
                    line2 = surface_matrix(i, 2);
                    line3 = surface_matrix(i, 3);
                
                    % Alle Knoten von dieser Fläche holen
                    node_of_surface = [balkenkoord(line1, :), balkenkoord(line2, :), balkenkoord(line3, :)];
                
                    % Nur die einzigeartigen Knoten holen
                    node_of_surface_unique = unique(node_of_surface);
                
                    % Ersten Knoten holen
                    node1 = node_of_surface_unique(1);
                
                    % Zweiten Knoten holen
                    node2 = node_of_surface_unique(2);
                
                    % Dritten Knoten holen
                    node3 = node_of_surface_unique(3);
                
                    % Koordinaten der Knoten holen
                    x = [knotenkoord2(node1, 2), knotenkoord2(node2, 2), knotenkoord2(node3, 2)];
                    y = [knotenkoord2(node1, 3), knotenkoord2(node2, 3), knotenkoord2(node3, 3)];
                    z = [knotenkoord2(node1, 4), knotenkoord2(node2, 4), knotenkoord2(node3, 4)];
                
                    % Fläche plotten
                    fill3(x, y, z, [0.8500 0.3250 0.0980], 'FaceAlpha', 0.5);            
                end
        
                % Holen des Bildinhaltes
                frame = getframe(gcf);
            
                % Schreiben der Bilddateien in das Videofile
                writeVideo(myVideo,frame);

                % Löschen aller Bildinhalte
                clf;
            end

            % Schließen der Bilddatei
            close(myVideo);
            close(gcf);

        % Ansonsten wenn diese Ansicht nicht gewählt wurde, nächste Ansicht
        else
            continue;
        end
    end
end