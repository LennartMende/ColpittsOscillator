%jac: allg. Jacobi-Matrix, opJac: Jac-Matrix am AP,
%eigenvalues: Eigenwerte von opJac, stabFlag: 0 = instabil, 1 = stabil
function [jac, opJac, eigenvalues] = linStability(x, f, eqPos)
    disp(f)
    jac = jacobian(f);
    opJac = subs(jac, [x(1), x(2), x(3)], [eqPos.x1, eqPos.x2, eqPos.x3]);
    eigenvalues = eig(opJac);
end