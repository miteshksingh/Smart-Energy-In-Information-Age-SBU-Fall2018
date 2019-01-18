%y = true demand values between Nov 1, 2015 to Nov 7, 2017
%x(0) = 0;
% Select a home number to proceed 
home_num = input('Enter the home no: ');
if home_num == 1
    data = csvread('Home1_yr1.csv');
elseif home_num == 2
    data = csvread('Home2_yr1.csv');
elseif home_num == 3
    data = csvread('Home3_yr1.csv');
elseif home_num == 4
    data = csvread('Home4_yr1.csv');
elseif home_num == 5
    data = csvread('Home5_yr1.csv');
elseif home_num == 6
    data = csvread('Home6_yr1.csv');
elseif home_num == 7
    data = csvread('Home7_yr1.csv');
elseif home_num == 8
    data = csvread('Home8_yr1.csv');
elseif home_num == 9
    data = csvread('Home9_yr1.csv');
elseif home_num == 10
    data = csvread('Home10_yr1.csv');
else
    disp('This is not a valid house number.');
    return
end

%Week into consideration: 11/01/2015 - 11/07/2015
%Last Week in csv data: 11/30/2015.
%Hence we need to shorten our field of interest in csv
W = 2208;
T = 672;
y = data(end - W - T + 1:end - W);
p = 0.4/4; % 0.4 kWh divided by 4 to give kW/15min
a = 4/4;
b = 4/4;   
x(1) = 0;
x(2) = 0;
k = 0;
superobj(1) = 0;
learningRate(1) = 0;
i = 1;
for l = 0:0.0000001:0.2
    learningRate(i) = l;
    obj = 0;
    for t = 2:T
        if y(t) > x(t)
            if x(t) > x(t-1)
                k = p-a+b;
            else
                k = p-a-b;
            end
        else
            if x(t) > x(t-1)
                k = p+b;
            else
                k = p-b;
            end
        end
        x(t+1) = x(t) - l * k;
    end

    for k = 2:T
        obj = obj + p*x(k) + a*max(0,y(k) - x(k))+ b*abs(x(k) - x(k-1));
    end
    superobj(i) = obj;
    i = i+1;
end

figure,
idxmin = find(superobj == min(superobj));

plot(learningRate,superobj,'-p','MarkerIndices',[idxmin],...
    'MarkerFaceColor','red',...
    'MarkerSize',15)
% plot(learningRate,superobj)
hold on
title(sprintf('Sensitivity Analysis based on House %d data',home_num))
xlabel('Learning Rate')
ylabel('Cost')




