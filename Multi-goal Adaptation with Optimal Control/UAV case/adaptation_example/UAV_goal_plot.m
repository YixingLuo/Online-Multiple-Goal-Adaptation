
global configure
configure = Configure();
figure,
safety_distance=[];
privacy_distance=[];
energy_target=[];
endtime = 25/2;
k = 0:0.5:endtime;
for i = 1: length(k)
    safety_distance(i) = configure.obstacle_radius + configure.obstacle_max + configure.radius;
end
for i = 1:length(k)
    privacy_distance(i) = configure.privacy_radius + configure.privacy_max + configure.radius;
end
for i = 1:length(k)
    energy_target(i) = configure.battery_target;
end

subplot(3,1,1)
 
plot(k, SR_list, '--x','linewidth',2,'Color',[0 0.4470 0.7410])
hold on
plot(k, safety_distance,'--','linewidth',2,'Color',[0.8500 0.3250 0.0980])
axis([0, endtime, 0, 6]);
% xlabel('Time [s]','Fontname', 'Times New Roman');
set(gca,'fontname','Times','FontSize',12);
ylabel({'Distance with','the nearest $o$ [m]'},'Fontname', 'Times New Roman','Interpreter','latex','FontSize',12);
lgd = legend('$||x_k-x_o||_2$','$r_a + r_o + D_o$','interpreter','latex','Box','off');
set(gca,'gridLineStyle', '-.');
set(gca,'xtick',0:1:12);

subplot(3,1,2)
plot(k, PR_list, ':','linewidth',2,'Color',[0 0.4470 0.7410])
hold on
plot(k, privacy_distance,'--','linewidth',2,'Color',[0.8500 0.3250 0.0980])
axis([0, endtime, 0, 6]);
% xlabel('Time [s]','Fontname', 'Times New Roman');
set(gca,'fontname','Times','FontSize',12);
ylabel({'Distance with','the nearest $c$ [m]'},'Fontname', 'Times New Roman','Interpreter','latex','FontSize',12);
lgd = legend('$||x_k-x_c||_2$','$r_a + r_c + D_c$','interpreter','latex','Box','off');
set(gca,'gridLineStyle', '-.');
set(gca,'xtick',0:1:12);

subplot(3,1,3)
plot(k, energy_list,'-.','linewidth',2,'Color',[0 0.4470 0.7410])
hold on
plot(k, energy_target,'--','linewidth',2,'Color',[0.8500 0.3250 0.0980])
axis([0, endtime, 0, 40]);
set(gca,'fontname','Times','FontSize',12);
xlabel('Time instant $k$ [s]','Fontname', 'Times New Roman','Interpreter','latex','FontSize',12);
ylabel({'Energy', 'consumption [unit]'},'Fontname', 'Times New Roman','Interpreter','latex','FontSize',12);
lgd = legend('$\sum E_k$','$E_t$','interpreter','latex','Box','off');
set(gca,'gridLineStyle', '-.');
set(gca,'xtick',0:1:12);


% k = 1: 359;
% figure, 
% subplot(4,1,4)
% plot(k, usage_plan(:,1), 'r','linewidth',1.2)
% hold on
% plot(k, usage_plan(:,2), 'b--','linewidth',1.2)
% hold on
% plot(k, usage_plan(:,3), 'g-.','linewidth',1.2)
% hold on
% plot(k, usage_plan(:,4), 'y','linewidth',1.2)
% hold on
% plot(k, usage_plan(:,5), 'r:','linewidth',1.2)
% axis([0, 360, 0, 1])
% hl = legend('S1','S2','S3','S4','S5');
% set(hl,'box','off')
% % xlabel('Time [100s]','Fontname', 'Times New Roman');
% ylabel({'Sensor','usage [%]'},'Fontname', 'Times New Roman');
% set(gca,'gridLineStyle', '-.');
% set(gca,'fontname','Times');
% h = xlabel({'Time [100s]'},'Fontname', 'Times New Roman');
% xlim = get(gca,'XLim');
% ylim = get(gca,'YLim');
% set(gca,'gridLineStyle', '-.');
% set(h,'Position',[xlim(2)+(xlim(2)+xlim(1))*0.08,ylim(1)])
% 
% distance_list = [];
% speed = [];
% acc_list = [];
% energy_list = [];
% pastdistance = 0;
% %% distance
% for j = 1: 359
%     speed_now = 0;
%     for i = 1:uuv.N_s
%         speed_now = speed_now + usage_plan(j,i)*uuv.s_speed(i)*usage_plan(j,i+uuv.N_s);
%     end
%     speed = [speed, speed_now];
%     pastdistance = pastdistance + speed_now * uuv.time_step;
%     distance_list = [distance_list, pastdistance];
% end
% k = 1: length(speed);
% % figure, 
% subplot(4,1,1)
% plot(k, speed, 'k','linewidth',1.2)
% axis([0, length(speed), 2.6, 3.6])
% % xlabel('Time [100s]','Fontname', 'Times New Roman');
% ylabel({'Scanning', 'speed [m/s]'},'Fontname', 'Times New Roman');
% set(gca,'gridLineStyle', '-.');
% set(gca,'fontname','Times');
% %% accuracy
% for j = 1: 359
%     acc = 0;
%     for i = 1:uuv.N_s
%         acc = acc + usage_plan(j,i)*uuv.s_accuracy(i)*usage_plan(j,i+2*uuv.N_s);
%     end
%     acc_list = [acc_list, acc];      
% end
% k = 1: length(acc_list);
% % figure, 
% subplot(4,1,2)
% plot(k, acc_list, 'k','linewidth',1.2)
% axis([0, length(acc_list), 0.8, 1]);
% % xlabel('Time [100s]','Fontname', 'Times New Roman');
% ylabel('Accuracy [%]','Fontname', 'Times New Roman');
% set(gca,'gridLineStyle', '-.');
% set(gca,'fontname','Times');
% %% energy
% for j = 1: 359
%     engy = 0;
%     for i = 1:uuv.N_s
%         engy = engy + usage_plan(j,i)*(exp(usage_plan(j,i + 2*uuv.N_s)+usage_plan(j,i + uuv.N_s)) - 1)/(exp(2)-1)*uuv.s_energy(i);
%     end
%     energy_list = [energy_list, engy];    
% end
% k = 1: length(energy_list);
% % figure, 
% subplot(4,1,3)
% plot(k, energy_list, 'k','linewidth',1.2)
% axis([0, length(energy_list), 100, 150]);
% % xlabel('Time [100s]','Fontname', 'Times New Roman');
% ylabel({'Energy', 'consumption [J/s]'},'Fontname', 'Times New Roman');
% set(gca,'fontname','Times');
% set(gca,'gridLineStyle', '-.');
