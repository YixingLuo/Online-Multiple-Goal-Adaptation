DS_SR=[];
DS_PR=[];
iternum = 50;
sr = [];
pr = [];
% for i = 1:iternum
%     if data1(i,8)>0
%         sr = [sr, data1(i,8)];
% %     else
% %         sr = [sr, 0];
%     end
%     if data1(i,10)>0
%         pr = [pr, data1(i,10)];
% %     else
% %         pr = [pr, 0];
%     end
% end
DS_SR = [DS_SR, mean(sr)];
DS_PR = [DS_PR, mean(pr)];

sr = [];
pr = [];
for i = 1:iternum
    if data2(i,8)>0
        sr = [sr, data2(i,8)];
%     else
%         sr = [sr, 0];
    end
    if data2(i,10)>0
        pr = [pr, data2(i,10)];
%             else
%         pr = [pr, 0];
    end
end
DS_SR = [DS_SR, mean(sr)];
DS_PR = [DS_PR, mean(pr)];

sr = [];
pr = [];
for i = 1:iternum
    if data3(i,8)>0
        sr = [sr, data3(i,8)];
%             else
%         sr = [sr, 0];
    end
    if data3(i,10)>0
        pr = [pr, data3(i,10)];
%             else
%         pr = [pr, 0];
    end
end
DS_SR = [DS_SR, mean(sr)];
DS_PR = [DS_PR, mean(pr)];
DS_SR,DS_PR