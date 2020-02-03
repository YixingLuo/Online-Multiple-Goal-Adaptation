size = 100;
start = 201;
iter = 5;
data1_copy = [];
data1_copy = data1 (start:start+size,:);
% for i = 2:2:6
%     for j = 1:size
%         if data1_copy(j,i)>1
%             data1_copy(j,i) = 1;
%         end
%     end
% end
data1_sorted = [];
for i = 1:6
    data1_sorted(:,i) = sort(data1_copy(:,i));
end
data1_mean = [];
for i = 1:iter
    data1_mean(i,:) = mean(data1_sorted(1+iter*(iter-i):size-iter*(iter-i),:));
end

data2_copy = [];
data2_copy = data2 (start:start+size,:);
% for i = 1:2:5
%     for j = 1:size
%         if data2_copy(j,i)>1
%             data2_copy(j,i) = 1;
%         end
%     end
% end
data2_sorted = [];
for i = 1:6
    data2_sorted(:,i) = sort(data2_copy(:,i));
end
data2_mean = [];
for i = 1:iter
    data2_mean(i,:) = mean(data2_sorted(1+iter*(iter-i):size-iter*(iter-i),:));
end

data3_copy = [];
data3_copy = data3 (start:start+size,:);
% for i = 1:2:5
%     for j = 1:size
%         if data3_copy(j,i)>1
%             data3_copy(j,i) = 1;
%         end
%     end
% end
data3_sorted = [];
for i = 1:12
    data3_sorted(:,i) = sort(data3_copy(:,i));
end
data3_mean = [];
for i = 1:iter
    data3_mean(i,:) = mean(data3_sorted(1+iter*(iter-i):size-iter*(iter-i),:));
end

