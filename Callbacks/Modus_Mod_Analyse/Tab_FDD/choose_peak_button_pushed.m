%% Callback für Auswählen der Peaks
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function choose_peak_button_pushed(app, fig)
    
    % Nötige Variablen holen
    src = app.choose_peak_button;                               % Button dieser Funktion
    psd_graph = app.psd_graph;                                  % Graph für 1. Singulärwerte der PSD in [dB]
    psd_graph2 = app.psd_graph2;                                % Graph für 1. Singulärwerte der PSD in [/]
    graph_type_db = app.graph_type_db.Value;                    % Wahl für Graph in [dB]
    graph_type_linear = app.graph_type_linear.Value;            % Wahl für Graph in [/]
    freq_table = app.freq_table2;                               % Tabelle für Frequenzen
    oma_dropdown = app.oma_dropdown;                            % Dropdown für OMA-Methoden
    freq_damp_table = app.freq_damp_table;                      % Tabelle für Ergebnisse
    eigenform_graph = app.eigenform_graph;                      % Graph für Eigenform
    update_eigenform_button = app.update_eigenform_button;      % Button für Darstellen der Eigenform
    oma_fdd_check2 = app.oma_fdd_check2;                        % Wahl für FDD (Sub-Tab "Mod. Parameter", Tab "Export")
    freq_damp_table2 = app.freq_damp_table2;                    % Tabelle für Ergebnisse (Sub-Tab "Mod. Parameter", Tab "Export")
    oma_fdd_check3 = app.oma_fdd_check3;                        % Wahl für FDD (Sub-Tab "Eigenform", Tab "Export")
    freq_damp_table3 = app.freq_damp_table3;                    % Tabelle für Ergebnisse (Sub-Tab "Eigenform", Tab "Export")
    lamp = app.status_lamp;                                     % Licht des Status
    status = app.status_text_area;                              % Textfeld des Status

    try
        % Fehlermeldung falls keine Daten importiert
        if isnan(app.fig.UserData.cache.modal.data_matrix)
            error('Keine Messdaten importiert!');
        end

        % Fehlermeldung falls FDD nicht durchgeführt
        if isempty(app.fig.UserData.cache.modal.fdd_result)
            error('FDD nicht durchgeführt!');
        end

        % Fehlermeldung falls Animation noch läuft
        if update_eigenform_button.UserData.is_animating == true
            error('Animation erstmal stoppen!');
        end

        % Wenn Peaks schon gewählt wurden, den Benutzer warnen
        if ~isempty(app.fig.UserData.cache.modal.selected_peak)

            % Warnung
            update_status(status, lamp, '>> Wartet auf Bestätigung...', 'warnung');
            choice = uiconfirm(fig, ['Peaks bereits gewählt. Wollen Sie die ' ...
                'gewählten Peaks beibehalten?'],'Warnung', ...
                'Icon', 'warning', 'Options',["Ja", "Nein"], 'DefaultOption', 1);
            
            % Wahl von Benutzer
            switch choice

                % Wenn "nein", alle gewählten Peaks löschen
                case 'Nein'
            
                    % Variable von gewählten Peaks löschen
                    app.fig.UserData.cache.modal.selected_peak = struct([]);

                    % Tabelle zurücksetzen
                    freq_table.Data = [];
                    freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};                 

                    % Graphen der 1. Singulärwerte der PSD aktualisieren
                    plot_eigenvalue_psd_db(psd_graph, app.fig.UserData.cache.modal.fdd_result, []);
                    plot_eigenvalue_psd_lin(psd_graph2, app.fig.UserData.cache.modal.fdd_result, []); 

                    % Status aktualisieren
                    update_status(status, lamp, ['>> Alle gewählten Peaks ' ...
                        'gelöscht'], 'erfolg');
                    pause(1);
                
                % Wenn "ja", die gewählten Pole beibehalten und weiter
                case 'Ja'

                    % Status aktualisieren
                    update_status(status, lamp, '>> Gewählte Peaks beibehalten', 'erfolg');
            end            
        end
        
        % Wenn Graph in [dB] gewählt wurde
        if graph_type_db

            % Graph in [dB] auswählen
            ax = psd_graph;

            % Daten der y-Achse holen
            y_data = mag2db(app.fig.UserData.cache.modal.fdd_result.S);

            % Den anderen Graph grau färben
            psd_graph2.Color = [0.8, 0.8, 0.8];

        % Wenn Graph in [/] gewählt wurde
        elseif graph_type_linear

            % Graph in [/] auswählen
            ax = psd_graph2;

            % Daten der y-Achse holen
            y_data = app.fig.UserData.cache.modal.fdd_result.S;

            % Den anderen Graph grau färben
            psd_graph.Color = [0.8, 0.8, 0.8];
        end

        % Daten der x-Achse holen
        x_data = app.fig.UserData.cache.modal.fdd_result.F;
        
        % Diesen Button deaktivieren
        src.Enable = 'off';

        % Status aktualisieren
        update_status(status, lamp, '----------------------------------------------------------', 'warnung');
        update_status(status, lamp, 'ersten Klick auf das Diagramm!)', 'warnung');
        update_status(status, lamp, 'ESC: Beenden (erst möglich nach dem', 'warnung');
        update_status(status, lamp, '(erst möglich nach dem ersten Klick auf das Diagramm!)', 'warnung');
        update_status(status, lamp, 'RÜCKTASTE: Letzte Auswahl rückgängig', 'warnung');
        update_status(status, lamp, 'KLICK UND ZIEHEN : Peak auswählen', 'warnung');
        update_status(status, lamp, '----------------------------------------------------------', 'warnung');
        update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');

        % Flagge instanziieren
        src.UserData.is_selecting = true;

        % Rücktaste aktivieren
        fig.KeyPressFcn = @(src,event) undo_key_pressed(app, event, ax, x_data, y_data); 

        % Rechteck zeichnen
        draw_rectangle(app, ax, x_data, y_data);

        % Rücktaste deaktivieren
        fig.KeyPressFcn = '';    

        % Diesen Button wieder aktivieren
        src.Enable = 'on';        

        % Farben der Graphen zurücksetzen
        psd_graph.Color = [1, 1, 1];
        psd_graph2.Color = [1, 1, 1];

        % Gewählte Zeile der Tabelle zurücksetzen
        freq_table.Selection = [];
        freq_table.UserData.row_selected = NaN;            

        % Vorgang hier beenden, falls gar keine Pole gewählt werden
        if isempty(app.fig.UserData.cache.modal.selected_peak)

            % Tabelle für Frequenzen zurücksetzen
            freq_table.Data = [];
            freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};

            % Ergebnisse in restlichen GUI-Komponenten aktualisieren
            update_result(eigenform_graph, [], [], oma_dropdown, ...
                "FDD", freq_damp_table, freq_damp_table2, freq_damp_table3);               

            % Status aktualisieren
            update_status(status, lamp, '>> Vorgang beendet ohne Auswahl', ...
                'erfolg');

            % Vorgang sofort beenden
            return;
        end

        % Ergebnisse holen
        eigenfreq_chosen = [app.fig.UserData.cache.modal.selected_peak.freq]';

        % Ergebnisse in restlichen GUI-Komponenten aktualisieren
        update_result(eigenform_graph, eigenfreq_chosen, [], oma_dropdown, ...
            "FDD", freq_damp_table, freq_damp_table2, freq_damp_table3, oma_fdd_check2, oma_fdd_check3);

        % Status aktualisieren
        update_status(status, lamp, '>> Vorgang beendet und Ergebnisse aktualisiert', ...
            'erfolg');        

    % Fehler fangen
    catch ME

        % Diesen Button aktivieren
        src.Enable = 'on'; 

        % Status aktualisieren
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end
end

