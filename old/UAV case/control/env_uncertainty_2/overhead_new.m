time=[];
for i = 1:size(planningtime3,1)
    for j = 1:size(planningtime3,2)
        if planningtime3(i,j)>0
            time=[time;planningtime3(i,j)];
        end
    end
end

a = mean(time)
c = std(time)

now_time = [];
num = find(time>(a+3*c)|time<(a-3*c));
for i = 1:length(time)
    if find(num==i)
        continue
    else
        now_time= [now_time;time(i)];
    end
end
a = mean(now_time)
c = std(now_time)
% figure,
% hist(time)

