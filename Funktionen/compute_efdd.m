%% Funktion zum Algorithmus der EFDD
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    F = Frequenzen
%                       PSD = Power-Spectral-Density aus der FDD
%                       eigenfreq = Eigenfrequenz aus der FDD
%                       mac = MAC-Grenze für EFDD
%                       U = Singulärvektoren aus der FDD
%                       time_vector = Zeitvektor
%                       sampling_freq = Abtastfrequenz
%                       correlation_type = Berechnungsmethode für Korrelationsfunktion

% Ausgabeparameter:     SBF = Spectral-Bell-Function
%                       mode_shape = Eigenformen
%                       time_recon = Rekonstruierte Zeit
%                       signal_recon = Korrelationsfunktion
%                       freq_d = Gedämpfte Eigenfrequenz (Bei EFDD als endgültige Eigenfrequenz übernommen)
%                       peak_info = Peaks der linearen Regression

function [SBF, mode_shape, time_recon, signal_recon, freq_d, peak_info] = ...
    compute_efdd(F, PSD, eigenfreq, mac, U, time_vector, sampling_freq, correlation_type)

    % SBF berechnen
    SBF = compute_sbf(F, PSD, eigenfreq, mac); 

    % Eigenform mit SBF gewichten
    phi_sum = zeros(size(PSD,1),1);
    for i = 1:length(SBF)
        phi_sum = phi_sum + SBF(i) * U(:,i);
    end
    mode_shape = real(phi_sum);

    % Eigenform normieren
    mode_shape = mode_shape./max(abs(mode_shape));   

    % Korrelationsfunktion berechnen
    [time_recon, signal_recon, freq_d] = compute_correlation_function(SBF, F, time_vector, sampling_freq, correlation_type);

    % Lineare Regression des logarithmischen Dekrements berechnen
    peak_info = compute_log_decrement(signal_recon);
end