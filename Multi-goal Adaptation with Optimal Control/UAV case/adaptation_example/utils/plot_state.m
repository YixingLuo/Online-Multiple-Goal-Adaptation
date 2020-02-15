function [ h_fig ] = plot_state( h_fig, state, time, name, type, view )
%PLOT_STATE visualize state data

if nargin < 6, view = 'sep'; end
if nargin < 5, type = 'vic'; end
if nargin < 4, name = 'pos'; end
if isempty(h_fig), h_fig = figure(); end
line_width = 2;

switch type
    case 'vic'
        line_color = 'r';
    case 'des'
        line_color = 'b';
    case 'est'
        line_color = 'g';
end

switch name
    case 'pos'
        labels = {'x [m]', 'y [m]', 'z [m]', '\omega [%]'};
    case 'vel'
        labels = {'$v_x$ [m/s]', '$v_y$ [m/s]', '$v_z$ [m/s]', '\omega [%]'};
    case 'euler'
        labels = {'roll [rad]', 'pitch [rad]', 'yaw [rad]'};
end

figure(h_fig)
if strcmp(view, 'sep')
    % Plot seperate
switch name
    case 'pos'
        for i = 1:4
            subplot(4, 1, i)
            hold on
            plot(time, state(i,:), line_color, 'LineWidth', line_width);
            hold off
            xlim([time(1), time(end)])
            grid on
            if i == 4
                xlabel('Time instant $k$ [s]','Interpreter','latex','FontSize',18)
            end
            ylabel(labels{i})
            set(gca,'fontname','Times');
            set(gca,'xtick',0:1:12);
    %         axis([0, 25, 0, 10]);
        end
    case 'vel'
        for i = 1:4
            subplot(4, 1, i)
            hold on
            plot(time, state(i,:), line_color, 'LineWidth', line_width);
            hold off
            xlim([time(1), time(end)])
            grid on
            set(gca,'fontname','Times','FontSize',14);
            if i == 4
                xlabel('Time instant $k$ [s]','Interpreter','latex','FontSize',18)
            end
            if i < 4
                ylabel(labels{i},'Interpreter','latex','FontSize',16)
            else
                ylabel(labels{i})
            end           
            set(gca,'xtick',0:1:12);
    %         axis([0, 25, 0, 10]);
        end
end
elseif strcmp(view, '3d')
    % Plot 3d
    hold on
    plot3(state(1,:), state(2,:), state(3,:), line_color, 'LineWidth', line_width)
    hold off
    grid on
    xlabel(labels{1});
    ylabel(labels{2});
    zlabel(labels{3});
    set(gca,'fontname','Times');
%     axis([0, 25, 0, 10]);
end

end
