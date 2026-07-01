%% Funktion zur Berechnung statistischer Kennwerte für einen Cluster (Stabilität ungeachtet)
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cluster_pole = Pole in einem Cluster

% Ausgabeparameter:     mode_info = Statistische Kennwerte für einen Cluster

function mode_info = compute_cluster_statistics_regardless_stability(cluster_pole)
    
    % Frequenzen holen
    frequencies = [cluster_pole.eigenfreq];

    % Frequenz berechnen
    mode_info.mean_frequency = mean(frequencies);
    mode_info.std_frequency = std(frequencies);
    
    % Dämpfungsgrade holen
    dampings = [cluster_pole.damping_ratio];

    % Dämpfungsgrade berechnen
    mode_info.mean_damping = mean(dampings);
    mode_info.std_damping = std(dampings);
    
    % Eigenformen holen
    mode_shapes = [cluster_pole.mode_shape];

    % Repräsentative Eigenform berechnen (Der erste Vektor in der 
    % resultierenden Matrix U beschreibt die Richtung mit der größten 
    % Varianz in den Daten und gilt somit als die repräsentativste Eigenform)
    [U,~,~] = svd(mode_shapes, 'econ');
    mode_rep = real(U(:,1));
    mode_info.mean_mode_shape = mode_rep;
    [~, max_idx] = max(abs(mode_info.mean_mode_shape));
    mode_info.mean_mode_shape = mode_info.mean_mode_shape / mode_info.mean_mode_shape(max_idx);
end