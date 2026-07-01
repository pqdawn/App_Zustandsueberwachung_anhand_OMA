%% Callback für Button zum Exportieren des Signalplots (Modi "Modalanalyse" und "Zustandsüberwachung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       name_sensor_export = Namen der Sensoren
%                       sensor_table = Tabelle der Sensoren
%                       path = Pfad zum Zielordner
%                       time_series_tick = Wahl für Zeitreihe
%                       spectrum_tick = Wahl für Frequenzspektrum
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function export_signal_button_pushed(cache, name_sensor_export, sensor_table, path, time_series_tick, spectrum_tick, lamp, status)

    try
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(cache.data_matrix)
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

        % Namen der Sensoren holen
        name_sensor_display = table2array(sensor_table(:, 1));

        % Zu exportierende Sensoren holen
        to_export =  table2array(sensor_table(:, 2));

        % Fehlermeldung falls gar kein Sensor gewählt
        if all(to_export == false)
            error('Kein Sensor gewählt!');
        end

        % Messdaten und Infos holen
        data_matrix = cache.data_matrix;
        sampling_freq = cache.sampling_freq;
        measurement_type = cache.measurement_type;

        % Alle Sensoren durchlaufen
        for i=1:size(name_sensor_display, 1)
    
            % Prüfen, ob dieser Sensor zu exportieren ist
            if ~to_export(i)
                continue;
            end

            % Name des Sensors
            sensor_name = name_sensor_display(i);
        
            % Zeitvektor und Messdaten des gewählten Sensors
            time_vector = data_matrix(:,1);
            sensor_data = data_matrix(:,2:end);
            sensor_data_selected = sensor_data(:,i);

            % Fehlermeldung falls gar keine Darstellungsart gewählt
            num_option = sum([time_series_tick, spectrum_tick]);
            if num_option == 0
                error('Keine Darstellungsart gewählt!');
            end
        
            % Zeitreihe gewählt
            if time_series_tick
    
                % Pfad konstruieren
                file_name = 'Zeitreihe_' + name_sensor_export(i) + '.pdf';
                full_path = fullfile(path, file_name);
        
                % Plotten
                fig = figure;
                plot(time_vector, sensor_data_selected);
                xlim([0 time_vector(end)]);
                max_value = max(sensor_data_selected);
                ylim([min(sensor_data_selected)-0.1*max_value max(sensor_data_selected)+0.1*max_value]);
                if contains(sensor_name, 'x')
                    sensor_name2 = replace(sensor_name, "(x", "(\textit{x}}\rm{}\textbf{");
                elseif contains(sensor_name, 'y')
                    sensor_name2 = replace(sensor_name, "(y", "(\textit{y}}\rm{}\textbf{");
                else
                    sensor_name2 = replace(sensor_name, "(z", "(\textit{z}}\rm{}\textbf{");
                end
                string = ['\textbf{Zeitreihe f\"ur ', sensor_name2, '}'];
                string = strjoin(string);
                title(string);
                xlabel('Zeit in [s]');
                grid('on');

                % y-Achse abhängig von gemessenen Größe aktualisieren
                if strcmp(measurement_type, 'displacement')
                    ylabel('Verschiebung in [m]');
                elseif strcmp(measurement_type, 'velocity')
                    ylabel('Geschwindigkeit in [m/s]');
                else
                    ylabel('Beschleunigung in [m/s$^2$]');
                end
    
                % Als PDF exportieren
                exportgraphics(fig, full_path, 'ContentType', 'vector');
    
                % Figur schließen
                close(fig);
            end
            
            % Frequenzspektrum gewählt
            if spectrum_tick
    
                % Pfad konstruieren
                file_name = 'Frequenzspektrum_' + name_sensor_export(i) + '.pdf';
                full_path = fullfile(path, file_name);
    
                % Länge der Signale
                signal_length = size(sensor_data_selected,1);
        
                % FFT berechnen
                fft_results = compute_fft(sensor_data_selected);
        
                % Frequenzvektor erstellen
                freq_vector = sampling_freq*(0:signal_length/2-1)/signal_length;
        
                % Plotten
                fig = figure;
                plot(freq_vector, fft_results);
                xlim([0 sampling_freq/2]);
                max_value = max(fft_results);
                ylim([0 max(fft_results)+0.1*max_value]);
                if contains(sensor_name, 'x')
                    sensor_name2 = replace(sensor_name, "(x", "(\textit{x}}\rm{}\textbf{");
                elseif contains(sensor_name, 'y')
                    sensor_name2 = replace(sensor_name, "(y", "(\textit{y}}\rm{}\textbf{");
                else
                    sensor_name2 = replace(sensor_name, "(z", "(\textit{z}}\rm{}\textbf{");
                end
                string = ['\textbf{Frequenzspektrum f\"ur ', sensor_name2, '}'];
                string = strjoin(string);
                title(string);
                xlabel('Frequenz in [Hz]');
                ylabel('Intensit\"at');
                grid('on');
        
                % Als PDF exportieren
                exportgraphics(fig, full_path, 'ContentType', 'vector');
    
                % Figur schließen
                close(fig);
            end
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