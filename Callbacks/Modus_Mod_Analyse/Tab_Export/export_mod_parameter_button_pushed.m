%% Callback für Button zum Exportieren der modalen Parameter (Modus "Modalanalyse")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function export_mod_parameter_button_pushed(app)

    % Nötige Variablen holen
    result_fdd = app.fig.UserData.cache.modal.selected_peak;                % Ergebnisse der FDD
    result_efdd = app.fig.UserData.cache.modal.efdd_result;                 % Ergebnisse der EFDD
    result_ssi_cov = app.fig.UserData.cache.modal.cov_selected_pole;        % Ergebnisse der SSI-COV    
    result_ssi_data = app.fig.UserData.cache.modal.data_selected_pole;      % Ergebnisse der SSI-DATA
    freq_damp_table = app.freq_damp_table2.Data;                            % Tabelle für Ergebnisse
    path = app.mod_parameter_path_edit_field.Value;                         % Pfad zum Zielordner
    eigenfreq_tick = app.eigenfreq_check.Value;                             % Checkbox für Eigenfrequenz
    damp_tick = app.damp_check.Value;                                       % Checkbox für Dämpfungsgrad
    eigenvector_tick = app.eigenvector_check.Value;                         % Checkbox für Eigenvektor
    lamp = app.status_lamp;                                                 % Licht des Status
    status = app.status_text_area;                                          % Textfeld des Status

    try
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
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
            error('Keine Ergebnisse!')
        end

        % OMA-Methoden holen
        oma_matrix = table2array(freq_damp_table(:, 1));

        % Einzigartige OMA-Methoden holen
        oma_uniq = unique(oma_matrix, 'stable');        

        % Eigenfrequenzen holen
        freq_matrix = table2array(freq_damp_table(:, 2));

        % Zu exportierende Ergebnisse holen
        to_export =  table2array(freq_damp_table(:, 3));

        % Fehlermeldung falls gar kein Ergebnis gewählt
        if all(to_export == false)
            error('Kein Ergebnis gewählt!');
        end

        % Matrizen für Dämpfungsgrade und Eigenvektoren aller OMA-Methoden
        % instanziieren
        damping_ratio_all_oma = [];
        eigenvector_all_oma = [];

        % Dämpfungsgrade und Eigenvektoren verschiedener Methoden zusammenfügen
        for i = 1:length(oma_uniq)

            switch oma_uniq(i)
                case "FDD"
                    num_mode = numel(find(oma_matrix == oma_uniq(i)));
                    damping_ratio_all_oma = [damping_ratio_all_oma; NaN(num_mode,1)];
                    eigenvector_all_oma = [eigenvector_all_oma, [result_fdd.mode_shape]];

                case "EFDD"
                    damping_ratio_all_oma = [damping_ratio_all_oma; [result_efdd.damping_ratio]'];
                    eigenvector_all_oma = [eigenvector_all_oma, [result_efdd.mode_shape]];

                case "SSI-COV"
                    damping_ratio_all_oma = [damping_ratio_all_oma; ([result_ssi_cov.damp_mean]').*100];
                    eigenvector_all_oma = [eigenvector_all_oma, [result_ssi_cov.mode_shape_mean]];

                case "SSI-DATA"
                    damping_ratio_all_oma = [damping_ratio_all_oma; ([result_ssi_data.damp_mean]').*100];
                    eigenvector_all_oma = [eigenvector_all_oma, [result_ssi_data.mode_shape_mean]];                    
            end
        end    

        % Nur die gewählten OMA-Methoden, Eigenfrequenzen, Dämpfungsgrade und
        % Eigenvektoren weiter betrachten
        oma_matrix = oma_matrix(to_export, :);
        freq_matrix = freq_matrix(to_export, :);
        damping_ratio_all_oma = damping_ratio_all_oma(to_export, :);
        eigenvector_all_oma = eigenvector_all_oma(:, to_export);

        % Zu exportierende Methoden extrahieren
        oma_to_export = unique(oma_matrix);

        % Fehlermeldung falls gar keine Daten gewählt
        num_option = sum([eigenfreq_tick, damp_tick, eigenvector_tick]);
        if num_option == 0
            error('Keine Daten gewählt!');
        end

        % Alle zu exportierenden Methoden durchlaufen
        for i = 1:numel(oma_to_export)

            % Methode holen
            oma_selected = oma_to_export(i);

            % Ergebnisse für diese Methode holen
            mask = oma_matrix == oma_selected;
            freq_selected = freq_matrix(mask);
            damping_selected = damping_ratio_all_oma(mask);
            eigenvector_selected = eigenvector_all_oma(:, mask);

            % Eigenfrequenz gewählt
            if eigenfreq_tick
    
                % Eigenfrequenzen holen
                num_freq_list = [(1:size(freq_selected,1))', freq_selected];
        
                % Datei erstellen
                file_name = strcat(path, '\Eigenfrequenz_', oma_selected, '.txt');
                fid = fopen(file_name, 'w+');
                fprintf(fid, 'Nummer     Frequenz [Hz]\n');
                fprintf(fid, '%6.0f        %10.4f\n', num_freq_list');
                fclose all;
            end
    
            % Dämpfungsgrad gewählt
            if damp_tick
    
                % Wenn die aktualle OMA-Methode FDD ist, Warnung
                if strcmp(oma_selected, "FDD")

                    % Status aktualisieren
                    update_status(status, lamp, '>> FDD liefert keine Dämpfungsgrade!', 'warnung');
                    pause(1);                    
                
                % Für andere OMA-Methoden lassen sich Dämpfungsgrade
                % exportieren
                else

                    % Dämpfungsgrade holen
                    num_damp_list = [(1:size(damping_selected,1))', damping_selected];
            
                    % Datei erstellen
                    file_name = strcat(path, '\Daempfungsgrade_', oma_selected, '.txt');
                    fid = fopen(file_name, 'w+');
                    fprintf(fid, 'Nummer  Dämpfungsgrad [%%]\n');
                    fprintf(fid, '%6.0f        %12.4f\n', num_damp_list');
                    fclose all;  
                end
            end
    
            % Eigenvektor gewählt
            if eigenvector_tick

                % Richtungen der importierten Messdaten holen
                direction_saved = app.fig.UserData.cache.modal.direction;
                num_direct_measure = sum(direction_saved);
        
                % Anzahl der Sensoren holen
                num_sensor_measure = app.fig.UserData.cache.modal.num_sensor;                
    
                % Alle Eigenvektoren durchlaufen
                for j=1:size(eigenvector_selected, 2)
    
                    % Aktuellen Eigenvektor holen
                    phi = eigenvector_selected(:, j);
    
                    % Falls gemessene Richtungen weniger als 3, müssen die
                    % Eigenvektoren angepasst werden, damit die Daten alle 3
                    % Richtungen umfassen
                    if num_direct_measure ~= 3
                        phi = reshape_eigenform(phi, num_sensor_measure, direction_saved);
                    end
            
                    % Skalieren der Eigenvektoren auf die Maximalamplitude von 1
                    maximalwert = max(abs(phi));
                    skalier = 1/maximalwert;
                    phi = phi*skalier;
                    phi = reshape(phi, num_direct_measure, []).';
    
                    % Datei erstellen
                    file_name = strcat(path, '\Eigenvektor_', string(freq_selected(j)), '_Hz_', oma_selected, '.txt');
                    fid = fopen(file_name, 'w+');
                    fprintf(fid, 'x-Koor      y-Koor      z-Koor\n');
                    fprintf(fid, '%7.4f %10.4f %10.4f\n', phi');
                    fclose all;
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