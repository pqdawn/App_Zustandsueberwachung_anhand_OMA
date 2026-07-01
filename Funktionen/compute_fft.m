%% Funktion zum Erstellen einer FFT von Signalen
% Author: Philipp Kähler
% Datum letzter Bearbeitung: 19.05.2017

% Stammt aus FDD-Algorithmus von Philipp Kähler

% Übergabeparameter:    asignal = Zeitreihe von einem Signal

% Ausgabeparameter:     spektrum = Frequenzspektrum [Hz]

function spektrum = compute_fft(asignal)

    sens = size(asignal,2);
    
    if sens == 3
        % Aufsplitten des alten Signals in die drei Kanäle, bzw. x, y, und
        % z-Richtung
        kan1 = asignal(:,1);
        kan2 = asignal(:,2);
        kan3 = asignal(:,3);
    
        % Erstellen von Kennwerten zum Rechnen
        L = length(asignal);                 % Signallaenge in s
    
    
        % Erzeugen einer FFT des alten Signals
        Y_1 = fft(kan1);
        Y_2 = fft(kan2);
        Y_3 = fft(kan3);
    
        % Erstellen des gespiegelten Spektrums (nur Amplituden interessant),
        % negative Werte werden positiv
        fft_1 = abs(Y_1/L);
        fft_2 = abs(Y_2/L);
        fft_3 = abs(Y_3/L);
    
        % Halbieren der Daten (nur eine Hälfte des gespiegelten Spektrums wird
        % benötigt)
        fft_1 = fft_1(1:floor(L/2));    % floor = abrunden (to the nearest integer less than or equal to that element)
        fft_2 = fft_2(1:floor(L/2));
        fft_3 = fft_3(1:floor(L/2));
    
        % Bei dem gespiegelten Spektrum sind die Amplituden nur halb so groß
        % gewesen. Deshalb müssen alle Werte verdoppelt werden, bis auf die Werte
        % in der Spiegelachse (der erste Wert und der letzte Wert)
        fft_1(2:end-1) = 2*fft_1(2:end-1);
        fft_2(2:end-1) = 2*fft_2(2:end-1);
        fft_3(2:end-1) = 2*fft_3(2:end-1);
    
        % Zusammenfügen der FFT's der drei Kanäle in die spektrum-Matrix
        spektrum = [fft_1,fft_2,fft_3];
    else
        
        % Aufsplitten des alten Signals in die drei Kanäle
        kan1 = asignal(:,1);
        
    
        % Erstellen von Kennwerten zum Rechnen
        L = length(asignal);                 % Signallaenge in s
    
    
        % Erzeugen einer FFT des alten Signals
        Y_1 = fft(kan1);
    
        % Erstellen des gespiegelten Spektrums (nur Amplituden interessant)
        fft_1 = abs(Y_1/L);
    
        % Halbieren der Daten (nur eine Hälfte des gespiegelten Spektrums wird
        % benötigt)
        fft_1 = fft_1(1:floor(L/2));
    
        % Bei dem gespiegelten Spektrum sind die Amplituden nur halb so groß
        % gewesen. Deshalb müssen alle Werte verdoppelt werden, bis auf die Werte
        % in der Spiegelachse (der erste Wert und der letzte Wert)
        fft_1(2:end-1) = 2*fft_1(2:end-1);
    
        % Zusammenfügen der FFT's der drei Kanäle in die spektrum-Matrix
        spektrum = fft_1;
    end
end