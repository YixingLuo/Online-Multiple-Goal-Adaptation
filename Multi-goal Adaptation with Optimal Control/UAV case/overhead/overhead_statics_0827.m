for i = 1:size(uav1,1)
    for j = 1:size(uav1,2)
        if uav1(i,j)>0
            time1_uav=[time1_uav;uav1(i,j)];
        end
    end
end
a1 = mean(time1_uav);
c1 = std(time1_uav);

now_time1 = [];
num1 = find(time1_uav>(a1+1*c1)|time1_uav<(a1-1*c1));
for i = 1:length(time1_uav)
    if find(num1==i)
        continue
    else
        now_time1= [now_time1;time1_uav(i)];
    end
end
a1 = mean(now_time1);
c1 = std(now_time1);

for i = 1:size(uav2,1)
    for j = 1:size(uav2,2)
        if uav1(i,j)>0
            time2_uav=[time2_uav;uav2(i,j)];
        end
    end
end
a2 = mean(time2_uav);
c2 = std(time2_uav);

now_time2 = [];
num2 = find(time2_uav>(a2+1*c2)|time2_uav<(a2-1*c2));
for i = 1:length(time2_uav)
    if find(num2==i)
        continue
    else
        now_time2= [now_time2;time2_uav(i)];
    end
end
a2 = mean(now_time2);
c2 = std(now_time2);

for i = 1:size(uav3,1)
    for j = 1:size(uav3,2)
        if uav3(i,j)>0
            time3_uav=[time3_uav;uav3(i,j)];
        end
    end
end
a3 = mean(time3_uav);
c3 = std(time3_uav);


now_time3 = [];
num3 = find(time3_uav>(a3+1*c3)|time3_uav<(a3-1*c3));
for i = 1:length(time3_uav)
    if find(num3==i)
        continue
    else
        now_time3= [now_time3;time3_uav(i)];
    end
end
a3 = mean(now_time3);
c3 = std(now_time3);


statistic_time_data = [a1,c1;a2,c2;a3,c3]