%% Funktion zum Zeichnen des Rechtecks

% Übergabeparameter:    app = gesamte App
%                       ax = Graph
%                       x_data = Daten der x-Achse
%                       y_data = Daten der y-Achse

% Ausgabeparameter:     -

function draw_rectangle(app, ax, x_data, y_data)

    % Diesen Button holen
    src = app.choose_peak_button;

    % Auf Rechteck vom Benutzer warten
    roi = drawrectangle(ax, 'FaceAlpha',0.1,'Color','r');   
    if ~src.UserData.is_selecting
        return;
    end

    % Rechteck weiterbearbeiten
    process_rectangle(app, roi, ax, x_data, y_data);
end

%% Funktion zur Nacharbeitung des Rechtecks

% Übergabeparameter:    app = gesamte App
%                       roi = Rechteck, das vom Benutzer gezeichnet wurde
%                       ax = Graph
%                       x_data = Daten der x-Achse
%                       y_data = Daten der y-Achse

% Ausgabeparameter:     -

function process_rectangle(app, roi, ax, x_data, y_data)

    % Weitere Variablen holen
    src = app.choose_peak_button;                               % Button dieser Funktion
    psd_graph = app.psd_graph;                                  % Graph für 1. Singulärwerte der PSD in [dB]
    psd_graph2 = app.psd_graph2;                                % Graph für 1. Singulärwerte der PSD in [/]    
    freq_table = app.freq_table2;                               % Tabelle für Frequenzen
    lamp = app.status_lamp;                                     % Licht des Status
    status = app.status_text_area;                              % Textfeld des Status

    % Position des Rechecks
    pos = roi.Position;

    % Wenn Position leer ist, dann wurde die ESC-Taste betätigt aber sie wurde nicht
    % von Funktion "undo_key_pressed" befasst
    if isempty(pos)

        % Vorgang beenden
        src.UserData.is_selecting = false;   
        return;
    end

    % Positionen der Punkte innerhalb der Auswahl holen
    is_in_box = x_data >= pos(1) & x_data <= pos(1)+pos(3) & ...
        y_data >= pos(2) & y_data <= pos(2)+pos(4);
    idx_in_box = find(is_in_box);

    % Punkte innerhalb der Auswahl holen
    x_in_box = x_data(is_in_box);
    y_in_box = y_data(is_in_box);

    % Wenn kein Peak gefunden wurde, leere Matrizen zurückgeben
    if isempty(x_in_box)

        % Status aktualisieren
        update_status(status, lamp, '>> Kein Peak gefunden!', 'fehler');
        pause(1);
        update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');

        % Rechteck löschen
        delete(roi);

        % Auf nächstes Rechteck warten
        draw_rectangle(app, ax, x_data, y_data);    
        return;
    end

    % Maximum innerhalb des Rechtecks finden
    [~, idx_peak_in_box] = max(y_in_box);

    % Position des Peaks innerhalb der originalen Daten finden
    idx_peak = idx_in_box(idx_peak_in_box); 

    % Variable von gewählten Peaks holen
    selected_peak = app.fig.UserData.cache.modal.selected_peak;

    % Anzahl der bereits gewählten Moden holen
    peak_counter = length(selected_peak);      

    % Anzahl der Peaks aktualisieren
    peak_counter = peak_counter + 1;

    % Eigenfrequenz holen
    eigenfreq = x_data(idx_peak);

    % Eigenform extrahieren
    mode_shape = real(app.fig.UserData.cache.modal.fdd_result.U(:,idx_peak));

    % Normalisieren der Eigenform
    mode_shape = mode_shape./max(abs(mode_shape));

    % Variablen speichern
    selected_peak(peak_counter).freq = eigenfreq;
    selected_peak(peak_counter).mode_shape = mode_shape;   
    selected_peak(peak_counter).idx = idx_peak; 
    app.fig.UserData.cache.modal.selected_peak = selected_peak;            

    % Graphen der 1. Singulärwerte der PSD aktualisieren
    plot_eigenvalue_psd_db(psd_graph, app.fig.UserData.cache.modal.fdd_result, [selected_peak.idx]);
    plot_eigenvalue_psd_lin(psd_graph2, app.fig.UserData.cache.modal.fdd_result, [selected_peak.idx]);     

    % Tabelle aktualisieren
    title = {'Frequenz [Hz]'};
    freq_table.ColumnName = title;
    freq_table.Data = [selected_peak.freq]';

    % Status aktualisieren
    update_status(status, lamp, '>> Peak erfolgreich gewählt', 'erfolg');
    pause(0.5);
    update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');  

    % Auf nächstes Rechteck warten
    draw_rectangle(app, ax, x_data, y_data);    
