%% Callback für Durchführen der Zustandsüberwachung
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function run_monitor_button_pushed_main(fig, app, oma_list)
    
    % Nötige Variablen holen
    num_segment = str2double(app.num_segment_edit_field.Value);               % Anzahl der Abschnitte
    num_ignore = str2double(app.num_ignore_row_edit_field.Value);             % Anzahl der ignorierten Zeilen
    oma_dropdown = app.oma_dropdown2;                                         % Dropdown für OMA-Methoden
    oma_fdd_check2 = app.oma_fdd_check2_monitor;                              % Wahl für FDD (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_efdd_check2 = app.oma_efdd_check2_monitor;                            % Wahl für EFDD (Sub-Tab Mod. Parameter, Tab Export,)
    oma_ssi_cov_check2 = app.oma_ssi_cov_check2_monitor;                      % Wahl für SSI-COV (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_ssi_data_check2 = app.oma_ssi_data_check2_monitor;                    % Wahl für SSI-DATA (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_fdd_check3 = app.oma_fdd_check3_monitor;                              % Wahl für FDD (Sub-Tab "Freq.-Zeit-Plot", Tab "Export")
    oma_efdd_check3 = app.oma_efdd_check3_monitor;                            % Wahl für EFDD (Sub-Tab "Freq.-Zeit-Plot", Tab "Export")
    oma_ssi_cov_check3 = app.oma_ssi_cov_check3_monitor;                      % Wahl für SSI-COV (Sub-Tab "Freq.-Zeit-Plot", Tab "Export")
    oma_ssi_data_check3 = app.oma_ssi_data_check3_monitor;                    % Wahl für SSI-DATA (Sub-Tab "Freq.-Zeit-Plot", Tab "Export")
    lamp = app.status_lamp;                                                   % Licht des Status
    status = app.status_text_area;                                            % Textfeld des Status

    % Dropdown für OMA-Methoden aktualisieren
    oma_dropdown.Items = oma_list;                  

    % Alle Checkboxen für OMA-Methoden beim Export erstmal deaktivieren
    oma_fdd_check2.Enable = 'off';
    oma_efdd_check2.Enable = 'off';
    oma_ssi_cov_check2.Enable = 'off';
    oma_ssi_data_check2.Enable = 'off';
    oma_fdd_check3.Enable = 'off';
    oma_efdd_check3.Enable = 'off';
    oma_ssi_cov_check3.Enable = 'off';
    oma_ssi_data_check3.Enable = 'off';
    oma_fdd_check2.Value = 0;
    oma_efdd_check2.Value = 0;
    oma_ssi_cov_check2.Value = 0;
    oma_ssi_data_check2.Value = 0;
    oma_fdd_check3.Value = 0;
    oma_efdd_check3.Value = 0;
    oma_ssi_cov_check3.Value = 0;
    oma_ssi_data_check3.Value = 0; 

    % Wenn aktuelle Anzahl der Abschnitte mit der vorherigen übereinstimmt
    if app.fig.UserData.cache.monitor.used_parameter.num_segment ...
        == app.fig.UserData.cache.monitor.current_parameter.num_segment

        % Vorherige Abschnitte holen
        segment_info = app.fig.UserData.cache.monitor.segment_info;

    % Sonst
    else

        % Messdaten holen
        data_matrix = app.fig.UserData.cache.monitor.data_matrix;        

        % Wenn Zeilen ignoriert werden sollten
        if num_ignore ~= 0

            % Zu ignorierende Zeilen entfernen
            edges = linspace(0, data_matrix(end-num_ignore+1,1), num_segment+1);
        
        % Sonst
        else
            
            % Direkt aufteilen und letzten Abschnitt um einen Zeitschritt 
            % erweitern, damit er später bei Aufteilung berücksichtigt wird
            edges = linspace(0, data_matrix(end,1), num_segment+1);
            edges(end) = edges(end)+data_matrix(2,1);
        end
    
        % Info für jeden Abschnitt instanziieren
        segment_info = struct([]);
    
        % Messdaten aufteilen und Info speichern
        for k = 1:length(edges)-1
            idx = data_matrix(:,1) >= edges(k) & data_matrix(:,1) < edges(k+1);
            segment_info(k).data = data_matrix(idx,:);
            segment_info(k).first_time_step = data_matrix(find(idx,1,'first'),1);
            segment_info(k).num_step = sum(idx);
            segment_info(k).last_time_step = data_matrix(find(idx,1,'last'),1);
        end
    end

    % Parameter und Abschnitte speichern
    app.fig.UserData.cache.monitor.used_parameter.num_segment = app.fig.UserData.cache.monitor.current_parameter.num_segment;
    app.fig.UserData.cache.monitor.segment_info = segment_info;

    % Alle gewählten OMA-Methoden durchlaufen
    for k = 1:numel(oma_list)

        % Aktuelle OMA-Methode holen
        oma_current = oma_list{k};
        switch oma_current

            % Wenn FDD gewählt
            case 'FDD'

                % FDD durchführen
                run_monitor_button_pushed_fdd(fig, app, segment_info);                        
                pause(1);

            % Wenn SSI-COV gewählt
            case 'SSI-COV'

                % SSI-COV durchfürhen
                run_monitor_button_pushed_ssi_cov(fig, app, segment_info);                          
                pause(1);                         

            % Wenn SSI-DATA gewählt
            case 'SSI-DATA'                       

                % SSI-DATA durchfürhen
                run_monitor_button_pushed_ssi_data(fig, app, segment_info);                            
                pause(1);                         
        end

        % Status aktualisieren
        update_status(status, lamp, ['>> ', oma_current, ' für Zustandsüberwachung durchgeführt'], 'erfolg');
        pause(1);           
    end        

    % Nachricht für Status
    message = '>> Ergebnisse für Zustandsüberwachung aktualisiert';

    % Status aktualisieren
    update_status(status, lamp, message, 'erfolg');
end