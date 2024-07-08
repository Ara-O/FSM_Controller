function worldFileGazeboGenerator(tasks,numRobots,regions,worldname,robotStart,foldName, obstacleNum)
% This file generates a .world file for implementation in stage simulation.
% It requires variables to be saved into the workspace by the
% FSM_Interpreter GUI. 
%   Call: worldFileGenerator(tasks,numRobots,regions,worldname,robotStart);
% The variables are:
%   tasks - a cell array containing the tasks, names, and locations.
%   numRobots - the number of robots required in the simulation
%   regions - a cell array containing the regions, their definitions, and
%     their names.
%   worldname - a string containing the desired name for the world file
%   robotStart - a cell array containing the name of the starting region of 
%     each robot.
%   foldName - the folder name that the world file will be saved in. Comes
%      in as '4task4regions.fsm' and is trimmed to remove '.fsm'
%   obstacleNum - number of obstacles that should be added to the world
%      (user specified) 


%% Variables

[num_tasks,~] = size(tasks);    % How many tasks do we have? Will need later

if contains(foldName, ".fsm")
    foldName = foldName(1:end-4); %Strip off .fsm from file name to make a folder
end


xR = zeros(1,numRobots);
yR = zeros(1,numRobots);
% i = 1;  % This is for the robot counter

for i = 1:numRobots
  xR(i) = robotStart{i,2}; % Extract the location of the robots
  yR(i) = robotStart{i,3};
end


% Note: this can be made dynamic by looking at the FSM. OR, having the GUI
% output an array (cell array preferred) that holds the starting position
% of each robot in order of robots (eg, robot1 then 2 then 3).

%TODO:
% From state 1 (s1), you can determine the starting region of each robot.
% Look at my 'mainController' to see how I cycled through regions

%% Static Portion
fo = fopen([ '../FSMs/' foldName '/' worldname],'w');
if fo == -1
  mkdir(['../FSMs/' foldName])
  fo = fopen(['../FSMs/' foldName '/fsmdataIncremental.m'],'w');
end
fprintf(fo,"<sdf version='1.4'>\n<world name='default'>\n <light name='sun' type='directional'>\n");
fprintf(fo,"    <cast_shadows>1</cast_shadows>\n");
fprintf(fo,"      <pose>0 0 10 0 -0 0</pose>\n");
fprintf(fo, "     <diffuse>0.8 0.8 0.8 1</diffuse>\n");
fprintf(fo,"      <pose>0 0 10 0 -0 0</pose>\n");
fprintf(fo,"      <specular>0.2 0.2 0.2 1</specular>\n");
fprintf(fo,"      <attenuation>\n\t<range>1000</range>\n\t<constant>0.9</constant>\n\t<linear>0.01</linear>\n\t<quadratic>0.001</quadratic>\n\t</attenuation>\n");
fprintf(fo,"      <direction>-0.5 0.1 -0.9</direction>      \n");
fprintf(fo,"    </light>\n");
fprintf(fo,"    <model name='ground_plane'>\n");
fprintf(fo,"      <static>1</static>\n");
fprintf(fo,"      <link name='link'>\n");
fprintf(fo,"       <collision name='collision'>\n");
fprintf(fo,"          <geometry>\n");
fprintf(fo,"            <plane>\n");
fprintf(fo,"              <normal>0 0 1</normal>\n");
fprintf(fo,"              <size>100 100</size>\n");
fprintf(fo,"            </plane>\n");
fprintf(fo,"          </geometry>\n");
fprintf(fo,"          <surface>\n");
fprintf(fo,"            <friction>\n");
fprintf(fo,"              <ode>\n");
fprintf(fo,"                <mu>100</mu>\n");
fprintf(fo,"                <mu2>50</mu2>\n");
fprintf(fo,"              </ode>\n");
fprintf(fo,"            </friction>\n");
fprintf(fo,"            <bounce/>      \n");
fprintf(fo,"            <contact>\n");
fprintf(fo,"              <ode/>\n");
fprintf(fo,"            </contact>\n");
fprintf(fo,"          </surface>      \n");
fprintf(fo,"          <max_contacts>10</max_contacts>\n");
fprintf(fo,"        </collision>\n");
fprintf(fo,"        <visual name='visual'>\n");
fprintf(fo,"          <cast_shadows>0</cast_shadows>      \n");
fprintf(fo,"          <geometry>\n");
fprintf(fo,"            <plane>      \n");
fprintf(fo,"              <normal>0 0 1</normal>      \n");
fprintf(fo,"              <size>100 100</size>      \n");
fprintf(fo,"            </plane>\n");
fprintf(fo,"          </geometry>\n");
fprintf(fo,"          <material>\n");
fprintf(fo,"            <script>\n");
fprintf(fo,"              <uri>file://media/materials/scripts/gazebo.material</uri>\n");
fprintf(fo,"              <name>Gazebo/Grey</name>\n");
fprintf(fo,"            </script>\n");
fprintf(fo,"          </material>\n");
fprintf(fo,"        </visual>\n");
fprintf(fo,"        <velocity_decay>\n");
fprintf(fo,"          <linear>0</linear>\n");
fprintf(fo,"          <angular>0</angular>\n");
fprintf(fo,"        </velocity_decay>\n");
fprintf(fo,"        <self_collide>0</self_collide>\n");
fprintf(fo,"        <kinematic>0</kinematic>\n");
fprintf(fo,"        <gravity>1</gravity>\n");
fprintf(fo,"      </link>\n");
fprintf(fo,"    </model>\n");


