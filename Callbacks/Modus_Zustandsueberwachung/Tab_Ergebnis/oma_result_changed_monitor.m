%% Callback für Button zum Darstellen der Ergebnisse anderer OMA-Methoden (Modus "Zustandsüberwachung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function oma_result_changed_monitor(app)

    % Nötige Variablen holen
    src = app.oma_dropdown2;                                % Dieses Dropdown   
    freq_damp_table = app.freq_damp_table4;                 % Tabelle für Ergebnisse des Abschnitts
    freq_time_graph = app.freq_time_graph;                  % Frequenz-Zeit-Plot
    examine_graph = app.examine_graph;                      % Graph für Untersuchung
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Gewählte OMA-Methode holen
        oma_selected = src.Value;    

        % Wenn FDD gewählt
        if strcmp(oma_selected, 'FDD')

            % Ergebnisse für FDD holen
            track_result = app.fig.UserData.cache.monitor.track_freq.fdd;        

        % Wenn EFDD gewählt
        elseif strcmp(oma_selected, 'EFDD')   

            % Ergebnisse für EFDD holen
            track_result = app.fig.UserData.cache.monitor.track_freq.efdd;      

        % Wenn SSI-COV gewählt
        elseif strcmp(oma_selected, 'SSI-COV')

            % Ergebnisse für SSI-COV holen
            track_result = app.fig.UserData.cache.monitor.track_freq.ssi_cov;

        % Wenn SSI-DATA gewählt
        elseif strcmp(oma_selected, 'SSI-DATA')

            % Ergebnisse für SSI-DATA holen
            track_result = app.fig.UserData.cache.monitor.track_freq.ssi_data;                
        end

        % Graph für Untersuchung zurücksetzen
        cla(examine_graph);
        delete(examine_graph.Legend);

        % Tabelle für Ergebnisse des Abschnitts zurücksetzen
        freq_damp_table.Data = [];       
        freq_damp_table.ColumnName = {'Ergebnisse werden hier angezeigt'};

        % Frequenz-Zeit-Plot aktualisieren
        cla(freq_time_graph);
        start_time_of_segment = [app.fig.UserData.cache.monitor.segment_info.first_time_step];
        hold(freq_time_graph, 'on');
        for t = 1:numel(track_result)
            plot(freq_time_graph, start_time_of_segment, track_result{t}, 'o-', 'LineWidth', 2);
        end
        hold(freq_time_graph, 'off');
        head_line = ['\textbf{Frequenz-Zeit-Plot (', char(oma_selected), ')}'];
        title(freq_time_graph, head_line);
        legend(freq_time_graph, compose('%d. Mode', 1:numel(track_result)), 'Location', 'northeast');

        % Status aktualisieren
        update_status(status, lamp, '>> Frequenz-Zeit-Plot aktualisiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end