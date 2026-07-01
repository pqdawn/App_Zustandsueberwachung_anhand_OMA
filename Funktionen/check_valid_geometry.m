%% Funktion zum Prüfen gültiger Geometrie
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    assign_matrix = Zuweisungen der Sensoren zu den Knoten
%                       node_matrix = Koordinaten der Punkte
%                       line_matrix = Anfangs- und Endknoten der Linien
%                       surface_matrix = Linien der Flächen

% Ausgabeparameter: -

function check_valid_geometry(assign_matrix, node_matrix, line_matrix, surface_matrix)

    % Alle Zuweisungen durchlaufen
    for i = 1:size(assign_matrix, 1)

        % Knoten holen
        node = assign_matrix(i,2);
        
        % Fehlermeldung, falls dieser Knoten nicht definiert wurde
        if node > size(node_matrix, 1)
            error('Knoten eines Sensors nicht definiert!');
        end
    end

    % Fehlermeldung, falls eine Linie mit "0. Knoten" definiert wurde
    if any(line_matrix(:) == 0)
        error('0 als Eingabe für Linie nicht erlaubt!');
    end

    % Alle Linien durchlaufen
    for i = 1:size(line_matrix, 1)

        % Knoten holen
        node1 = line_matrix(i, 1);
        node2 = line_matrix(i, 2);

        % Prüfen, ob deren Knoten schon definiert wurden
        check1 = logical(node1 <= size(node_matrix,1));
        check2 = logical(node2 <= size(node_matrix,1));

        % Fehlermeldung falls einer davon nicht definiert wurde
        if check1 == false || check2 == false
            error('Knoten in einer Linie noch nicht definiert!')
        end

        % Koordinaten der Knoten holen
        coor_node1 = node_matrix(node1, :);
        coor_node2 = node_matrix(node2, :);

        % Abstand zwischen zwei Knoten berechnen
        squared_distance = sum((coor_node2 - coor_node1).^2);

        % Fehlermeldung, falls Abstand zwischen Knoten gleich Null
        if squared_distance == 0
            error('Länge einer Linie gleich Null!');
        end
    end

    % Fehlermeldung, falls eine Fläche mit "0. Linie" definiert wurde
    if any(surface_matrix(:) == 0)
        error('0 als Eingabe für Fläche nicht erlaubt!');
    end

    % Alle Flächen durchlaufen
    for i = 1:size(surface_matrix, 1)

        % Linien holen
        line1 = surface_matrix(i, 1);
        line2 = surface_matrix(i, 2);
        line3 = surface_matrix(i, 3);

        % Prüfen, ob deren Linien schon definiert wurden
        check1 = logical(line1 <= size(line_matrix,1));
        check2 = logical(line2 <= size(line_matrix,1));
        check3 = logical(line3 <= size(line_matrix,1));

        % Fehlermeldung falls einer davon nicht definiert wurde
        if check1 == false || check2 == false || check3 == false
            error('Linie in einer Fläche noch nicht definiert!')
        end

        % Alle Knoten von dieser Fläche holen
        node_of_surface = [line_matrix(line1, :), line_matrix(line2, :), line_matrix(line3, :)];

        % Nur die einzigeartigen Knoten holen
        node_of_surface_unique = unique(node_of_surface);

        % Prüfen, ob diese Fläche aus mehr als 3 Knoten besteht
        if length(node_of_surface_unique) == 3

            % Knoten holen
            nodeA = node_matrix(node_of_surface_unique(1), :);
            nodeB = node_matrix(node_of_surface_unique(2), :);
            nodeC = node_matrix(node_of_surface_unique(3), :);

            % Vektor für Kreuzprodukt
            AB = nodeB - nodeA;
            AC = nodeC - nodeA;

            % Fläche mit Kreuzprodukt berechnen
            area = 0.5*norm(cross(AB, AC));

            % Fehlermeldung, falls die Fläche gleich 0 ist
            if area == 0
                error('Größe einer Fläche gleich 0!');
            end

        % Fehlermeldung, falls eine Fläche aus weniger als 3 Knoten besteht
        elseif length(node_of_surface_unique) < 3
            error('Eine Fläche besteht aus weniger als 3 Knoten!');

        % Fehlermeldung, falls eine Fläche aus mehr als 3 Knoten besteht
        else
            error('Eine Fläche besteht aus mehr als 3 Knoten!');
        end
    end
end