%% Print waypoints on each goal/task point
xG = zeros(1,num_tasks); % initalize goal/task array. Will need these later
yG = zeros(1,num_tasks);

for i = 1:num_tasks  
    % Cell format can't be referenced by fprintf, so convert to matrix.
    xG(i) = cell2mat(tasks(i,2)); % x position is second column
    yG(i) = cell2mat(tasks(i,3)); % y position is third column
    %fprintf(fo,'<waypoint name="waypoint_%d"> <pose> %d %d 0 0 0 </pose> </waypoint> \n',i,xG(i),yG(i));
    % the "%d" references a signed integer of 32 bits
end

%% Obstacle

area = cell2mat(regions(:,2:end));  % The numbers defining the regions
maxPt = max(area(:));   % The map is a square, so the maximum our regions go
minPt = min(area(:));   % Square, so this is the minimum the regions go.

xObs = zeros(obstacleNum,1);
yObs = zeros(obstacleNum,1);

% Generate the obstacle locations
for i = 1:obstacleNum
   xObs(i) = randi([minPt maxPt],1);
   yObs(i) = randi([minPt maxPt],1);
end

% Check that the obstacle locations aren't within 1m of any robot start
% locations, and within 1m of any tasks.
for i = 1:obstacleNum
  for j = 1:numRobots
     while ((xObs(i)-1 <= xR(j))&&(xR(j)<= xObs(i)+1)) && ((yObs(i)-1 <= yR(j))&&(yR(j)<= yObs(i)+1))
        xObs(i) = randi([minPt maxPt],1);
        yObs(i) = randi([minPt maxPt],1);
     end
   for k = 1:num_tasks
      while ((xObs(i)-1 <= xG(j))&&(xG(j)<= xObs(i)+1)) && ((yObs(i)-1 <= yG(j))&&(yG(j)<= yObs(i)+1))
        xObs(i) = randi([minPt maxPt],1);
        yObs(i) = randi([minPt maxPt],1);
     end
   end
  end
end



for i= 1:obstacleNum
    fprintf(fo,"    <model name='box_obstacle_%d'> \n", i);
    fprintf(fo,"      <pose>%d %d 0.125 0 0 0</pose>\n", xObs(i), yObs(i));
    fprintf(fo,"      <static>true</static>\n");
    fprintf(fo,"      <link name='link'>\n");
    fprintf(fo,"        <pose>0 0 0 0 0 0</pose>\n");
    fprintf(fo,"        <collision name='collision'>\n");
    fprintf(fo,"          <geometry>\n");
    fprintf(fo,"            <box>\n");
    fprintf(fo,"              <size>0.25 0.25 0.25</size>\n");
    fprintf(fo,"            </box>\n");
    fprintf(fo,"          </geometry>\n");
    fprintf(fo,"        </collision>\n");   
    fprintf(fo,"        <visual name='visual'>\n");    
    fprintf(fo,"          <geometry>\n");
    fprintf(fo,"            <box>\n");  
    fprintf(fo,"              <size>0.25 0.25 0.25</size>\n");   
    fprintf(fo,"            </box>\n");   
    fprintf(fo,"          </geometry>\n");   
    fprintf(fo,"          <material>\n");   
    fprintf(fo,"            <script>\n");   
    fprintf(fo,"              <uri>file://media/materials/scripts/gazebo.material</uri>\n");   
    fprintf(fo,"              <name>Gazebo/White</name>\n");   
    fprintf(fo,"            </script>\n");   
    fprintf(fo,"          </material>\n");   
    fprintf(fo,"        </visual>\n");   
    fprintf(fo,"      </link>\n");   
    fprintf(fo,"    </model>\n");   
