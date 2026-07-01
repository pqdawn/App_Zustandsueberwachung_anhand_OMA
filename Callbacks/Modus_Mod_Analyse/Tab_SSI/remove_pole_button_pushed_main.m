%% Callback für Button zum Entfernen der Pole
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function remove_pole_button_pushed_main(app)
    
    % Nötige Variablen holen
    ssi_choice = app.ssi_dropdown.Value;            % Wahl für Art der SSI

    % Wenn SSI-COV gewählt wurde
    if strcmp(ssi_choice, 'SSI-COV')
        remove_pole_button_pushed_cov(app);

    % Wenn SSI-DATA gewählt wurde
    elseif strcmp(ssi_choice, 'SSI-DATA')
        remove_pole_button_pushed_data(app);
    end
end