end

%% Funktion zum rückgängig Machen

% Übergabeparameter:    app = gesamte App
%                       event = Ereignis
%                       ax = Graph
%                       x_data = Daten der x-Achse
%                       y_data = Daten der y-Achse

% Ausgabeparameter:     -

function undo_key_pressed(app, event, ax, x_data, y_data)

    % Weitere Variablen holen
    src = app.choose_peak_button;                                   % Button dieser Funktion
    psd_graph = app.psd_graph;                                      % Graph für 1. Singulärwerte der PSD in [dB]
    psd_graph2 = app.psd_graph2;                                    % Graph für 1. Singulärwerte der PSD in [/]    
    selected_peak = app.fig.UserData.cache.modal.selected_peak;     % Gewählte Peaks
    freq_table = app.freq_table2;                                   % Tabelle für Frequenzen 
    lamp = app.status_lamp;                                         % Licht des Status
    status = app.status_text_area;                                  % Textfeld des Status

    % Die letzte Auswahl löschen, wenn "Rücktaste" betätigt wird
    if strcmp(event.Key, 'backspace')

        % Falls noch keine gewählten Peaks vorhanden sind
        if isempty(selected_peak)
    
            % Status aktualisieren
            update_status(status, lamp, '>> Keine Auswahl zu löschen!', 'fehler');
            pause(1);
            update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');
            return;
        end
    
        % Letzten Peak in der Liste löschen
        selected_peak(end) = [];

        % Graphen der 1. Singulärwerte der PSD aktualisieren
        plot_eigenvalue_psd_db(psd_graph, app.fig.UserData.cache.modal.fdd_result, [selected_peak.idx]);
        plot_eigenvalue_psd_lin(psd_graph2, app.fig.UserData.cache.modal.fdd_result, [selected_peak.idx]);         
    
        % Tabelle aktualisieren
        freq_table.Data = [selected_peak.freq]';    
    
        % Variable speichern
        app.fig.UserData.cache.modal.selected_peak = selected_peak;
    
        % Status aktualisieren
        update_status(status, lamp, '>> Letzte Auswahl gelöscht', 'erfolg');
        pause(0.5);
        update_status(status, lamp, '>> Wartet auf Auswahl...', 'warnung');

        % Auf nächstes Rechteck warten
        draw_rectangle(app, ax, x_data, y_data);        

    % Vorgang beenden, wenn "ESC" betätigt wird
    elseif strcmp(event.Key, 'escape')
        src.UserData.is_selecting = false;     

    % Fehlermeldung falls andere Taste betätigt werden
    else

        % Status aktualisieren
        update_status(app.status_text_area, app.status_lamp, '>> Keine gültige Taste!', 'fehler');
        pause(1);
        update_status(app.status_text_area, app.status_lamp, '>> Wartet auf Auswahl...', 'warnung');
    end
end