end
    
fprintf(fo,"    <physics type='ode'>\n");
fprintf(fo,"      <max_step_size>0.001</max_step_size>\n");
fprintf(fo,"      <real_time_factor>1</real_time_factor>\n");
fprintf(fo,"      <real_time_update_rate>1000</real_time_update_rate>\n");
fprintf(fo,"      <gravity>0 0 -9.8</gravity>\n");
fprintf(fo,"    </physics>\n");
fprintf(fo,"    <scene>\n");
fprintf(fo,"      <ambient>0.4 0.4 0.4 1</ambient>\n");
fprintf(fo,"      <background>0.7 0.7 0.7 1</background>\n");
fprintf(fo,"      <shadows>1</shadows>\n");
fprintf(fo,"    </scene>\n");
fprintf(fo,"    <spherical_coordinates>\n");
fprintf(fo,"      <surface_model>EARTH_WGS84</surface_model>\n");
fprintf(fo,"      <latitude_deg>0</latitude_deg>\n");
fprintf(fo,"      <longitude_deg>0</longitude_deg>\n");
fprintf(fo,"      <elevation>0</elevation>\n");
fprintf(fo,"      <heading_deg>0</heading_deg>\n");
fprintf(fo,"    </spherical_coordinates>     \n");
fprintf(fo,"    <state world_name='default'>\n");
fprintf(fo,"      <sim_time>720 994000000</sim_time>\n");
fprintf(fo,"      <real_time>302 715799688</real_time>\n");
fprintf(fo,"      <wall_time>1612280080 673831851</wall_time>\n");
fprintf(fo,"      <model name='ground_plane'>\n");
fprintf(fo,"        <pose>0 0 0 0 -0 0</pose>\n");
fprintf(fo,"        <link name='link'>\n");
fprintf(fo,"          <pose>0 0 0 0 -0 0</pose>\n");
fprintf(fo,"          <velocity>0 0 0 0 -0 0</velocity>\n");
fprintf(fo,"          <acceleration>0 0 0 0 -0 0</acceleration>\n");
fprintf(fo,"          <wrench>0 0 0 0 -0 0</wrench>\n");
fprintf(fo,"        </link>\n");
fprintf(fo,"      </model>\n");
fprintf(fo,"      <model name='unit_box_1'>\n");
fprintf(fo,"        <pose>1.25 0 0 0 -0 0</pose>\n");
fprintf(fo,"        <link name='link'>\n");
fprintf(fo,"          <pose>1.25 0 0 0 -0 0</pose>\n");
fprintf(fo,"          <velocity>0 0 0 0 -0 0</velocity>\n");
fprintf(fo,"          <acceleration>0 0 0 0 -0 0</acceleration>\n");
fprintf(fo,"          <wrench>0 0 0 0 -0 0</wrench>\n");
fprintf(fo,"        </link>\n");
fprintf(fo,"      </model>\n");
fprintf(fo,"    </state>\n");
fprintf(fo,"    <gui fullscreen='0'>\n");
fprintf(fo,"      <camera name='user_camera'>\n");
fprintf(fo,"        <pose>1.17968 -0.248018 24.7979 4.45261e-16 1.4458 1.6122</pose>\n");
fprintf(fo,"        <view_controller>orbit</view_controller>\n");
fprintf(fo,"      </camera>\n");
fprintf(fo,"    </gui>\n");
fprintf(fo,"  </world>\n</sdf>\n");

%% Dynamic Portion

fprintf(fo,'\n');


fclose(fo);