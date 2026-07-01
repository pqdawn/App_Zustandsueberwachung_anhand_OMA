%% Funktion zum Finden des besten Bereichs für Ermittlung des Dämpfungsgrads
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    fig = Figur der App
%                       peak_values = Amplitude der Peaks
%                       idx_start = Index des Peak mit Amplitude = 0,9
%                       idx_end = Index des Peak mit Amplitude = 0,2

% Ausgabeparameter:     best_result = Strukturarray für gesamte Ergebnisse

function best_result = find_best_damping_area_auto(fig, peak_values, idx_start, idx_end)

    % Progressbar instanziieren
    progressbar = uiprogressdlg(fig, 'Title', 'Wählen des besten Bereiches für Dämpfungsgrad',...
        'Message', 'Es fängt gleich an...', 'Cancelable', 'on', 'CancelText', 'Stop');

    % Peaks zwischen Amplituden von 0,2 bis 0,9 weiter betrachten
    peaks = peak_values(idx_start:idx_end);
    num_peaks = length(peaks);

    % Strukturarray für Ergebnisse instanziieren
    best_result = struct( ...
        'idx_start', idx_start, ...
        'idx_end', idx_end, ...
        'mu', NaN, ...
        'sigma', NaN, ...
        'cov', Inf);

    % Wenn weniger als 10 Peaks vorliegen
    if num_peaks < 10

        % Dämpfungsgrad direkt anhand dieser Peaks berechnen
        [mu, sigma] = compute_damping_ratio(peaks, 1, num_peaks);

        % Ergebnisse speichern
        best_result.mu  = mu;
        best_result.sigma = sigma;
        best_result.cov = sigma / mu;

        % Funktion beenden
        return;
    end

    % Verschiedene Anzahl von Peaks probieren (Mindestanzahl von 10 Peaks)
    for k = 10:num_peaks

        % Falls "Abbrechen" im Progressbar betätigt wird, Vorgang abbrechen
        % und Fehler zeigen
        if progressbar.CancelRequested
            error('Vorgang abgebrochen!');
        end

        % Progressbar aktualisieren
        progress_Value = (k-10)/num_peaks;
        progressbar.Value = progress_Value;
        progressbar.Message = sprintf('Alle möglichen Kombinationen werden untersucht...');        

        % Aktuelle Anzahl von Peaks holen
        peak_subset = peaks(1:k);

        % Dämpfungsgrad mit diesen Peaks berechnen
        [mu, sigma] = compute_damping_ratio(peak_subset, 1, k);

        % Wenn Dämpfungsgrad ungültig ist, diese Kombination überspringen
        if mu <= 0 || sigma <= 0
            continue;
        end

        % Variationskoeffizient berechnen
        cov = sigma / mu;

        % Wenn dieser Koeffizient besser als der gespeicherte Koeffizient
        if cov < best_result.cov

            % Ergebnisse speichern
            best_result.mu = mu;
            best_result.sigma = sigma;
            best_result.cov = cov;
            best_result.idx_start = idx_start;
            best_result.idx_end = idx_start + k - 1;
        end
    end

    % Progressbar schließen
    pause(1);
    close(progressbar);    
end