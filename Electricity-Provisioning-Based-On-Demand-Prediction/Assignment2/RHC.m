% Choosing a home number -------------------------------------------------
home_num = input('Enter the number of the desired home (1-10): ');
if home_num == 4
    data = csvread('HousePredictionsRidge/House_4_RidgeRegression.csv');
elseif home_num == 9
    data = csvread('HousePredictionsRidge/House_9_RidgeRegression.csv');
elseif home_num == 10
    data = csvread('HousePredictionsRidge/House_10_RidgeRegression.csv');
else
    disp('Not a valid home number');
    return
end

T = 4*24*7;
y = data;
objlist(1) = 0;
predictionHorizon = 5;
optValues = zeros(T,1);
B = [0.1 1 5 10 100];
for j = 1:numel(A)
    b = B(j);
    for horizonStart = 1:T
        horizonEnd = horizonStart + predictionHorizon - 1;
        windowY = y(horizonStart: horizonEnd);
        
        cvx_begin
        
        obj = 0;
        p=0.4/4;
        a=4/4;
%         b=4/4;
        variables x(predictionHorizon)
        
        for i = 1:predictionHorizon
            obj = obj + p*x(i) + a*max(0,windowY(i)-x(i));
            if i == 1
                obj = obj + b*abs(x(i)); %because x(0) is 0
            else
                obj = obj + b*abs(x(i)-x(i-1));
            end
        end
        
        minimize(obj)
        
        cvx_end
        
        optValues(horizonStart) = x(1);
    end
    
    obj = 0;
    for i = 1:T
        obj = obj + p*optValues(i) + a*max(0,y(i)-optValues(i));
        if i == 1
            obj = obj + b*abs(optValues(i)); %because x(0) is 0
        else
            obj = obj + b*abs(optValues(i)-optValues(i-1));
        end
    end
    objlist(j) = obj;
end


figure,
plot(A,objlist)
% plot(y)
% hold on
% plot(optValues)
title(sprintf('Optimal Penalty(a) for (Home %d)',home_num))
xlabel('Penalty(a)')
ylabel('Objective function')
% legend('Energy Demand (Actual)','Energy Supplied')
% txt = sprintf(...
%     'a = %.02f $/kW 15min \nb = %.02f $/kW 15 min \nOptimal Value: %.03f'...
%     ,a, b, obj);
% text(T*0.05,max(y)*.9,txt)