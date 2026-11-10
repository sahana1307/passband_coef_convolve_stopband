%showBand_return_averaged_spectras_v1.m
% will return "nsets" sets of "nAvgerages" time averaged spectras
% USAGE eg.:  Yarray=showBand_return_averaged_spectras_v1(chout,1,499,8); 
% will take chout as the input data array 
% (chout.dat produced by doing: seperate12_TCchannelsV2c RECON.DAT chout.dat 25600 >/dev/null )
% "1" is module number, "499" is no of averages to be done per spectra, 
% "8" is no of averaged sets to be produced. 
% Yarray is the returned data, it is an array of diamention (256 X noOfSets)  
%  
%           -TP, 11-04-2008 RAC OOTY
%showBand_v1d.m
% modifications for RMS test 10Apr2008 SV,TP RAC 
% showBand_v1c.m 
% 8apr08 changes in total power calculation 
% and 512 point spectrum instead of 500pt 
%  tp RAC, 2may07 tp  RAC-OOTY tp 17-Mar-07
function Y=return_averaged_spectras_v1b(ipdata,chNo,nAvgerages,nSets, npt)
row=length(ipdata)

 Fstart= 31.85;
 Fend=30.625;

aspec = zeros;
aspecA(1:npt,nSets) = zeros;

%npt = 512;

totalSpectrasAsked = nAvgerages *nSets  % no of spectras to be computed

NoOfAvailableSpectras = floor(row/npt)-1 

diff = totalSpectrasAsked - NoOfAvailableSpectras
if totalSpectrasAsked <= NoOfAvailableSpectras % check if enough data is available, else exit
 for set=1:nSets 
 set;
  for I= 1: nAvgerages %nspectra
  I;
    startNo = I*npt +  (set-1)*nAvgerages*npt ;
    endNo = startNo+npt ;
    startNo = startNo+1;
    spc= (abs(fft(ipdata(startNo:endNo,chNo)))).^2;
    
    %aspec=aspec+abs(fft(ipdata(startNo:endNo,chNo))).^2;
    %aspecA(1:256,set)=aspecA(1:256,set) + spc(1:256,1);
    aspecA(:,set)=aspecA(:,set) + spc(:,1);
    %specSet(1:256,I)= spc(1:256,1); 
  end;
  
  aspecA(:,set)=fftshift(aspecA(:,set)./nAvgerages);
  
 end; 
 size(spc) ;
 size(aspecA);
 
%aspec=aspec./nAvgerages;  %nspectra;

freq(1:256) = (Fstart  - ((Fstart - Fend)/255)*(0:255)) ;

%logOfspec = 10*(log10(aspec(1:npt/2)));
%plot(freq,aspec(1:npt/2),";;");  % Y in linear scale 
%plot(freq,logOfspec,";;");       % Y in dB scale  
%grid on

%Y = sum(aspec(2:npt/2));
%rm = std(aspec(2:npt/2))

%Y(1,1) = rm;
%Y(2,1) = aspec(1)/(npt) + sum(aspec(2:((npt/2)-1))/(sqrt(2)*npt/2)) + aspec(npt/2)/(npt);
%Y=specSet;
disp 'DONE.'
Y= aspecA;
else 
  disp 'processing NOT DONE.'
  disp 'There is NOT Enough DATA'
  disp 'Try reducing no. of sets OR no. of averagss per set. Exiting!'
  Y(1:2,1) =0;
end;
%Y=aspec(1)/2 + sum(aspec(2:npt/2));
