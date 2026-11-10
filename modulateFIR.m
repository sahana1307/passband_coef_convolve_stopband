function modNum = modulateFIR(Num,Fc)
    N = length(Num)-1;
    modNum = Num.*exp(1j*Fc*pi*(0:N));
end