relax_for_3 = [];
for i = 1:length(relax_num)/3
    relax_for_3(i,1)=relax_num((i-1)*3+1);
    relax_for_3(i,2)=relax_num((i-1)*3+2);
    relax_for_3(i,3)=relax_num((i-1)*3+3);
end
k = 0:0.01:1;
figure, 
% subplot(4,1,4)
plot(k, relax_for_32(:,1), 'r-','linewidth',1.2,'Color',[0.8500 0.3250 0.0980])
% plot(k, data3(:,1), 'r-','linewidth',1.2)
hold on
plot(k, relax_for_32(:,2), 'b--','linewidth',1.2,'Color',[0 0.4470 0.7410])
% plot(k, data3(:,3), 'b--','linewidth',1.2)
hold on
plot(k, relax_for_32(:,3), 'g-.','linewidth',1.2,'Color',[0.4660 0.6740 0.1880])
% plot(k, data3(:,5), 'g-.','linewidth',1.2)
axis([0, 1, 0, 13])
hl = legend('Accuracy','Scanning Distance','Energy Consumption');
set(hl,'box','off')
h = xlabel('\epsilon','Fontname', 'Times New Roman');
ylabel('Adaptation Times','Fontname', 'Times New Roman');
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times');
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
set(h,'Position',[xlim(2)+(xlim(2)-xlim(1))*0.03,ylim(1)])