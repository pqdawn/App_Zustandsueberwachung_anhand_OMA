%% Funktion zum Algorithmus der Modenverfolgung
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    ref_eigenfreq_list = Eigenfrequenzen der Referenzmoden
%                       ref_eigenvector_list = Eigenvektoren der Referenzmoden
%                       freq_all = Frequenzen aller Abschnitte
%                       mode_shape_all = Eigenformen aller Abschnitte
%                       selection_quality = Qualitätswerte der Auswahlen
%                       freq_threshold = Frequenzgrenze für Modenzuordnung
%                       mac_threshold = MAC-Grenze für Modenzuordnung
%                       damping_all = Dämpfungsgrade aller Abschnitte

% Ausgabeparameter:     track_freq_list = Ketten der Eigenfrequenzen (Jede Kette verfolgt eine Mode, Spalte = Mode)
%                       track_phi_list = Ketten der Eigenformen
%                       used_mode = Maske für benutzte Moden
%                       track_damp_list = Ketten der Dämpfungsgrade

function [track_freq_list, track_phi_list, used_mode, track_damp_list] = ...
    track_freq_across_time(ref_eigenfreq_list, ref_eigenvector_list, freq_all, ...
    mode_shape_all, selection_quality, freq_threshold, mac_threshold, damping_all)

    % Anzahl der Referenzmoden
    num_ref_mode = length(ref_eigenfreq_list);
    
    % Anzahl der Abschnitt
    num_segment = numel(freq_all);
    
    % Anzahl der Sensoren
    num_sensor = size(ref_eigenvector_list{1,1}, 1);
    
    % Liste der Ketten instanziieren (Jede Kette verfolgt eine Mode, Spalte = Mode)
    track_freq_list = cell(1, num_ref_mode);
    track_damp_list = cell(1, num_ref_mode);
    track_phi_list = cell(1, num_ref_mode);
    
    % Anzahl der Moden aller Abschnitte holen
    num_mode_all = cellfun(@(x) size(x, 2), mode_shape_all);
    
    % Maske für benutzte Moden instanziieren (Zeile = Abschnitt, Spalte = Mode)
    used_mode = false(num_segment, max(num_mode_all));
    
    % Alle Abschnitte durchlaufen
    for i = 1:num_segment
    
        % Moden dieses Abschnitts holen
        freq_list_this_segment = freq_all{i};
        phi_list_this_segment = mode_shape_all{i};
        quality_this_segment = selection_quality{i};
        num_mode_this_segment = length(freq_list_this_segment);
    
        % Wenn Dämpfungsgrade eingegeben wurden
        if nargin == 8
    
            % Dämpfungen dieses Abschnitts holen
            damp_list_this_segment = damping_all{i};
        end
        
        % Wenn keine Moden innerhalb dieses Abschnitts identifiziert wurden, NaN
        % zuordnen und überspringen
        if isempty(freq_list_this_segment)
            for j = 1:numel(track_freq_list)
                track_freq_list{j}(i) = NaN;
                track_damp_list{j}(i) = NaN;
                track_phi_list{j}(:,i) = NaN(num_sensor,1);
            end
            continue;
        end
        
        % Kostenmatrix instanziieren
        cost_matrix = inf(num_ref_mode, num_mode_this_segment);
        
        % Alle Referenzmoden durchlaufen
        for j = 1:num_ref_mode
    
            % Aktuelle Referenzmode holen
            ref_freq = ref_eigenfreq_list(j);
            ref_phi = ref_eigenvector_list{j,1};
            
            % Alle Moden dieses Abschnitts durchlaufen
            for k = 1:num_mode_this_segment

                % Eigenfrequenz mit Referenz vergleichen
                freq_dist = abs(freq_list_this_segment(k) - ref_freq);

                % Eigenform mit Referenz vergleichen
                mac_value = compute_mac_value(ref_phi, phi_list_this_segment(:,k));

                % Qualitätswert dieser Auswahl holen
                quality = quality_this_segment(k);
                
                % Wenn die Grenzwerte für Modenzuordnung erfüllt sind
                if freq_dist <= freq_threshold && mac_value*100 >= mac_threshold
    
                    % Kostenwert anhand von MAC und Qualitätswert berechnen
                    mac_score = 1-mac_value;
                    quality_score = 1-quality;
                    cost_matrix(j, k) =  0.4*mac_score + 0.6*quality_score;
                end
            end
        end
        
        % Wenn geeignete Toolbox vorhanden ist
        if exist('matchpairs', 'file')

            % Valide Paare holen
            valid_pairs = cost_matrix < inf;

            % Wenn valide Paare vorliegen
            if any(valid_pairs(:))

                % Kandidat mit dem kleinsten Kostenwert für jede
                % Referenzmode zuordnen
                finite_costs = cost_matrix(valid_pairs);
                max_finite_cost = max(finite_costs);
                assignments = matchpairs(cost_matrix, max_finite_cost + 1); % (1. Spalte = Welche Mode von ref_freq, 2. Spalte = Welche Mode von freq_all)

            % Sonst nichts zuordnen
            else
                assignments = [];
            end

        % Sonst "greedy_assignment" benutzen
        else
            assignments = greedy_assignment(cost_matrix);
        end
        
        % Alle Zuordnungen durchlaufen
        if ~isempty(assignments)

            % Alle Referenzmoden durchlaufen
            for j = 1:num_ref_mode

                % Zeile dieser Referenz holen
                row_this_ref = find(assignments(:,1) == j);
                
                % Wenn Kandidat dafür zugeordnet wurde
                if ~isempty(row_this_ref)

                    % Kandidat dafür holen
                    k = assignments(row_this_ref, 2);

                    % Modale Parameter dieses Kandidaten in Ketten hinzufügen
                    track_freq_list{j}(i) = freq_list_this_segment(k);
                    track_phi_list{j}(:,i) = phi_list_this_segment(:,k);
    
                    % Wenn Dämpfungsgrade eingegeben wurden
                    if nargin == 8
    
                        % Zugehörigen Dämpfungsgrad in die Kette hinzufügen
                        track_damp_list{j}(i) = damp_list_this_segment(k);
                    end
    
                    % Diesen Kandidaten als "benutzt" markieren
                    used_mode(i,k) = true;

                % Sonst
                else

                    % NaN in Ketten hinzufügen
                    track_freq_list{j}(i) = NaN;
                    track_damp_list{j}(i) = NaN;
                    track_phi_list{j}(:,i) = NaN(num_sensor,1);
                end
            end
        end
    end
end