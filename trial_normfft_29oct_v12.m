clear all;close all;

%x_in = randn(1,204800000);
%y_in = randn(1,204800000);
%cdata1 = complex(x_in,y_in);

%cdata = transpose(cdata1);
%load cdata_toloadint32.mat;
cdata = complex(randn(1,320000000),randn(1,320000000));
cdata = transpose(cdata);

SegLen= 320000000;
dataSeg2 = cdata(1:SegLen);

Fs = 8e9;
dt = 1/Fs;                    

StopTime = SegLen*dt          % seconds
t = (0:dt:StopTime-dt)';     % seconds


fileID1 = fopen('coeffcient_and_pbf_quanti_9nov26.txt', 'w');
fileID2 = fopen('LMnotfound.txt', 'w');



Fc2 = 0.38884;
%dSampFact =8;
dataseg2_shifted = double(dataSeg2).*(exp(-1j*2*pi* Fc2*t));
%ufact=3;

%load filterDescoef.mat;





deltaf = 1800;
k = 2222;
%%DDC egres sample rate
fr = (2.2*10^6 + k)*(1.5*deltaf);

req_band = 2.5*10^9; %% Apass in f


                ddc_rate = 7.9279992; %G

                
                M_down = 4;%1 % 41;
                L_up = 3;%5 % 29;
                

                
                %fr = 5.946;
                %% oversampling factor
                
                Oa = fr/(2*req_band);
                % Oa = 1;
                % Oa = 1.171314783;
                
                
                denom = 2*Oa*M_down;
                
                
                pbf = 1/denom;
                sbf = ((2*Oa)-1)/denom; % TG p#96 fig 4-34
                stopbandattn = 50;
                pb_ripple = 0.245;
                %pb_ripple = 1.4;
                [pbf,sbf,pb_ripple,stopbandattn ]
                
                % 
                % N = 400;
                % Fp = 0.065;
                % Fst = 0.0724;
                % Hf = fdesign.lowpass('N,Fp,Fst',N,Fp,Fst);

                %spdec = (60-40)/(1-Fst)

                %Hd4 = design(Hf,'equiripple',StopbandShape='linear',StopbandDecay=25,SystemObject=true);
                
                load complexlowpassfir2_Num.mat;
                %load Num2.mat;
                coeff_length = length(complexlowpassfir1_Num);
                
                
                bpfc = 1/(2*(M_down));
                width = (L_up/(M_down*Oa));
                %new_bpfc = -(bpfc - (0.5*width))-0.022; %revsit 0.022 fudge factor
                %new_bpfc = -(bpfc - (0.5*width))+0.05;
                %new_bpfc = -(bpfc - (0.5*width));
                %Hbp2 = clone(Hlp2);
                filterDescoef = modulateFIR(complexlowpassfir1_Num,bpfc); 
                
                
                
                
                uSampData = upSample(dataseg2_shifted,L_up);
                
                %filtercoef = (ufact*filterDescoef)/dSampFact;
                filtercoef = filterDescoef;
                convdataupfr = conv(uSampData,filtercoef,'valid');
                %convdataupfr = conv(dataseg2_shifted,filtercoef,'valid');
                
                dSampData_realr =  downsample(real(convdataupfr),M_down);
                
                
len_y = length(dSampData_realr);
nfft_real  = 8192*2*2*2;
nsets = 1;
navg  = len_y/nfft_real-2;
colNo = 1;

avg_result = (return_averaged_spectras_v1b(dSampData_realr,colNo,navg,nsets,nfft_real)/nfft_real );

