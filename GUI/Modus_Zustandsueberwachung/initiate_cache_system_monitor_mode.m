%% Cache-System für Modus "Zustandsüberwachung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = initiate_cache_system_monitor_mode(app)

    % Speicherplatz für Messdaten und Infos
    app.fig.UserData.cache.monitor.data_matrix = NaN;                   % Messdaten
    app.fig.UserData.cache.monitor.sampling_freq = NaN;                 % Abtastfrequenz
    app.fig.UserData.cache.monitor.num_sensor = NaN;                    % Anzahl der Sensoren
    app.fig.UserData.cache.monitor.direction = false(1,3);              % Richtungen
    app.fig.UserData.cache.monitor.measurement_type = NaN;              % Gemessene Größe

    % Speicherplatz für Referenzmoden
    app.fig.UserData.cache.monitor.ref_eigenfreq = [];
    app.fig.UserData.cache.monitor.ref_eigenvector = {};

    % Speicherplatz für Ergebnisse
    app.fig.UserData.cache.monitor.segment_info = struct([]);
    app.fig.UserData.cache.monitor.fdd_result = struct([]);
    app.fig.UserData.cache.monitor.selected_peak = struct([]);
    app.fig.UserData.cache.monitor.efdd_result = struct([]);
    app.fig.UserData.cache.monitor.cov_all_pole = struct([]);
    app.fig.UserData.cache.monitor.cov_selected_pole = struct([]);
    app.fig.UserData.cache.monitor.cov_cluster_quality = struct([]);
    app.fig.UserData.cache.monitor.cov_unselected_counter = NaN;
    app.fig.UserData.cache.monitor.data_all_pole = struct([]);
    app.fig.UserData.cache.monitor.data_selected_pole = struct([]);
    app.fig.UserData.cache.monitor.data_cluster_quality = struct([]);
    app.fig.UserData.cache.monitor.data_unselected_counter = NaN;
    app.fig.UserData.cache.monitor.track_freq.fdd = [];
    app.fig.UserData.cache.monitor.track_freq.efdd = [];
    app.fig.UserData.cache.monitor.track_freq.ssi_cov = [];
    app.fig.UserData.cache.monitor.track_freq.ssi_data = [];
    app.fig.UserData.cache.monitor.track_phi.fdd = [];
    app.fig.UserData.cache.monitor.track_phi.efdd = [];
    app.fig.UserData.cache.monitor.track_phi.ssi_cov = [];
    app.fig.UserData.cache.monitor.track_phi.ssi_data = [];  
    app.fig.UserData.cache.monitor.track_damp.ssi_cov = [];
    app.fig.UserData.cache.monitor.track_damp.ssi_data = [];    

    % Speicherplatz für benutzte Parameter der Zustandsüberwachung
    app.fig.UserData.cache.monitor.used_parameter.num_segment = NaN;
    app.fig.UserData.cache.monitor.used_parameter.fdd = struct([]);
    app.fig.UserData.cache.monitor.used_parameter.cov = struct([]);
    app.fig.UserData.cache.monitor.used_parameter.cov_cluster = struct([]);
    app.fig.UserData.cache.monitor.used_parameter.data = struct([]);
    app.fig.UserData.cache.monitor.used_parameter.data_cluster = struct([]);   

    % Speicherplatz für aktuelle Parameter der Zustandsüberwachung
    app.fig.UserData.cache.monitor.current_parameter.num_segment = NaN;
    app.fig.UserData.cache.monitor.current_parameter.fdd = struct([]);
    app.fig.UserData.cache.monitor.current_parameter.cov = struct([]);
    app.fig.UserData.cache.monitor.current_parameter.cov_cluster = struct([]);
    app.fig.UserData.cache.monitor.current_parameter.data = struct([]);
    app.fig.UserData.cache.monitor.current_parameter.data_cluster = struct([]);  
end