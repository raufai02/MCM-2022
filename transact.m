function [newHoldings, newWeights, fees] = transact(currentWeights, optimalWeights, currentHoldings)

    %take in two 3 element weight vectors and a vector with asset values,
    %return new Portfolio 
    %currentHoldings measures assets in USD
    alphaG = 0.01;
    alphaB = 0.02;
    delta = optimalWeights - currentWeights;
    newWeights = currentWeights;
    theoreticalCash = sum(currentHoldings);
    deltaAssets = (delta * theoreticalCash); % change in cash value for every asset

    fees = [0, alphaG, alphaB] .*abs(deltaAssets);
    %fees = [fees(1,3) + fees(1,2), 0, 0];
    newHoldings = currentHoldings;

    for i = 2:3
        if delta(i) < 0 %if stock is to be sold, move stock to cash and take out the fee
            %soldAmt = newHoldings(i) - deltaAssets(i);
            newHoldings(i) = newHoldings(i) - abs(deltaAssets(i)); %subtract change in USD from stock
            newHoldings(1) = newHoldings(1) + abs(deltaAssets(i)) - fees(i); %add the cash but minus the fees!
                    end
    end
    %recompute!!!
    newWeights = newHoldings ./ sum(newHoldings);
    delta = optimalWeights - newWeights;
    theoreticalCash = sum(newHoldings);
    deltaAssets = (delta * theoreticalCash); % change in cash value for every asset
    fees = [0, alphaG, alphaB] .*abs(deltaAssets);
    for i = 2:3
        if delta(i) > 0 %if stock is to be BOUGHT
            %buyAmt = deltaAssets(i); %amount to remove from cash = change!
            newHoldings(1) = newHoldings(1) - abs(deltaAssets(i));  %subtract from cash
            newHoldings(i) = newHoldings(i) + deltaAssets(i) - fees(i); %only add 99% of stock purchased!
        end
    end
    
    newWeights = newHoldings ./ sum(newHoldings);

    for i = 1:3
        if newHoldings(i) < 0.001
            newHoldings(i) = 0;
        end
    end

    fees = sum(fees);
   
    



