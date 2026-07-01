%% Funktion zur Berechnung des Dämpfungsgrads
% Author: Robert Jürgensen, Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Stammt aus EFDD-Algorithmus von Robert Jürgensen, ggf. angepasst

% FDD- und EFDD-App von Robert Jürgensen (2025)
% https://github.com/Robert4J/StudienarbeitStatik_Modalanalyse
% Github, abgerufen am 25.12.2025.

% Übergabeparameter:    peak_value_signal = Amplitude der Peaks
%                       idx_peak_start = Index der ersten Grenze des Bereichs
%                       idx_peak_end = Index der zweiten Grenze des Bereichs

% Ausgabeparameter:     mu = Mittelwert der Normalverteilung
%                       sigma = Standardabweichung der Normalverteilung

function [mu, sigma] = compute_damping_ratio(peak_value_signal, idx_peak_start, idx_peak_end)

    % Dämpfungsgrad für jedes Paar k und k+1 berechnen
    delta = 2*log(peak_value_signal(idx_peak_start:idx_peak_end-1) ./ peak_value_signal(idx_peak_start+1:idx_peak_end));
    zeta = delta./sqrt(delta.^2 + 4 * pi^2);        

    % Dämpfungsgrade in Normalverteilung fitten
    pd = fitdist(zeta, 'Normal');

    % Mittelwert und Standardabweichung holen
    mu = pd.ParameterValues(1);
    sigma = pd.ParameterValues(2);
end