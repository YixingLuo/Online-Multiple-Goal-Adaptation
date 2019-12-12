
% eplison_list = [1e-10,5e-10,1e-9,5e-9,1e-8,5e-8,1e-7,5e-7,1e-6,5e-6,1e-5,5e-5,1e-4,5e-4,1e-3,5e-3,1e-2,5e-2,1e-1,5e-1];
% k = abs(log10(eplison_list));
% figure, 
% 
% xx=linspace(k(end),k(1));
% yy=interp1(k,relax_for_52(:,1),xx,'PCHIP');
% plot(xx,yy,'--x','linewidth',1.2,'MarkerIndices',1:5:length(yy),'Color',[0.4940 0.1840 0.5560])
% hold on
% 
% xx=linspace(k(end),k(1));
% yy=interp1(k,relax_for_52(:,2),xx,'PCHIP');
% plot(xx,yy,':','linewidth',2,'Color',[0.9290 0.6940 0.1250])
% hold on
% 
% % plot(k, relax_for_52(:,3), '-','linewidth',1.2,'Color',[0.8500 0.3250 0.0980])
% xx=linspace(k(end),k(1));
% yy=interp1(k,relax_for_52(:,3),xx,'PCHIP');
% plot(xx,yy,'-','linewidth',1.2,'Color',[0.8500 0.3250 0.0980])
% hold on
% 
% % plot(k, relax_for_52(:,4), '--','linewidth',1.2,'Color',[0 0.4470 0.7410])
% xx=linspace(k(end),k(1));
% yy=interp1(k,relax_for_52(:,4),xx,'PCHIP');
% plot(xx,yy,'--','linewidth',1.2,'Color',[0 0.4470 0.7410])
% hold on
% 
% % plot(k, relax_for_52(:,5), '-.','linewidth',1.2,'Color',[0.4660 0.6740 0.1880])
% xx=linspace(k(end),k(1));
% yy=interp1(k,relax_for_52(:,5),xx,'PCHIP');
% plot(xx,yy,'-.','linewidth',1.2,'Color',[0.4660 0.6740 0.1880])
% hold on
% 
% axis([0, 10, 0, 11])
% hl = legend('Safety Risk','Privacy Risk','Accuracy','Travelling Time','Energy Consumption');
% set(hl,'box','off')
% h = xlabel({'-lg(\epsilon)'},'Fontname', 'Times New Roman');
% ylabel('Adaptation Times','Fontname', 'Times New Roman');
% set(gca,'gridLineStyle', '-.');
% set(gca,'fontname','Times');
% ax = gca;
% ax.XDir = 'reverse';
% xlim = get(gca,'XLim');
% ylim = get(gca,'YLim');
% set(h,'Position',[xlim(1)-(xlim(2)-xlim(1))*0.05,ylim(1)])

relax_sum1 = [];
relax_sum = [];
relax_sum1 = sum(tag_list3_1,2);

for i = 1:length(relax_sum1)/5
    temp_sum = 0;
    for j = 1:5
        temp_sum = temp_sum + relax_sum1((i-1)*5+j);
    end
    if temp_sum > 0
        relax_sum = [relax_sum ; relax_sum1((i-1)*5+1:(i*5))];
    end
end
relax_for_5 = [];
for i = 1:size(relax_sum,1)/5
    for j = 1:5
        relax_for_5(i,j)=relax_sum((i-1)*5+j);
    end
end
relax_for_5 = mean(relax_for_5,1);

% relax_for_5 = mean(data3_1,1);
