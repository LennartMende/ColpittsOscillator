%% ============================================================
%  3D-ZUSTANDSRAUMDARSTELLUNG
%  3 EINZELPLOTS – OPTIMALER BLICKWINKEL
%% ============================================================

%% Farben
c1 = [0.85 0 0];    % Rot   – Messung 1
c2 = [0 0.6 0];     % Grün  – Messung 2
c3 = [0 0 0.85];    % Blau  – Messung 3

%% ============================================================
%  Figure: echtes Vollbild
%% ============================================================

figure('Color','w')
set(gcf,'Units','normalized','OuterPosition',[0 0 1 1])

%% ============================================================
%  Manuelle Achspositionen
%  [left bottom width height]
%% ============================================================

pos1 = [0.05 0.12 0.26 0.76];   % Messung 1
pos2 = [0.37 0.12 0.26 0.76];   % Messung 2 (mehr Abstand)
pos3 = [0.69 0.12 0.26 0.76];   % Messung 3

%% -------------------------------
% Messung 1
% -------------------------------
axes('Position', pos1)
plot3( out.u1_1.signals.values, ...
       out.u2_1.signals.values, ...
       out.il_1.signals.values * 1e3, ...
       'LineWidth', 2, 'Color', c1 )

grid on
box on
xlabel('$U_1$ [V]', 'Interpreter','latex', 'FontSize', 18)
ylabel('$U_2$ [V]', 'Interpreter','latex', 'FontSize', 18)
zlabel('$I_L$ [mA]', 'Interpreter','latex', 'FontSize', 18)
title('Messung 1', 'Interpreter','latex', 'FontSize', 20)

view(45,30)
set(gca,'FontSize',18)

%% -------------------------------
% Messung 2
% -------------------------------
axes('Position', pos2)
plot3( out.u1_2.signals.values, ...
       out.u2_2.signals.values, ...
       out.il_2.signals.values * 1e3, ...
       'LineWidth', 2, 'Color', c2 )

grid on
box on
xlabel('$U_1$ [V]', 'Interpreter','latex', 'FontSize', 18)
ylabel('$U_2$ [V]', 'Interpreter','latex', 'FontSize', 18)
zlabel('$I_L$ [mA]', 'Interpreter','latex', 'FontSize', 18)
title('Messung 2', 'Interpreter','latex', 'FontSize', 20)

view(45,30)
set(gca,'FontSize',18)

%% -------------------------------
% Messung 3
% -------------------------------
axes('Position', pos3)
plot3( out.u1_3.signals.values, ...
       out.u2_3.signals.values, ...
       out.il_3.signals.values * 1e3, ...
       'LineWidth', 2, 'Color', c3 )

grid on
box on
xlabel('$U_1$ [V]', 'Interpreter','latex', 'FontSize', 18)
ylabel('$U_2$ [V]', 'Interpreter','latex', 'FontSize', 18)
zlabel('$I_L$ [mA]', 'Interpreter','latex', 'FontSize', 18)
title('Messung 3', 'Interpreter','latex', 'FontSize', 20)

view(45,30)
set(gca,'FontSize',18)
