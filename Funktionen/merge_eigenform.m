%% Funktion zur Zusammenführung der Eigenformen
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    assign_matrix = Zuweisungen aller Gruppen
%                       eigenvector_matrix = Eigenvektoren aller Gruppen

% Ausgabeparameter:     result_modes = Zusammengeführte Eigenformen

function result_modes = merge_eigenform(assign_matrix, eigenvector_matrix)

    % Gruppen und Anzahl der Moden holen
    groups = unique(assign_matrix(:,1));
    num_modes = size(eigenvector_matrix,2);
    
    % Knoten holen
    nodes = assign_matrix(:,3);
    unique_nodes = unique(nodes, 'stable');
    num_unique_nodes = length(unique_nodes);
    
    % Zelle für zusammengeführte Eigenformen instanziieren (Spalte = Mode)
    result_modes = cell(1,num_modes);
    
    % Alle Moden durchlaufen
    for mode = 1:num_modes
    
        % Globaler Eigenvektor dieser Mode instanziieren
        global_mode = zeros(num_unique_nodes,4);

        % Mit Knoten befüllen
        global_mode(:,1) = unique_nodes;
    
        % Erste Gruppe als Referenz holen
        g_ref = groups(1);
        rows_ref = find(assign_matrix(:,1)==g_ref);
        nodes_ref = assign_matrix(rows_ref,3);
        phi_ref = eigenvector_matrix{g_ref,mode};
    
        % Eigenvektor der ersten Gruppe direkt in den globalen Eigenvektor
        % hinzufügen
        for k = 1:length(rows_ref)
            node = nodes_ref(k);
            row_in_global = global_mode(:,1)==node;
            global_mode(row_in_global,2:4) = phi_ref(k,:);
        end
    
        % Weitere Gruppen durchlaufen
        for g = groups(2:end)'
    
            % Knoten und Eigenvektor dieser Gruppe holen
            rows_g = find(assign_matrix(:,1)==g);
            nodes_g = assign_matrix(rows_g,3);
            phi_g = eigenvector_matrix{g,mode};
    
            % Gemeinsame Knoten mit der ersten Gruppe finden
            [shared_nodes, idx_ref, idx_g] = intersect(nodes_ref, nodes_g);
    
            % Fehlermeldung falls keine gemeinsamen Knoten gefunden
            if isempty(shared_nodes)
                error('Keine gemeinsamen Knoten zwischen Gruppen!');
            else

                % Komponente der Eigenvektoren an gemeinsamen Knoten
                % extrahieren
                Phi_ref_shared = phi_ref(idx_ref,:);
                Phi_g_shared = phi_g(idx_g,:);
                v_ref = Phi_ref_shared(:);
                v_g = Phi_g_shared(:);
    
                % Skalierungsfaktor bestimmen (least-squares scaling)
                if norm(v_g) < 1e-12
                    scale = 1;
                else
                    scale = (v_ref' * v_g) / (v_g' * v_g);
                end
            end
    
            % Eigenvektor dieser Gruppe skalieren
            phi_scaled = phi_g * scale;
    
            % Eigenvektor in den globalen Eigenvektor hinzufügen
            for k = 1:length(rows_g)
                node = nodes_g(k);
                row_in_global = global_mode(:,1)==node;
                global_mode(row_in_global,2:4) = phi_scaled(k,:);
            end
        end
    
        % Globalen Eigenvektor dieser Mode in die Zelle für
        % zusammengeführte Eigenformen hinzufügen
        result_modes{mode} = global_mode(:,2:4);
    end
end