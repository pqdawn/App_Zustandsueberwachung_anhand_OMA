%% Funktion zum Plotten der Geometrie
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 23.05.2025

% Übergabeparameter:    assign_matrix = Zuweisungen der Sensoren zu den Knoten
%                       node_matrix = Koordinaten der Punkte
%                       line_matrix = Anfangs- und Endknoten der Linien
%                       surfaca_matrix = Linien der Flächen
%                       graph = Achse fürs Plotten

% Ausgabeparameter: -

function plot_geometry(assign_matrix, node_matrix, line_matrix, surface_matrix, graph)

    % Alles auf Graph löschen
    cla(graph);

    % Knoten plotten
    node_plot = plot3(graph, node_matrix(:,1), node_matrix(:,2), node_matrix(:,3), '.r', 'MarkerSize', 15, 'DisplayName', 'Knoten');
    hold(graph, 'on');

    % Koordinaten für Zuweisungen instanziieren
    x_assign = zeros(size(assign_matrix, 1), 1);
    y_assign = zeros(size(assign_matrix, 1), 1);
    z_assign = zeros(size(assign_matrix, 1), 1);
    
    % Koordinaten für Linien instanziieren
    x_line = zeros(2, size(line_matrix, 1));
    y_line = zeros(2, size(line_matrix, 1));
    z_line = zeros(2, size(line_matrix, 1));

    % Alle Linien durchlaufen
    for i = 1:size(line_matrix, 1)

        % Ersten Knoten holen
        node1 = line_matrix(i, 1);

        % Zweiten Knoten holen
        node2 = line_matrix(i, 2);

        % Koordinaten der Knoten holen
        x_line(:, i) = [node_matrix(node1, 1); node_matrix(node2, 1)];
        y_line(:, i) = [node_matrix(node1, 2); node_matrix(node2, 2)];
        z_line(:, i) = [node_matrix(node1, 3); node_matrix(node2, 3)];
    end

    % Linie plotten
    plot3(graph, x_line, y_line, z_line, '-b', 'LineWidth', 1.5);
    hold(graph, 'on');

    % Alle Flächen durchlaufen
    for i = 1:size(surface_matrix, 1)

        % Linien holen
        line1 = surface_matrix(i, 1);
        line2 = surface_matrix(i, 2);
        line3 = surface_matrix(i, 3);

        % Alle Knoten von dieser Fläche holen
        node_of_surface = [line_matrix(line1, :), line_matrix(line2, :), line_matrix(line3, :)];

        % Nur die einzigeartigen Knoten holen
        node_of_surface_unique = unique(node_of_surface);

        % Ersten Knoten holen
        node1 = node_of_surface_unique(1);

        % Zweiten Knoten holen
        node2 = node_of_surface_unique(2);

        % Dritten Knoten holen
        node3 = node_of_surface_unique(3);

        % Koordinaten der Knoten holen
        x = [node_matrix(node1, 1), node_matrix(node2, 1), node_matrix(node3, 1)];
        y = [node_matrix(node1, 2), node_matrix(node2, 2), node_matrix(node3, 2)];
        z = [node_matrix(node1, 3), node_matrix(node2, 3), node_matrix(node3, 3)];

        % Fläche plotten
        fill3(graph, x, y, z, 'cyan', 'FaceAlpha', 0.5);            
    end

    % Beschriften der Knoten mit den entsprechenden Nummern
    for i = 1:size(node_matrix,1)
        text(graph, node_matrix(i,1), node_matrix(i,2), node_matrix(i,3), string(i), ...
            'FontSize', 15, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        hold(graph, 'on');
    end

    % Schleife über alle Zuweisungen
    for i = 1:size(assign_matrix, 1)

        % Name dieses Sensors holen
        sensor_num = assign_matrix(i, 1);

        % Stelle dieses Sensors holen
        position = assign_matrix(i, 2);

        % Koordinaten dieser Stelle holen
        x_assign(i) = node_matrix(position, 1);
        y_assign(i) = node_matrix(position, 2);
        z_assign(i) = node_matrix(position, 3);

        % Beschriften des Sensors mit der entsprechenden Nummer
        label = sprintf('S%d', sensor_num);
        text(graph, node_matrix(position, 1), node_matrix(position, 2), node_matrix(position, 3), label, ...
            'FontSize', 15, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
        hold(graph, 'on');
    end

    % Sensor plotten
    assign_plot = plot3(graph, x_assign, y_assign,z_assign, 'squarer', 'MarkerSize', 15, 'DisplayName', 'Sensor');
    hold(graph, 'on');

    % Legende
    legend([node_plot, assign_plot]);

    % Achse anpassen
    axis(graph, 'equal');
end