size = 100;
% data1_copy = [];
% data1_copy = data1 (1:size,:);
% for i = 1:2:5
%     for j = 1:size
%         if data1_copy(j,i)>1
%             data1_copy(j,i) = 1;
%         end
%     end
% end
% data1_sorted = [];
% for i = 1:6
%     data1_sorted(:,i) = sort(data1_copy(:,i));
% end
% data1_mean = [];
% for i = 1:5
%     data1_mean(i,:) = mean(data1_sorted(1+5*(5-i):size-5*(5-i),:));
% end
% %% risk
% data1_risk = [];
% % data1_copy (:,1) = data1_copy(:,end);
% for i = 1:2:5
%     for j = 1:size
%         if data1_copy(j,i)>0.95
%             data1_risk(j,ceil(i/2)) = 1;
%         else
%             data1_risk(j,ceil(i/2)) = 0;
%         end
%     end
% end
% data1_risk_sorted = [];
% for i = 1:3
%     data1_risk_sorted(:,i) = sort(data1_risk(:,i));
% end
% data1_risk_mean = [];
% for i = 1:5
%     data1_risk_mean(i,:) = mean(data1_risk_sorted(1+5*(5-i):size-5*(5-i),:));
% end
% 
% data2_copy = [];
% data2_copy = data2 (1:size,:);
% for i = 1:2:5
%     for j = 1:size
%         if data2_copy(j,i)>1
%             data2_copy(j,i) = 1;
%         end
%     end
% end
% data2_sorted = [];
% for i = 1:6
%     data2_sorted(:,i) = sort(data2_copy(:,i));
% end
% data2_mean = [];
% for i = 1:5
%     data2_mean(i,:) = mean(data2_sorted(1+5*(5-i):size-5*(5-i),:));
% end
% %% risk
% data2_risk = [];
% % data2_copy (:,1) = data2_copy(:,end);
% for i = 1:2:5
%     for j = 1:size
%         if data2_copy(j,i)>0.95
%             data2_risk(j,ceil(i/2)) = 1;
%         else
%             data2_risk(j,ceil(i/2)) = 0;
%         end
%     end
% end
% data2_risk_sorted = [];
% for i = 1:3
%     data2_risk_sorted(:,i) = sort(data2_risk(:,i));
% end
% data2_risk_mean = [];
% for i = 1:5
%     data2_risk_mean(i,:) = mean(data2_risk_sorted(1+5*(5-i):size-5*(5-i),:));
% end

data3_copy = [];
data3_copy = data3 (1:size,:);
for i = 1:2:5
    for j = 1:size
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
    data3_mean(i,:) = mean(data3_sorted(1+5*(5-i):size-5*(5-i),:));
end
%% risk
data3_risk = [];
% data3_copy (:,1) = data3_copy(:,end);
for i = 1:2:5
    for j = 1:size
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
    data3_risk_mean(i,:) = mean(data3_risk_sorted(1+5*(5-i):size-5*(5-i),:));
end

% data1_achievement = [0,0,0,0];
% for i = 1:size
%     j =  data1_risk(i,1) + data1_risk(i,2) + data1_risk(i,3);
%     data1_achievement(j+1) = data1_achievement(j+1) +1;  
% end
% data1_achievement = flip(data1_achievement');
% data2_achievement = [0,0,0,0];
% for i = 1:size
%     j =  data2_risk(i,1) + data2_risk(i,2) + data2_risk(i,3);
%     data2_achievement(j+1) = data2_achievement(j+1) +1;  
% end
% data2_achievement = flip(data2_achievement');
data3_achievement = [0,0,0,0];
for i = 1:size
    j =  data3_risk(i,1) + data3_risk(i,2) + data3_risk(i,3);
    data3_achievement(j+1) = data3_achievement(j+1) +1;  
end
data3_achievement = flip(data3_achievement');