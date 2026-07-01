%% Funktion zur automatischen Peakauswahl
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Funktion zum Peak-Picking von Antoine Liutkus (2015)
% https://de.mathworks.com/matlabcentral/fileexchange/42927-pickpeaks-v-select-display
% MATLAB Central File Exchange, abgerufen am 15.12.2025.

% Übergabeparameter:    fdd_result = Ergebnisse der FDD
%                       user_input = Parameter für Peakauswahl

% Ausgabeparameter:     selected_peak = Gewählte Peaks
%                       peak_quality_final = Qualitätswert der Peaks (Höhe der Peaks)

function [selected_peak, peak_quality_final] = identify_peak_automatic(fdd_result, user_input)

    % Ergebnisse der FDD holen
    F = fdd_result.F;
    S_db = mag2db(fdd_result.S);
    U = fdd_result.U;  

    % MAC-Grenze holen
    mac_threshold = user_input.mac;

    % Falls Anzahl der Moden bekannt ist
    if user_input.num_mode_known 

        % Mit Bandbreite von 0.3 Hz wird die Umgebung eines Peaks 
        % ausreichend untersucht
        bandwidth_value = 0.3;        

        % Parameter für die Peak-Picking-Funktion entspricht der Zielanzahl
        pick_picking_param = user_input.target_num;

        % Wenn die Zielanzahl gleich 1 ist, muss sie auf 0.99 setzen, damit
        % die Peak-Picking-Funktion funktioniert
        if pick_picking_param == 1
            pick_picking_param = 0.99;
        end                

    % Falls Anzahl der Moden nicht bekannt ist
    else    

        % Bandbreite holen
        bandwidth_value = user_input.bandwidth;        

        % Mit Parameter von 0.25 für die Peak-Picking-Funktion werden 
        % ausreichende lokale Peaks für weitere Auswertung ausgewählt
        pick_picking_param = 0.25;
    end   

    % Mögliche Peaks auf dem Graph der Eigenwerte der PSD in [dB] finden
    [idx_possible_peak, all_peak_quality] = pickpeaks(S_db,pick_picking_param,0);

    % Qualitätswerte der möglichen Peaks holen (Höhe der Peaks)
    possible_peak_quality = all_peak_quality(idx_possible_peak);

    % Array für valide Peaks instanziieren
    idx_peak_final = [];
    peak_quality_final = [];

    % Alle möglichen Peaks durchlaufen
    for i = 1:length(idx_possible_peak)

        % Frequenz für diesen möglichen Peak holen
        f0 = F(idx_possible_peak(i));

        % Umgebung innerhalb Bandbreite holen
        band = find(abs(F - f0) < bandwidth_value);

        % Wenn die Umgebung zu klein ist (weil Auflösung zu groß
        % ist), weitere Nachbarn zwangsläufig holen
        band_size = length(band);
        if band_size < 11
            if rem(band_size,2) == 0 
                mid_pos = band_size/2;
            else
                mid_pos = (band_size+1)/2;
            end
            band = (band(mid_pos)-5:band(mid_pos)+5)';
            if any(band <= 0)
                band = band(band > 0);
            end
            if any(band > length(U))
                band = band(band <= length(U));
            end                
        end

        % Array für MAC-Werte innerhalb der Bandbreite instanziieren
        mac_in_band = zeros(length(band)-1, 1);

        % Alle Frequenzlinien innerhalb der Bandbreite durchlaufen
        for j = 1:(length(band)-1)

            % Benachbarte Eigenformen holen
            phi1 = real(U(:,band(j)));
            phi2 = real(U(:,band(j+1)));

            % MAC-Wert berechnen
            mac_value = compute_mac_value(phi1, phi2);

            % In Array hinzufügen
            mac_in_band(j) = mac_value;
        end

        % Wenn der Durchschnitt aller MAC-Werte über Grenzwert liegt,
        % diesen möglichen Peak als validen Peak einstufen
        if mean(mac_in_band) >= mac_threshold

            % Index dieser Frequenz finden
            [~,idx] = min(abs(F - f0));

            % In Array für valide Peaks hinzufügen
            idx_peak_final = [idx_peak_final; idx];
            peak_quality_final = [peak_quality_final; possible_peak_quality(i)];
        end
    end

    % Wenn Anzahl der Moden bekannt ist
    if user_input.num_mode_known

        % Wenn Anzahl der Referenzmoden eingegeben wurde, diese Anzahl
        % übernehmen
        if isfield(user_input, 'target_num_ref')
            pick_picking_param = user_input.target_num_ref;
        end

        % Fehlermeldung falls Anzahl der validen Peaks weniger als
        % Zielanzahl
        if length(idx_peak_final) < pick_picking_param
            error(['Konnte nicht genau die gewünschte Anzahl von Peaks finden! ' ...
                'Probieren Sie mit anderen Parametern.']);
        end
    end

    % Valide Peaks nach Frequenz sortieren
    [~, idx_sorted] = sort(idx_peak_final);
    idx_peak_final = idx_peak_final(idx_sorted);
    peak_quality_final = peak_quality_final(idx_sorted);
    
    % Strukturarray für valide Peaks instanziieren
    selected_peak = struct([]);  
    
    % Wenn valide Peaks vorliegen
    if ~isempty(idx_peak_final)
        
        % Alle Peaks durchlaufen
        for k = 1:length(idx_peak_final)
        
            % Index dieses Peaks holen
            idx = idx_peak_final(k);
        
            % Eigenfrequenz holen
            eigenfreq = F(idx);
        
            % Eigenform extrahieren
            mode_shape = real(fdd_result.U(:,idx));
        
            % Eigenform normieren
            mode_shape = mode_shape./max(abs(mode_shape));
        
            % Variablen speichern
            selected_peak(k).freq = eigenfreq;
            selected_peak(k).mode_shape = mode_shape;   
            selected_peak(k).idx = idx;
        end
    end
end