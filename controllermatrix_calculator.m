clear; clc; close all;

%% ============================================================
%  Parameterdefinition
% =============================================================
k  = 1.380649e-23;
e  = 1.602176634e-19;
T  = 25 + 273.15;
UT = k*T/e;

IS = 1e-8;
R  = 1e3;
L  = 10e-3;
C1 = 100e-9;
C2 = 1e-6;

%% ============================================================
%  Symbolische Variablen
% =============================================================
syms U1 U2 IL U0 I0 real

x = [U1; U2; IL];
u = [U0; I0];

%% ============================================================
%  Nichtlineares Zustandsmodell
% =============================================================
f1 = -(IS/C1)*exp(-U2/UT) + (1/C1)*IL;
f2 = (1/C2)*IL - (1/C2)*I0;
f3 = -(1/L)*U1 - (1/L)*U2 - (R/L)*IL + (1/L)*U0;

f = [f1; f2; f3];

%% ============================================================
%  Arbeitspunkt (numerisch festlegen!)
% =============================================================
U0_val = 12;
I0_val = 2.9e-3;

%% ============================================================
%  Gleichgewichtspunkt numerisch berechnen
% =============================================================
f_num = subs(f, u, [U0_val; I0_val]);

eq = solve(f_num == 0, x, 'Real', true);

U1_bar = double(eq.U1);
U2_bar = double(eq.U2);
IL_bar = double(eq.IL);

x_bar = [U1_bar; U2_bar; IL_bar];

disp('Numerischer Gleichgewichtspunkt x_bar:')
disp(x_bar)

%% ============================================================
%  Linearisierung (A- und B-Matrix)
% =============================================================
A_sym = jacobian(f, x);
B_sym = jacobian(f, u);

A = double(subs(A_sym, [x; u], [x_bar; U0_val; I0_val]));
B = double(subs(B_sym, [x; u], [x_bar; U0_val; I0_val]));

disp('Matrix A:')
disp(A)

disp('Matrix B:')
disp(B)

%% ============================================================
%  Regelbarkeit prüfen
% =============================================================
Co = ctrb(A, B);
rankCo = rank(Co);

fprintf('Rank(ctrb(A,B)) = %d\n', rankCo);

if rankCo < 3
    error('System ist nicht vollständig regelbar.');
end

%% ============================================================
%  Soll-Eigenwerte (komplexes Paar + reell)
% =============================================================
desired_poles = [ ...
    -200 + 200i;
    -200 - 200i;
    -500 ];

disp('Vorgegebene Soll-Eigenwerte:')
disp(desired_poles)

%% ============================================================
%  Reglermatrix G berechnen
% =============================================================
G = place(A, B, desired_poles);

disp('Reglermatrix G:')
disp(G)

%% ============================================================
%  Überprüfung: Eigenwerte des geschlossenen Systems
% =============================================================
eig_closed = eig(A - B*G);

disp('Eigenwerte von (A - B*G):')
disp(eig_closed)

%% ============================================================
%  Abschlussmeldung
% =============================================================
fprintf('\nErfolg: Komplexe Soll-Eigenwerte wurden korrekt platziert.\n');
