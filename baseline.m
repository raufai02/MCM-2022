%baseline tests


gold = [0, 1000, 0];

bitcoin = [0, 0, 1000];

balanced = [333.33, 333.33, 333.33]
B_usdP = aux(1,2); %current B_usd value
G_usdP = gMat(1,2); %current gold usd value

B_usd = aux(end,2);
G_usd = aux(end,2);

scalar = [1, B_usd/B_usdP, G_usd/G_usdP]; %change in value since last transaction

gold = scalar .* gold

bitcoin = scalar .* bitcoin

balanced = scalar .*balanced