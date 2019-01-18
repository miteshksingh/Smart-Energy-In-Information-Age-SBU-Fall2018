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

% We are using 7 days of data divided into chunks of 15 minutes
t = 4*24*7; 

%Week into consideration: 11/01/2015 - 11/07/2015
%Last Week in csv data: 11/30/2015.
%Hence we need to shorten our field of interest in csv
W = 2208;
y = data(end - W - T + 1:end - W);

% p(t) - price of electricity at time t, we use a constant initially
% a - penalty of insufficient provisioning

cvx_begin

obj = 0;
p = 0.4/4; % 0.4 kWh divided by 4 to give kW per 15min
a = 4/4;
variables x
for k = 2:t
    obj = obj + p*x + a*max(0,y(k) - x);
end
minimize(obj)

cvx_end

x = ones(T,1)*x;

figure,
plot(y)
hold on
plot(x)
title(sprintf('CVX Offline Static Optimization for Home %d ',home_num))
xlabel('Time interval (15min)')
ylabel('Energy (kWh)')
legend('Energy Demand (Actual)','Energy Supplied')
txt = sprintf(...
    'a = %.02f $/kWh \nOptimal Value: %.03f'...
    ,a,obj);
text(T*0.05,max(y)*.9,txt)
