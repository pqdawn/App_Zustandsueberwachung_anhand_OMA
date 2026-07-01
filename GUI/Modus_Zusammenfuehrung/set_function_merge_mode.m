%% Funktionen für UI-Komponenten im Modus "Zusammenführung"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function set_function_merge_mode(app)

    % Button für Suchen des Ordners
    app.search_file_eigenfreq_button.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.eigenfreq_path_edit_field, ...              % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status     

    % Button für Importieren der Gruppen der Eigenfrequenzen
    app.import_eigenfreq_group_button.ButtonPushedFcn = @(~, ~) import_eigenfreq_group_button_pushed(app);

    % Auswahl einer Zeile aus der Tabelle für Gruppen der Eigenfrequenzen
    app.eigenfreq_group_table.SelectionChangedFcn = @(src, event) row_selected(src, event);  

    % Änderung der Tabelle für Gruppen der Eigenfrequenzen
    app.eigenfreq_group_table.DisplayDataChangedFcn = @(src, event) group_table_changed(src, event, ...
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status 

    % Button für Anzeigen der Eigenfrequenzen
    app.show_freq_button.ButtonPushedFcn = @(~, ~) show_freq_button_pushed(app); 

    % Button für Aktualisieren der Gruppen der Eigenfrequenzen
    app.update_eigenfreq_group_button.ButtonPushedFcn = @(~, ~) update_eigenfreq_group_button_pushed(app);

    % Änderung des Dropdowns für Gruppennummer
    app.group_number_dropdown.ValueChangedFcn = @(~, ~) group_number_dropdown_changed(app);            

    % Button für Suchen des Ordners
    app.search_file_eigenvector_button.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.eigenvector_path_edit_field, ...            % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status     

    % Button für Importieren der Gruppen der Eigenvektoren
    app.import_eigenvector_group_button.ButtonPushedFcn = @(~, ~) import_eigenvector_group_button_pushed(app); 

    % Auswahl einer Zeile aus der Tabelle für Gruppen der Eigenvektoren
    app.eigenvector_group_table.SelectionChangedFcn = @(src, event) row_selected(src, event); 

    % Änderung der Tabelle für Gruppen der Eigenvektoren
    app.eigenvector_group_table.DisplayDataChangedFcn = @(src, event) group_table_changed(src, event, ...
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status 

    % Button für Anzeigen des Eigenvektors
    app.show_vector_button.ButtonPushedFcn = @(~, ~) show_vector_button_pushed(app);

    % Button für Aktualisieren der Gruppen der Eigenvektoren
    app.update_eigenvector_group_button.ButtonPushedFcn = @(~, ~) update_eigenvector_group_button_pushed(app);       

    % Button für Importieren der Zuweisungen
    app.assign_import_button_merge.ButtonPushedFcn = @(~, ~) assign_import_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.assign_table_merge, ...                     % Tabelle für Zuweisungen
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Importieren der Knoten
    app.node_import_button_merge.ButtonPushedFcn = @(~, ~) node_import_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.node_table_merge, ...                       % Tabelle für Knoten
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Auswahl einer Zeile aus der Tabelle für Knoten
    app.node_table_merge.SelectionChangedFcn = @(src, event) row_selected(src, event);    

    % Button für Einfügen eines Knotens
    app.node_insert_button_merge.ButtonPushedFcn = @(~, ~) node_insert_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.node_table_merge, ...                       % Tabelle für Knoten
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Entfernen eines Knotens
    app.node_remove_button_merge.ButtonPushedFcn = @(~, ~) node_remove_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.node_table_merge, ...                       % Tabelle für Knoten
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status  

    % Button für Importieren der Linien
    app.line_import_button_merge.ButtonPushedFcn = @(~, ~) line_import_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.node_table_merge, ...                       % Tabelle für Knoten
        app.line_table_merge, ...                       % Tabelle für Linien
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Auswahl einer Zeile aus der Tabelle für Linien
    app.line_table_merge.SelectionChangedFcn = @(src, event) row_selected(src, event);  

    % Button für Einfügen einer Linie
    app.line_insert_button_merge.ButtonPushedFcn = @(~, ~) line_insert_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.node_table_merge, ...                       % Tabelle für Knoten
        app.line_table_merge, ...                       % Tabelle für Linien
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Entfernen einer Linie
    app.line_remove_button_merge.ButtonPushedFcn = @(~, ~) line_remove_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.line_table_merge, ...                       % Tabelle für Linien
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Importieren der Flächen
    app.surface_import_button_merge.ButtonPushedFcn = @(~, ~) surface_import_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.line_table_merge, ...                       % Tabelle für Linien
        app.surface_table_merge, ...                    % Tabelle für Flächen
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Auswahl einer Zeile aus der Tabelle für Flächen
    app.surface_table_merge.SelectionChangedFcn = @(src, event) row_selected(src, event);  

    % Button für Einfügen einer Fläche
    app.surface_insert_button_merge.ButtonPushedFcn = @(~, ~) surface_insert_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.line_table_merge, ...                       % Tabelle für Linien
        app.surface_table_merge, ...                    % Tabelle für Flächen
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Entfernen einer Fläche
    app.surface_remove_button_merge.ButtonPushedFcn = @(~, ~) surface_remove_button_pushed( ...
        app.fig.UserData.cache.merge, ...               % Cache-System
        app.surface_table_merge, ...                    % Tabelle für Flächen
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status

    % Button für Aktualisieren der Geometrie
    app.update_geometry_button_merge.ButtonPushedFcn = @(~, ~) update_geometry_button_pushed_merge(app);  

    % Auswahl einer Zeile aus der Tabelle für Ergebnisse
    app.freq_table_merge.SelectionChangedFcn = @(src, event) row_selected(src, event);

    % Button für Darstellen der Eigenform
    app.update_eigenform_button_merge.ButtonPushedFcn = @(src, ~) update_eigenform_button_pushed_merge(app, src, app.fig);    

    % Button für Stoppen der Animation
    app.stop_button_merge.ButtonPushedFcn = @(~, ~) stop_button_pushed( ...
        app.update_eigenform_button, ...                % Button für Darstellen der Eigenform (Modus "Modalanalyse")
        app.stop_button_merge, ...                      % Button für Stoppen
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area, ...                       % Textfeld des Status
        app.update_eigenform_button_merge);             % Button für Darstellen der Eigenform

    % Button für Suchen des Ordners
    app.search_file_geometry_button_merge.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.geometry_path_edit_field_merge, ...         % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status        

    % Button für Exportieren der Geometrie
    app.export_geometry_button_merge.ButtonPushedFcn = @(~, ~) export_geometry_button_pushed_merge(app);  

     % Button für Suchen des Ordners
    app.search_file_mod_parameter_button_merge.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.mod_parameter_path_edit_field_merge, ...    % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status     

    % Button für Exportieren der modalen Parameter
    app.export_mod_parameter_button_merge.ButtonPushedFcn = @(~, ~) export_mod_parameter_button_pushed_merge(app);    

     % Button für Suchen des Ordners
    app.search_file_eigenform_button_merge.ButtonPushedFcn = @(~, ~) search_file_button_pushed( ...
        app.eigenform_path_edit_field_merge, ...        % Eingabefeld für Ordnerpfad
        app.status_lamp, ...                            % Licht des Status
        app.status_text_area);                          % Textfeld des Status     

    % Button für Exportieren der Eigenform
    app.export_eigenform_button_merge.ButtonPushedFcn = @(~, ~) export_eigenform_button_pushed_merge(app);    
end