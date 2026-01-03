R = 1e+3;
L = 100e-3;
C1 = 100e-9;
C2 = 1e-6;

k  = 1.380649e-23;
e  = 1.602176634e-19;
T  = 25 + 273.15;
UT = k*T/e;
I_S = 10e-9;

syms U1 U2 IL U0 I0
x = [U1, U2, IL];
%Zerlegung in System-, Ausgangs- und Eingangswirkung
f_ea = [
    -I_S*exp(-U2/UT)/C1 + IL/C1;
    IL/C2;
    -U1/L - U2/L - R*IL/L
]
g_ea = [
    0, 0;
    0, -1/C2;
    1/L, 0;
]
g_ea_U0 = [
    0;
    0;
    1/L;
]
g_ea_I0 = [
    0;
    -I0/C2;
    0;
]
h_ea = IL %for y = xi set h_ea at position i to 1

%Lie-Ableitungen berechnen
Lf = h_ea;
r = 0;

L_fh = Lf;

while true
    LgLf = jacobian(Lf, x) * g_ea_I0;
    if LgLf ~= 0
        break;
    end
    Lf = jacobian(Lf, x) * f_ea;
    Lf_h =Lf;
    r = r + 1;
end

r = r + 1


syms v
L_nom = v - Lf_h;  % letzte Lf
L_denom = LgLf;
L = L_nom / L_denom;