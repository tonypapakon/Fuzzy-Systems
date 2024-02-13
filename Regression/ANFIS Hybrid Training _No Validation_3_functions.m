%% Load data - Split data
Data = readtable('airfoil_self_noise.dat');
data = Data{:,:};
preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);
Perf=zeros(2,4);

%% Evaluation function
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);
Nsq = @(ypred,y) sum((ypred-y).^2)/sum((y-mean(y)).^2);

%% FIS with grid partition
fis=genfis1(trnData,3,'gbellmf','constant');
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);

plotmf(fis,'input',size(trnData,2)-1);

%% No Validation
figure(1);
plot(trnError,'LineWidth',2); grid on;
legend('Training Error');
xlabel('# of Iterations'); ylabel('Error');
title('ANFIS Hybrid Training - No Validation');
Y=evalfis(chkData(:,1:end-1),trnFis);
R2=Rsq(Y,chkData(:,end));
NMSE = Nsq(Y,chkData(:,end));
NDEI = sqrt(NMSE);
RMSE=sqrt(mse(Y,chkData(:,end)));
Perf(:,1)=[R2;RMSE];
figure(2);
plotmf(trnFis,'input',size(trnData,2)-1);