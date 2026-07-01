%% Funktion zur Berechnung des MAC-Werts
% Author: Philipp Kähler, Qiao Dawn Puah
% Datum letzter Bearbeitung: 23.05.2025

% Stammt aus FDD-Algorithmus von Philipp Kähler, ggf. angepasst

% Übergabeparameter: eigenvector1 = 1. Vektor
%                    eigenvector2 = 2. Vektor

% Ausgabeparameter: mac_value = MAC-Wert zwischen 0 und 1 [/]

function mac_value = compute_mac_value(eigenform1, eigenform2)

    % Der Zähler (beim Transponieren ist auf den Punkt zu achten(.'), da sonst komplexe
    % Zahlen gleichzeitig komplex konjugiert werden)
    wert1 = eigenform1.'*conj(eigenform2);
    
    % Der Nenner
    wert2 = eigenform1.'*conj(eigenform1);
    wert3 = eigenform2.'*conj(eigenform2);
    
    % MAC-Wert berechnen
    mac_value = abs(wert1)^2/(wert2*wert3);
end