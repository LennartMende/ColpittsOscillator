%Zerlegung in System-, Ausgangs- und Eingangswirkung
f_ea = [
    -I_S*exp(-x2/U_T)/C1 + x3/C1;
    x3/C2;
    -x1/L - x2/L - R*x3/L
]
g_ea = [
    0, 0;
    0, -I0/C2;
    1/L, 0;
]
g_ea_u1 = [
    0;
    0;
    1/L;
]
g_ea_u2 = [
    0;
    -I0/C2;
    0;
]
h_ea = x1 %for y = xi set h_ea at position i to 1

%Lie-Ableitungen berechnen
Lf = h_ea;
r = 0;

L_fh = Lf;

while true
    LgLf = jacobian(Lf, x) * g_ea_u1;
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
L = L_nom / L_denom;