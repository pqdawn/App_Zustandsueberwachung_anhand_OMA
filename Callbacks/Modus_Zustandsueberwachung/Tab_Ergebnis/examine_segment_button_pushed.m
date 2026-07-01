%% Callback für Button zur Untersuchung des Abschnitts
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function examine_segment_button_pushed(app)

    % Nötige Variablen holen
    sampling_freq = app.fig.UserData.cache.monitor.sampling_freq;           % Abtastfrequenz
    freq_limit = str2double(app.freq_limit_edit_field_monitor.Value);       % Frequenzgrenze   
    oma_dropdown = app.oma_dropdown2;                                       % Dropdown für OMA-Methoden
    step_table = app.step_table;                                            % Tabelle für Abschnitte
    freq_damp_table = app.freq_damp_table4;                                 % Tabelle für Ergebnisse des Abschnitts    
    examine_graph = app.examine_graph;                                      % Graph für Untersuchung
    lamp = app.status_lamp;                                                 % Licht des Status
    status = app.status_text_area;                                          % Textfeld des Status

    try
        % Fehlermeldung falls keine Messdaten importiert
        if isnan(app.fig.UserData.cache.monitor.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Fehlermeldung falls noch keine Ergebnisse
        if isempty(step_table.Data)
            error('Zustandsüberwachung nicht durchgeführt!')
        end

        % Gewählte Zeile holen
        row_selected = step_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(step_table.Data,1)
            error('Keine Zeile gewählt!');
        end

        % Graph für Untersuchung zurücksetzen
        cla(examine_graph);
        delete(examine_graph.Legend);

        % Wenn FDD oder EFDD gewählt wurde
        if strcmp(oma_dropdown.Value, 'FDD') || strcmp(oma_dropdown.Value, 'EFDD')

            % Ergebnisse der FDD holen
            fdd_result = app.fig.UserData.cache.monitor.fdd_result{row_selected};
            F = fdd_result.F;
            selected_peak = app.fig.UserData.cache.monitor.selected_peak{row_selected};
            if ~isempty(selected_peak)
                idx_peak = [selected_peak.idx];
            else
                idx_peak = [];
            end  

            % Plotten der 1. Singulärwerte der PSD
            plot_eigenvalue_psd_db(examine_graph, fdd_result, idx_peak);  

            % y-Achse bearbeiten
            y_min = min(mag2db(fdd_result.S));
            y_max = max(mag2db(fdd_result.S));
            y_dev = 0.05*abs(y_max-y_min);
            y_min = y_min - y_dev;                      
            y_max = y_max + y_dev;
            y_string = '1. Singul\"arwerte der PSD in [dB]';

            % Eigenfrequenzen holen
            eigenfreq = [selected_peak.freq];

            % Wenn EFDD gewählt wurde
            if strcmp(oma_dropdown.Value, 'EFDD')

                % Ergebnisse der EFDD holen
                efdd_result = app.fig.UserData.cache.monitor.efdd_result{row_selected};

                % SBF markieren
                hold(examine_graph, 'on');
                for k = 1:numel(efdd_result) 
                    SBF = efdd_result(k).SBF;
                    plot(examine_graph, F(SBF~=0), mag2db(SBF(SBF~=0)), 'red');
                end
                hold(examine_graph, 'off');

                % Eigenfrequenzen holen
                eigenfreq = [efdd_result.freq_d];                
            end

            % Achse bearbeiten
            if freq_limit <= sampling_freq/2
                examine_graph.XLim = [0, freq_limit];
            else
                examine_graph.XLim = [0, sampling_freq/2];
            end
            examine_graph.YLim = [y_min, y_max];
            examine_graph.Title.String = '\textbf{1. Singul\"arwerte der PSD}';
            examine_graph.XLabel.String = 'Frequenz in [Hz]';
            examine_graph.YLabel.String = y_string;
    
            % Wenn keine Mode in diesem Abschnitt gefunden wurde
            if isempty(idx_peak)
    
                % Tabelle für Ergebnisse des Abschnitts aktualisieren
                freq_damp_table.Data = [];
                freq_damp_table.ColumnName = {'Keine Peak in diesem Abschnitt gefunden!'};
    
            % Wenn Moden gefunden wurden
            else
        
                % Tabelle für Ergebnisse des Abschnitts aktualisieren
                freq_damp_table.Data = eigenfreq';
                freq_damp_col_title = {'Frequenz [Hz]'};
                freq_damp_table.ColumnName = freq_damp_col_title;
                freq_damp_table.ColumnWidth = repmat({'1x'}, 1, 1);
            end
    
            % Status aktualisieren   
            message_num_peak = sprintf('Anzahl der identifizierten Peaks: %d\n', (length(idx_peak)));
            update_status(status, lamp, '----------------------------------------------------------', 'erfolg');
            update_status(status, lamp, message_num_peak, 'erfolg');
            update_status(status, lamp, '----------------------------------------------------------', 'erfolg');           
            update_status(status, lamp, '>> Ergebnisse und Eigenwerte der PSD aktualisiert', 'erfolg');            

        % Wenn SSI-COV oder SSI-DATA gewählt wurde
        elseif strcmp(oma_dropdown.Value, 'SSI-COV') || strcmp(oma_dropdown.Value, 'SSI-DATA')

            % Wenn SSI-COV gewählt wurde
            if strcmp(oma_dropdown.Value, 'SSI-COV')

                % Ergebnisse holen
                all_pole = app.fig.UserData.cache.monitor.cov_all_pole{row_selected};
                selected_pole = app.fig.UserData.cache.monitor.cov_selected_pole{row_selected};
                unselected_counter = app.fig.UserData.cache.monitor.cov_unselected_counter(row_selected);

            % Wenn SSI-DATA gewählt wurde
            elseif strcmp(oma_dropdown.Value, 'SSI-DATA')

                % Ergebnisse holen
                all_pole = app.fig.UserData.cache.monitor.data_all_pole{row_selected};
                selected_pole = app.fig.UserData.cache.monitor.data_selected_pole{row_selected};
                unselected_counter = app.fig.UserData.cache.monitor.data_unselected_counter(row_selected);
            end
    
            % Stabilisationsdiagramm aktualisieren
            plot_stab_diag(examine_graph, all_pole, 1, 1, 1, 1, 'An', 1, 0, oma_dropdown.Value, 1); 
            examine_graph.XLabel.String = 'Frequenz in [Hz]';
            examine_graph.YLabel.String = 'Model-Order $n$';
            examine_graph.XLim = [0, freq_limit];         
    
            % Wenn keine Mode in diesem Abschnitt gefunden wurde
            if isempty(selected_pole)
    
                % Tabelle für Ergebnisse des Abschnitts aktualisieren
                freq_damp_table.Data = [];
                freq_damp_table.ColumnName = {'Keine Mode in diesem Abschnitt gefunden!'};
        
                % Anzahl der Cluster auf Null setzen
                num_selected_pole = 0;
                num_unselected = 0;
    
            % Wenn Moden gefunden wurden
            else
    
                % Eigenfrequenzen holen
                eigenfreq = [selected_pole.freq_mean];
        
                % Zugehörige Dämpfungsgrade holen
                damping = [selected_pole.damp_mean];
        
                % Tabelle für Ergebnisse des Abschnitts aktualisieren
                freq_damp_table.Data = [eigenfreq', damping'.*100];
                freq_damp_col_title = {'Frequenz [Hz]', 'Dämpfungsgrad [%]'};
                freq_damp_table.ColumnName = freq_damp_col_title;
                freq_damp_table.ColumnWidth = repmat({'1x'}, 1, 2);
        
                % Anzahl der Cluster holen
                num_selected_pole = numel(selected_pole);
                num_unselected = unselected_counter;
            end
    
            % Status aktualisieren
            message_num_end = sprintf('Anzahl der endgültigen Cluster: %d\n', num_selected_pole);
            message_num_rej = sprintf('Anzahl der abgelehnten Cluster: %d\n', num_unselected);
            message_num_clus = sprintf('Anzahl der identifizierten Cluster: %d\n', (num_selected_pole+num_unselected));
            message_cluster = 'Ergebnisse der Cluster-Analyse: ';
            update_status(status, lamp, '----------------------------------------------------------', 'erfolg');
            update_status(status, lamp, message_num_end, 'erfolg');
            update_status(status, lamp, message_num_rej, 'erfolg');
            update_status(status, lamp, message_num_clus, 'erfolg');
            update_status(status, lamp, message_cluster, 'erfolg');
            update_status(status, lamp, '----------------------------------------------------------', 'erfolg');         
            update_status(status, lamp, '>> Ergebnisse und Stabilisationsdiagramm des Abschnitts aktualisiert', 'erfolg');
        end

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end