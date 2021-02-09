function res = fit_result_imp(x)
global zmes w
wo=x(1);
q=x(2);
cp=x(3);
kmsq=x(4);

zth=abs((q*w.^2*1i + w*wo - q*wo^2*1i)./(cp*w.*(q*wo^2 - q*w.^2 + kmsq*q*wo^2 + w*wo*1i)));

res=zth - zmes;

%% Un-comment the line if wanted to see the adjustments in the graph in each stage

% figure(1) 
% plot(w,zth,'-b',w,zmes,'.')
% pause(0.5)