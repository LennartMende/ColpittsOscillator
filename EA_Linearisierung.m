syms x1 x2 x3 real

R = 1e+3;
L = 100e-3;
C1 = 100e-9;
C2 = 1e-6;

UT = 25.693e-3;
IS = 10e-9;

U0 = 12;
I0 = 10e-3;

f = [
    -IS*exp(-x2/UT)/C1 + x3/C1;
    x3/C2 - I0/C2;
    -x1/L - x2/L - R*x3/L + U0/L
];
n = 3
x = [x1, x2, x3];

% Entwurf der E/A-Linearisierung:
%Zerlegung in System-, Ausgangs- und Eingangswirkung
f_ea = [
    -I_S*exp(-x2/U_T)/C1 + x3/C1;
    x3/C2;
    -x1/L - x2/L - R*x3/L
]
g_ea = [
    0, 0;
    0, -1/C2;
    1/L, 0;
]
g_ea_u0 = [
    0;
    0;
    1/L;
]
g_ea_i0 = [
    0;
    -1/C2;
    0;
]
h_ea = x1 %for y = xi set h_ea at position i to 1

%Lie-Ableitungen berechnen
Lf = h_ea;
r = 0;

L_fh = Lf;

while true
    LgLf = jacobian(Lf, x) * g_ea_u0;
    if LgLf ~= 0
        break;
    end
    Lf = jacobian(Lf, x) * f_ea;
    Lf_h =Lf;
    r = r + 1;
end

r = r + 1


syms v
L_nom = v - L_fh;  % letzte Lf
L_denom = LgLf;
L = L_nom * pinv(L_denom);


% Regelung mit Polvorgabe
poles = [-200+200i, -200-200i, -500];
a = poly(poles);