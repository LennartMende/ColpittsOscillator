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
h_ea = U2 %for y = xi set h_ea at position i to 1

%Lie-Ableitungen berechnen
Lf = h_ea;
Lf_h = Lf;
r = 0;

Lf_r = sym(zeros(10,1))
Lf_r(1) = Lf_h

while true
    LgLf = jacobian(Lf, x) * g_ea % x = [U1; U2; IL]
    if LgLf ~= 0
        % vermutlich notwendig, um L_f^r h anstelle von L_f^{(r-1)} h zu
        % erhalten
        Lf = jacobian(Lf, x) * f_ea
        Lf_h = Lf
        %
        break;
    end
    Lf = jacobian(Lf, x) * f_ea % x = [U1; U2; IL], Lf = IL/C2
    Lf_h = Lf
    Lf_r(r+2) = Lf_h
    r = r + 1
end

r = r + 1

disp(Lf_r)

syms v
L_nom = v - Lf_h % letzte Lf
L_denom = LgLf
L = L_nom * pinv(L_denom)

%syms U2_ref Kp
%v = Kp * (U2_ref - U2);