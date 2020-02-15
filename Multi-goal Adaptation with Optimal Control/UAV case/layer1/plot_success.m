figure,
layer1_success = [0.97,0.96,0.74,0.67,0.47];
layer2_success = [0.99,0.99,0.98,0.98,0.98];
k=[1,2,3,4,5];
plot(k,layer1_success,'-^','linewidth',3,'Color',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor',[0.8500 0.3250 0.0980])
hold on
plot(k,layer2_success,'--d','linewidth',3,'Color',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor',[0 0.4470 0.7410])
set(gca,'fontname','Times' ,'FontSize',16);
hlegend = legend('Constrained Planning','Our Approach');
legend('FontName','Times New Roman','FontSize',16);
h = xlabel({'Number of soft goals'},'Fontname', 'Times New Roman','FontSize',20);
% xlabel({'|TG|'},'Fontname', 'Times New Roman','Interpreter', 'latex');
ylabel('Success Probability','Fontname', 'Times New Roman','FontSize',20);
set(hlegend,'box','off')
grid on
axis([0, 6, 0, 1.1])
set(gca,'gridLineStyle', '-.');

xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
% set(h,'Position',[xlim(2)+(xlim(2)+xlim(1))*0.2,ylim(1)])
% title('Success rate with the increase of $TG$','Interpreter', 'latex');