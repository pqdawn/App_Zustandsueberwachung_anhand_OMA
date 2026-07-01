%% Callback für Button zur Übertragung der Auswahlen
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function transfer_choice_button_pushed_main(app, fig)
    
    % Nötige Variablen holen
    ssi_choice = app.ssi_dropdown.Value;           % Wahl für Art der SSI

    % Wenn SSI-COV gewählt wurde
    if strcmp(ssi_choice, 'SSI-COV')
        transfer_choice_button_pushed_cov(app, fig);

    % Wenn SSI-DATA gewählt wurde
    elseif strcmp(ssi_choice, 'SSI-DATA')
        transfer_choice_button_pushed_data(app, fig);
    end
end