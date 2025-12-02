clear; clc;

% === Define symbolic variables ===
k = 1.380649e-23;
e = 1.602176634e-19;
T_C = 25;
T = T_C + 273.15;
UT = k*T/e
IS = 1e-8;
R = 10e3;
L = 0.1;
C1 = 100e-9;
C2 = 1e-6;

syms U1 U2 IL U0 I0 real;

% === Define system equations ===
f1 = -(IS/C1)*exp(-U2/UT) + (1/C1)*IL;                 % dU1/dt
f2 = (1/C2)*IL - (1/C2)*I0;                            % dU2/dt
f3 = -(1/L)*U1 - (1/L)*U2 - (R/L)*IL + (1/L)*U0;       % dIL/dt

% === Solve for equilibrium: f(x*) = 0 ===
equations = [f1 == 0, f2 == 0, f3 == 0];
variables = [U1, U2, IL];

equilibrium_point = solve(equations, variables, ReturnConditions=true);

% extract results for each variable
U1_bar = equilibrium_point.U1;
U2_bar = equilibrium_point.U2;
IL_bar = equilibrium_point.IL;

% conclude as equilibrium point vector
equilibriumPointVector = [U1_bar; U2_bar; IL_bar]

% calculate the Jacobian matrix at the equilibrium point
J = jacobian([f1, f2, f3], [U1, U2, IL])

% substitute the equilibrium expressions into the Jacobian
Ji_sym = subs(J, [U1, U2, IL], [U1_bar, U2_bar, IL_bar])

% Jacobi-Matrix an Gleichgewichtspunkt ausgewertet (symbolisch in I0)
J_eq = subs(J, [U1 U2 IL], [U1_bar U2_bar IL_bar]);

% === Einsetzen des Eingangsspannung U0 ===
U0_val = 12;
I0_val = 2.82618e-3;

J_eq = subs(J_eq, U0, U0_val);

% === Bedingung: Eigenwerte sollen rein imaginär werden ===
% Wir setzen λ = i*w und fordern det(J - i*w*I) = 0
syms w real
lambda = 1i*w;

P = det(J_eq - lambda*eye(3));

% Real- und Imaginärteil
eq_real = simplify(real(P));
eq_imag = simplify(imag(P));

% === Lösung für w aus imag(P)=0 (nicht w=0!) ===
sol_w = solve(eq_imag == 0, w, 'Real', true);
sol_w = sol_w(sol_w ~= 0);  % ω != 0

% === Lösung für I0 aus real(P)=0 ===
sol_I0 = simplify(solve(subs(eq_real, w, sol_w) == 0, I0));

% === Numerische Auswertung ===
I0_crit = double(sol_I0);

fprintf('I0_crit = \n\n    %.6g A\n', I0_crit);

% substitute numerical values for U0 and I0
Ji_wp = subs(Ji_sym, [U0, I0], [U0_val, I0_val])

% compute eigenvalues
eigenvalues = eig(Ji_wp);

% numerisch auswerten (double-Genauigkeit)
lambda_num = double(eigenvalues);

% Real- und Imaginärteil getrennt
Re_lambda = real(lambda_num);
Im_lambda = imag(lambda_num);

% Ausgabe mit begrenzter Anzahl von Nachkommastellen
fprintf('\neigenvalues =\n\n');
for k = 1:length(lambda_num)
    fprintf('   %.4f +  %.4fi\n', Re_lambda(k), Im_lambda(k));
end
fprintf('\n')
