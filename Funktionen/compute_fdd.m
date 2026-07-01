%% Funktion zum Algorithmus der FDD
% Author: Philipp Kähler, Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Stammt aus FDD-Algorithmus von Philipp Kähler, ggf. angepasst

% Übergabeparameter:    fig = Figur der App
%                       psd_mode = Gewählter Modus für Berechnung der PSD
%                       data_matrix = Messdaten
%                       sampling_freq = Abtastfrequenz
%                       window_func = Fensterfunktion
%                       window_size = Größe eines Fensters
%                       overlap = Prozentsatz der Überlappung
%                       num_fft = Anzahl der DFT-Punkte
%                       freq_limit = Frequenzgrenze
%                       lowest_freq = Niedrigste zu untersuchende Frequenz
%                       it_current = Aktueller Iterationsschritt für Zustandsüberwachung
%                       it_total = Gesamte Iterationsschritte für Zustandsüberwachung

% Ausgabeparameter:     fdd_result = Strukturarray für gesamte Ergebnisse

function fdd_result = compute_fdd(fig, psd_mode, data_matrix, sampling_freq, window_func, ...
    window_size, overlap, num_fft, freq_limit, lowest_freq, it_current, it_total)

    % Wenn Iterationsschritte nicht eingegeben wurden, handelt es sich um Modalanalyse
    if nargin == 10

        % Progressbar ohne Iterationsschritt instanziieren
        progressbar = uiprogressdlg(fig, 'Title', 'FDD',...
            'Message', 'Es fängt gleich an...', 'Cancelable', 'on', 'CancelText', 'Stop');

    % Sonst handelt es sich um Zustandsüberwachung
    else
    
        % Progressbar mit Iterationsschritt instanziieren
        progressbar_msg = ['Abschnitt ', num2str(it_current), ' von ', ...
            num2str(it_total), ' (FDD)'];
        progressbar = uiprogressdlg(fig, 'Title', progressbar_msg ,...
            'Message', 'Es fängt gleich an...', 'Cancelable', 'on', 'CancelText', 'Stop');
    end

    % Progressbar zeichnen
    drawnow;

    % Konstante und lineare Trends entfernen
    data_matrix = detrend(data_matrix);

    % Prüfen, damit die Größe der Messdaten gerade ist (Für den weiteren 
    % Verlauf ist es besser, wenn die Anzahl an Messdaten gerade ist)
    if mod(length(data_matrix),2) == 1
        data_matrix(end,:) = [];
    end

    % Anzahl der Ausgangskanäle und Anzahl der Zeitschritte holen
    [Nyy,N] = size(data_matrix);

    % Dimension der Messdaten für weiteren Verlauf anpassen
    if Nyy > N
        data_matrix = data_matrix';
        [Nyy,N] = size(data_matrix);
    end

    % Eingabeparameter abhängig vom gewählten Modus zuordnen
    % Direkt
    if strcmp(psd_mode, 'Direkt')

        % Rechteckiges Fenster mit allen Messdaten innerhalb eines Fensters
        window = rectwin(N);

        % Keine Überlappung
        overlap = [];

        % Anzahl der DFT-Punkte entspricht der gesamten Messdaten
        num_fft = N;

    % Welch
    elseif strcmp(psd_mode, 'Welch')

        % 8 Hamming-Fenster
        window_size = ceil(10 * sampling_freq / lowest_freq);        
        window = hann(window_size);

        % 50% Überlappung
        overlap = round(0.5*window_size);

        % Anzahl der DFT-Punkte entspricht der Größe eines Fensters
        num_fft = window_size;        

    % Benutzerdefiniert
    elseif strcmp(psd_mode, 'User')

        % Wenn gesamte Messdaten für Größe eines Fensters gewählt wurde
        if strcmp(window_size, 'Gesamte Messdaten')
            
            % Gesamte Messdaten dafür holen
            window_size = N;

        % Sonst die gewählte Anzahl holen
        else
            window_size = str2double(window_size);
        end    

        % Fensterfunktion zuordnen
        if strcmp(window_func, 'Hamming')
            window = hamming(window_size);
        elseif strcmp(window_func, 'Bartlett')
            window = bartlett(window_size);
        elseif strcmp(window_func, 'Blackman')
            window = blackman(window_size);
        elseif strcmp(window_func, 'Hann')
            window = hann(window_size);
        elseif strcmp(window_func, 'Rechteck')
            window = rectwin(window_size);
        end

        % Gewählte Überlappung holen
        if strcmp(overlap, '0%')
            overlap = 0;
        elseif strcmp(overlap, '25%')
            overlap = round(0.25*window_size);
        elseif strcmp(overlap, '50%')
            overlap = round(0.5*window_size);
        elseif strcmp(overlap, '75%')
            overlap = round(0.75*window_size);
        end

        % Wenn Gesamte Messdaten für Anzahl der DFT-Punkte gewählt wurde
        if strcmp(num_fft, 'Gesamte Messdaten')
            
            % Gesamte Messdaten dafür holen
            num_fft = N;

        % Sonst die gewählte Anzahl holen
        else
            num_fft = str2double(num_fft);
        end           
    end

    % Alle Ausgangskanäle durchlaufen
    for i=1:Nyy

        % Falls "Abbrechen" im Progressbar betätigt wird, Vorgang abbrechen
        % und Fehler zeigen
        if progressbar.CancelRequested
            error('FDD abgebrochen!');
        end

        % Progressbar aktualisieren (erstmal nur bis 50%)
        progress_Value = i/Nyy * 0.5;
        progressbar.Value = progress_Value;
        progressbar.Message = sprintf('PSD wird berechnet...');

        % Alle Ausgangskanäle durchlaufen
        for j=1:Nyy

            % CPSD bzw. PSD durchführen
            [PSD(i,j,:),F] = cpsd(data_matrix(i,:),data_matrix(j,:),window,overlap,num_fft,sampling_freq);
        end
    end
    pause(1);

    % Ergebnisse unterhalb der Frequenzgrenze weiter betrachten
    idx = F <= freq_limit;
    F = F(idx);
    PSD = PSD(:,:,idx);
    
    % Array für Eigenwerte der SVD instanziieren
    eigenwerte = zeros(size(PSD,2),size(PSD,3));
    
    % Alle PSD durchlaufen
    for i=1:size(PSD,3)

        % Falls "Abbrechen" im Progressbar betätigt wird, Vorgang abbrechen
        % und Fehler zeigen
        if progressbar.CancelRequested
            error('FDD abgebrochen!');
        end
    
        % Progressbar aktualisieren (50% bis 100%)
        progress_Value = 0.5 + i/size(PSD,3) * 0.5;
        progressbar.Value = progress_Value;
        progressbar.Message = sprintf('SVD wird durchgeführt...');

        % SVD der PSD durchführen
        [u(:,:,i),s,~] = svd(PSD(:,:,i));

        % Eigenwerte speichern
        eigenwerte(:,i)=diag(s);
    end
    
    % Nur die ersten Eigenwerte weiter betrachten
    S = eigenwerte(1,:);

    % Um die negative Spitze bei f = 0 Hz nach mag2db zu vermeiden, wird 
    % der Singulärwert bei 0 Hz mit dem benachbarten Wert ersetzt
    S(1) = S(2);

    % Nur die ersten Eigenformen weiter betrachten
    U = u(:,1,:);
    U = squeeze(U);
    if size(U,1) > size(U,2)
        U = U';
    end

    % Ergebnisse in einem Strukturarray speichern
    fdd_result = struct();
    fdd_result.PSD = PSD;
    fdd_result.F = F;
    fdd_result.S = S';
    fdd_result.U = U;

    % Progressbar schließen
    pause(1);
    close(progressbar);
end