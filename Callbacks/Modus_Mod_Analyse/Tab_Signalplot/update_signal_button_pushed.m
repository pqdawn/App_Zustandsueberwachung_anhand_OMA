%% Callback für Button zum Darstellen des Signalplots (Modi "Modalanalyse" und "Zustandsüberwachung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       sensor_dropdown = Dropdown für Sensoren
%                       time_series_tick = Wahl für Zeitreihe
%                       spectrum_tick = Wahl für Frequenzspektrum
%                       graph = Graph für Signalplot
%                       slider = Slider für x-Achse
%                       range_edit_field = Eingabefeld für fixierten Bereich der x-Achse
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function update_signal_button_pushed(cache, sensor_dropdown, time_series_tick, spectrum_tick, graph, slider, range_edit_field, lamp, status)

    try
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(cache.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Messdaten und Infos holen
        data_matrix = cache.data_matrix;
        sampling_freq = cache.sampling_freq;
        measurement_type = cache.measurement_type;        

        % Gewählten Sensor holen
        sensor_selected = sensor_dropdown.Value;
    
        % Namen des gewählten Sensors holen
        sensor_name = sensor_dropdown.Items{sensor_selected};
    
        % Zeitvektor und Messdaten des gewählten Sensors holen
        time_vector = data_matrix(:,1);
        sensor_data = data_matrix(:,2:end);
        sensor_data_selected = sensor_data(:,sensor_selected);
    
        % Zeitreihe gewählt
        if time_series_tick
    
            % Plotten
            plot(graph, time_vector, sensor_data_selected);
            xlim(graph, [0 ceil(time_vector(end))]);
            max_value = max(sensor_data_selected);
            ylim(graph, [min(sensor_data_selected)-0.1*max_value max(sensor_data_selected)+0.1*max_value]);
            if contains(sensor_name, 'x')
                sensor_name2 = replace(sensor_name, "(x", "(\textit{x}}\rm{}\textbf{");
            elseif contains(sensor_name, 'y')
                sensor_name2 = replace(sensor_name, "(y", "(\textit{y}}\rm{}\textbf{");
            else
                sensor_name2 = replace(sensor_name, "(z", "(\textit{z}}\rm{}\textbf{");
            end
            title(graph, ['\textbf{Zeitreihe f\"ur ', sensor_name2, '}']);
            xlabel(graph, 'Zeit in [s]');

            % y-Achse abhängig von gemessener Größe aktualisieren
            if strcmp(measurement_type, 'displacement')
                ylabel(graph, 'Verschiebung in [m]');
            elseif strcmp(measurement_type, 'velocity')
                ylabel(graph, 'Geschwindigkeit in [m/s]');
            else
                ylabel(graph, 'Beschleunigung in [m/s$^2$]');
            end

            % Slider aktualisieren
            slider.Limits = [0 ceil(time_vector(end))];
            slider.Value = [0 ceil(time_vector(end))];
            slider.MajorTicks = graph.XTick;

            % Gespeicherte obere und untere Grenzen aktualisieren
            range_edit_field.UserData.lower_limit = slider.Value(1);
            range_edit_field.UserData.upper_limit = slider.Value(2);
    
            % Wert des Bereiches im Eingabefeld aktualisieren
            range_edit_field.Value = sprintf('%.2f', slider.Value(2) - slider.Value(1));
    
            % Status aktualisieren
            update_status(status, lamp, '>> Zeitreihe aktualisiert', 'erfolg');
        
        % Frequenzspektrum gewählt
        elseif spectrum_tick

            % Länge der Signale
            signal_length = size(sensor_data_selected,1);
    
            % FFT berechnen
            fft_results = compute_fft(sensor_data_selected);
    
            % Frequenzvektor erstellen
            freq_vector = sampling_freq*(0:signal_length/2-1)/signal_length;
    
            % Plotten
            plot(graph, freq_vector, fft_results);
            xlim(graph, [0 ceil(sampling_freq/2)]);
            max_value = max(fft_results);
            ylim(graph, [0 max(fft_results)+0.1*max_value]);
            if contains(sensor_name, 'x')
                sensor_name2 = replace(sensor_name, "(x", "(\textit{x}}\rm{}\textbf{");
            elseif contains(sensor_name, 'y')
                sensor_name2 = replace(sensor_name, "(y", "(\textit{y}}\rm{}\textbf{");
            else
                sensor_name2 = replace(sensor_name, "(z", "(\textit{z}}\rm{}\textbf{");
            end
            title(graph, ['\textbf{Frequenzspektrum f\"ur ', sensor_name2, '}']);
            xlabel(graph, 'Frequenz in [Hz]');
            ylabel(graph, 'Intensit\"at');

            % Slider aktualisieren
            slider.Limits = [0 ceil(sampling_freq/2)];
            slider.Value = [0 ceil(sampling_freq/2)];
            slider.MajorTicks = graph.XTick;

            % Gespeicherte obere und untere Grenzen aktualisieren
            range_edit_field.UserData.lower_limit = slider.Value(1);
            range_edit_field.UserData.upper_limit = slider.Value(2);
    
            % Wert des Bereiches im Eingabefeld aktualisieren
            range_edit_field.Value = sprintf('%.2f', slider.Value(2) - slider.Value(1));
    
            % Status aktualisieren
            update_status(status, lamp, '>> Frequenzspektrum aktualisiert', 'erfolg');
        end

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end