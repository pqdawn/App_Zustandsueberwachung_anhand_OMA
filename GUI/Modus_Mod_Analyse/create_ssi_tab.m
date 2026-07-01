%% Tab "SSI" im Modus "Modalanalyse"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_ssi_tab(app)

    % Größen holen
    y_fig = app.y_fig;
    x_boundary = app.x_boundary;
    y_boundary = app.y_boundary;
    x_space = app.x_space;
    y_space = app.y_space;
    x_small = app.x_small;
    y_fix = app.y_fix;

    % Alle Komponenten in diesem Tab löschen
    delete(app.ssi_tab.Children);

    % Checkboxen für Filter
    app.all_poles_check = uicheckbox(app.ssi_tab, 'Text', 'Alle Pole', 'Value', 1);
    app.all_poles_check.Position = [x_boundary+0.4*x_small y_fig-60 0.8*x_small y_fix];
    app.stable_freq_check = uicheckbox(app.ssi_tab, 'Text', 'Stabile Frequenzen', 'Value', 1);
    app.stable_freq_check.Position = [x_boundary+0.4*x_small+0.8*x_small y_fig-60 1.4*x_small y_fix];
    app.stable_damp_check = uicheckbox(app.ssi_tab, 'Text', 'Stabile Dämpfungsgrade', 'Value', 1);
    app.stable_damp_check.Position = [x_boundary+0.4*x_small+2.2*x_small y_fig-60 1.7*x_small y_fix];
    app.mac_check = uicheckbox(app.ssi_tab, 'Text', 'MAC-Bedingung erfüllt', 'Value', 1);
    app.mac_check.Position = [x_boundary+0.4*x_small+3.9*x_small y_fig-60 1.6*x_small y_fix];
    
    % Radiobutton-Gruppe für Filter
    app.filter_radio_group = uibuttongroup(app.ssi_tab);
    app.filter_radio_group.Position = [x_boundary+0.4*x_small+5.5*x_small y_fig-60 3.3*x_small+2*x_space y_fix];
    app.filter_radio_group.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für "oder"
    app.filter_or_radio = uiradiobutton(app.filter_radio_group, 'Text', 'oder');
    app.filter_or_radio.Position = [0 0 0.45*x_small y_fix];

    % Radiobutton für "und"
    app.filter_and_radio = uiradiobutton(app.filter_radio_group, 'Text', 'und');
    app.filter_and_radio.Position = [0.45*x_small+x_space 0 1.15*x_small y_fix];

    % Label für automatische Peakauswahl
    app.pole_chosen_label = uilabel(app.ssi_tab, 'Text', 'Gewählte Pole: ');
    app.pole_chosen_label.Position = [x_boundary+0.4*x_small y_fig-90 2.2*x_small y_fix];

    % Switch für automatische Peakauswahl
    app.pole_chosen_switch = uiswitch(app.ssi_tab);
    app.pole_chosen_switch.Position = [x_boundary+1.7*x_small y_fig-90 app.auto_peak_switch.Position(3) app.auto_peak_switch.Position(4)];
    app.pole_chosen_switch.Items = {'Aus', 'An'};
    app.pole_chosen_switch.Value = 'An';

    % Graph für Stabilisationsdiagramm
    x_stab_graph = 730;
    app.stab_graph = uiaxes(app.ssi_tab);
    app.stab_graph.XGrid = 'on';
    app.stab_graph.YGrid = 'on';
    app.stab_graph.Position = [x_boundary y_boundary+2*y_fix+2*y_space x_stab_graph y_fig-60-3*y_space-y_boundary-3*y_fix];
    app.stab_graph.Title.String = '\textbf{Stabilisationsdiagramm}';
    app.stab_graph.XLabel.String = 'Frequenz in [Hz]';
    app.stab_graph.YLabel.String = 'Model-Order $n$';   

    % Slider für x-Achse des Stabilisationsdiagramms 
    app.stab_graph_slider = uislider(app.ssi_tab, 'range');
    app.stab_graph_slider.Position = [3*x_boundary y_boundary+2*y_fix+y_space x_stab_graph-2.25*x_boundary app.stab_graph_slider.Position(4)];
    app.stab_graph_slider.Limits = [min(app.stab_graph.XTick), max(app.stab_graph.XTick)];
    app.stab_graph_slider.Value = [min(app.stab_graph.XTick), max(app.stab_graph.XTick)];
    app.stab_graph_slider.MajorTicks = app.stab_graph.XTick;

    % Checkbox für fixierten Bereich der x-Achse
    app.stab_graph_range_check = uicheckbox(app.ssi_tab, 'Text', 'Bereich der x-Achse fixieren:', 'Value', 0);
    app.stab_graph_range_check.Position = [2.6*x_boundary y_boundary 180 y_fix];

    % Eingabefeld für fixierten Bereich der x-Achse
    app.stab_graph_range_edit_field = uieditfield(app.ssi_tab, 'Value', '1','Editable', 0);
    app.stab_graph_range_edit_field.BackgroundColor = [0.80,0.80,0.80];
    app.stab_graph_range_edit_field.Position = [2.6*x_boundary+180 y_boundary 0.5*x_small y_fix];

    % Variablen unter "stab_graph_range_edit_field" speichern
    app.stab_graph_range_edit_field.UserData.lower_limit = 0;
    app.stab_graph_range_edit_field.UserData.upper_limit = 1;

    % Label für Art der SSI
    app.ssi_label = uilabel(app.ssi_tab, 'Text', 'Art der SSI: ');
    app.ssi_label.Position = [x_boundary+x_stab_graph+x_space y_fig-60 x_small y_fix];

    % Dropdown für Art der SSI
    app.ssi_dropdown = uidropdown(app.ssi_tab);
    app.ssi_dropdown.Position = [x_boundary+x_stab_graph+x_space+x_small y_fig-60 x_small y_fix];
    app.ssi_dropdown.Items = {'SSI-COV'};        

    % Label für Messdaten
    app.measurement_label = uilabel(app.ssi_tab, 'Text', 'Messdaten: ');
    app.measurement_label.Position = [x_boundary+x_stab_graph+x_space y_fig-90 x_small y_fix];

    % Dropdown für Messdaten
    app.measurement_dropdown = uidropdown(app.ssi_tab);
    app.measurement_dropdown.Position = [x_boundary+x_stab_graph+x_space+x_small y_fig-90 x_small y_fix];
    app.measurement_dropdown.Items = {'Beschleunigung (original)'};
    app.measurement_dropdown.ItemsData = 1;    

    % Hilfe für Messdaten
    app.measurement_help = uilabel(app.ssi_tab, 'Text', '(?)');
    app.measurement_help.Position = [x_boundary+x_stab_graph+2*x_space+2*x_small y_fig-90 0.2*x_small y_fix];
    app.measurement_help.Tooltip = ['Wenn Verschiebungs- oder Geschwindigkeitsdaten verwendet wurden, ' ...
        'ist es möglich, Stabilisationsdiagramm basierend auf originalen Messdaten ' ...
        'oder auf Beschleunigungsdaten (abgeleitet) darzustellen. Das Diagramm basierend auf Beschleunigungsdaten ist oft aussagekräftiger ' ...
        'und hilft dabei, stabile Pole zu identifizieren. Die ausgewählten Pole basierend auf Beschleunigungsdaten ' ...
        'können auf das Diagramm der originalen Messdaten übertragen werden. WICHTIG: Die Berechnung der modalen ' ...
        'Parameter erfolgt ausschließlich mit den originalen Messdaten!'];    

    % Label für Toleranz
    app.tolerance_label = uilabel(app.ssi_tab, 'Text', 'Toleranz: ');
    app.tolerance_label.Position = [x_boundary+x_stab_graph+x_space y_fig-120 x_small y_fix];

    % Spinner für Toleranz
    app.tolerance_spinner = uispinner(app.ssi_tab, 'Value', 0.1, ...
        'Step', 0.05, 'Limits', [0.05 0.5]);
    app.tolerance_spinner.Position = [x_boundary+x_stab_graph+x_space+x_small y_fig-120 x_small y_fix];

    % Hilfe für Toleranz
    app.tolerance_help = uilabel(app.ssi_tab, 'Text', '(?)');
    app.tolerance_help.Position = [x_boundary+x_stab_graph+2*x_space+2*x_small y_fig-120 0.2*x_small y_fix];
    app.tolerance_help.Tooltip = ['Sie legt den Frequenzbereich fest, in dem beim Klicken die ' ...
        'zugehörigen Pole ausgewählt werden']; 

    % Button für Auswählen der physikalischen Pole
    app.choose_pole_button = uibutton(app.ssi_tab, 'Text', ...
        'Pole wählen', 'Interruptible', 'off','BusyAction', 'cancel');
    app.choose_pole_button.Position = [x_boundary+x_stab_graph+x_space y_fig-150 2.2*x_small y_fix];

    % Button für Übertragung der Auswahlen
    app.transfer_choice_button = uibutton(app.ssi_tab, 'Text', ...
        'Auswahlen übertragen', 'Interruptible', 'off','BusyAction', 'cancel');
    app.transfer_choice_button.Enable = 'off';
    app.transfer_choice_button.Position = [x_boundary+x_stab_graph+x_space y_fig-180 2.2*x_small y_fix];

    % Tabelle für Frequenzen der gewählten Pole
    app.freq_table = uitable(app.ssi_tab);
    app.freq_table.Position = [x_boundary+x_stab_graph+x_space y_boundary+60 2.2*x_small y_fig-230-2*y_space-y_boundary];
    app.freq_table.ColumnName = {'Auswahlen werden hier angezeigt'};

    % Gewählte Zeile unter "freq_table" speichern
    app.freq_table.UserData.row_selected = NaN;

    % Button für Anzeigen der zugehörigen Pole
    app.show_corresp_pole_button = uibutton(app.ssi_tab, 'Text', 'Zugehörige Pole anzeigen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.show_corresp_pole_button.Position = [x_boundary+x_stab_graph+x_space y_boundary+30 2.2*x_small y_fix];

    % Button für Entfernen der Pole
    app.remove_pole_button = uibutton(app.ssi_tab, 'Text', 'Pole entfernen', ...
        'Interruptible', 'off','BusyAction', 'cancel');
    app.remove_pole_button.Position = [x_boundary+x_stab_graph+x_space y_boundary 2.2*x_small y_fix];  
end