data1_copy = [];
data1_copy = data1 (1:50,:);
for i = 2:2:6
    for j = 1:50
        if data1_copy(j,i)>1
            data1_copy(j,i) = 1;
        end
    end
end
data1_sorted = [];
for i = 1:6
    data1_sorted(:,i) = sort(data1_copy(:,i));
end
data1_mean = [];
for i = 1:5
    data1_mean(i,:) = mean(data1_sorted(1+5*(5-i):50-5*(5-i),:));
end
%% risk
data1_risk = [];
for i = 2:2:6
    for j = 1:50
        if data1_copy(j,i)>0.95
            data1_risk(j,ceil(i/2)) = 1;
        else
            data1_risk(j,ceil(i/2)) = 0;
        end
    end
end
data1_risk_sorted = [];
for i = 1:3
    data1_risk_sorted(:,i) = sort(data1_risk(:,i));
end
data1_risk_mean = [];
for i = 1:5
    data1_risk_mean(i,:) = mean(data1_risk_sorted(1+5*(5-i):50-5*(5-i),:));
end

data2_copy = [];
data2_copy = data2 (1:50,:);
for i = 2:2:6
    for j = 1:50
        if data2_copy(j,i)>1
            data2_copy(j,i) = 1;
        end
    end
end
data2_sorted = [];
for i = 1:6
    data2_sorted(:,i) = sort(data2_copy(:,i));
end
data2_mean = [];
for i = 1:5
    data2_mean(i,:) = mean(data2_sorted(1+5*(5-i):50-5*(5-i),:));
end
%% risk
data2_risk = [];
for i = 2:2:6
    for j = 1:50
        if data2_copy(j,i)>0.95
            data2_risk(j,ceil(i/2)) = 1;
        else
            data2_risk(j,ceil(i/2)) = 0;
        end
    end
end
data2_risk_sorted = [];
for i = 1:3
    data2_risk_sorted(:,i) = sort(data2_risk(:,i));
end
data2_risk_mean = [];
for i = 1:5
    data2_risk_mean(i,:) = mean(data2_risk_sorted(1+5*(5-i):50-5*(5-i),:));
end

data3_copy = [];
data3_copy = data3 (1:50,:);
for i = 2:2:6
    for j = 1:50
        if data3_copy(j,i)>1
            data3_copy(j,i) = 1;
        end
    end
end
data3_sorted = [];
for i = 1:7
    data3_sorted(:,i) = sort(data3_copy(:,i));
end
data3_mean = [];
for i = 1:5
    data3_mean(i,:) = mean(data3_sorted(1+5*(5-i):50-5*(5-i),:));
end
%% risk
data3_risk = [];
for i = 2:2:6
    for j = 1:50
        if data3_copy(j,i)>0.95
            data3_risk(j,ceil(i/2)) = 1;
        else
            data3_risk(j,ceil(i/2)) = 0;
        end
    end
end
data3_risk_sorted = [];
for i = 1:3
    data3_risk_sorted(:,i) = sort(data3_risk(:,i));
end
data3_risk_mean = [];
for i = 1:5
    data3_risk_mean(i,:) = mean(data3_risk_sorted(1+5*(5-i):50-5*(5-i),:));
end