%% Callback für Button zum Anzeigen der zugehörigen Pole
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function show_corresp_pole_button_pushed(app)
    
    % Nötige Variablen holen
    graph = app.stab_graph;                                 % Graph für Stabilisationsdiagramm
    ssi_choice = app.ssi_dropdown.Value;                    % Wahl für Art der SSI
    measurement_choice = app.measurement_dropdown.Value;    % Wahl für Messdaten
    pole_chosen_tick = app.pole_chosen_switch.Value;        % Wahl des Filters für gewählte Pole
    freq_table = app.freq_table;                            % Tabelle für Frequenzen
    update_eigenform_button = app.update_eigenform_button;  % Button für Darstellen der Eigenform
    lamp = app.status_lamp;                                 % Licht des Status
    status = app.status_text_area;                          % Textfeld des Status

    try
        % Fehlermeldung falls keine Daten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Wenn orignale Messdaten gewählt
        if measurement_choice == 1

            % Wenn SSI-COV gewählt wurde
            if strcmp(ssi_choice, 'SSI-COV')
    
                % Fehlermeldung falls SSI-COV nicht durchgeführt
                if isempty(app.fig.UserData.cache.modal.cov_all_pole)
                    error('SSI-COV nicht durchgeführt!');
                end            

                % Pole holen
                all_pole = app.fig.UserData.cache.modal.cov_all_pole; 
                selected_pole = app.fig.UserData.cache.modal.cov_selected_pole;
    
            % Wenn SSI-DATA gewählt wurde
            elseif strcmp(ssi_choice, 'SSI-DATA')
    
                % Fehlermeldung falls SSI-DATA nicht durchgeführt
                if isempty(app.fig.UserData.cache.modal.data_all_pole)
                    error('SSI-DATA nicht durchgeführt!');
                end 

                % Pole holen
                all_pole = app.fig.UserData.cache.modal.data_all_pole;
                selected_pole = app.fig.UserData.cache.modal.data_selected_pole;
            end

        % Wenn abgeleitete Messdaten gewählt
        elseif measurement_choice == 2

            % Wenn SSI-COV gewählt wurde
            if strcmp(ssi_choice, 'SSI-COV')
    
                % Fehlermeldung falls SSI-COV der abgeleitete Messdaten nicht durchgeführt
                if isempty(app.fig.UserData.cache.modal.cov_all_pole_diff)
                    error('SSI-COV der abgeleitete Messdaten nicht durchgeführt!');
                end            

                % Pole holen
                all_pole = app.fig.UserData.cache.modal.cov_all_pole_diff;    
                selected_pole = app.fig.UserData.cache.modal.cov_selected_pole_diff;
    
            % Wenn SSI-DATA gewählt wurde
            elseif strcmp(ssi_choice, 'SSI-DATA')
    
                % Fehlermeldung falls SSI-DATA der abgeleitete Messdaten nicht durchgeführt
                if isempty(app.fig.UserData.cache.modal.data_all_pole_diff)
                    error('SSI-DATA der abgeleitete Messdaten nicht durchgeführt!');
                end 

                % Pole holen
                all_pole = app.fig.UserData.cache.modal.data_all_pole_diff;  
                selected_pole = app.fig.UserData.cache.modal.data_selected_pole_diff;
            end
        end

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
        end

        % Fehlermeldung falls Checkbox für gewählte Pole nicht an
        if strcmp(pole_chosen_tick, 'Aus')
            error('Gewählte Pole werden nicht dargestellt! Filter dafür erstmal aktivieren!')
        end

        % Fehlermeldung falls keine Pole gewählt wurden
        if isempty(selected_pole)
            error('Pole noch nicht gewählt!');
        end

        % Frequenzen der gewählten Pole holen
        freq_matrix = freq_table.Data;

        % Gewählte Zeile holen
        row_selected = freq_table.UserData.row_selected;

        % Fehlermeldung falls keine Zeile gewählt wurde
        if any(isnan(row_selected), 'all') || isempty(row_selected)
            error('Keine Zeile gewählt!');
        end

        % Fehlermeldung falls die gewählte Zeile "out of range"
        if row_selected > size(freq_matrix, 1)
            error('Keine Zeile gewählt!');
        end

        % Positionen der Pole für die gewählte Zeile holen
        idx_tol = [selected_pole(row_selected(1,1)).pole_idx];
        
        % Gewählte Pole holen
        corresp_pole = zeros([length(idx_tol),2]);
        for i = 1:length(idx_tol)
            corresp_pole(i,1) = all_pole(idx_tol(i)).model_order;
            corresp_pole(i,2) = all_pole(idx_tol(i)).eigenfreq;
        end

        % Pole auf dem Graph markieren
        highlight_selected_pole(graph, corresp_pole);

        % Status aktualisieren
        update_status(status, lamp, '>> Zugehörige Pole angezeigt', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end