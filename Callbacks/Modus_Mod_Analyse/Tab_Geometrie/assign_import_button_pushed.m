%% Callback für Button zum Importieren der Zuweisungen (Modi "Modalanalyse" und "Zusammenführung")
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    cache = Cache-System
%                       assign_table = Tabelle für Zuweisungen
%                       lamp = Licht des Status
%                       status = Textfeld des Status

% Ausgabeparameter: -

function assign_import_button_pushed(cache, assign_table, lamp, status)

    try
        % Für Modus "Modalanalyse"
        if isfield(cache, 'data_matrix')

            % Fehlermeldung falls keine Messdaten importiert
            if isnan(cache.data_matrix)
                error('Keine Messdaten importiert!');
            end

        % Für Modus "Zusammenführung"
        elseif isfield(cache, 'eigenfreq')

            % Fehlermeldung falls keine Eigenfrequenzen importiert
            if isempty(cache.eigenfreq)
                error('Keine Eigenfrequenzen importiert!');
            end
    
            % Fehlermeldung falls Eigenvektoren nicht vollständig importiert
            if any(cellfun(@isempty, cache.eigenvector))
                error('Eigenvektoren nicht vollständig importiert!');
            end   
        end

        % Datei auswählen
        [filename,path] = uigetfile('*.txt');

        % Fehlermeldung falls keine Datei ausgewählt wurde
        if isequal(filename,0)
            error('Keine Datei ausgewählt');
        end

        % Dateipfad holen
        path = [path,filename];        
        
        % Daten einlesen
        assign_matrix_new = readmatrix(path, 'NumHeaderLines', 1);

        % Vorhandene Zuweisungen (nach Importieren) holen
        assign_matrix_old = assign_table.Data;
        
        % Fehlermeldung falls die Datei mit der Anzahl
        % der Sensoren nicht übereinstimmen
        if size(assign_matrix_old,1) ~= size(assign_matrix_new,1)
             error(['Größe der eingegebenen Datei stimmt nicht mit der ' ...
                'Anzahl der Sensoren überein!']);
        end

        % Für Modus "Modalanalyse"
        if isfield(cache, 'data_matrix')  

            % Fehlermeldung falls die Datei nicht genau 2 Spalten hat
            if size(assign_matrix_new,2) ~= 2
                 error('Die Datei hat nicht genau 2 Spalten!');
            end
    
            % Tabelle für Knoten aktualisieren
            assign_table.Data = [assign_matrix_old(:,1), assign_matrix_new(:,2)];

        % Für Modus "Zusammenführung"
        elseif isfield(cache, 'eigenfreq') 

            % Fehlermeldung falls die Datei nicht genau 3 Spalten hat
            if size(assign_matrix_new,2) ~= 3
                 error('Die Datei hat nicht genau 3 Spalten!');
            end
    
            % Tabelle für Knoten aktualisieren
            assign_table.Data = [assign_matrix_old(:,1:2), assign_matrix_new(:,3)];
        end

        % Status aktualisieren
        update_status(status, lamp, '>> Zuweisungen importiert', 'erfolg');

    % Fehler fangen
    catch ME
        update_status(status, lamp, ['>> Fehler: ', ME.message], 'fehler');
    end 
end