function Z = model( X, Y, params )
    Z = (log10(Y).^params.k3).*(params.k1-params.k2.*X.^.5)-params.k4;
end
