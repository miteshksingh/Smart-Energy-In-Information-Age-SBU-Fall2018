% Choosing a home number -------------------------------------------------
home_num = input('Enter the number of the desired home (1-10): ');
if home_num == 4
    data = csvread('HousePredictions/House_4_RandomForest.csv');
elseif home_num == 9
    data = csvread('HousePredictions/House_9_RandomForest.csv');
elseif home_num == 10
    data = csvread('HousePredictions/House_10_RandomForest.csv');
else
    disp('Not a valid home number');
    return
end

T = 4*24*7;
y = data;

predictionHorizon = 5;
commitmentHorizon = 3;
optValues = zeros(T+5,1);


for horizonStart = 1:T
    horizonEnd = horizonStart + predictionHorizon - 1;
    windowY = y(horizonStart: horizonEnd);
    
    cvx_begin
    
    obj = 0;
    p=0.4/4;
    a=4/4;
    b=4/4;
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
    
    for i = 1:commitmentHorizon
        optValues(horizonStart+i-1)= optValues(horizonStart+i-1) + x(i);
    end
end

optValues = optValues./commitmentHorizon ;

obj = 0;
for i = 1:T
    obj = obj + p*optValues(i) + a*max(0,y(i)-optValues(i));
    if i == 1
        obj = obj + b*abs(optValues(i)); %because x(0) is 0
    else
        obj = obj + b*abs(optValues(i)-optValues(i-1));
    end
end


figure,
plot(y)
hold on
plot(optValues)
title(sprintf('Commitment Horizon Control Implementation (Home %d)',home_num))
xlabel('Timestep(15 min)')
ylabel('Electricity (kWh)')
legend('Electricity Demand (True)','Electricity Provisioned (Predicted)')
txt = sprintf(...
    'a = %.02f $/kW 15 min \nb = %.02f $/kW 15 min \nOptimal Value: %.03f'...
    ,a, b, obj);
text(T*0.05,max(y)*.9,txt)