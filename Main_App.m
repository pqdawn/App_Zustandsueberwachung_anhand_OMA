%% Main-Funktion der App zur Zustandsüberwachung anhand OMA
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function Main_App

    % Alle Daten und Ausgaben an Konsole löschen
    clc;
    close all;

    % Latex als Interpreter für Darstellungen einstellen
    list_factory = fieldnames(get(groot,'factory'));
    index_interpreter = find(contains(list_factory,'Interpreter'));
    for i = 1:length(index_interpreter)
        default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
        set(groot, default_name,'latex');
    end

    % Pfad zu Funktionen und Callbacks setzen
    addpath(genpath(fileparts(mfilename('fullpath'))));

    % Gesamte Größe der Figur
    x_app = 1340;
    x_fig = 1300;
    y_app = 760;
    y_fig = 700;
    
    % Größen zwischen Rändern und Komponenten
    x_boundary = 20;
    y_boundary = 20;
    x_space = 10;
    y_space = 10;

    % Andere Größen
    x_large = 300;
    x_small = 100;
    y_fix = 20;

    % Größen speichern
    app.x_fig = x_fig;
    app.y_fig = y_fig;
    app.x_boundary = x_boundary;
    app.y_boundary = y_boundary;
    app.x_space = x_space;
    app.y_space = y_space;
    app.x_large = x_large;
    app.x_small = x_small;
    app.y_fix = y_fix;    

    % Figur für GUI 
    app.fig = uifigure('Name', 'App zur Zustandsüberwachung anhand OMA');
    app.fig.Position = [100 100 x_app y_app];

    % Label für Anweisungen
    app.title_label = uilabel(app.fig, 'Text', 'Die App wird in drei Modi unterteilt:');
    app.title_label.Position = [x_boundary y_app-y_boundary x_large y_fix];
    app.modal_label = uilabel(app.fig, 'Text', '1. Modalanalyse');
    app.modal_label.Position = [x_boundary y_app-y_boundary-y_fix 0.5*x_large y_fix];
    app.merge_label = uilabel(app.fig, 'Text', '2. Zusammenführung');
    app.merge_label.Position = [x_boundary y_app-y_boundary-2*y_fix 0.5*x_large y_fix];
    app.monitor_label = uilabel(app.fig, 'Text', '3. Zustandsüberwachung');
    app.monitor_label.Position = [x_boundary y_app-y_boundary-3*y_fix 0.5*x_large y_fix];
    app.title_label2 = uilabel(app.fig, 'Text', 'Die drei Modi können unabhängig voneinander');
    app.title_label2.Position = [x_boundary y_app-y_boundary-4*y_fix 260 y_fix]; 
    app.title_label3 = uilabel(app.fig, 'Text', 'verwendet werden.');
    app.title_label3.Position = [x_boundary y_app-y_boundary-5*y_fix 260 y_fix];      

    % Hilfe für Anweisungen
    app.modal_help = uilabel(app.fig, 'Text', '(?)');
    app.modal_help.Position = [x_boundary+0.5*x_large y_app-y_boundary-y_fix 0.2*x_small y_fix];
    app.modal_help.Tooltip = {['An den Messdaten werden die ausgewählten OMA-Methoden ' ...
        'durchgeführt. Dadurch lassen sich die modalen Parameter bestimmen.']};
    app.merge_help = uilabel(app.fig, 'Text', '(?)');
    app.merge_help.Position = [x_boundary+0.5*x_large y_app-y_boundary-2*y_fix 0.2*x_small y_fix];
    app.merge_help.Tooltip = {['Anhand der gewonnenen modalen Parameter verschiedener Gruppen desselben ' ...
        'Messobjekts können die Eigenformen der Struktur zusammengeführt werden. Dadurch lässt sich ' ...
        'eine vollständigere Darstellung der Eigenform erzielen.']}; 
    app.monitor_help = uilabel(app.fig, 'Text', '(?)');
    app.monitor_help.Position = [x_boundary+0.5*x_large y_app-y_boundary-3*y_fix 0.2*x_small y_fix];
    app.monitor_help.Tooltip = {['Die Messdaten werden in eine gewünschte Anzahl von Abschnitten ' ...
        'aufgeteilt. An jedem Abschnitt werden die ausgewählten OMA-Methoden durchgeführt. ' ...
        'Anschließend werden die Moden basierend auf Referenzmoden über die Abschnitte ' ...
        'verfolgt und in einem Frequenz-Zeit-Plot dargestellt.']};    
    
    % Label für Status
    y_status = 560;
    app.status_label = uilabel(app.fig, ...
        'Text', 'Status: ');
    app.status_label.Position = [x_boundary y_boundary+y_status+y_fix+y_space x_small y_fix];

    % Lampe für Status
    app.status_lamp = uilamp(app.fig);
    app.status_lamp.Position = [x_boundary+45 y_boundary+y_status+2+y_fix+y_space y_fix y_fix];

    % Textfeld für Status
    app.status_text_area = uitextarea(app.fig, ...
        'Value', {'>> System ist bereit';}, ...
        'Editable', 'off');
    app.status_text_area.Position = [x_boundary y_boundary+y_fix+y_space 260 y_status];

    % Button für Löschen
    app.delete_button = uibutton(app.fig, 'Text', 'Alle Daten löschen und App zurücksetzen');
    app.delete_button.Position = [x_boundary y_boundary 260 y_fix];    

    % Modi
    app.mode_group = uitabgroup(app.fig);
    app.mode_group.Position = [300 0 x_app-300 y_app];
    app.modal_mode = uitab(app.mode_group, 'Title', 'Modalanalyse');                      % Modus für Modalanalyse
    app.merge_mode = uitab(app.mode_group, 'Title', 'Zusammenführung');                   % Modus für Zusammenführung
    app.monitor_mode = uitab(app.mode_group, 'Title', 'Zustandsüberwachung');             % Modus für Zustandsüberwachung    

    % Tabs für Modalanalyse
    app.modal_tab_group = uitabgroup(app.modal_mode);
    app.modal_tab_group.Position = [x_boundary y_boundary x_app-300-2*x_boundary y_app-40-y_boundary];
    app.data_tab = uitab(app.modal_tab_group, 'Title', 'Messdaten');                      % Tab für Messdaten
    app.signal_tab = uitab(app.modal_tab_group, 'Title', 'Signalplot');                   % Tab für Signalplot
    app.geometry_tab = uitab(app.modal_tab_group, 'Title', 'Geometrie');                  % Tab für Geometrie
    app.parameter_tab = uitab(app.modal_tab_group, 'Title', 'Parameter');                 % Tab für Parameter
    app.fdd_tab = uitab(app.modal_tab_group, 'Title', 'FDD / EFDD');                      % Tab für FDD / EFDD
    app.ssi_tab = uitab(app.modal_tab_group, 'Title', 'SSI');                             % Tab für SSI
    app.result_tab = uitab(app.modal_tab_group, 'Title', 'Ergebnis');                     % Tab für Ergebnis
    app.export_tab = uitab(app.modal_tab_group, 'Title', 'Export');                       % Tab für Export
    app = create_data_tab(app);
    app = create_geometry_tab(app);
    app = create_signal_tab(app);
    app = create_parameter_tab(app);
    app = create_fdd_tab(app);
    app = create_ssi_tab(app);
    app = create_result_tab(app);
    app = create_export_tab(app);

    % Tabs für Zusammenführung
    app.merge_tab_group = uitabgroup(app.merge_mode);
    app.merge_tab_group.Position = [x_boundary y_boundary x_app-300-2*x_boundary y_app-40-y_boundary];
    app.eigenfreq_tab = uitab(app.merge_tab_group, 'Title', 'Eigenfrequenz');               % Tab für Eigenfrequenz
    app.eigenvector_tab = uitab(app.merge_tab_group, 'Title', 'Eigenvektor');               % Tab für Eigenvektor
    app.geometry_tab_merge_mode = uitab(app.merge_tab_group, 'Title', 'Geometrie');         % Tab für Geometrie
    app.result_tab_merge_mode = uitab(app.merge_tab_group, 'Title', 'Ergebnis');            % Tab für Ergebnis
    app.export_tab_merge_mode = uitab(app.merge_tab_group, 'Title', 'Export');              % Tab für Export
    app = create_eigenfreq_tab(app);
    app = create_eigenvector_tab(app);
    app = create_geometry_tab_merge_mode(app);
    app = create_result_tab_merge_mode(app);
    app = create_export_tab_merge_mode(app);

    % Tabs für Zustandsüberwachung
    app.monitor_tab_group = uitabgroup(app.monitor_mode);
    app.monitor_tab_group.Position = [x_boundary y_boundary x_app-300-2*x_boundary y_app-40-y_boundary];    
    app.data_tab_monitor_mode = uitab(app.monitor_tab_group, 'Title', 'Messdaten');         % Tab für Messdaten
    app.signal_tab_monitor_mode = uitab(app.monitor_tab_group, 'Title', 'Signalplot');      % Tab für Signalplot
    app.reference_tab = uitab(app.monitor_tab_group, 'Title', 'Referenzmoden');             % Tab für Referenzmoden
    app.parameter_tab_monitor_mode = uitab(app.monitor_tab_group, 'Title', 'Parameter');    % Tab für Parameter
    app.result_tab_monitor_mode = uitab(app.monitor_tab_group, 'Title', 'Ergebnis');        % Tab für Ergebnis
    app.export_tab_monitor_mode = uitab(app.monitor_tab_group, 'Title', 'Export');          % Tab für Export
    app = create_data_tab_monitor_mode(app);
    app = create_signal_tab_monitor_mode(app);
    app = create_reference_tab(app);
    app = create_parameter_tab_monitor_mode(app);
    app = create_result_tab_monitor_mode(app);
    app = create_export_tab_monitor_mode(app);

    % Cache-System initialisieren
    app = initiate_cache_system_modal_mode(app);
    app = initiate_cache_system_merge_mode(app);
    app = initiate_cache_system_monitor_mode(app);

    % Funktionen für UI-Komponenten definieren
    set_function_modal_mode(app);
    set_function_merge_mode(app);
    set_function_monitor_mode(app);  
end