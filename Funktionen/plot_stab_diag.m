%% Funktion zum Plotten des Stabilisationsdiagramms
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    graph = Graph für Stabilisationsdiagramm
%                       all_pole = Alle Pole aus der SSI
%                       all_poles_tick = Wahl des Filters für alle berechneten Pole
%                       stable_freq_tick = Wahl des Filters für stabile Frequenz
%                       stable_damp_tick = Wahl des Filters für stabilen Dämpfungsgrad
%                       mac_tick = Wahl des Filters für "MAC-Bedingung erfüllt"
%                       pole_chosen_tick = Wahl des Filters für gewählte Pole
%                       or_tick = Wahl des Filters für "oder"
%                       and_tick = Wahl des Filters für "und"
%                       ssi_choice = Wahl für Art der SSI
%                       measurement_choice = Wahl für Messdaten
%                       freq_limit = Frequenzgrenze
%                       slider = Slider für x-Achse des Graphs
%                       range_check = Checkbox für fixierten Bereich der x-Achse
%                       range_edit_field = Eingabefeld für fixierten Bereich der x-Achse

% Ausgabeparameter: -

function plot_stab_diag(graph, all_pole, all_poles_tick, ...
    stable_freq_tick, stable_damp_tick, mac_tick, pole_chosen_tick, ...
    or_tick, and_tick, ssi_choice, measurement_choice, freq_limit, ...
    slider, range_check, range_edit_field)

    % Daten für Plotten holen
    eigenfreq = [all_pole.eigenfreq];
    model_order = [all_pole.model_order];

    % Logische Indizes holen
    idx_freq_stable = [all_pole.is_stable_freq];
    idx_damp_stable = [all_pole.is_stable_damp];
    idx_mac         = [all_pole.is_mac];
    idx_chosen = [all_pole.is_chosen];

    % Alles auf Graph löschen
    cla(graph);   

    % Falls Frequenzgrenze und UI-Elemente für x-Achse eingegeben wurden 
    % (SSI wurde neu durchgeführt), dann müssen die UI-Elemente und die 
    % Achsengrenzen angepasst werden
    if nargin == 15

        % Grenze für x-Achse
        xlim(graph, [0 ceil(freq_limit)]);
        
        % Slider aktualisieren
        slider.Limits = [0 ceil(freq_limit)];
        slider.Value = [0 ceil(freq_limit)];
        slider.MajorTicks = graph.XTick;

        % Checkbox aktualisieren
        range_check.Value = 0;

        % Gespeicherte obere und untere Grenzen aktualisieren
        range_edit_field.UserData.lower_limit = slider.Value(1);
        range_edit_field.UserData.upper_limit = slider.Value(2);
    
        % Wert des Bereiches im Eingabefeld aktualisieren
        range_edit_field.Value = sprintf('%.2f', slider.Value(2) - slider.Value(1));
    end
    
    % Grenze für y-Achse
    ylim(graph, [0 max(model_order)]);
    
    % Legende instanziieren
    legend_name = {};

    % Wenn "oder" gewählt wurde (Markieren, wenn mindestens ein Kriterium 
    % erfüllt ist)
    if or_tick    
    
        % Alle berechneten Pole markieren
        if all_poles_tick
            scatter(graph, eigenfreq, model_order, 30, 'y', 'filled');
            hold(graph, 'on');
            legend_name{end+1} = 'Alle berechneten Pole';
        end
        
        % Pole mit stabilen Frequenzen markieren
        if stable_freq_tick && any(idx_freq_stable)
            scatter(graph, eigenfreq(idx_freq_stable), model_order(idx_freq_stable), 30, 'r');
            hold(graph, 'on');
            legend_name{end+1} = 'Stabile Frequenz';
        end
        
        % Pole mit stabilen Dämpfungsgraden markieren
        if stable_damp_tick && any(idx_damp_stable)
            scatter(graph, eigenfreq(idx_damp_stable), model_order(idx_damp_stable), 30, 'b+');
            hold(graph, 'on');
            legend_name{end+1} = 'Stabiler D\"ampfungsgrad';
        end
        
        % Pole, die MAC-Bedingung erfüllen, markieren
        if mac_tick && any(idx_mac)
            scatter(graph, eigenfreq(idx_mac), model_order(idx_mac), 30, 'gx');
            hold(graph, 'on');
            legend_name{end+1} = 'MAC-Bedingung erf\"ullt';
        end

    % Wenn "und" gewählt wurde (Markieren, wenn alle Kriterien erfüllt
    % sind)
    elseif and_tick

        % Abhängig vom gewählten Filter logische Indizes holen
        logic_idx = [];
        if stable_freq_tick
            logic_idx = [logic_idx; all_pole.is_stable_freq];
        end
        if stable_damp_tick
            logic_idx = [logic_idx; all_pole.is_stable_damp];
        end
        if mac_tick
            logic_idx = [logic_idx; all_pole.is_mac];
        end 
        
        % Nur wahr zuordnen, wenn alle Kriterien erfüllt sind
        final_to_plot = all(logic_idx);

        % Alle berechneten Pole markieren
        if all_poles_tick && any(final_to_plot)
            scatter(graph, eigenfreq(final_to_plot), model_order(final_to_plot), 30, 'y', 'filled');
            hold(graph, 'on');
            legend_name{end+1} = 'Alle berechneten Pole';
        end
        
        % Pole mit stabilen Frequenzen markieren
        stable_freq_check = all([final_to_plot; idx_freq_stable]);
        if stable_freq_tick && any(stable_freq_check)
            scatter(graph, eigenfreq(stable_freq_check), model_order(stable_freq_check), 30, 'r');
            hold(graph, 'on');
            legend_name{end+1} = 'Stabile Frequenz';
        end
        
        % Pole mit stabilen Dämpfungsgraden markieren
        stable_damp_check = all([final_to_plot; idx_damp_stable]);
        if stable_damp_tick && any(stable_damp_check)
            scatter(graph, eigenfreq(stable_damp_check), model_order(stable_damp_check), 30, 'b+');
            hold(graph, 'on');
            legend_name{end+1} = 'Stabiler D\"ampfungsgrad';
        end
        
        % Pole, die MAC-Bedingung erfüllen, markieren
        mac_check = all([final_to_plot; idx_mac]);
        if mac_tick && any(mac_check)
            scatter(graph, eigenfreq(mac_check), model_order(mac_check), 30, 'gx');
            hold(graph, 'on');
            legend_name{end+1} = 'MAC-Bedingung erf\"ullt';
        end      
    end

    % Gewählte Pole markieren
    if strcmp(pole_chosen_tick, 'An') && any(idx_chosen)
        scatter(graph, eigenfreq(idx_chosen), model_order(idx_chosen), 'r', 'filled');
        hold(graph, 'on');
        legend_name{end+1} = 'Gew\"ahlte Pole';
    end    

    % Fehlermeldung falls keine Pole gefunden wurden
    if isempty(legend_name)
        error('Keine Pole für Stabilisationsdiagramm gefunden!');
    end

    % Legende erzeugen, abhängig von vorhandenen Elementen
    if ~isempty(legend_name)
        legend(graph, legend_name, 'Location', 'southeast');
    end

    % Falls Art der SSI und Messdaten eingegeben wurden dann muss der Titel
    % aktualisiert werden
    if nargin >= 11
        if measurement_choice == 1
            title_string = ['\textbf{Stabilisationsdiagramm der ', ssi_choice, '}'];
        elseif measurement_choice == 2
            title_string = ['\textbf{Stabilisationsdiagramm der ', ssi_choice, ' (Abgeleitete Messdaten)}'];
        end
        title(graph, title_string);
    end
end