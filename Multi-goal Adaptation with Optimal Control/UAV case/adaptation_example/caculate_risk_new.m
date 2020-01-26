function [SR_risk, PR_risk] =  caculate_risk_new(current_point, env)
global configure
length_o = 0;
width_o = 0;
length_p = 0;
width_p = 0;
[length_o, width_o] = size(env.obstacle_list);
[length_p, width_p] = size(env.privacy_list);
configure = Configure();
SR_risk = 0;
PR_risk = 0;
dis_o = [];
dis_p = [];
if length_o> 0
    for j = 1: length_o
        obstacle = env.obstacle_list(j,:);
        dis_o(j) = sqrt((current_point(1) - obstacle(1)).^2 + (current_point(2) - obstacle(2)).^2 + (current_point(3) - obstacle(3)).^2);
    end
    SR_risk = min(dis_o);
end

if length_p > 0
    for j = 1: length_p
        privacy = env.privacy_list(j,:);
        dis_p(j) = sqrt((current_point(1) - privacy(1)).^2 + (current_point(2) - privacy(2)).^2 + (current_point(3) - privacy(3)).^2);
    end
    PR_risk = min(dis_p);
end

