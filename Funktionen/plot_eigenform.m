%% Funktion zum Plotten der Eigenform
% Author: Philipp Kähler, Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Stammt aus FDD-Algorithmus von Philipp Kähler, ggf. angepasst

% Übergabeparameter:    graph = Achse fürs Plotten
%                       phi = Eigenform
%                       knotenkoord = Koordinaten der Punkte
%                       balkenkoord = Anfangs- und Endknoten der Linien
%                       dof_data = Zuweisungen der Sensoren zu den Knoten
%                       surfaca_matrix = Linien der Flächen
%                       scale = Skalierungsfaktor für die Eigenform
%                       ansicht = gewählte Ansicht
%                       direction = gewählte Richtungen
%                       freq = Eigenfrequenz
%                       oma = OMA-Methode

% Ausgabeparameter: -

function plot_eigenform(graph, phi, knotenkoord, balkenkoord, dof_data, surface_matrix, scale, ansicht, direction, freq, oma)

    % Größe der Matrix anpassen
    [Nyy,N] = size(phi);
    if Nyy < N
        phi = phi';
    end
    
    % Graph zurücksetzen
    cla(graph);
        
    % Skalieren der Eigenformen auf die Maximalamplitude von 1
    maximalwert = max(abs(phi(:,1)));
    skalier = 1/maximalwert;
    phi(:,1) = phi(:,1)*skalier;
    fensterskal = max(abs(phi(:,1)));
    
    %---------------------------------------------------------------------%
    %             Plotten des ursprünglichen Objekts (unbewegt)
    %---------------------------------------------------------------------%
    % Plotten der Knoten
    scatter3(graph, knotenkoord(:,2),knotenkoord(:,3),knotenkoord(:,4),'+');
    axis(graph, 'equal');
    xlim(graph, [min(knotenkoord(:,2)-scale*fensterskal),max(knotenkoord(:,2)+scale*fensterskal)]);
    ylim(graph, [min(knotenkoord(:,3)-scale*fensterskal),max(knotenkoord(:,3)+scale*fensterskal)]);
    zlim(graph, [min(knotenkoord(:,4)-scale*fensterskal),max(knotenkoord(:,4)+scale*fensterskal)]);
    
    % Winkel für verschiedene Ansichten
    angle = [-37.5, 30;
               0,  0;
             -90,  0;
               0, 90];
    
    % Ansicht wählen
    angle_selected = angle(ansicht, :);
    view(graph, angle_selected);
    hold(graph, 'on');
    
    % Beschriften der Knoten mit den entsprechenden Nummern
    for i=1:size(knotenkoord, 1)
        text(graph, knotenkoord(i,2),knotenkoord(i,3),knotenkoord(i,4),num2str(knotenkoord(i,1)));
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
        plot3(graph, x_koord,y_koord,z_koord,'--b','LineWidth',0.5);
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
    
            % Eigenform dazu addieren
            knotenkoord2(knotennr,2) = x_koord+scale*phi(i,1);
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
    
            % Eigenform dazu addieren
            knotenkoord2(knotennr,3) = y_koord+scale*phi(i+1,1);
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
    
            % Eigenform dazu addieren
            knotenkoord2(knotennr,4) = z_koord+scale*phi(i+2,1);
        end
    end
    
    %---------------------------------------------------------------------%
    %                       Plotten der Eigenform
    %---------------------------------------------------------------------%
    % Plotten der verschobenen Knoten
    scatter3(graph, knotenkoord2(:,2),knotenkoord2(:,3),knotenkoord2(:,4),'+r');
    
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
        plot3(graph, x_koord,y_koord,z_koord,'-r','LineWidth',2);
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
        fill3(graph, x, y, z, [0.8500 0.3250 0.0980], 'FaceAlpha', 0.5);            
    end

    % Wenn die OMA-Methode eingegeben wurde, muss sie im Titel angezeigt werden
    if nargin == 11
        head_line = ['\textbf{Eigenform f\"ur Frequenz ', num2str(freq), ' Hz anhand ', char(oma), '}'];

    % Sonst Titel ohne OMA-Methode anzeigen
    else
        head_line = ['\textbf{Eigenform f\"ur Frequenz ', num2str(freq), ' Hz}'];
    end

    % Titel erzeugen
    title(graph, head_line);
end