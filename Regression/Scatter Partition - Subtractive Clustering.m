%% Load data - Split data
Data = readtable('train.csv');
data = Data{:,:};
preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);
Perf=zeros(2,4);

%% Evaluation function
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);
Nsq = @(ypred,y) sum((ypred-y).^2)/sum((y-mean(y)).^2);

%% Scatter Partition - Subtractive Clustering
fis=genfis2(trnData(:,1:end-1),trnData(:,end),0.5);
plotmf(fis,'input',size(trnData,2)-1);

[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);

figure(1);
plot([trnError valError],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('ANFIS Hybrid Training - Validation');
Y=evalfis(chkData(:,1:end-1),valFis);
NMSE = Nsq(Y,chkData(:,end));
NDEI = sqrt(NMSE);
R2=Rsq(Y,chkData(:,end));
RMSE=sqrt(mse(Y,chkData(:,end)));
Perf(:,3)=[R2;RMSE];
figure(2);
plotmf(valFis,'input',size(trnData,2)-1);
