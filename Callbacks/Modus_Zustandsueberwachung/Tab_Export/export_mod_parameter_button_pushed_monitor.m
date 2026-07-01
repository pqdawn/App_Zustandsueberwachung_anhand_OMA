%% Callback für Button zum Exportieren der modalen Parameter (Modus "Zustandsüberwachung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function export_mod_parameter_button_pushed_monitor(app)

    % Nötige Variablen holen
    freq_damp_table = app.freq_damp_table2_monitor.Data;                    % Tabelle für Ergebnisse
    path = app.mod_parameter_path_edit_field_monitor.Value;                 % Pfad zum Zielordner
    eigenfreq_tick = app.eigenfreq_check_monitor.Value;                     % Checkbox für Eigenfrequenz
    damp_tick = app.damp_check_monitor.Value;                               % Checkbox für Dämpfungsgrad
    eigenvector_tick = app.eigenvector_check_monitor.Value;                 % Checkbox für Eigenvektor
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

        % Fehlermeldung falls noch keine Ergebnisse
        if isempty(freq_damp_table)
            error('Zustandsüberwachung nicht durchgeführt!')
        end

        % OMA-Methoden holen
        oma_matrix = table2array(freq_damp_table(:, 1));

        % Einzigartige OMA-Methoden holen
        oma_uniq = unique(oma_matrix, 'stable');        

        % Eigenfrequenzen holen
        ref_freq_matrix = table2array(freq_damp_table(:, 2));

        % Zu exportierende Ergebnisse holen
        to_export =  table2array(freq_damp_table(:, 3));

        % Fehlermeldung falls gar kein Ergebnis gewählt
        if all(to_export == false)
            error('Kein Ergebnis gewählt!');
        end

        % Matrizen für Dämpfungsgrade und Eigenvektoren aller OMA-Methoden 
        % instanziieren
        track_freq_all_oma_all_segment = [];
        track_phi_all_oma_all_segment = [];
        track_damp_all_oma_all_segment = [];

        % Dämpfungsgrade und Eigenvektoren verschiedener Methoden zusammenfügen
        for i = 1:length(oma_uniq)

            switch oma_uniq(i)
                case "FDD"
                    num_mode = numel(find(oma_matrix == oma_uniq(i)));
                    track_freq_all_oma_all_segment = [track_freq_all_oma_all_segment, app.fig.UserData.cache.monitor.track_freq.fdd];
                    track_damp_all_oma_all_segment = [track_damp_all_oma_all_segment, repmat({NaN}, 1,num_mode)];
                    track_phi_all_oma_all_segment = [track_phi_all_oma_all_segment, app.fig.UserData.cache.monitor.track_phi.fdd];

                case "EFDD"
                    num_mode = numel(find(oma_matrix == oma_uniq(i)));
                    track_freq_all_oma_all_segment = [track_freq_all_oma_all_segment, app.fig.UserData.cache.monitor.track_freq.efdd];
                    track_damp_all_oma_all_segment = [track_damp_all_oma_all_segment, repmat({NaN}, 1,num_mode)];
                    track_phi_all_oma_all_segment = [track_phi_all_oma_all_segment, app.fig.UserData.cache.monitor.track_phi.efdd];

                case "SSI-COV"
                    track_freq_all_oma_all_segment = [track_freq_all_oma_all_segment, app.fig.UserData.cache.monitor.track_freq.ssi_cov];
                    track_damp_all_oma_all_segment = [track_damp_all_oma_all_segment, app.fig.UserData.cache.monitor.track_damp.ssi_cov];
                    track_phi_all_oma_all_segment = [track_phi_all_oma_all_segment, app.fig.UserData.cache.monitor.track_phi.ssi_cov];

                case "SSI-DATA"
                    track_freq_all_oma_all_segment = [track_freq_all_oma_all_segment, app.fig.UserData.cache.monitor.track_freq.ssi_data];
                    track_damp_all_oma_all_segment = [track_damp_all_oma_all_segment, app.fig.UserData.cache.monitor.track_damp.ssi_data];
                    track_phi_all_oma_all_segment = [track_phi_all_oma_all_segment, app.fig.UserData.cache.monitor.track_phi.ssi_data];
            end
        end    

        % Nur die gewählten OMA-Methoden, Eigenfrequenzen, Dämpfungsgrade und
        % Eigenvektoren weiter betrachten
        oma_matrix = oma_matrix(to_export, :);
        ref_freq_matrix = ref_freq_matrix(to_export);
        track_freq_all_oma_all_segment = track_freq_all_oma_all_segment(:, to_export);
        track_damp_all_oma_all_segment = track_damp_all_oma_all_segment(:, to_export);
        track_phi_all_oma_all_segment = track_phi_all_oma_all_segment(:, to_export);

        % Zu exportierende Methoden extrahieren
        oma_to_export = unique(oma_matrix);

        % Fehlermeldung falls gar keine Daten gewählt
        num_option = sum([eigenfreq_tick, eigenvector_tick]);
        if num_option == 0
            error('Keine Daten gewählt!');
        end

        % Alle zu exportierenden Methoden durchlaufen
        for i = 1:numel(oma_to_export)

            % Methode holen
            oma_selected = oma_to_export(i);

            % Ergebnisse für diese Methode holen
            mask = oma_matrix == oma_selected;
            freq_selected = ref_freq_matrix(mask);
            track_freq_this_oma = track_freq_all_oma_all_segment(:, mask);
            track_damp_this_oma = track_damp_all_oma_all_segment(:, mask);
            track_phi_this_oma = track_phi_all_oma_all_segment(:, mask);

            % Eigenfrequenz gewählt
            if eigenfreq_tick

                % Alle Ketten in Array zuordnen
                track_freq_array = vertcat(track_freq_this_oma{:});
    
                % Eigenfrequenzen holen
                num_freq_list = [(1:size(freq_selected,1))', track_freq_array];

                % Datei erstellen
                num_col = size(num_freq_list, 2);
                file_name = strcat(path, '\Eigenfrequenz_', oma_selected, '.txt');
                fid = fopen(file_name, 'w+');
                fprintf(fid, 'Mode');
                for k = 2:num_col
                    fprintf(fid, '\t%d. Abschnitt [Hz]', k-1);
                end
                fprintf(fid, '\n');
                formatSpec = ['%4.0f', repmat('\t%17.4f', 1, num_col-1), '\n'];
                fprintf(fid, formatSpec, num_freq_list');                
                fclose all;
            end

            % Dämpfungsgrad gewählt
            if damp_tick
    
                % Wenn die aktualle OMA-Methode FDD ist, Warnung
                if strcmp(oma_selected, "FDD")

                    % Status aktualisieren
                    update_status(status, lamp, '>> FDD liefert keine Dämpfungsgrade!', 'warnung');
                    pause(1);

                % Wenn die aktualle OMA-Methode EFDD ist, Warnung
                elseif strcmp(oma_selected, "EFDD")

                    % Status aktualisieren
                    update_status(status, lamp, '>> EFDD liefert keine Dämpfungsgrade in diesem Modus!', 'warnung');
                    pause(1);                        
                
                % Für andere OMA-Methoden lassen sich Dämpfungsgrade
                % exportieren
                else

                    % Alle Ketten in Array zuordnen
                    damping_array = vertcat(track_damp_this_oma{:}).*100;
        
                    % Dämpfungsgrade holen
                    num_damp_list = [(1:size(freq_selected,1))', damping_array];
    
                    % Datei erstellen
                    num_col = size(num_damp_list, 2);
                    file_name = strcat(path, '\Daempfungsgrade_', oma_selected, '.txt');
                    fid = fopen(file_name, 'w+');
                    fprintf(fid, 'Mode');
                    for k = 2:num_col
                        fprintf(fid, '\t%d. Abschnitt [%%]', k-1);
                    end
                    fprintf(fid, '\n');
                    formatSpec = ['%4.0f', repmat('\t%16.4f', 1, num_col-1), '\n'];
                    fprintf(fid, formatSpec, num_damp_list');                
                    fclose all; 
                end
            end            
    
            % Eigenvektor gewählt
            if eigenvector_tick

                % Richtungen der importierten Messdaten holen
                direction_saved = app.fig.UserData.cache.monitor.direction;
                num_direct_measure = sum(direction_saved);              
    
                % Alle Moden durchlaufen
                for j=1:size(track_phi_this_oma, 2)
    
                    % Eigenvektoren dieser Mode holen
                    track_phi_this_mode = track_phi_this_oma{j};

                    % Alle Abschnitte durchlaufen
                    for k=1:size(track_phi_this_mode,2)

                        % Eigenvektor dieses Abschnitts holen
                        phi = track_phi_this_mode(:, k);

                        % Wenn diese Eigenform mit NaN befüllt ist, dann
                        % wurde diese Mode in diesem Abschnitt nicht
                        % erkannt
                        if all(isnan(phi))

                            % Datei erstellen
                            file_name = strcat(path, '\Eigenvektor_', string(freq_selected(j)), '_Hz_Abschnitt_', string(k), '_', oma_selected, '.txt');
                            fid = fopen(file_name, 'w+');
                            fprintf(fid, 'Diese Mode wurde in diesem Abschnitt nicht erkannt!');
                            fclose all;
                            continue;
                        end
                
                        % Skalieren der Eigenvektoren auf die Maximalamplitude von 1
                        maximalwert = max(abs(phi));
                        skalier = 1/maximalwert;
                        phi = phi*skalier;
                        phi = reshape(phi, num_direct_measure, []).';
        
                        % Datei erstellen
                        file_name = strcat(path, '\Eigenvektor_', string(freq_selected(j)), '_Hz_Abschnitt_', string(k), '_', oma_selected, '.txt');
                        fid = fopen(file_name, 'w+');
                        fprintf(fid, 'x-Koor      y-Koor      z-Koor\n');
                        fprintf(fid, '%7.4f %10.4f %10.4f\n', phi');
                        fclose all;
                    end
                end
            end
        end

        % Status aktualisieren
        update_status(status, lamp, '>> Daten exportiert', ...
        'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end