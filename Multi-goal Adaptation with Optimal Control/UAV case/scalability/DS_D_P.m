S_list=[];
P_list=[];
configure = Configure();
env = Environment();
name = 'gridmap-' + string(100) + '.mat';
gridmap = load(name);
env = gridmap.map;
env_known = env;
for i = 1:size(trajectory,1)   
    current_point = trajectory(i,:);
    length_o = 0;
    width_o = 0;
    length_p = 0;
    width_p = 0;
    [length_o, width_o] = size(env.obstacle_list);
    [length_p, width_p] = size(env.privacy_list);
    env_known = remove_obstacle(env_known);
    env_known = remove_privacy(env_known);
    for oo = 1:length_o
        if sqrt((env.obstacle_list(oo, 1)-current_point(1)).^2+(env.obstacle_list(oo, 2)-current_point(2)).^2+(env.obstacle_list(oo, 3)-current_point(3)).^2) <=configure.viewradius
            needplan = 1;
            env_known = add_obstacle(env_known, env.obstacle_list(oo, 1), env.obstacle_list(oo, 2), env.obstacle_list(oo, 3));
        end
    end
    
    for pp = 1:length_p
        if sqrt((env.privacy_list(pp, 1)-current_point(1)).^2+(env.privacy_list(pp, 2)-current_point(2)).^2+(env.privacy_list(pp, 3)-current_point(3)).^2) <=configure.viewradius
            needplan = 1;
            env_known = add_privacy(env_known, env.privacy_list(pp, 1), env.privacy_list(pp, 2), env.privacy_list(pp, 3));
        end
    end
    [DS_S, DS_P] =  caculate_DS(current_point, env_known);
    if DS_P < 1-1e-20
        i,DS_P
    end
    S_list = [S_list; DS_S];
    P_list = [P_list; DS_P];
end