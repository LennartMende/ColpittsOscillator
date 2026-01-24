function eqPositions = equilPositions(f,x)
    eqn = f == [0;0;0];
    eqPositions = solve(eqn, [x(1), x(2), x(3)],  ReturnConditions=true);
end