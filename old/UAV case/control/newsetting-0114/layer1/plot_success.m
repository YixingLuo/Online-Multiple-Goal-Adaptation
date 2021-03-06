figure,
layer1_success = [1,0.99,0.75,0.72,0.43];
layer2_success = [1,1,0.99,0.98,0.98];
k=[1,2,3,4,5];
plot(k,layer1_success,'-^','linewidth',1.2,'Color',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor',[0.8500 0.3250 0.0980])
hold on
plot(k,layer2_success,'--d','linewidth',1.2,'Color',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor',[0 0.4470 0.7410])

hlegend = legend('Constrained Planning','Our Approach');
h = xlabel({'Number of target goals'},'Fontname', 'Times New Roman');
% xlabel({'|TG|'},'Fontname', 'Times New Roman','Interpreter', 'latex');
ylabel('Success Probability','Fontname', 'Times New Roman');
set(hlegend,'box','off')
grid on
axis([1, 5, 0, 1.1])
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times');
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
% set(h,'Position',[xlim(2)+(xlim(2)+xlim(1))*0.2,ylim(1)])
% title('Success rate with the increase of $TG$','Interpreter', 'latex');