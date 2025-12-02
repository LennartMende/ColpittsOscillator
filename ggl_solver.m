clear; clc;

% === Define symbolic variables ===
UT = 26e-3;
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

equilibrium_point = solve(equations, variables, ReturnConditions=true)

% extract results for each variable
U1_bar = equilibrium_point.U1;
U2_bar = equilibrium_point.U2;
IL_bar = equilibrium_point.IL;

% conclude as equilibrium point vector
equilibriumPointVector = [U1_bar, U2_bar, IL_bar];

% calculate the Jacobian matrix at the equilibrium point
J = jacobian([f1, f2, f3], [U1, U2, IL]);

U0_val = 12;
I0_val = 2.86e-3;

% substitute the equilibrium expressions into the Jacobian
Ji_sym = subs(J, [U1, U2, IL], [U1_bar, U2_bar, IL_bar])

% substitute numerical values for U0 and I0
Ji_wp = subs(Ji_sym, [U0, I0], [U0_val, I0_val])

% compute eigenvalues
eigenvalues = eig(Ji_wp)
