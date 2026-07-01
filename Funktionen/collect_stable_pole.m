%% Funktion zum Sammeln stabiler Pole
% Author: Qiao Dawn Puah
% Datum letzter Bearbeitung: 30.06.2026

% Übergabeparameter:    all_pole = Alle Pole
%                       crit_stable_freq_tick = Wahl für stabile Frequenz
%                       crit_stable_damp_tick = Wahl für stabilen Dämpfungsgrad
%                       crit_mac_tick = Wahl für "MAC-Bedingung erfüllt"

% Ausgabeparameter:     all_pole = Alle Pole mit Flaggen
%                       stable_idx = Indizes der stabilen Pole

function [all_pole, stable_idx] = collect_stable_pole(all_pole, crit_stable_freq_tick, crit_stable_damp_tick, crit_mac_tick)

    % Anzahl der Pole
    N = numel(all_pole);

    % Wahr für alle Pole
    mask = true(N,1);

    % Wenn stabile Frequenz als Kriterium gewählt wurde
    if crit_stable_freq_tick

        % Pole mit stabiler Frequenz weiter betrachten
        mask = mask & [all_pole.is_stable_freq]';
    end

    % Wenn stabiler Dämpfungsgrad als Kriterium gewählt wurde
    if crit_stable_damp_tick

        % Pole mit stabilem Dämpfungagrad weiter betrachten
        mask = mask & [all_pole.is_stable_damp]';
    end

    % Wenn "MAC-Bedingung erfüllt" als Kriterium gewählt wurde
    if crit_mac_tick

        % Pole mit "MAC-Bedingung erfüllt" weiter betrachten
        mask = mask & [all_pole.is_mac]';
    end

    % Wahre Pole als "stabil" markieren
    for k = 1:N
        all_pole(k).is_stable = mask(k);
    end

    % Indizes holen
    stable_idx = find(mask);
end