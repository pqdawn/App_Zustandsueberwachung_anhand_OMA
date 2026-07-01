%% Funktion zur Berechnung der linearen Regression des logarithmischen Dekrements
% Author: Philipp Kähler, Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Stammt aus EFDD-Algorithmus von Philipp Kähler, ggf. angepasst

% Übergabeparameter:    signal_recon = Korrelationsfunktion

% Ausgabeparameter:     peak_info = Peaks der linearen Regression

function peak_info = compute_log_decrement(signal_recon)

    % Strukturarray für Infos der Peaks instanziieren
    peak_info = [];
    
    % Peaks finden
    [peak_up,idx_up]=findpeaks(signal_recon);

    % Löschen aller Peaks, die kleiner 0 sind
    removepeaks = peak_up<0;
    peak_up(removepeaks) = [];
    idx_up(removepeaks) = [];

    % Bestimmen der Valleys, die im richtigen Abstand bzgl. der ersten
    % Eigenfrequenz liegen
    [peak_down,idx_down]=findpeaks(-signal_recon);
    
    % Löschen aller Valleys, die kleiner 0 sind
    removepeaks = peak_down<0;
    peak_down(removepeaks) = [];
    idx_down(removepeaks) = [];
    
    % Zusammenfügen der Peaks und Valleys in eine Matrix
    idx_in_signal = [idx_up;idx_down];
    peak_value = [peak_up;peak_down];
    peak_value_idx = [peak_value,idx_in_signal];
    
    % Nach Indizes sortieren
    peak_value_idx_sorted = sortrows(peak_value_idx,2);

    % Logarithmische Peakskala berechnen
    peak_log = 2*log(peak_value_idx_sorted(:,1));

    % Variablen speichern
    peak_info.idx_of_peak_in_time = peak_value_idx_sorted(:,2);
    peak_info.peak_value_signal = peak_value_idx_sorted(:,1);
    peak_info.peak_value_log = peak_log;  
    peak_info.idx_peak_start = 1;
    peak_info.idx_peak_end = length(peak_log);
    peak_info.idx_peak_start_final = NaN;
    peak_info.idx_peak_end_final = NaN;
end