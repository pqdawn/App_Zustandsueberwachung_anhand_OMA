%% Funktion zur Berechnung statistischer Kennwerte für einen Cluster
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cluster_pole = Pole in einem Cluster

% Ausgabeparameter:     mode_info = Statistische Kennwerte für einen Cluster

function mode_info = compute_cluster_statistics(cluster_pole)
    
    % Stabile Frequenzen holen
    idx_stable_freq = [cluster_pole.is_stable_freq];
    frequencies = [cluster_pole(idx_stable_freq).eigenfreq];

    % Frequenz berechnen
    mode_info.mean_frequency = mean(frequencies);
    mode_info.std_frequency = std(frequencies);
    
    % Stabile Dämpfungsgrade holen
    idx_stable_damp = [cluster_pole.is_stable_damp];
    dampings = [cluster_pole(idx_stable_damp).damping_ratio];

    % Dämpfungsgrade berechnen
    mode_info.mean_damping = mean(dampings);
    mode_info.std_damping = std(dampings);
    
    % Eigenformen mit erfüllter MAC-Bedingung holen
    idx_mac = [cluster_pole.is_mac];
    mode_shapes = [cluster_pole(idx_mac).mode_shape];

    % Repräsentative Eigenform berechnen (Der erste Vektor in der 
    % resultierenden Matrix U beschreibt die Richtung mit der größten 
    % Varianz in den Daten und gilt somit als die repräsentativste Eigenform)
    [U,~,~] = svd(mode_shapes, 'econ');
    mode_rep = real(U(:,1));
    mode_info.mean_mode_shape = mode_rep;
    [~, max_idx] = max(abs(mode_info.mean_mode_shape));
    mode_info.mean_mode_shape = mode_info.mean_mode_shape / mode_info.mean_mode_shape(max_idx);
end