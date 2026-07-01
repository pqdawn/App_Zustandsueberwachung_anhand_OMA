%% Tab "Parameter" im Modus "Modalanalyse"
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

function app = create_parameter_tab(app)

    % Größen holen
    y_fig = app.y_fig;
    x_boundary = app.x_boundary;
    x_space = app.x_space;
    y_space = app.y_space;
    x_large = app.x_large;
    x_small = app.x_small;
    y_fix = app.y_fix;

    % Alle Komponenten in diesem Tab löschen
    delete(app.parameter_tab.Children);

    % Label für OMA-Methoden
    app.oma_label = uilabel(app.parameter_tab, 'Text', 'OMA-Methoden: ');
    app.oma_label.Position = [x_boundary y_fig-60 1.8*x_small y_fix];

    % Checkboxen für OMA-Methoden
    app.oma_fdd_check = uicheckbox(app.parameter_tab, 'Text', 'FDD / EFDD', 'Value', 1);
    app.oma_fdd_check.Position = [x_boundary+1.8*x_small+0.5 y_fig-60 100 y_fix];
    app.oma_ssi_cov_check = uicheckbox(app.parameter_tab, 'Text', 'SSI-COV', 'Value', 1);
    app.oma_ssi_cov_check.Position = [x_boundary+1.8*x_small+100 y_fig-60 80 y_fix];
    app.oma_ssi_data_check = uicheckbox(app.parameter_tab, 'Text', 'SSI-DATA', 'Value', 1);
    app.oma_ssi_data_check.Position = [x_boundary+1.8*x_small+180 y_fig-60 100 y_fix];

    % Label für Frequenzgrenze
    app.freq_limit_label = uilabel(app.parameter_tab, 'Text', 'Frequenzgrenze: ');
    app.freq_limit_label.Position = [x_boundary y_fig-90 1.8*x_small y_fix];

    % Eingabefeld für Frequenzgrenze
    app.freq_limit_edit_field = uieditfield(app.parameter_tab, 'InputType', 'Digits', 'Placeholder', 'in Einheit [Hz]');
    app.freq_limit_edit_field.Position = [x_boundary+1.8*x_small+0.5 y_fig-90 x_small y_fix];    

    % Hilfe für Frequenzgrenze
    app.freq_limit_help = uilabel(app.parameter_tab, 'Text', '(?)');
    app.freq_limit_help.Position = [x_boundary+2.8*x_small+0.5+x_space y_fig-90 0.2*x_small y_fix];
    app.freq_limit_help.Tooltip = 'Sie legt fest, bis welche Frequenz die Auswertung durchgeführt wird. Bei FDD/EFDD ist diese auf die halbe Abtastfrequenz begrenzt.';

    % Label für niedrigste zu untersuchende Frequenz
    app.lowest_freq_label = uilabel(app.parameter_tab, 'Text', 'Niedrigste zu untersuch. Freq.: ');
    app.lowest_freq_label.Position = [x_boundary y_fig-120 1.8*x_small y_fix];

    % Eingabefeld für niedrigste zu untersuchende Frequenz
    app.lowest_freq_edit_field = uieditfield(app.parameter_tab, 'InputType', 'Digits', 'Placeholder', 'in Einheit [Hz]');
    app.lowest_freq_edit_field.Position = [x_boundary+1.8*x_small+0.5 y_fig-120 x_small y_fix];    

    % Hilfe für niedrigste zu untersuchende Frequenz
    app.lowest_freq_help = uilabel(app.parameter_tab, 'Text', '(?)');
    app.lowest_freq_help.Position = [x_boundary+2.8*x_small+0.5+x_space y_fig-120 0.2*x_small y_fix];
    app.lowest_freq_help.Tooltip = 'Sie legt die Fensterlänge für Welch-Methode fest, sowie Vorschläge der Parameter für SSI-COV und -DATA gemäß Empfehlungen';    

    % Subtabs für Parameter verschiedener OMA-Methoden 
    app.sub_tab_group_parameter_tab = uitabgroup(app.parameter_tab);
    x_sub_tab = 800;
    y_sub_tab = 530;
    app.sub_tab_group_parameter_tab.Position = [x_boundary y_fig-y_sub_tab-130 x_sub_tab y_sub_tab];
    app.fdd_sub_tab = uitab(app.sub_tab_group_parameter_tab, 'Title', 'FDD / EFDD');              % FDD / EFDD
    app.ssi_cov_sub_tab = uitab(app.sub_tab_group_parameter_tab, 'Title', 'SSI-COV');             % SSI-COV
    app.ssi_data_sub_tab = uitab(app.sub_tab_group_parameter_tab, 'Title', 'SSI-DATA');           % SSI-DATA

    % Label für Modus der PSD
    app.psd_mode_label = uilabel(app.fdd_sub_tab, 'Text', 'Modus: ');
    app.psd_mode_label.Position = [x_boundary y_sub_tab-60 2.2*x_small y_fix];

    % Radiobutton-Gruppe für Modus der PSD
    app.psd_mode_radio_group = uibuttongroup(app.fdd_sub_tab);
    app.psd_mode_radio_group.Position = [x_boundary+2.2*x_small y_sub_tab-120 x_large 3*y_fix+2*y_space];
    app.psd_mode_radio_group.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für direkt
    app.psd_mode_direct= uiradiobutton(app.psd_mode_radio_group, 'Text', 'Direkt');
    app.psd_mode_direct.Position = [0 2*y_fix+2*y_space x_small y_fix];

    % Hilfe für direkt
    app.psd_mode_direct_help = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.psd_mode_direct_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-60 0.2*x_small y_fix];
    app.psd_mode_direct_help.Tooltip = ['Die DFT wird direkt auf die gesamten Messdaten als ein einzelnes ' ...
        'Segment angewendet, auf dem die rechteckige Fensterfunktion verwendet wird. Die Fensterlänge sowie ' ...
        'die Anzahl der DFT-Punkte entsprechen dabei der Anzahl der Zeitschritte der gesamten Messdaten. Es ' ...
        'findet keine Überlappung statt. Für die Berechnung der Korrelationsfunktion wird die IFFT verwendet'];     

    % Radiobutton für Welch
    app.psd_mode_welch = uiradiobutton(app.psd_mode_radio_group, 'Text', 'Welch');
    app.psd_mode_welch.Position = [0 y_fix+y_space x_small y_fix];

    % Hilfe für Welch
    app.psd_mode_welch_help = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.psd_mode_welch_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-90 0.2*x_small y_fix];
    app.psd_mode_welch_help.Tooltip = ['Die Welch-Methode wird durchgeführt. Die Verwendung einer ' ...
        'Hann-Fensterfunktion mit 50% Überlappung stellt eine geeignete Wahl für OMA-Anwendungen dar. ' ...
        'Die Fensterlänge wird so gewählt, dass sie mindestens dem 10-fachen der Periode der niedrigsten ' ...
        'zu untersuchenden Frequenz entspricht. Für die Berechnung der Korrelationsfunktion wird die ' ...
        'Kosinustransformation angewendet.'];  
    
    % Radiobutton für benutzerdefiniert
    app.psd_mode_user_defined = uiradiobutton(app.psd_mode_radio_group, 'Text', 'Benutzerdefin.');
    app.psd_mode_user_defined.Position = [0 0 2.2*x_small y_fix];

    % Label für Fensterfunktion
    app.window_func_label = uilabel(app.fdd_sub_tab, 'Text', 'Fensterfunktion: ');
    app.window_func_label.Position = [x_boundary y_sub_tab-150 2.2*x_small y_fix];

    % Dropdown für Fensterfunktion
    app.window_func_dropdown = uidropdown(app.fdd_sub_tab, 'Enable', 'off');
    app.window_func_dropdown.Items = {'Bartlett', 'Blackman', 'Hamming', 'Hann', 'Rechteck'};
    app.window_func_dropdown.Value = 'Rechteck';
    app.window_func_dropdown.Position = [x_boundary+2.2*x_small y_sub_tab-150 x_small y_fix];   

    % Label für Fensterlänge
    app.window_size_label = uilabel(app.fdd_sub_tab, 'Text', 'Fensterlänge: ');
    app.window_size_label.Position = [x_boundary y_sub_tab-180 2.2*x_small y_fix];

    % Dropdown für Fensterlänge
    app.window_size_dropdown = uidropdown(app.fdd_sub_tab, 'Enable', 'off');
    app.window_size_dropdown.Items = {'1024', '2048', '4096', '8192', '16384', '32768', 'Gesamte Messdaten'};
    app.window_size_dropdown.Value = '1024';
    app.window_size_dropdown.Position = [x_boundary+2.2*x_small y_sub_tab-180 x_small y_fix];

    % Hilfe für Fensterlänge
    app.window_size_help = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.window_size_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-180 0.2*x_small y_fix];
    app.window_size_help.Tooltip = ['Diese Zahl handelt sich um die Anzahl der Messdaten für ein Segment. Sie bestimmt ' ...
        'die physikalische Frequenzauflösung. Auflösung = Abtastfrequenz / Fensterlänge'];

    % Label für Überlappungsgrad
    app.overlap_label = uilabel(app.fdd_sub_tab, 'Text', 'Überlappungsgrad: ');
    app.overlap_label.Position = [x_boundary y_sub_tab-210 2.2*x_small y_fix];

    % Dropdown für Überlappungsgrad
    app.overlap_dropdown = uidropdown(app.fdd_sub_tab, 'Enable', 'off');
    app.overlap_dropdown.Items = {'0%', '25%', '50%', '75%'};
    app.overlap_dropdown.Value = '50%';
    app.overlap_dropdown.Position = [x_boundary+2.2*x_small y_sub_tab-210 x_small y_fix];    

    % Hilfe für Überlappungsgrad
    app.overlap_help = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.overlap_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-210 0.2*x_small y_fix];
    app.overlap_help.Tooltip = ['Er bestimmt den Überlappungsgrad benachbarter Segmente, ohne die physikalische ' ...
        'Frequenzauflösung zu verändern'];      

    % Label für Anzahl der DFT-Punkte
    app.num_fft_label = uilabel(app.fdd_sub_tab, 'Text', 'Anzahl der DFT-Punkte: ');
    app.num_fft_label.Position = [x_boundary y_sub_tab-240 2.2*x_small y_fix];

    % Dropdown für Anzahl der DFT-Punkte
    app.num_fft_dropdown = uidropdown(app.fdd_sub_tab, 'Enable', 'off');
    app.num_fft_dropdown.Items = {'1024', '2048', '4096', '8192', '16384', '32768', 'Gesamte Messdaten'};
    app.num_fft_dropdown.Value = '1024';
    app.num_fft_dropdown.Position = [x_boundary+2.2*x_small y_sub_tab-240 x_small y_fix];       

    % Hilfe für Anzahl der DFT-Punkte
    app.num_ff_help = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.num_ff_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-240 0.2*x_small y_fix];
    app.num_ff_help.Tooltip = ['Sie bestimmt den Linienabstand des Frequenzrasters, ohne die physikalische ' ...
        'Frequenzauflösung zu verändern. Eine höhere Anzahl erzeugt glattere Kurve.'];

    % Label für automatische Peakauswahl
    app.auto_peak_label = uilabel(app.fdd_sub_tab, 'Text', 'Automatische Peakauswahl: ');
    app.auto_peak_label.Position = [x_boundary y_sub_tab-270 2.2*x_small y_fix];

    % Switch für automatische Peakauswahl
    app.auto_peak_switch = uiswitch(app.fdd_sub_tab);
    app.auto_peak_switch.Position = [x_boundary+2.45*x_small y_sub_tab-270 app.auto_peak_switch.Position(3) app.auto_peak_switch.Position(4)];
    app.auto_peak_switch.Items = {'Aus', 'An'};
    app.auto_peak_switch.Value = 'Aus'; 

    % Label für Anzahl der Moden
    app.num_mode_label_fdd = uilabel(app.fdd_sub_tab, 'Text', 'Anzahl der Moden: ');
    app.num_mode_label_fdd.Position = [x_boundary y_sub_tab-300 2.2*x_small y_fix];

    % Radiobutton-Gruppe für Anzahl der Moden
    app.num_mode_radio_group_fdd = uibuttongroup(app.fdd_sub_tab);
    app.num_mode_radio_group_fdd.Position = [x_boundary+2.2*x_small y_sub_tab-330 2*x_small 2*y_fix+y_space];
    app.num_mode_radio_group_fdd.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für unbekannt
    app.num_mode_unknown_fdd = uiradiobutton(app.num_mode_radio_group_fdd, 'Text', 'Unbekannt', 'Enable', 'off');
    app.num_mode_unknown_fdd.Position = [0 y_fix+y_space x_small y_fix];

    % Radiobutton für bekannt
    app.num_mode_known_fdd = uiradiobutton(app.num_mode_radio_group_fdd, 'Text', 'Bekannt', 'Enable', 'off');
    app.num_mode_known_fdd.Position = [0 0 x_small y_fix];

    % Label für Bandbreite um den Peak
    app.bandwidth_peak_label = uilabel(app.fdd_sub_tab, 'Text', 'Bandbreite um den Peak: ');
    app.bandwidth_peak_label.Position = [x_boundary y_sub_tab-360 2.2*x_small y_fix];

    % Spinner für Bandbreite um den Peak
    app.bandwidth_peak_spinner = uispinner(app.fdd_sub_tab, 'Value', 0.3, ...
        'Step', 0.1, 'Limits', [0.1 5], 'ValueDisplayFormat', '%11.4g Hz', 'Enable', 'off');
    app.bandwidth_peak_spinner.Position = [x_boundary+2.2*x_small y_sub_tab-360 x_small y_fix];

    % Hilfe für Bandbreite um den Peak
    app.bandwidth_peak_help = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.bandwidth_peak_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-360 0.2*x_small y_fix];
    app.bandwidth_peak_help.Tooltip = ['Sie definiert die halbe Frequenzbandbreite um den Peak, in der die Eigenformen für Validierung ' ...
        'eines Peaks ausgewertet werden.'];   

    % Label für MAC-Grenze für validen Peak
    app.mac_label_valid_peak = uilabel(app.fdd_sub_tab, 'Text', 'MAC-Grenze für validen Peak: ');
    app.mac_label_valid_peak.Position = [x_boundary y_sub_tab-390 2.2*x_small y_fix];

    % Spinner für MAC-Grenze für validen Peak
    app.mac_spinner_valid_peak = uispinner(app.fdd_sub_tab, 'Value', 90, ...
        'Step', 1, 'Limits', [0 99], 'ValueDisplayFormat', '%11.4g%%', 'Enable', 'off');
    app.mac_spinner_valid_peak.Position = [x_boundary+2.2*x_small y_sub_tab-390 x_small y_fix];

    % Hilfe für MAC-Grenze für validen Peak
    app.mac_help_valid_peak = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.mac_help_valid_peak.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-390 0.2*x_small y_fix];
    app.mac_help_valid_peak.Tooltip = ['Sie legt fest, wie ähnlich die Eigenformen innerhalb der festgelegten Bandbreite ' ...
        'eines Peaks sein müssen, damit dieser Peak als valid eingestuft wird']; 

    % Label für Zielanzahl
    app.target_num_label_fdd = uilabel(app.fdd_sub_tab, 'Text', 'Zielanzahl der Moden: ');
    app.target_num_label_fdd.Position = [x_boundary y_sub_tab-420 2.2*x_small y_fix];

    % Spinner für Zielanzahl
    app.target_num_spinner_fdd = uispinner(app.fdd_sub_tab, 'Value', 5, ...
        'Step', 1, 'Limits', [1 20], 'Enable', 'off');
    app.target_num_spinner_fdd.Position = [x_boundary+2.2*x_small y_sub_tab-420 x_small y_fix];    

    % Label für EFDD nach automatischer Peakauswahl
    app.efdd_auto_peak_label = uilabel(app.fdd_sub_tab, 'Text', 'EFDD nach auto. Peakauswahl: ');
    app.efdd_auto_peak_label.Position = [x_sub_tab/2+x_boundary y_sub_tab-60 2.2*x_small y_fix];

    % Switch für EFDD nach automatischer Peakauswahl
    app.efdd_auto_peak_switch = uiswitch(app.fdd_sub_tab, 'Enable', 'off');
    app.efdd_auto_peak_switch.Position = [x_sub_tab/2+x_boundary+2.45*x_small y_sub_tab-60 app.efdd_auto_peak_switch.Position(3) app.efdd_auto_peak_switch.Position(4)];
    app.efdd_auto_peak_switch.Items = {'Aus', 'An'};
    app.efdd_auto_peak_switch.Value = 'Aus';    

    % Hilfe für EFDD nach automatischer Peakauswahl
    app.auto_peak_help = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.auto_peak_help.Position = [x_sub_tab/2+x_boundary+3.2*x_small+x_space y_sub_tab-60 0.2*x_small y_fix];
    app.auto_peak_help.Tooltip = 'Dämpfungsgrade werden nicht automatisch ermitellt';

    % Label für Korrelationsfunktion
    app.correlation_curve_label2 = uilabel(app.fdd_sub_tab, 'Text', 'Berechnung der Korrelationsfunktion: ');
    app.correlation_curve_label2.Position = [x_sub_tab/2+x_boundary y_sub_tab-90 2.2*x_small y_fix];     

    % Radiobutton-Gruppe für Korrelationsfunktion
    app.correlation_type_radio_group2 = uibuttongroup(app.fdd_sub_tab);
    app.correlation_type_radio_group2.Position = [x_sub_tab/2+x_boundary+2.2*x_small y_sub_tab-120 2*x_small 2*y_fix+y_space];
    app.correlation_type_radio_group2.BorderColor = [0.94,0.94,0.94];

    % Hilfe für Korrelationsfunktion
    app.correlation_type_help2 = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.correlation_type_help2.Position = [x_sub_tab/2+x_boundary+3.2*x_small+x_space y_sub_tab-90 0.2*x_small y_fix];
    app.correlation_type_help2.Tooltip = ['Diese Einstellung wird nur bei Modus "Benutzerdefin." für EFDD nach automatischer Peakauswahl aktiviert. IFFT ist geeignet für ' ...
        'FDD mit weniger Segmenten ohne Überlappung. Kosinustransformation ist hingegen geeignet für FDD mit mehreren Segmenten und Überlappung'];

    % Radiobutton für IFFT
    app.correlation_type_ifft2 = uiradiobutton(app.correlation_type_radio_group2, 'Text', 'IFFT', 'Enable', 'off');
    app.correlation_type_ifft2.Position = [0 y_fix+y_space x_small y_fix];   

    % Radiobutton für Kosinustransformation
    app.correlation_type_cos2 = uiradiobutton(app.correlation_type_radio_group2, 'Text', 'Kosinustrans.', 'Enable', 'off');
    app.correlation_type_cos2.Position = [0 0 x_small y_fix];      

    % Label für MAC-Grenze
    app.mac_label4 = uilabel(app.fdd_sub_tab, 'Text', 'MAC-Grenze für EFDD: ');
    app.mac_label4.Position = [x_sub_tab/2+x_boundary y_sub_tab-150 2.2*x_small y_fix];

    % Spinner für MAC-Grenze
    app.mac_spinner4 = uispinner(app.fdd_sub_tab, 'Value', 95, ...
        'Step', 1, 'Limits', [0 99], 'ValueDisplayFormat', '%11.4g%%', 'Enable', 'off');
    app.mac_spinner4.Position = [x_sub_tab/2+x_boundary+2.2*x_small y_sub_tab-150 x_small y_fix];

    % Hilfe für MAC-Grenze
    app.mac_help4 = uilabel(app.fdd_sub_tab, 'Text', '(?)');
    app.mac_help4.Position = [x_sub_tab/2+x_boundary+3.2*x_small+x_space y_sub_tab-150 0.2*x_small y_fix];
    app.mac_help4.Tooltip = ['Sie legt fest, wie ähnlich die Eigenformen benachbarter Frequenzen sein müssen, ' ...
        'damit sie derselben Schwingungsform zugeordnet und in der EFDD-Auswertung berücksichtigt werden'];        

    % Label für maximalen verzögerten Zeitschritt
    app.max_lag_label = uilabel(app.ssi_cov_sub_tab, 'Text', 'Maximaler verzögerter Zeitschritt: ');
    app.max_lag_label.Position = [x_boundary y_sub_tab-60 2.2*x_small y_fix];

    % Eingabefeld für maximalen verzögerten Zeitschritt
    app.max_lag_edit_field = uieditfield(app.ssi_cov_sub_tab, 'InputType', 'Digits');
    app.max_lag_edit_field.Position = [x_boundary+2.2*x_small y_sub_tab-60 x_small y_fix];

    % Hilfe für maximalen verzögerten Zeitschritt
    app.max_lag_help = uilabel(app.ssi_cov_sub_tab, 'Text', '(?)');
    app.max_lag_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-60 0.2*x_small y_fix];
    app.max_lag_help.Tooltip = {'Idealerweise größer als f_s/(2*f_0), wobei:';
        '- f_s = Abtastfrequenz';
        '- f_0 = niedrigste zu untersuchende Frequenz';};

    % Label für maximale Model-Order
    app.max_model_order_label = uilabel(app.ssi_cov_sub_tab, 'Text', 'Maximale Model-Order: ');
    app.max_model_order_label.Position = [x_boundary y_sub_tab-90 2.2*x_small y_fix];

    % Eingabefeld für maximale Model-Order
    app.max_model_order_edit_field = uieditfield(app.ssi_cov_sub_tab, 'InputType', 'Digits');
    app.max_model_order_edit_field.Position = [x_boundary+2.2*x_small y_sub_tab-90 x_small y_fix];

    % Hilfe für maximale Model-Order
    app.max_model_order_help = uilabel(app.ssi_cov_sub_tab, 'Text', '(?)');
    app.max_model_order_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-90 0.2*x_small y_fix];
    app.max_model_order_help.Tooltip = {'Darf nicht größer als n_0*j, wobei:';
        '- n_0 = Anzahl der Ausgangskanäle';
        '- j = maximaler verzögerter Zeitschritt';};    

    % Label für Grenzwert für stabile Frequenz
    app.freq_variation_label = uilabel(app.ssi_cov_sub_tab, 'Text', 'Grenzwert für stabile Frequenz: ');
    app.freq_variation_label.Position = [x_boundary y_sub_tab-120 2.2*x_small y_fix];

    % Spinner für Grenzwert für stabile Frequenz
    app.freq_variation_spinner = uispinner(app.ssi_cov_sub_tab, 'Value', 1, ...
        'Step', 0.1, 'Limits', [1 10], 'ValueDisplayFormat', '%11.4g%%');
    app.freq_variation_spinner.Position = [x_boundary+2.2*x_small y_sub_tab-120 x_small y_fix];

    % Hilfe für Grenzwert für stabile Frequenz
    app.freq_variation_help = uilabel(app.ssi_cov_sub_tab, 'Text', '(?)');
    app.freq_variation_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-120 0.2*x_small y_fix];
    app.freq_variation_help.Tooltip = ['Er legt fest, wie groß die Abweichung zwischen den Frequnzen ' ...
        'sein darf, damit ein Pol als "stabile Frequenz" betrachtet wird'];

    % Label für Grenzwert für stabilen Dämpfungsgrad
    app.damping_variation_label = uilabel(app.ssi_cov_sub_tab, 'Text', 'Grenzwert für stabilen Dämpfungsgrad: ');
    app.damping_variation_label.Position = [x_boundary y_sub_tab-150 2.2*x_small y_fix];

    % Spinner für Grenzwert für stabilen Dämpfungsgrad
    app.damping_variation_spinner = uispinner(app.ssi_cov_sub_tab, 'Value', 5, ...
        'Step', 0.1, 'Limits', [1 10], 'ValueDisplayFormat', '%11.4g%%');
    app.damping_variation_spinner.Position = [x_boundary+2.2*x_small y_sub_tab-150 x_small y_fix];

    % Hilfe für Grenzwert für stabilen Dämpfungsgrad
    app.damping_variation_help = uilabel(app.ssi_cov_sub_tab, 'Text', '(?)');
    app.damping_variation_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-150 0.2*x_small y_fix];
    app.damping_variation_help.Tooltip = ['Er legt fest, wie groß die Abweichung zwischen den Dämpfungsgraden ' ...
        'sein darf, damit ein Pol als "stabiler Dämpfungsgrad" betrachtet wird'];

    % Label für Grenzwert für "MAC-Bedingung erfüllt"
    app.mac_label = uilabel(app.ssi_cov_sub_tab, 'Text', 'Grenzwert für "MAC-Bedingung erfüllt": ');
    app.mac_label.Position = [x_boundary y_sub_tab-180 2.2*x_small y_fix];

    % Spinner für Grenzwert für "MAC-Bedingung erfüllt"
    app.mac_spinner = uispinner(app.ssi_cov_sub_tab, 'Value', 99, ...
        'Step', 1, 'Limits', [50 99], 'ValueDisplayFormat', '%11.4g%%');
    app.mac_spinner.Position = [x_boundary+2.2*x_small y_sub_tab-180 x_small y_fix];

    % Hilfe für Grenzwert für "MAC-Bedingung erfüllt"
    app.mac_help = uilabel(app.ssi_cov_sub_tab, 'Text', '(?)');
    app.mac_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-180 0.2*x_small y_fix];
    app.mac_help.Tooltip = ['Er legt fest, wie ähnlich die Eigenformen zueinander sein müssen, ' ...
        'damit ein Pol als "MAC-Bedingung erfüllt" betrachtet wird'];

    % Label für automatische Polauswahl
    app.auto_pol_label = uilabel(app.ssi_cov_sub_tab, 'Text', 'Automatische Polauswahl: ');
    app.auto_pol_label.Position = [x_boundary y_sub_tab-210 2.2*x_small y_fix];

    % Switch für automatische Polauswahl
    app.auto_pol_switch = uiswitch(app.ssi_cov_sub_tab);
    app.auto_pol_switch.Position = [x_boundary+2.45*x_small y_sub_tab-210 app.auto_pol_switch.Position(3) app.auto_pol_switch.Position(4)];
    app.auto_pol_switch.Items = {'Aus', 'An'};
    app.auto_pol_switch.Value = 'Aus';

    % Label für Kriterien für Polauswahl
    app.criteria_label = uilabel(app.ssi_cov_sub_tab, 'Text', 'Kriterien für Polauswahl: ');
    app.criteria_label.Position = [x_boundary y_sub_tab-240 2.2*x_small y_fix];

    % Checkboxen für Kriterien
    app.criteria_stable_freq_check = uicheckbox(app.ssi_cov_sub_tab, 'Text', 'Stabile Frequenz', 'Value', 1, 'Enable', 'off');
    app.criteria_stable_freq_check.Position = [x_boundary+2.2*x_small y_sub_tab-240 200 y_fix];
    app.criteria_stable_damp_check = uicheckbox(app.ssi_cov_sub_tab, 'Text', 'Stabiler Dämpfungsgrad', 'Value', 1, 'Enable', 'off');
    app.criteria_stable_damp_check.Position = [x_boundary+2.2*x_small y_sub_tab-270 200 y_fix];
    app.criteria_mac_check = uicheckbox(app.ssi_cov_sub_tab, 'Text', 'MAC-Bedingung erfüllt', 'Value', 1, 'Enable', 'off');
    app.criteria_mac_check.Position = [x_boundary+2.2*x_small y_sub_tab-300 300 y_fix];

    % Label für Anzahl der Moden
    app.num_mode_label_ssi_cov = uilabel(app.ssi_cov_sub_tab, 'Text', 'Anzahl der Moden: ');
    app.num_mode_label_ssi_cov.Position = [x_boundary y_sub_tab-330 2.2*x_small y_fix];

    % Radiobutton-Gruppe für Anzahl der Moden
    app.num_mode_radio_group_ssi_cov = uibuttongroup(app.ssi_cov_sub_tab);
    app.num_mode_radio_group_ssi_cov.Position = [x_boundary+2.2*x_small y_sub_tab-360 2*x_small 2*y_fix+y_space];
    app.num_mode_radio_group_ssi_cov.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für unbekannt
    app.num_mode_unknown_ssi_cov = uiradiobutton(app.num_mode_radio_group_ssi_cov, 'Text', 'Unbekannt', 'Enable', 'off');
    app.num_mode_unknown_ssi_cov.Position = [0 y_fix+y_space x_small y_fix];

    % Radiobutton für bekannt
    app.num_mode_known_ssi_cov = uiradiobutton(app.num_mode_radio_group_ssi_cov, 'Text', 'Bekannt', 'Enable', 'off');
    app.num_mode_known_ssi_cov.Position = [0 0 x_small y_fix];

    % Label für Mindestgröße eines Clusters
    app.min_cluster_size_label = uilabel(app.ssi_cov_sub_tab, 'Text', 'Mindestgröße eines Clusters: ');
    app.min_cluster_size_label.Position = [x_boundary y_sub_tab-390 2.2*x_small y_fix];

    % Spinner für Mindestgröße eines Clusters
    app.min_cluster_size_spinner = uispinner(app.ssi_cov_sub_tab, 'Value', 4, ...
        'Step', 1, 'Limits', [1 100], 'Enable', 'off');
    app.min_cluster_size_spinner.Position = [x_boundary+2.2*x_small y_sub_tab-390 x_small y_fix];

    % Hilfe für Mindestgröße eines Clusters
    app.min_cluster_size_help = uilabel(app.ssi_cov_sub_tab, 'Text', '(?)');
    app.min_cluster_size_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-390 0.2*x_small y_fix];
    app.min_cluster_size_help.Tooltip = ['Sie legt fest, wie viele Pole ein Cluster mindestens erhalten muss, ' ...
        'um als gültig zu gelten. Kleine Werte erlauben auch einzelne Pole, große Werte erkennen nur mehrfach ' ...
        'auftretende stabile Pole an. WICHTIG: Ein Punkt auf Diagramm könnte zwei Pole umfassen!'];

    % Label für Cluster-Distanzschwelle
    app.cluster_distance_label = uilabel(app.ssi_cov_sub_tab, 'Text', 'Cluster-Distanzschwelle: ');
    app.cluster_distance_label.Position = [x_boundary y_sub_tab-420 2.2*x_small y_fix];

    % Spinner für Cluster-Distanzschwelle
    app.cluster_distance_spinner = uispinner(app.ssi_cov_sub_tab, 'Value', 0.01, ...
        'Step', 0.001, 'Limits', [0.001 1], 'Enable', 'off');
    app.cluster_distance_spinner.Position = [x_boundary+2.2*x_small y_sub_tab-420 x_small y_fix];

    % Hilfe für Cluster-Distanzschwelle
    app.cluster_distance_help = uilabel(app.ssi_cov_sub_tab, 'Text', '(?)');
    app.cluster_distance_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-420 0.2*x_small y_fix];
    app.cluster_distance_help.Tooltip = ['Sie legt fest, wie ähnlich sich Pole in Frequenz und Eigenform ' ...
        'sein müssen, um zu einem Cluster zusammenzufassen. Kleine Werte führen zu strengeren, große ' ...
        'zu weiter gefassten Clustern.'];

    % Label für Zielanzahl
    app.target_num_label_ssi_cov = uilabel(app.ssi_cov_sub_tab, 'Text', 'Zielanzahl der Moden: ');
    app.target_num_label_ssi_cov.Position = [x_boundary y_sub_tab-450 2.2*x_small y_fix];

    % Spinner für Zielanzahl
    app.target_num_spinner_ssi_cov = uispinner(app.ssi_cov_sub_tab, 'Value', 5, ...
        'Step', 1, 'Limits', [1 20], 'Enable', 'off');
    app.target_num_spinner_ssi_cov.Position = [x_boundary+2.2*x_small y_sub_tab-450 x_small y_fix];    

    % Label für Zeilenanzahl der Hankelmatrix
    app.num_row_hankel_label = uilabel(app.ssi_data_sub_tab, 'Text', 'Zeilenanzahl der Hankelmatrix: ');
    app.num_row_hankel_label.Position = [x_boundary y_sub_tab-60 2.2*x_small y_fix];

    % Eingabefeld für Zeilenanzahl der Hankelmatrix
    app.num_row_hankel_edit_field = uieditfield(app.ssi_data_sub_tab, 'InputType', 'Digits');
    app.num_row_hankel_edit_field.Position = [x_boundary+2.2*x_small y_sub_tab-60 x_small y_fix];

    % Hilfe für Zeilenanzahl der Hankelmatrix
    app.num_row_hankel_help = uilabel(app.ssi_data_sub_tab, 'Text', '(?)');
    app.num_row_hankel_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-60 0.2*x_small y_fix];
    app.num_row_hankel_help.Tooltip = {'Idealerweise größer als f_s/f_0, wobei:';
        '- f_s = Abtastfrequenz';
        '- f_0 = niedrigste zu untersuchende Frequenz';};  

    % Label für Spaltenanzahl der Hankelmatrix
    app.num_col_hankel_label = uilabel(app.ssi_data_sub_tab, 'Text', 'Spaltenanzahl der Hankelmatrix: ');
    app.num_col_hankel_label.Position = [x_boundary y_sub_tab-90 2.2*x_small y_fix];

    % Eingabefeld für Spaltenanzahl der Hankelmatrix
    app.num_col_hankel_edit_field = uieditfield(app.ssi_data_sub_tab, 'InputType', 'Digits');
    app.num_col_hankel_edit_field.Position = [x_boundary+2.2*x_small y_sub_tab-90 x_small y_fix];

    % Hilfe für Spaltenanzahl der Hankelmatrix
    app.num_col_hankel_help = uilabel(app.ssi_data_sub_tab, 'Text', '(?)');
    app.num_col_hankel_help.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-90 0.2*x_small y_fix];
    app.num_col_hankel_help.Tooltip = {'Idealerweise größer als n_0*n_row und darf nicht größer als N+1-n_row/n_0, wobei:';
        '- n_0 = Anzahl der Ausgangskanäle';
        '- n_row = Zeilenanzahl der Hankelmatrix';
        '- N = Anzahl der Zeitschritte';};

    % Label für maximale Model-Order
    app.max_model_order_label2 = uilabel(app.ssi_data_sub_tab, 'Text', 'Maximale Model-Order: ');
    app.max_model_order_label2.Position = [x_boundary y_sub_tab-120 2.2*x_small y_fix];

    % Eingabefeld für maximale Model-Order
    app.max_model_order_edit_field2 = uieditfield(app.ssi_data_sub_tab, 'InputType', 'Digits');
    app.max_model_order_edit_field2.Position = [x_boundary+2.2*x_small y_sub_tab-120 x_small y_fix];

    % Hilfe für maximale Model-Order
    app.max_model_order_help2 = uilabel(app.ssi_data_sub_tab, 'Text', '(?)');
    app.max_model_order_help2.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-120 0.2*x_small y_fix];
    app.max_model_order_help2.Tooltip = {'Darf nicht größer als (n_0*n_block)/2, wobei:';
        '- n_0 = Anzahl der Ausgangskanäle';
        '- n_block = n_row/n_0 auf GERADE Zahl abgerundet';
        '- n_row = Zeilenanzahl der Hankelmatrix';};    

    % Label für Grenzwert für stabile Frequenz
    app.freq_variation_label2 = uilabel(app.ssi_data_sub_tab, 'Text', 'Grenzwert für stabile Frequenz: ');
    app.freq_variation_label2.Position = [x_boundary y_sub_tab-150 2.2*x_small y_fix];

    % Spinner für Grenzwert für stabile Frequenz
    app.freq_variation_spinner2 = uispinner(app.ssi_data_sub_tab, 'Value', 1, ...
        'Step', 0.1, 'Limits', [1 10], 'ValueDisplayFormat', '%11.4g%%');
    app.freq_variation_spinner2.Position = [x_boundary+2.2*x_small y_sub_tab-150 x_small y_fix];

    % Hilfe für Grenzwert für stabile Frequenz
    app.freq_variation_help2 = uilabel(app.ssi_data_sub_tab, 'Text', '(?)');
    app.freq_variation_help2.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-150 0.2*x_small y_fix];
    app.freq_variation_help2.Tooltip = ['Er legt fest, wie groß die Abweichung zwischen den Frequnzen ' ...
        'sein darf, damit ein Pol als "stabile Frequenz" betrachtet wird'];

    % Label für Grenzwert für stabilen Dämpfungsgrad
    app.damping_variation_label2 = uilabel(app.ssi_data_sub_tab, 'Text', 'Grenzwert für stabilen Dämpfungsgrad: ');
    app.damping_variation_label2.Position = [x_boundary y_sub_tab-180 2.2*x_small y_fix];

    % Spinner für Grenzwert für stabilen Dämpfungsgrad
    app.damping_variation_spinner2 = uispinner(app.ssi_data_sub_tab, 'Value', 5, ...
        'Step', 0.1, 'Limits', [1 10], 'ValueDisplayFormat', '%11.4g%%');
    app.damping_variation_spinner2.Position = [x_boundary+2.2*x_small y_sub_tab-180 x_small y_fix];

    % Hilfe für Grenzwert für stabilen Dämpfungsgrad
    app.damping_variation_help2 = uilabel(app.ssi_data_sub_tab, 'Text', '(?)');
    app.damping_variation_help2.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-180 0.2*x_small y_fix];
    app.damping_variation_help2.Tooltip = ['Er legt fest, wie groß die Abweichung zwischen den Dämpfungsgraden ' ...
        'sein darf, damit ein Pol als "stabiler Dämpfungsgrad" betrachtet wird'];

    % Label für Grenzwert für "MAC-Bedingung erfüllt"
    app.mac_label5 = uilabel(app.ssi_data_sub_tab, 'Text', 'Grenzwert für "MAC-Bedingung erfüllt": ');
    app.mac_label5.Position = [x_boundary y_sub_tab-210 2.2*x_small y_fix];

    % Spinner für Grenzwert für "MAC-Bedingung erfüllt"
    app.mac_spinner5 = uispinner(app.ssi_data_sub_tab, 'Value', 99, ...
        'Step', 1, 'Limits', [50 99], 'ValueDisplayFormat', '%11.4g%%');
    app.mac_spinner5.Position = [x_boundary+2.2*x_small y_sub_tab-210 x_small y_fix];

    % Hilfe für Grenzwert für "MAC-Bedingung erfüllt"
    app.mac_help5 = uilabel(app.ssi_data_sub_tab, 'Text', '(?)');
    app.mac_help5.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-210 0.2*x_small y_fix];
    app.mac_help5.Tooltip = ['Er legt fest, wie ähnlich die Eigenformen zueinander sein müssen, ' ...
        'damit ein Pol als "MAC-Bedingung erfüllt" betrachtet wird'];

    % Label für automatische Polauswahl
    app.auto_pol_label2 = uilabel(app.ssi_data_sub_tab, 'Text', 'Automatische Polauswahl: ');
    app.auto_pol_label2.Position = [x_boundary y_sub_tab-240 2.2*x_small y_fix];

    % Switch für automatische Polauswahl
    app.auto_pol_switch2 = uiswitch(app.ssi_data_sub_tab);
    app.auto_pol_switch2.Position = [x_boundary+2.45*x_small y_sub_tab-240 app.auto_pol_switch.Position(3) app.auto_pol_switch.Position(4)];
    app.auto_pol_switch2.Items = {'Aus', 'An'};
    app.auto_pol_switch2.Value = 'Aus';

    % Label für Kriterien für Polauswahl
    app.criteria_label2 = uilabel(app.ssi_data_sub_tab, 'Text', 'Kriterien für Polauswahl: ');
    app.criteria_label2.Position = [x_boundary y_sub_tab-270 2.2*x_small y_fix];

    % Checkboxen für Kriterien
    app.criteria_stable_freq_check2 = uicheckbox(app.ssi_data_sub_tab, 'Text', 'Stabile Frequenz', 'Value', 1, 'Enable', 'off');
    app.criteria_stable_freq_check2.Position = [x_boundary+2.2*x_small y_sub_tab-270 200 y_fix];
    app.criteria_stable_damp_check2 = uicheckbox(app.ssi_data_sub_tab, 'Text', 'Stabiler Dämpfungsgrad', 'Value', 1, 'Enable', 'off');
    app.criteria_stable_damp_check2.Position = [x_boundary+2.2*x_small y_sub_tab-300 200 y_fix];
    app.criteria_mac_check2 = uicheckbox(app.ssi_data_sub_tab, 'Text', 'MAC-Bedingung erfüllt', 'Value', 1, 'Enable', 'off');
    app.criteria_mac_check2.Position = [x_boundary+2.2*x_small y_sub_tab-330 200 y_fix];

    % Label für Anzahl der Moden
    app.num_mode_label_ssi_data = uilabel(app.ssi_data_sub_tab, 'Text', 'Anzahl der Moden: ');
    app.num_mode_label_ssi_data.Position = [x_boundary y_sub_tab-360 2.2*x_small y_fix];

    % Radiobutton-Gruppe für Anzahl der Moden
    app.num_mode_radio_group_ssi_data = uibuttongroup(app.ssi_data_sub_tab);
    app.num_mode_radio_group_ssi_data.Position = [x_boundary+2.2*x_small y_sub_tab-390 2*x_small 2*y_fix+y_space];
    app.num_mode_radio_group_ssi_data.BorderColor = [0.94,0.94,0.94];

    % Radiobutton für unbekannt
    app.num_mode_unknown_ssi_data = uiradiobutton(app.num_mode_radio_group_ssi_data, 'Text', 'Unbekannt', 'Enable', 'off');
    app.num_mode_unknown_ssi_data.Position = [0 y_fix+y_space x_small y_fix];

    % Radiobutton für bekannt
    app.num_mode_known_ssi_data = uiradiobutton(app.num_mode_radio_group_ssi_data, 'Text', 'Bekannt', 'Enable', 'off');
    app.num_mode_known_ssi_data.Position = [0 0 x_small y_fix];    

    % Label für Mindestgröße eines Clusters
    app.min_cluster_size_label2 = uilabel(app.ssi_data_sub_tab, 'Text', 'Mindestgröße eines Clusters: ');
    app.min_cluster_size_label2.Position = [x_boundary y_sub_tab-420 2.2*x_small y_fix];

    % Spinner für Mindestgröße eines Clusters
    app.min_cluster_size_spinner2 = uispinner(app.ssi_data_sub_tab, 'Value', 4, ...
        'Step', 1, 'Limits', [1 100], 'Enable', 'off');
    app.min_cluster_size_spinner2.Position = [x_boundary+2.2*x_small y_sub_tab-420 x_small y_fix];

    % Hilfe für Mindestgröße eines Clusters
    app.min_cluster_size_help2 = uilabel(app.ssi_data_sub_tab, 'Text', '(?)');
    app.min_cluster_size_help2.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-420 0.2*x_small y_fix];
    app.min_cluster_size_help2.Tooltip = ['Sie legt fest, wie viele Pole ein Cluster mindestens erhalten muss, ' ...
        'um als gültig zu gelten. Kleine Werte erlauben auch einzelne Pole, große Werte erkennen nur mehrfach ' ...
        'auftretende stabile Pole an. WICHTIG: Ein Punkt auf Diagramm könnte zwei Pole umfassen!'];

    % Label für Cluster-Distanzschwelle
    app.cluster_distance_label2 = uilabel(app.ssi_data_sub_tab, 'Text', 'Cluster-Distanzschwelle: ');
    app.cluster_distance_label2.Position = [x_boundary y_sub_tab-450 2.2*x_small y_fix];

    % Spinner für Cluster-Distanzschwelle
    app.cluster_distance_spinner2 = uispinner(app.ssi_data_sub_tab, 'Value', 0.01, ...
        'Step', 0.001, 'Limits', [0.001 1], 'Enable', 'off');
    app.cluster_distance_spinner2.Position = [x_boundary+2.2*x_small y_sub_tab-450 x_small y_fix];

    % Hilfe für Cluster-Distanzschwelle
    app.cluster_distance_help2 = uilabel(app.ssi_data_sub_tab, 'Text', '(?)');
    app.cluster_distance_help2.Position = [x_boundary+3.2*x_small+x_space y_sub_tab-450 0.2*x_small y_fix];
    app.cluster_distance_help2.Tooltip = ['Sie legt fest, wie ähnlich sich Pole in Frequenz und Eigenform ' ...
        'sein müssen, um zu einem Cluster zusammenzufassen. Kleine Werte führen zu strengeren, große ' ...
        'zu weiter gefassten Clustern.'];

    % Label für Zielanzahl
    app.target_num_label_ssi_data = uilabel(app.ssi_data_sub_tab, 'Text', 'Zielanzahl der Moden: ');
    app.target_num_label_ssi_data.Position = [x_boundary y_sub_tab-480 2.2*x_small y_fix];

    % Spinner für Zielanzahl
    app.target_num_spinner_ssi_data = uispinner(app.ssi_data_sub_tab, 'Value', 5, ...
        'Step', 1, 'Limits', [1 20], 'Enable', 'off');
    app.target_num_spinner_ssi_data.Position = [x_boundary+2.2*x_small y_sub_tab-480 x_small y_fix];      

    % Button für Durchführen der Modalanalyse
    app.run_analysis_button = uibutton(app.parameter_tab, 'Text', 'Modalanalyse durchführen');
    app.run_analysis_button.Position = [x_boundary y_fig-y_sub_tab-130-3*y_space x_large y_fix];  
end