%% Callback für Button zum Exportieren des Frequenz-Zeit-Plot
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function export_freq_time_button_pushed(app)

    % Nötige Variablen holen
    path = app.freq_time_path_edit_field.Value;                             % Pfad zum Zielordner
    fdd_tick = app.oma_fdd_check3_monitor.Value;                            % Wahl für FDD
    efdd_tick = app.oma_efdd_check3_monitor.Value;                          % Wahl für EFDD
    ssi_cov_tick = app.oma_ssi_cov_check3_monitor.Value;                    % Wahl für SSI-COV
    ssi_data_tick = app.oma_ssi_data_check3_monitor.Value;                  % Wahl für SSI-DATA
    lamp = app.status_lamp;                                                 % Licht des Status
    status = app.status_text_area;                                          % Textfeld des Status

    try
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(app.fig.UserData.cache.monitor.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Fehlermeldung falls Pfad nicht eingegeben
        if isempty(path)
            error('Pfad nicht eingegeben!');
        end

        % Falls dieser Ordner nicht existiert, einen neuen Ordner erstellen
        if ~exist(path, 'dir')
            mkdir(path);
        end

        % Fehlermeldung falls gar keine Daten gewählt
        num_option = sum([fdd_tick, efdd_tick, ssi_cov_tick, ssi_data_tick]);
        if num_option == 0
            error('Keine Daten gewählt!');
        end        

        % Fehlermeldung falls keine Ketten
        if isempty(app.fig.UserData.cache.monitor.track_freq)
            error('Zustandsüberwachung nicht durchgeführt!')
        end

        % Zeitschritte holen
        start_time_of_segment = [app.fig.UserData.cache.monitor.segment_info.first_time_step];        
        
        % FDD gewählt
        if fdd_tick

            % Pfad konstruieren
            file_name = 'Freq_Zeit_Plot_FDD.pdf';
            full_path = fullfile(path, file_name);

            % Ergebnisse für FDD holen
            track_result = app.fig.UserData.cache.monitor.track_freq.fdd;            
    
            % Plotten
            fig = figure;
            hold on;
            for t = 1:numel(track_result)
                plot(start_time_of_segment, track_result{t}, 'o-', 'LineWidth', 2);
            end
            hold off;     
            title('\textbf{Frequenz-Zeit-Plot (FDD)}');
            xlabel('Zeit in [s]');
            ylabel('Frequenz in [Hz]');
            grid on;
            legend(compose('%d. Mode', 1:numel(track_result)), 'Location', 'eastoutside');

            % Als PDF exportieren
            exportgraphics(fig, full_path, 'ContentType', 'vector');

            % Figur schließen
            close(fig);
        end

        % EFDD gewählt
        if efdd_tick

            % Pfad konstruieren
            file_name = 'Freq_Zeit_Plot_EFDD.pdf';
            full_path = fullfile(path, file_name);

            % Ergebnisse für EFDD holen
            track_result = app.fig.UserData.cache.monitor.track_freq.efdd;            
    
            % Plotten
            fig = figure;
            hold on;
            for t = 1:numel(track_result)
                plot(start_time_of_segment, track_result{t}, 'o-', 'LineWidth', 2);
            end
            hold off;     
            title('\textbf{Frequenz-Zeit-Plot (EFDD)}');
            xlabel('Zeit in [s]');
            ylabel('Frequenz in [Hz]');
            grid on;
            legend(compose('%d. Mode', 1:numel(track_result)), 'Location', 'eastoutside');

            % Als PDF exportieren
            exportgraphics(fig, full_path, 'ContentType', 'vector');

            % Figur schließen
            close(fig);
        end    

        % SSI-COV gewählt
        if ssi_cov_tick

            % Pfad konstruieren
            file_name = 'Freq_Zeit_Plot_SSI-COV.pdf';
            full_path = fullfile(path, file_name);

            % Ergebnisse für SSI-COV holen
            track_result = app.fig.UserData.cache.monitor.track_freq.ssi_cov;            
    
            % Plotten
            fig = figure;
            hold on;
            for t = 1:numel(track_result)
                plot(start_time_of_segment, track_result{t}, 'o-', 'LineWidth', 2);
            end
            hold off;     
            title('\textbf{Frequenz-Zeit-Plot (SSI-COV)}');
            xlabel('Zeit in [s]');
            ylabel('Frequenz in [Hz]');
            grid on;
            legend(compose('%d. Mode', 1:numel(track_result)), 'Location', 'eastoutside');

            % Als PDF exportieren
            exportgraphics(fig, full_path, 'ContentType', 'vector');

            % Figur schließen
            close(fig);
        end   

        % SSI-DATA gewählt
        if ssi_data_tick

            % Pfad konstruieren
            file_name = 'Freq_Zeit_Plot_SSI-DATA.pdf';
            full_path = fullfile(path, file_name);

            % Ergebnisse für SSI-DATA holen
            track_result = app.fig.UserData.cache.monitor.track_freq.ssi_data;            
    
            % Plotten
            fig = figure;
            hold on;
            for t = 1:numel(track_result)
                plot(start_time_of_segment, track_result{t}, 'o-', 'LineWidth', 2);
            end
            hold off;     
            title('\textbf{Frequenz-Zeit-Plot (SSI-DATA)}');
            xlabel('Zeit in [s]');
            ylabel('Frequenz in [Hz]');
            grid on;
            legend(compose('%d. Mode', 1:numel(track_result)), 'Location', 'eastoutside');

            % Als PDF exportieren
            exportgraphics(fig, full_path, 'ContentType', 'vector');

            % Figur schließen
            close(fig);
        end          

        % Status aktualisieren
        update_status(status, lamp, '>> Plots exportiert', 'erfolg');

    % Fehler fangen
    catch ME

        % Spezifische Fehlermeldung wenn eine neue Datei nicht exportiert
        % werden kann, weil eine Datei mit dem gleichen Namen geöffnet ist 
        if contains(ME.message, "Permission")
            update_status(status, lamp, '>> Fehler: Eine Datei mit dem gleichen Namen ist geöffnet! Zugang verweigert!', 'fehler');

        % Ansonsten normale Fehlermeldung
        else
            update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
        end
    end
end