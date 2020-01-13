relax_for_3 = [];
for i = 1:length(relax_num)/3
    relax_for_3(i,1)=relax_num((i-1)*3+1);
    relax_for_3(i,2)=relax_num((i-1)*3+2);
    relax_for_3(i,3)=relax_num((i-1)*3+3);
end
k = 0:0.01:1;
figure, 
% subplot(4,1,4)
plot(k, relax_for_3(:,1), 'r-','linewidth',1.2)
hold on
plot(k, relax_for_3(:,2), 'b--','linewidth',1.2)
hold on
plot(k, relax_for_3(:,3), 'g-.','linewidth',1.2)
axis([0, 1, 0, 13])
hl = legend('Accuracy','Scanning Distance','Energy Consumption');
set(hl,'box','off')
xlabel('Error Tolerance','Fontname', 'Times New Roman');
ylabel('Adaptation times','Fontname', 'Times New Roman');