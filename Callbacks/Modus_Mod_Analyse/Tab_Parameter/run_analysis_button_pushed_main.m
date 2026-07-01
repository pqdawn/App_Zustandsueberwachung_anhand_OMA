%% Callback für Durchführen der Modalanalyse
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function run_analysis_button_pushed_main(fig, app, oma_list, ssi_list)
    
    % Nötige Variablen holen
    ssi_dropdown = app.ssi_dropdown;                                        % Dropdown für Art der SSI
    oma_dropdown = app.oma_dropdown;                                        % Dropdown für OMA-Methoden
    oma_fdd_check2 = app.oma_fdd_check2;                                    % Wahl für FDD (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_efdd_check2 = app.oma_efdd_check2;                                  % Wahl für EFDD (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_ssi_cov_check2 = app.oma_ssi_cov_check2;                            % Wahl für SSI-COV (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_ssi_data_check2 = app.oma_ssi_data_check2;                          % Wahl für SSI-DATA (Sub-Tab "Mod. Parameter", Tab "Export") 
    oma_fdd_check3 = app.oma_fdd_check3;                                    % Wahl für FDD (Sub-Tab "Eigenform", Tab "Export")
    oma_efdd_check3 = app.oma_efdd_check3;                                  % Wahl für EFDD (Sub-Tab "Eigenform", Tab "Export")
    oma_ssi_cov_check3 = app.oma_ssi_cov_check3;                            % Wahl für SSI-COV (Sub-Tab "Eigenform", Tab "Export")
    oma_ssi_data_check3 = app.oma_ssi_data_check3;                          % Wahl für SSI-DATA (Sub-Tab "Eigenform", Tab "Export")
 
    % Dropdown für Art der SSI aktualisieren
    ssi_dropdown.Items = ssi_list;

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

    % Alle gewählten OMA-Methoden durchlaufen
    for k = 1:numel(oma_list)

        % Aktuelle OMA-Methode holen
        oma_current = oma_list{k};
        switch oma_current

            % Wenn FDD gewählt
            case 'FDD'
                
                % Dropdown für OMA-Methoden aktualisieren
                oma_dropdown.Value = 'FDD';            
    
                % Checkboxen beim Export aktivieren
                oma_fdd_check2.Enable = 'on';
                oma_fdd_check3.Enable = 'on';
                oma_fdd_check2.Value = 1;
                oma_fdd_check3.Value = 1;

                % FDD durchführen
                run_analysis_button_pushed_fdd(fig, app);                        
                pause(1);

            % Wenn SSI-COV gewählt
            case 'SSI-COV'  

                % Dropdown für Art der SSI aktualisieren
                ssi_dropdown.Value = 'SSI-COV'; 

                % Dropdown für OMA-Methoden aktualisieren
                oma_dropdown.Value = 'SSI-COV';          
    
                % Checkboxen beim Export aktivieren
                oma_ssi_cov_check2.Enable = 'on';
                oma_ssi_cov_check3.Enable = 'on';
                oma_ssi_cov_check2.Value = 1;
                oma_ssi_cov_check3.Value = 1;

                % SSI-COV durchfürhen
                run_analysis_button_pushed_ssi_cov(fig, app);                          
                pause(1);                         

            % Wenn SSI-DATA gewählt
            case 'SSI-DATA' 

                % Dropdown für Art der SSI aktualisieren
                ssi_dropdown.Value = 'SSI-DATA';                         

                % Dropdown für OMA-Methoden aktualisieren
                oma_dropdown.Value = 'SSI-DATA';               
    
                % Checkboxen beim Export aktivieren
                oma_ssi_data_check2.Enable = 'on';
                oma_ssi_data_check3.Enable = 'on';
                oma_ssi_data_check2.Value = 1;
                oma_ssi_data_check3.Value = 1;

                % SSI-DATA durchfürhen
                run_analysis_button_pushed_ssi_data(fig, app);                            
                pause(1);                         
        end
    end         
end