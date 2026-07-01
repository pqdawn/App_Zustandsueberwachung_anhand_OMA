%% Cache-System für Modus "Modalanalyse"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = initiate_cache_system_modal_mode(app)

    % Speicherplatz für Messdaten und Infos
    app.fig.UserData.cache.modal.data_matrix = NaN;                   % Messdaten
    app.fig.UserData.cache.modal.data_matrix_diff = NaN;              % Abgeleitete Messdaten
    app.fig.UserData.cache.modal.sampling_freq = NaN;                 % Abtastfrequenz
    app.fig.UserData.cache.modal.num_sensor = NaN;                    % Anzahl der Sensoren
    app.fig.UserData.cache.modal.direction = false(1,3);              % Richtungen
    app.fig.UserData.cache.modal.measurement_type = NaN;              % Gemessene Größe

    % Speicherplatz für Geometrie
    app.fig.UserData.cache.modal.geometry = struct([]);

    % Speicherplatz für Ergebnisse der FDD und EFDD
    app.fig.UserData.cache.modal.fdd_result = struct([]);
    app.fig.UserData.cache.modal.selected_peak = struct([]);
    app.fig.UserData.cache.modal.efdd_result = struct([]);

    % Speicherplatz für Ergebnisse der SSI-COV
    app.fig.UserData.cache.modal.cov_all_pole = struct([]);
    app.fig.UserData.cache.modal.cov_selected_pole = struct([]);
    app.fig.UserData.cache.modal.cov_all_pole_diff = struct([]);
    app.fig.UserData.cache.modal.cov_selected_pole_diff = struct([]);
    app.fig.UserData.cache.modal.cov_unselected_counter = NaN;

    % Speicherplatz für Ergebnisse der SSI-DATA
    app.fig.UserData.cache.modal.data_all_pole = struct([]);
    app.fig.UserData.cache.modal.data_selected_pole = struct([]);
    app.fig.UserData.cache.modal.data_all_pole_diff = struct([]);
    app.fig.UserData.cache.modal.data_selected_pole_diff = struct([]);
    app.fig.UserData.cache.modal.data_unselected_counter = NaN;

    % Speicherplatz für benutzte Parameter
    app.fig.UserData.cache.modal.used_parameter.fdd = struct([]);
    app.fig.UserData.cache.modal.used_parameter.cov = struct([]);
    app.fig.UserData.cache.modal.used_parameter.cov_cluster = struct([]);
    app.fig.UserData.cache.modal.used_parameter.data = struct([]);
    app.fig.UserData.cache.modal.used_parameter.data_cluster = struct([]);  

    % Speicherplatz für aktuelle Parameter
    app.fig.UserData.cache.modal.current_parameter.fdd = struct([]);
    app.fig.UserData.cache.modal.current_parameter.cov = struct([]);
    app.fig.UserData.cache.modal.current_parameter.cov_cluster = struct([]);
    app.fig.UserData.cache.modal.current_parameter.data = struct([]);
    app.fig.UserData.cache.modal.current_parameter.data_cluster = struct([]); 
end