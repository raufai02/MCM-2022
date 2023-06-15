tic
table = readtable('BCHAIN-MKPRU.csv');
bValue = table2array(table(:,2));
b_date = datenum(table2array(table(:,1)));
mat = [b_date bValue];
index = isnan(mat(:,2));
mat(index,:) = []; %remove nan values
%plot(b_date,bValue)
g_table = readtable('LBMA-GOLD.csv');
g_value = table2array(g_table(:,2));

g_dates = datenum(table2array(g_table(:,1)));

gMat = [g_dates g_value];
idx = isnan(gMat(:,2));
gMatOld = gMat;
gMat(idx,:) = []; % remove nan values from data
%plot(g_dates, g_value)



s = size(b_date); s = s(1);
j = 1; k = 1;
sG = size(gMat); aux = zeros(sG(1), sG(2));
sg2 = size(gMatOld); 
aux2 = zeros(sg2(1), sg2(2));

for i = 1:s
    if mat(i,1) == gMat(j,1)
        aux(j,:) = mat(i,:); %copy entire row into aux array
        j = j+1;
    else
      %increment i
    end  
    if mat(i,1) == gMatOld(k,1)
        aux2(k,:) = mat(i,:);
        k= k+1;
    else
    end
end
%aux = all bitcoin weekday values
        
%%FILTER
 Fs = 100; % Sampling frequency of data (Hz) ie interval 
% % Design a 3rd order butterworth lowpass filter
 N3 = 3; %Order
 lb = 2.5/(0.5*Fs); % Lower cutoff frquency
 [b2,a2] = butter(N3,lb,'low');
f_Val = filtfilt(b2,a2,aux(:,2));

[b1,a1] = butter(N3, lb, 'low');

% f_G  =filtfilt(b1, a1, gMat(:,2));
% %plot(gMat(:,1), gMat(:,2));
% hold on
% %plot(gMat(:,1), f_G);
% hold off
% %figure()
% %plot(aux(:,1), aux(:,2));
% hold on
% %plot(aux(:,1), f_Val);
% hold off

%%

symbol=["Cash";"Gold";"Bitcoin"];
%maximize sharpe ratio
x= size(aux,1);
cash=ones(x,1);
%cashHoldings = [1000, 0, 0];
holdings = [1000, 0, 0];
w = [1,0,0];
interval = 1;
newHoldings = zeros(ceil(sG(1)/interval), 3);
newHoldings(1,:) = holdings;
weights = zeros(ceil(sG(1)/interval), 3);
weights(1,:) = w;
B_usdP = aux(1,2);
G_usdP = gMat(1,2);
feeMinimizer = zeros(300,1);
feeTot = zeros(300, 1);
for interval = 1:300
    weights = zeros(ceil(sG(1)/interval), 3);
    weights(1,:) = w;
    holdings = [1000, 0, 0];
    newHoldings = zeros(ceil(sG(1)/interval), 3);
    newHoldings(1,:) = holdings;
    w = [1,0,0];
    j=2;
    for i = 2:interval:sG(1)
        %every day
        returnB= tick2ret(aux(1:i,2));
        returnG= tick2ret(gMat(1:i,2));
        returnC= tick2ret(cash(1:i,1));
        returnTot =[returnC returnG returnB];
        
        B_usd = aux(i,2); %current B_usd value
        G_usd = gMat(i,2); %current gold usd value

        scalar(j,:) = [1, B_usd/B_usdP, G_usd/G_usdP]; %change in value since last transaction
        
        holdings = scalar(j,:) .* holdings;
       
        p = Portfolio('AssetList',symbol,'RiskFreeRate',0.00/252);
        [lb, ub, isbounded] = estimateBounds(p);
        p= estimateAssetMoments(p, returnTot);
        p=setDefaultConstraints(p);
        %p=setBudget(p, 0.8, 0.9);
       % p=setTurnover(p, 0.3)
        w1=estimateMaxSharpeRatio(p);
        w1 = w1';
        weights(j,:) = w1;
        %[risk1, ret1]=estimatePortMoments(p,w1)
        %transact (current, optimum, currentHoldings)
        [holdings, w1, fee] = transact(w, w1, holdings);
        feeTot(interval) = feeTot(interval) + fee;
        newHoldings(j,:) = holdings;
        w = w1; %update weights
        j=j+1;
        G_usdP = G_usd;
        B_usdP = B_usd;
    end
f = newHoldings(:,1) + newHoldings(:,2) + newHoldings(:,3);
feeMinimizer(interval) = f(end); %end return value
end
toc


    
    






