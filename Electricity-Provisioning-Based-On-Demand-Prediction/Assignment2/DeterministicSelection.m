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
W = 2208;
p = 0.4/4; % 0.4 kWh divided by 4 to give kW/15min
a = 4/4;
b = 4/4;   
y = data(end - W - 672 + 1:end - W);
for t = 3:4:668
    c1 = ogd(t,t+4,y,p,a,b);
    c2 = 10;
    c3 = 11;
%     c2 = rhc(t,t+4,y,p,a,b);
%     c3 = chc(t,t+4,y,p,a,b);
%     disp(c1);
%     disp(c2);
%     disp(c3);
    if c1 <c2 && c1<c3
        disp('OGD is the best with optimal value')
    end
    if c2 <c1 && c2<c3
        disp('RHC is the best with optimal value')
    end
    if c3 <c2 && c3<c1
        disp('CHC is the best with optimal value')
    end
end

function cost_ogd = ogd(e,f,g,h,i,j)   
    cost_ogd = 0;
    x(e-1)=0;
    x(e-2) = 0;
    k = 0;
    l = 0.029;
%     disp(e)
%     disp(f);
    for t = e-1:f
        if g(t) > x(t)
            if x(t) > x(t-1)
                k = h-i+j;
            else
                k = h-i-j;
            end
        else
            if x(t) > x(t-1)
                k = h+j;
            else
                k = h-j;
            end
        end
        x(t+1) = x(t) - l * k;
    end 

    for k = e-1:f
        cost_ogd = cost_ogd + h*x(k) + i*max(0,g(k) - x(k))+ j*abs(x(k) - x(k-1));
    end
%     disp(cost_ogd);
end