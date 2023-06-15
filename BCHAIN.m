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
j = 1; k = 1
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

f_G  =filtfilt(b1, a1, gMat(:,2));
plot(gMat(:,1), gMat(:,2));
hold on
plot(gMat(:,1), f_G);
hold off

figure()


plot(aux(:,1), aux(:,2))
hold on
plot(aux(:,1), f_Val)
hold off