norm_data = avg_result/max(avg_result);


                log_norm_realr = 10*log10(norm_data);
                %subplot(2,1,1)
                hold on;
               plot(log_norm_realr)





                start_idx1 = (nfft_real/2)+2;
                end_idx1 = (nfft_real/2)+(nfft_real/4);
                start_idx2 = (nfft_real/2)+(nfft_real/4);
                end_idx2 = nfft_real;
                x_axis2_real = -1:(2/nfft_real):(1-(2/nfft_real));




            indexatxzero = find(x_axis2_real == 0);
            y_dBsr = log_norm_realr(indexatxzero);
            y_dBer = log_norm_realr(nfft_real);



                                                    log_norm_real_fidx1r = log_norm_realr(start_idx1:end_idx1);
                                                    
                                                    x_axis2_real_idx1   = x_axis2_real(start_idx1:end_idx1);
                                                    
                                                    
                                                    [idxval1r] = find((log_norm_real_fidx1r> -3.15) & (log_norm_real_fidx1r <= -3));
                                                    
                                                   if isempty(idxval1r)
                                                            fprintf(fileID2,'%d,%d\n',M_down,L_up);
                                                            vfname  = strcat("logfile",num2str(M_down),num2str(L_up),"octo30",".mat")
                                                            save(vfname,'log_norm_realr')
                                                   else
                                                    %temp_array = [log_norm_real_fidx1(idxval1(1))];
                                                    temp_arrayr = [log_norm_real_fidx1r(idxval1r(1))];
                                                    
                                                     
                                                    
                                                    for checkidx = 2: length(idxval1r)
                                                        temp_arrayr = [temp_arrayr,log_norm_real_fidx1r(idxval1r(checkidx))];
                                                        
                                                    end    

                                                    
                                                     
                                                    addthree_arrr = temp_arrayr+3;
                                                    
                                                    findmaxr = max(addthree_arrr);
                                                    
                                                    
                                                    
                                                    indexfind1r = find(addthree_arrr == findmaxr);
                                                    
                                                    
                                                    
                                                    findidxvalr = idxval1r(indexfind1r);
                                                    

                                                    x_pbfstrtr   = x_axis2_real_idx1(findidxvalr);
                                                    


                                                       
                                                    clear addthree_arrr;
                                                    clear findmaxr;   


                                                   
                                                    log_norm_real_fidx2r = log_norm_realr(start_idx2:end_idx2);
                                                    
                                                    x_axis2_real_idx2   = x_axis2_real(start_idx2:end_idx2);
                                                    
                                                    
                                                    [idxval2r] = find((log_norm_real_fidx2r> -3.15) & (log_norm_real_fidx2r <= -3));
                                                    



                                                   if isempty(idxval2r)
                                                            fprintf(fileID2,'%d,%d\n',M_down,L_up);
                                                            vfname  = strcat("logfile",num2str(M_down),num2str(L_up),"octo30",".mat")
                                                            save(vfname,'log_norm_realr')


                                                   else
                                                    temp_array2r = [log_norm_real_fidx1r(idxval2r(1))];
                                                    
                                                    
                     


                                                    for checkidx = 2: length(idxval2r)
                                                        temp_array2r = [temp_array2r,log_norm_real_fidx1r(idxval2r(checkidx))];
                                                        
                                                    end 
                                                 

                                                    addthree_arrr = temp_array2r+3;
                                                    
                                                    findmaxr = max(addthree_arrr);
                                                    
                                                    
                                                    
                                                    indexfind2r = find(addthree_arrr == findmaxr);
                                                    
                                                    
                                                    
                                                    findidxval2r = idxval2r(indexfind2r);
                                                    

                                                    x_pbfendr   = x_axis2_real_idx2(findidxval2r);
                                                    

                                                    pbf_calculatedr = ((x_pbfendr-x_pbfstrtr)*(ddc_rate/2)*L_up)/M_down;
                                                    


           
                                                    fprintf(fileID1,'%d,%d,%d,%f,%f,%f\n',coeff_length,M_down,L_up,pbf_calculatedr,y_dBsr,y_dBer);
                                                   [pbf_calculatedr,y_dBsr,y_dBer,coeff_length]
                                                   
                                                   end
                                                   end 


clear temp_array2;
clear temp_array;
clear temp_arrayr;
clear temp_array2r;

%end


plot(log_norm_realr)
fclose(fileID1);