%% Callback für Auswählen der Pole
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function choose_pole_button_pushed_main(app, fig)
    
    % Nötige Variablen holen
    ssi_choice = app.ssi_dropdown.Value;                    % Wahl für Art der SSI
    measurement_choice = app.measurement_dropdown.Value;    % Wahl für Messdaten

    % Wenn abgeleitete Messdaten gewählt wurden
    if measurement_choice == 2

        % Wenn SSI-COV gewählt wurde
        if strcmp(ssi_choice, 'SSI-COV')
            choose_pole_button_pushed_cov_diff(app, fig);

        % Wenn SSI-DATA gewählt wurde
        elseif strcmp(ssi_choice, 'SSI-DATA')
            choose_pole_button_pushed_data_diff(app, fig);
        end

    % Wenn originale Messdaten gewählt wurden
    else

        % Wenn SSI-COV gewählt wurde
        if strcmp(ssi_choice, 'SSI-COV')        
            choose_pole_button_pushed_cov_original(app, fig);

        % Wenn SSI-DATA gewählt wurde
        elseif strcmp(ssi_choice, 'SSI-DATA')  
            choose_pole_button_pushed_data_original(app, fig);
        end
    end
end