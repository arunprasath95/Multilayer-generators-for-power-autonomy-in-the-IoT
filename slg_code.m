file1 = dlmread('MFIA_reading_1.txt'); 
file2 = dlmread('MFIA_reading_2.txt');
file3 = dlmread('MFIA_reading_3.txt');
file4 = dlmread('MFIA_reading_4.txt');
file5 = dlmread('MFIA_reading_5.txt'); % n number of readings form the MFIA instrument

file_tot = file1 + file2 + file3 + file4 + file5 ; % adding all the readings
file_avg = file_tot / 5; % to get an average of the n number of readings

file(:,1) = file_avg(:,1);
file(:,2) = file_avg(:,2);

global zmes w 
zmes = file(:,2);
wmes = file(:,1);

kmsq = 0.05;
q = 40;
cp = 100 * 10.^-9;
wo = 240*pi;

w = wmes;
%% Equation obtained by using simplify() function in MATLAB

ztot = (q*w.^2*1i + w*wo - q*wo^2*1i)./(cp*w.*(q*wo^2 - q*w.^2 + kmsq*q*wo^2 + w*wo*1i));

%% lsqnonlin function

[zmax,I]= max(abs(zmes));
wres=w(I);
xo = [wres     ; 40  ; 100e-9 ; 0.05];
xmax=[wres*1.1 ; 150 ; 1000e-9 ; 0.9];
xmin=[wres*0.8 ; 20  ; 50e-9  ; 0.01];
options = optimset('TolFun',1e-12,'TolX',1e-9);

x = lsqnonlin(@(t) fit_result_imp(t),xo,xmin,xmax,options);

wo=x(1);
q=x(2);
cp=x(3);
kmsq=x(4);

zth=abs((q*w.^2*1i + w*wo - q*wo^2*1i)./(cp*w.*(q*wo^2 - q*w.^2 + kmsq*q*wo^2 + w*wo*1i)));

%% plot

figure(1)
plot(file(:,1),file(:,2))
xlabel('Frequency (Hz)')
ylabel('Impedance (KOhm)')
title('Resonance plot')
legend('Resonance curve')%,'location','southeast'
grid on

figure(2)
plot(w,zth,'-b',w,zmes,'.')
xlabel('Frequency (Hz)')
ylabel('Impedance (KOhm)')
title('Resonance plot comparision')
legend('Theoritical curve','Experiment curve','location','southeast')
grid on;