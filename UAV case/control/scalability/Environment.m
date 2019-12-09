classdef Environment
    properties
        obstacle_list=[];
        privacy_list=[];
    end
    methods
        function env = Environment()
            env.obstacle_list=[];
            env.privacy_list=[];
        end
        
        function env = add_obstacle(env, obstacle_x, obstacle_y, obstacle_z)
            obs = [obstacle_x, obstacle_y, obstacle_z];
%             env.obstacle_list;
            list = [env.obstacle_list; obs];
            env.obstacle_list = list;
        end
        
        function env = remove_obstacle(env)
            env.obstacle_list = [];
        end
        
        function env = add_privacy(env, privacy_x, privacy_y, privacy_z)
            obs = [privacy_x, privacy_y, privacy_z];
%             env.obstacle_list;
            list = [env.privacy_list; obs];
            env.privacy_list = list;
        end
        
        function env = remove_privacy(env)
            env.privacy_list = [];
        end
        
        function env = map_tools(env, x, y, z)
            global configure
            index = unifrnd (0,1);  
            if index <= configure.obstacle_likelihood
                while 1
%                     x, y, z
%                     max(x - configure.viewradius,configure.obstacle_radius)
%                     min(x + configure.viewradius,configure.grid_x - configure.obstacle_radius)
%                   temp_x = unifrnd(max(x - configure.viewradius,configure.obstacle_radius), min(x + configure.viewradius,configure.grid_x - configure.obstacle_radius));
%                   temp_y = unifrnd(max(y - configure.viewradius,configure.obstacle_radius), min(y + configure.viewradius,configure.grid_y - configure.obstacle_radius));
%                   temp_z = unifrnd(max(z - configure.viewradius,configure.obstacle_radius), min(z + configure.viewradius,configure.grid_z - configure.obstacle_radius));
                  
                  temp_x = unifrnd(0+configure.obstacle_radius, configure.grid_x-1-configure.obstacle_radius);
                  temp_y = unifrnd(0+configure.obstacle_radius, configure.grid_y-1-configure.obstacle_radius);
                  temp_z = unifrnd(0+configure.obstacle_radius, configure.grid_z-1-configure.obstacle_radius);
                  
                  left = [x,y,z];
                  right = [x+1,y+1,z+1];
                  o = [temp_x,temp_y,temp_z];
                  lr = [right(1)-left(1), right(2)-left(2), right(3)-left(3)];
                  lo = [o(1)-left(1), o(2)-left(2), o(3)-left(3)];
                  angle = acos(dot(lo, lr)/(norm(lo)*norm(lr)));
                  dis = sin(angle)*norm(lo);
                  if dis <= configure.obstacle_radius + configure.radius
%                         continue
%                   end
%                   if sqrt((temp_x-x).^2 + (temp_y-y).^2 + (temp_z-z).^2 ) <= configure.obstacle_radius + configure.radius
                        continue
                  else
                       env = env.add_obstacle(temp_x, temp_y, temp_z );
                        break
                  end
                end
            else
                 while 1
%                   temp_x = unifrnd(max(x - configure.viewradius,configure.privacy_radius), min(x + configure.viewradius,configure.grid_x - configure.privacy_radius));
%                   temp_y = unifrnd(max(y - configure.viewradius,configure.privacy_radius), min(y + configure.viewradius,configure.grid_y - configure.privacy_radius));
%                   temp_z = unifrnd(max(z - configure.viewradius,configure.privacy_radius), min(z + configure.viewradius,configure.grid_z - configure.privacy_radius));

                    temp_x = unifrnd(0+configure.privacy_radius, configure.grid_x-1-configure.privacy_radius);
                    temp_y = unifrnd(0+configure.privacy_radius, configure.grid_y-1-configure.privacy_radius);
                    temp_z = unifrnd(0+configure.privacy_radius, configure.grid_z-1-configure.privacy_radius);
                  
                  left = [x,y,z];
                  right = [x+1,y+1,z+1];
                  o = [temp_x,temp_y,temp_z];
                  lr = [right(1)-left(1), right(2)-left(2), right(3)-left(3)];
                  lo = [o(1)-left(1), o(2)-left(2), o(3)-left(3)];
                  angle = acos(dot(lo, lr)/(norm(lo)*norm(lr)));
                  dis = sin(angle)*norm(lo);
                  if dis <= configure.privacy_radius + configure.radius
%                         continue
%                   end
%                   if sqrt((temp_x-x).^2 + (temp_y-y).^2 + (temp_z-z).^2 ) <= configure.privacy_radius + configure.radius
                        continue
                  else
                        env = env.add_privacy(temp_x, temp_y, temp_z );
                        break
                  end
                end
            end                          
        end
        
        function env = map_initial(env, k)
            global configure
            while k > 0
               index = unifrnd (0,1);
                if index <= configure.obstacle_likelihood 
                    temp_x = unifrnd(0+configure.obstacle_radius, configure.grid_x-1-configure.obstacle_radius);
                    temp_y = unifrnd(0+configure.obstacle_radius, configure.grid_y-1-configure.obstacle_radius);
                    temp_z = unifrnd(0+configure.obstacle_radius, configure.grid_z-1-configure.obstacle_radius);
                    env = env.add_obstacle(temp_x, temp_y, temp_z );
                else                    
                    temp_x = unifrnd(0+configure.privacy_radius, configure.grid_x-1-configure.privacy_radius);
                    temp_y = unifrnd(0+configure.privacy_radius, configure.grid_y-1-configure.privacy_radius);
                    temp_z = unifrnd(0+configure.privacy_radius, configure.grid_z-1-configure.privacy_radius);
                    env = env.add_privacy(temp_x, temp_y, temp_z );
                end
            k = k-1;
            end
        end
        
        function env = map_initial2(env, k, rate)
            global configure          
%             while k > 0
%                index = unifrnd (0,1);
%                 if index <= rate
                for index = 1:1:floor(k*rate)
                    temp_x = unifrnd(0+configure.obstacle_radius, configure.grid_x-1-configure.obstacle_radius);
                    temp_y = unifrnd(0+configure.obstacle_radius, configure.grid_y-1-configure.obstacle_radius);
                    temp_z = unifrnd(0+configure.obstacle_radius, configure.grid_z-1-configure.obstacle_radius);
                    env = env.add_obstacle(temp_x, temp_y, temp_z );
                end
%                 else                    
                for index = 1:1:floor(k*(1-rate))
                    temp_x = unifrnd(0+configure.privacy_radius, configure.grid_x-1-configure.privacy_radius);
                    temp_y = unifrnd(0+configure.privacy_radius, configure.grid_y-1-configure.privacy_radius);
                    temp_z = unifrnd(0+configure.privacy_radius, configure.grid_z-1-configure.privacy_radius);
                    env = env.add_privacy(temp_x, temp_y, temp_z );
                end
%             k = k-1;
%             end
        end
        
    end
end

        