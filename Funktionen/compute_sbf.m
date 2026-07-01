%% Funktion zum Algorithmus der SBF
% Author: Philipp Kähler, Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Stammt aus EFDD-Algorithmus von Philipp Kähler, ggf. angepasst

% Übergabeparameter:    F = Frequenzen
%                       PSD = Power-Spectral-Density aus der FDD
%                       freq_current = Eigenfrequenz aus der FDD
%                       mac_ref = MAC-Grenze für EFDD

% Ausgabeparameter:     SBF = Spectral-Bell-Function

function SBF = compute_sbf(F,PSD,freq_current,mac_ref)

    % Matrix für SBF instanziieren
    SBF = zeros(size(PSD,3),1);

    % Stelle der untersuchende Frequenz finden
    idx = find(F == freq_current, 1);
    
    % Eigenform der aktuellen Eigenfrequenz als Referenz holen
    zwischenspeicher = PSD(:,:,idx);
    [ug,~,~] = svd(zwischenspeicher);
    phi_ref = ug(:,1);

    % Anzahl der zu prüfenden Eingenvektoren
    num_to_test = size(PSD,3);

    % Flagge für nicht erfüllte MAC-Grenze (sobald ein Eigenvektor die 
    % MAC-Grenze nicht erfüllt, sollte der SBF weiterer Stellen Null zuordnen)
    is_mac_failed = false;   
    
    % ---------------------------------------------------------------------
    % Als nächstes werden alle Eigenvektoren aller Eigenfrequenzen 
    % getestet, ob der resultierende MAC-Wert oberhalb der Grenzwert liegt. 
    % Ist dies der Fall, liegt weiterhin die gleiche Eigenform vor. So kann 
    % eine Umgebung von der Referenz gefunden werden, in der alle 
    % Frequenzen der gleichen Eigenform angehören. Dieser isolierte Verlauf 
    % ist die Spectral-Bell-Function.
    % ---------------------------------------------------------------------

    % Alle PSD-Anteile nach links durchlaufen
    for j=idx:-1:1

        % Solange die MAC-Grenze noch erfüllt ist
        if ~is_mac_failed
        
            % SVD dieses PSD-Anteils
            [ug,sg,~] = svd(PSD(:,:,j));
            
            % Eigenform, welche getestet werden soll
            phi_test = ug(:,1);
            
            % MAC berechnen
            mac_current = compute_mac_value(phi_ref,phi_test);
            
            % Wenn MAC als der Grenzwert größer ist
            if mac_current > mac_ref
                
                % Eigenwert in die SBF hinzufügen
                SBF(j) = sg(1,1);

            % Sonst
            else

                % Null zuordnen
                SBF(j) = 0;

                % Flagge aktualisieren
                is_mac_failed = true;
            end

        % SBF weiterer Stellen Null zuordnen
        else
            SBF(j) = 0;
        end
    end

    % Flagge erneut instanziieren
    is_mac_failed = false; 

    % Alle PSD-Anteile nach rechts durchlaufen
    for j=idx+1:num_to_test

        % Solange die MAC-Grenze noch erfüllt ist
        if ~is_mac_failed        
        
            % SVD dieses PSD-Anteils
            [ug,sg,~] = svd(PSD(:,:,j));
            
            % Eigenform, welche getestet werden soll
            phi_test = ug(:,1);
            
            % MAC berechnen
            mac_current = compute_mac_value(phi_ref,phi_test);
            
            % Wenn MAC als der Grenzwert größer ist
            if mac_current > mac_ref
                
                % Eigenwert in die SBF hinzufügen
                SBF(j) = sg(1,1);

            % Sonst
            else

                % Null zuordnen
                SBF(j) = 0;

                % Flagge aktualisieren
                is_mac_failed = true;
            end

        % SBF weiterer Stellen Null zuordnen
        else
            SBF(j) = 0;
        end
    end
end