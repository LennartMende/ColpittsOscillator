function VDot = stability(x, f, V)
    grad = gradient(V,x)
    VDot = 0;
    for i=1:length(x)
        VDot = VDot + grad(i) * f(i);
    end
end