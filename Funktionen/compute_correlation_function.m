%% Funktion zur Berechnung der Korrelationsfunktion
% Author: Robert Jürgensen, Philipp Kähler, Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Stammt aus EFDD-Algorithmus von Robert Jürgensen und Philipp Kähler, ggf. angepasst

% FDD- und EFDD-App von Robert Jürgensen (2025)
% https://github.com/Robert4J/StudienarbeitStatik_Modalanalyse
% Github, abgerufen am 25.12.2025.

% Übergabeparameter:    SBF = Spectral-Bell-Function
%                       F = Frequenzen
%                       t = Zeitvektor
%                       sampling_freq = Abtastfrequenz
%                       correlation_type = Berechnungsmethode für Korrelationsfunktion

% Ausgabeparameter:     time_recon = Rekonstruierte Zeit
%                       signal_recon = Korrelationsfunktion
%                       freq_d = Gedämpfte Eigenfrequenz

function [time_recon, signal_recon, freq_d] = compute_correlation_function(SBF, F, t, sampling_freq, correlation_type)

    % Wenn der erste Zeitschritt ungleich 0 ist, wird der Zeitvektor
    % verschoben, damit er mit 0 anfängt
    if t(1) ~= 0
        t = t-t(1);
    end

    % Wenn IFFT für Berechunung gewählt wurde
    if strcmp(correlation_type, 'IFFT')

        % Info von ursprünglichen Messdaten holen
        num_sample = length(t);
        df = sampling_freq/num_sample;
    
        % Größe des einseitigen Spektrums berechnen
        num_half = floor(num_sample/2) + 1;    
    
        % Einseitiges Spektrum instanziieren
        Y_half = zeros(num_half, 1);
    
        % Alle Frequenzen durchlaufen
        for i = 1:length(F)
    
            % Einseitiges Spektrum aus SBF rekonstruieren
            idx = round(F(i)/df)+1;
            if idx <= num_half
                Y_half(idx) = SBF(i);
            end
        end    

        % Größe des einseitigen Spektrums berechnen
        num_half = length(Y_half);

        % Größe des vollständigen Spektrums berechnen
        num_full = 2 * (num_half - 1);
    
        % Prüfen, damit die Größe gerade ist
        if mod(num_full, 2) == 1
            num_full = num_full + 1;
        end
    
        % IFFT durchführen
        X_rec = ifft(Y_half, num_sample, 'symmetric');
    
        % Zeitvektor des rekonstuierten Spektrums erstellen
        T = t(end) * num_full / length(t);
        time_recon = linspace(0, T, num_sample);            
    
        % Peaks holen
        [~,locs]=findpeaks(X_rec);

        % Gedämpfte Eigenfrequenz berechnen
        natPeriod = diff(time_recon(locs));
        freq_d = length(natPeriod)/sum(natPeriod);

        % Auflösung berechnen
        nerf = round(freq_d * T * 20);

        % Wenn die Auflösung des Spektrums nicht ausreichend ist
        if nerf > num_sample
            
            % IFFT mit höherer Auflösung durchführen
            X_rec = ifft(Y_half, nerf, 'symmetric');
            
            % Zeitvektor des rekonstuierten Spektrums erstellen
            time_recon = linspace(0, T, nerf);
    
            % Gedämpfte Eigenfrequenz nochmal berechnen
            [~,locs]=findpeaks(X_rec);
            natPeriod = diff(time_recon(locs));
            freq_d = length(natPeriod)/sum(natPeriod);         
        end
    
        % Amplitude normieren
        signal_recon = X_rec / max(abs(X_rec));

    % Wenn Kosinustransformation für Berechunung gewählt wurde
    elseif strcmp(correlation_type, 'Cos')
        
        % Info von ursprünglichen Messdaten holen
        num_sample = length(t);
        delta_t = 1/sampling_freq;
        delta_f = sampling_freq/num_sample;

        % Zeitvektor rekonstruieren
        time_recon = linspace(t(1),floor(t(end)/2),floor(t(end)/2)/delta_t);

        % Spektrum rekonstruieren
        omega = 2*pi*F;
        A = sqrt(2*SBF(SBF~=0)*delta_f);
        B = cos(omega(SBF~=0)*time_recon);
        ifftsignal = A'*B;
        signal_recon = ifftsignal';

        % Amplitude normieren
        signal_recon = signal_recon./max(signal_recon);    
        
        % Peaks holen
        [~, locs] = findpeaks(signal_recon, time_recon);

        % Wenn mindestens drei Peaks vorliegen
        if length(locs) > 2

            % Gedämpfte Eigenfrequenz berechnen
            T_d = mean(diff(locs));
            freq_d = 1 / T_d;

        % Sonst Fehlermeldung
        else
            error('Unzureichende Peaks nach Kosinustransformation! Parameter ungeeignet!');
        end 
    end
    
    % Nur Hälfte der Rekonstruktion weiter betrachten
    signal_recon = signal_recon(1:round(length(signal_recon)/2));
    time_recon = time_recon(1:round(length(time_recon)/2));    
end