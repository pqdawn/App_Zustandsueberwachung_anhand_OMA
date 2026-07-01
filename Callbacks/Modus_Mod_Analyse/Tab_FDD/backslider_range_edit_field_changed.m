%% Callback für Eingabefeld zum fixierten Bereich des x-Achse für Korrelationsfunktion der 1. Singulärwerte
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function backslider_range_edit_field_changed(app)

    % Nötige Variablen holen
    src = app.backsignal_range_edit_field;                  % Eingabefeld für fixierten Bereich der x-Achse
    psd_graph2 = app.psd_graph3;                            % Graph für 1. Singulärwerte der PSD in [dB]
    backsignal_graph = app.backsignal_graph;                % Graph für Korrelationsfunktion der 1. Singulärwerte
    slider = app.backsignal_slider;                         % Slider für x-Achse des Graphs für Korrelationsfunktion der 1. Eigenwerte
    log_graph = app.log_graph;                              % Graph für lineare Regression des logarithmischen Dekrements
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Eingegebenen Bereich holen
        fixed_range = str2double(src.Value);

        % Fehlermeldung falls Eingabe keine gültige Zahl ist
        if isnan(fixed_range)
            error('Eingegebener Bereich ungültig!');
        end

        % Fehlermeldung falls Eingabe größer als Bereich des Sliders ist
        if fixed_range > diff(slider.Limits)
            error('Eingegebener Bereich zu groß!');
        end        

        % Werte aus dem Slider holen
        slider_value = slider.Value;

        % Neuen Wert für die rechte Seite des Sliders berechnen
        slider_value(2) = slider_value(1) + fixed_range;

        % Überprüfen, ob die Werte innerhalb der Grenzen des Sliders
        % passen, wenn nicht, müssen sie ggf. angepasst werden
        limits = slider.Limits;
        if slider_value(1) < limits(1)
            slider_value(1) = limits(1);
            slider_value(2) = slider_value(1) + fixed_range;
        elseif slider_value(2) > limits(2)
            slider_value(2) = limits(2);
            slider_value(1) = slider_value(2) - fixed_range;
        end

        % Slider aktualisieren
        slider.Value = slider_value;

        % Gespeicherte obere und untere Grenzen aktualisieren
        src.UserData.lower_limit = slider.Value(1);
        src.UserData.upper_limit = slider.Value(2);

        % Wert des Bereiches im Eingabefeld aktualisieren
        src.Value = sprintf('%.2f', slider.Value(2) - slider.Value(1));

        % Graph aktualisieren
        xlim(backsignal_graph, slider.Value);

        % Untersuchte Mode holen
        mode_num = psd_graph2.UserData.mode_num;           

        % Ergebnisse der EFDD holen
        time_recon = app.fig.UserData.cache.modal.efdd_result(mode_num).time_recon; 
        idx_of_peak_in_time = app.fig.UserData.cache.modal.efdd_result(mode_num).peak_info.idx_of_peak_in_time;        

        % Zugehörigen Peak für linke Seite finden
        x_left = slider.Value(1);
        [~, idx_left] = min(abs(time_recon - x_left));
        [~, idx_left] = min(abs(idx_of_peak_in_time - idx_left));

        % Zugehörigen Peak für rechte Seite finden
        x_right = slider.Value(2);
        [~, idx_right] = min(abs(time_recon - x_right));
        [~, idx_right] = min(abs(idx_of_peak_in_time - idx_right));    

        % x-Achse des 2. Graphs aktualisieren
        xlim(log_graph, [idx_left idx_right]);              
        
        % Status aktualisieren
        update_status(status, lamp, '>> x-Achse aktualisiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end