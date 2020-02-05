
iter = 5;
% data1_copy = [];
% for i = 1:size(data1,1)
%     if data1(i,8)~=-1 && data1(i,10) ~=-1 && data1(i,1)~=0
%         data1_copy = [data1_copy;data1(i,:)];
%     end
% end
% data1_sorted = [];
% for i = 1:6
%     data1_sorted(:,i) = sort(data1_copy(:,i));
% end
% data1_mean = [];
% for i = 1:iter
%     data1_mean(i,:) = mean(data1_sorted(1+iter*(iter-i):size(data1_copy,1)-iter*(iter-i),:));
% end

data2_copy = [];
for i = 1:size(data2,1)
    if data2(i,8)~=-1 && data2(i,10) ~=-1 && data2(i,1)~=0
        data2_copy = [data2_copy;data2(i,:)];
    end
end
data2_sorted = [];
for i = 1:6
    data2_sorted(:,i) = sort(data2_copy(:,i));
end
data2_mean = [];
for i = 1:iter
    data2_mean(i,:) = mean(data2_sorted(1+iter*(iter-i):size(data2_copy,1)-iter*(iter-i),:));
end

data3_copy = [];
for i = 1:size(data3,1)
    if data3(i,8)~=-1 && data3(i,10) ~=-1 && data3(i,1)~=0
        data3_copy = [data3_copy;data3(i,:)];
    end
end
data3_sorted = [];
for i = 1:6
    data3_sorted(:,i) = sort(data3_copy(:,i));
end
data3_mean = [];
for i = 1:iter
    data3_mean(i,:) = mean(data3_sorted(1+iter*(iter-i):size(data3_copy,1)-iter*(iter-i),:));
end

% iter = 5;
% data1_copy = [];
% for i = 1:size(data1,1)
%     if data1(i,1)~=0
%         data1_copy = [data1_copy;data1(i,:)];
%     end
% end
% data1_sorted = [];
% for i = 1:6
%     data1_sorted(:,i) = sort(data1_copy(:,i));
% end
% data1_mean = [];
% for i = 1:iter
%     data1_mean(i,:) = mean(data1_sorted(1+iter*(iter-i):size(data1_copy,1)-iter*(iter-i),:));
% end
% 
% data2_copy = [];
% for i = 1:size(data2,1)
%     if data2(i,1)~=0
%         data2_copy = [data2_copy;data2(i,:)];
%     end
% end
% data2_sorted = [];
% for i = 1:6
%     data2_sorted(:,i) = sort(data2_copy(:,i));
% end
% data2_mean = [];
% for i = 1:iter
%     data2_mean(i,:) = mean(data2_sorted(1+iter*(iter-i):size(data2_copy,1)-iter*(iter-i),:));
% end
% 
% data3_copy = [];
% for i = 1:size(data3,1)
%     if data3(i,1)~=0
%         data3_copy = [data3_copy;data3(i,:)];
%     end
% end
% data3_sorted = [];
% for i = 1:6
%     data3_sorted(:,i) = sort(data3_copy(:,i));
% end
% data3_mean = [];
% for i = 1:iter
%     data3_mean(i,:) = mean(data3_sorted(1+iter*(iter-i):size(data3_copy,1)-iter*(iter-i),:));
% end

