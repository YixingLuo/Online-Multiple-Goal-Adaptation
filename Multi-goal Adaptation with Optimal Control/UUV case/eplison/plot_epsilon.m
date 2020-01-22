% tag_list3 = zeros(300,100);
% for i = 1:size(rate_list3,1)
%     for j = 2:size(rate_list3,2)
%         if rate_list3(i,j)>eplison
%             tag_list3(i,j)=1;
%         end
%     end
% end
% relax_sum1 = [];
% relax_sum = [];
% relax_sum1 = sum(tag_list3,2);
% for i = 1:length(relax_sum1)/3
%     temp_sum = 0;
%     for j = 1:3
%         temp_sum = temp_sum + relax_sum1((i-1)*3+j);
%     end
%     if temp_sum > 0
%         relax_sum = [relax_sum ; relax_sum1((i-1)*3+1:(i*3))];
%     end
% end
% relax_for_3 = [];
% for i = 1:size(relax_sum,1)/3
%     for j = 1:3
%         relax_for_3(i,j)=relax_sum((i-1)*3+j);
%     end
% end
% relax_for_3 = mean(relax_for_3,1)/9;


eplison_list = [1e-40,1e-35,1e-30,1e-25,1e-20,1e-15,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,5e-1,1];
k = abs(log10(eplison_list));
figure, 

xx=linspace(k(end),k(1));
yy=interp1(k,relax_for_32(:,1),xx,'PCHIP');
plot(xx,yy,'-','linewidth',2,'Color',[0.8500 0.3250 0.0980])
hold on

% plot(k, relax_for_52(:,4), '--','linewidth',1.2,'Color',[0 0.4470 0.7410])
xx=linspace(k(end),k(1));
yy=interp1(k,relax_for_32(:,2),xx,'PCHIP');
plot(xx,yy,'--','linewidth',2,'Color',[0 0.4470 0.7410])
hold on

% plot(k, relax_for_52(:,5), '-.','linewidth',1.2,'Color',[0.4660 0.6740 0.1880])
xx=linspace(k(end),k(1));
yy=interp1(k,relax_for_32(:,3),xx,'PCHIP');
plot(xx,yy,'-.','linewidth',2,'Color',[0.4660 0.6740 0.1880])
hold on

axis([0, 40, 0, 1])
hl = legend('Accuracy','Scanning Distance','Energy Consumption');
set(hl,'box','off')
h = xlabel({'-lg(\epsilon)'},'Fontname', 'Times New Roman');
ylabel('Adaptation Rate','Fontname', 'Times New Roman');
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times');
ax = gca;
ax.XDir = 'reverse';
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
set(h,'Position',[xlim(1)-(xlim(2)-xlim(1))*0.05,ylim(1)])