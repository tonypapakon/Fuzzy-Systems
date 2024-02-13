%% Load data - Split data
data=load('haberman.data');
preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);


%% ANFIS - Grid Partition
fis=genfis1(trnData,2,'gaussmf','constant');
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);
plot([trnError valError],'LineWidth',2); grid on;
legend('Training Error','Validation Error');
xlabel('# of Epochs');
ylabel('Error');
title('ANFIS Classification with Grid Partition');
Y=evalfis(tstData(:,1:end-1),valFis);
Y=round(Y);

diff=tstData(:,end)-Y;
Acc=(length(diff)-nnz(diff))/length(Y)*100;

%%Clustering Per Class
radius=0.5;
[c1,sig1]=subclust(trnData(trnData(:,end)==1,:),radius);
[c2,sig2]=subclust(trnData(trnData(:,end)==2,:),radius);
num_rules=size(c1,1)+size(c2,1);



[rowc1 colc1] = size(c1);

for i = 1:rowc1
for j = 1:(colc1-1)
C1(i,j) = c1(i,j);
end
end


[rowc2 colc2] = size(c2);

for i = 1:rowc2
for j = 1:(colc2-1)
C2(i,j) = c2(i,j);
end
end


[rowC1 colC1] = size(C1);
[rowC2 colC2] = size(C2);

%N = 0;
Xii = 0;
for i = 1:rowC1
for j = 1:(colC1)
if i==j;

Xii = Xii + C1(i,j);

%N = N + 1;
end
end
end


N = 0;
for i = 1:rowC1
for j = 1:(colC1)
N = N + 1;
end
end


%N = 0;
Xii2 = 0;
for i = 1:rowC2
for j = 1:(colC2)
if i==j;

Xii2 = Xii2 + C2(i,j);

%N = N + 1;
end
end
end

%N2 = 0;
for i = 1:rowC2
for j = 1:(colC2)
N2 = N2 + 1;
end
end


for i = 1:rowC1
Xir(i) = sum(C1(i,:));
end


for j = 1:colC1
Xjc(j) = sum(C1(:,j));
end

for i = 1:rowC1
Xic(i) = sum(C1(i,:));
end

for i = 1:rowC1;
UA(i) = Xii/Xir(i);
end

for j = 1:colC1;
PA(j) = Xii/Xjc(j);
end


OA = Xii/N;

XirXic = 0;
XicXir = 0;
for i = 1:rowC1
XirXic = XirXic + Xir(i)*Xic(i);
XicXir = XicXir + Xic(i)*Xir(i);
end


Kc1 = (N*Xii - XirXic)/(N^2 - XicXir);


OA2 = Xii2/N2;

for i = 1:rowC2
Xir2(i) = sum(C2(i,:));
end


for j = 1:colC2
Xjc2(j) = sum(C2(:,j));
end

for i = 1:rowC2
Xic2(i) = sum(C2(i,:));
end

for i = 1:rowC2;
UAc2(i) = Xii2/Xir2(i);
end

for j = 1:colC2;
PAc2(j) = Xii2/Xjc2(j);
end



Xir2Xic2 = 0;
Xic2Xir2 = 0;
for i = 1:rowC1
Xir2Xic2 = Xir2Xic2 + Xir2(i)*Xic2(i);
Xic2Xir2 = Xic2Xir2 + Xic2(i)*Xir2(i);
end


K2 = (N*Xii2 - Xir2Xic2)/(N^2 - Xic2Xir2);