%% Cache-System für Modus "Zusammenführung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = initiate_cache_system_merge_mode(app)

    % Speicherplatz für importierte Daten und Infos
    app.fig.UserData.cache.merge.num_mode = NaN;                     % Anzahl der Moden
    app.fig.UserData.cache.merge.num_group = NaN;                    % Anzahl der Gruppen
    app.fig.UserData.cache.merge.eigenfreq = [];                     % Eigenfrequenzen (Zeile = Gruppe, Spalte = Mode)
    app.fig.UserData.cache.merge.result_eigenfreq = [];              % Ergebnisse der Eigenfrequenzen (Zeile = Mode)
    app.fig.UserData.cache.merge.eigenvector = {};                   % Eigenvektoren (Zeile = Gruppe, Spalte = Mode)
    app.fig.UserData.cache.merge.result_eigenform = [];              % Ergebnisse der Eigenformen (Zeile = Mode)

    % Speicherplatz für Geometrie
    app.fig.UserData.cache.merge.geometry = struct([]); 
end