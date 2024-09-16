function pval=pr(n1,fh1length,FH2size,k,x,y,type)
    nN=n1+2*(fh1length-n1);
    nprime=((1./n1)+(1./nN)).^-1;
    b=FH2size;
    x2=b;
    y2=0;
    dotprod=(x*x2)+(y*y2);
    pval_dimer= (...
        (3./(2*pi.*nprime.*(k.^2))).^(3/2) .* ...
        exp( (3.*(b^2)) ./ (2*(k^2).*(n1+nN)) ).*...
        exp( (-3./(2.*(k^2))) .* ( ((x^2+y^2)./n1) + ((x^2+y^2+b^2-2.*dotprod)./nN) ) )...
    );
    pval_double=( ( 3./(2*pi.*n1.*(k^2)) ).^(3/2)) .* exp( -3.*(x^2+y^2)./(2.*n1.*(k^2)) ) ;

    pval_dimer=pval_dimer.*6.1503*10^7;
    pval_double=pval_double.*6.1503*10^7;

    if type=="dimer"
        pval=pval_dimer;
    elseif type=="double"
        pval=pval_double;
    elseif type=="ratio"
        pval=pval_dimer./pval_double;
    end
end