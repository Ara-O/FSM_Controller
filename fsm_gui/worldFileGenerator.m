function worldFileGenerator(tasks,numRobots,regions,worldname,robotStart,foldName, obstacleNum)
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

foldName = foldName(1:end-4); %Strip off .fsm from file name to make a folder

% Note: this can be made dynamic by looking at the FSM. OR, having the GUI
% output an array (cell array preferred) that holds the starting position
% of each robot in order of robots (eg, robot1 then 2 then 3).

%TODO:
% From state 1 (s1), you can determine the starting region of each robot.
% Look at my 'mainController' to see how I cycled through regions

%% Static Portion
fo = fopen([ '../FSMs/' foldName '/' worldname],'w');
% fo = fopen([worldname],'w');    % This line is for testing! Delete later

fprintf(fo,'# ##### This world file was automatically generated #####\n\n');
fprintf(fo,'include "include/stage_igvc_obstacles.inc"\n');
fprintf(fo,'include "include/stage_igvc_waypoints.inc"\n');
fprintf(fo,'include "include/husky_camera.inc"\n\n');

fprintf(fo,'# set the resolution of the underlying raytrace model in meters\n');
fprintf(fo,'resolution 0.02 \n\n');

fprintf(fo,'threads 8         # Multi-core Processing! \n');
fprintf(fo,'interval_sim 100  # simulation timestep in milliseconds \n\n');

fprintf(fo,'window                     \n');
fprintf(fo,'(                          \n');
fprintf(fo,'  size [ 700.000 700.000 ] \n');
fprintf(fo,'  rotate [ 0.000 0.000 ]   \n');
fprintf(fo,'  scale 15                 \n');
fprintf(fo,')                          \n\n');

fprintf(fo,'define map model     \n');
fprintf(fo,'(                    \n');
fprintf(fo,'  color "purple"     \n');
fprintf(fo,'  boundary 1         \n');
fprintf(fo,'  fiducial_return 0  \n');
fprintf(fo,'  gripper_return 0   \n');
fprintf(fo,')                    \n\n');

fprintf(fo,'map                                \n');
fprintf(fo,'(                                  \n');
fprintf(fo,'  name "testmap"                   \n');
fprintf(fo,'  bitmap "include/wall2.png"	     \n');
fprintf(fo,'  size [42.0 42.0 1.0]             \n');
fprintf(fo,'  pose [ 0.000 0.000 0.000 0.000 ] \n');
fprintf(fo,')                                  \n\n');

%% Dynamic Portion

fprintf(fo,'\n');

%% Random Robot Starting Positions
% Uncomment this if you want random start positions, and comment OUT the
% static positions portion below.

% % number of regions = size of regions((1:end not including task regions),first column)
% flagStart = false;  % There is no "start" task
% for j = 1:num_tasks     % Check to see if the useless "start" task exists
%     if strcmp(tasks(j,1),'start')   
%         flagStart = true;   % There IS a "start" task
%     end
% end
% if(flagStart)   % Because the "start" task WILL NOT BE in the regions array...
%     [reg,~] = size(cell2mat(regions(1:end-(num_tasks-1),1))); % The regions and their names
% %     'Start found'
% else    % The num_tasks includes "start" so if no, do not need to subtract it.
%     [reg,~] = size(cell2mat(regions(1:end-(num_tasks),1))); % The regions and their names
% %     'Start not found'
% end
% 
% xR = zeros(1,numRobots);
% yR = zeros(1,numRobots);
% i = 1;  % This is for the robot counter
% % Cycle through the regions array and the starting positions array
% for j = 1:reg       
%     for k = 1:size(robotStart)
%         % If the current region name matches the robot's starting region...
%         if strcmp(regions(j),robotStart(k,1))   
%            x1 = cell2mat(regions(j,2)); % Extract the corners of the region
%            x2 = cell2mat(regions(j,4));
%            y1 = cell2mat(regions(j,3));
%            y2 = cell2mat(regions(j,5));
%            % Create a random start in the region, based on the corners.
%            xR(i) = (x2-x1)*rand(1) + x1; 
%            yR(i) = (y2-y1)*rand(1) + y1;
%            i = i+1; % Increment robot counter to next robot.
%         end
%     end
% end

%% Static Robot Starting Positions
% The start point cell array is needed for this. Each robot will start at a
% pre-defined position, according to what is entered into the GUI.
% Comment this section OUT if you want random starting positions, and
% UNCOMMENT the random start position section above.

xR = zeros(1,numRobots);
yR = zeros(1,numRobots);
% i = 1;  % This is for the robot counter

for i = 1:numRobots
  xR(i) = robotStart{i,2}; % Extract the location of the robots
  yR(i) = robotStart{i,3};
end

%% Print the robots

% Cerberus
% for i = 1:numRobots
%     
%   curr = num2str(i-1);
%   
%   fprintf(fo,'cerberus(		  \n');
%   fprintf(fo,'  name "Robot_%s" \n',curr);
%   fprintf(fo,'  pose [ %3.3f %3.3f 0.000 90.000 ] \n',xR(i),yR(i));
%   fprintf(fo,'  localization "gps" \n');
%   fprintf(fo,'  localization_origin [ 0 0 0 0 ] \n');
%   fprintf(fo,') \n');
% 
% end

% Husky
for i = 1:numRobots
    
  curr = num2str(i-1);
  
  fprintf(fo,'husky_base( \n');
  fprintf(fo,'  name "Robot_%s" \n',curr);
  fprintf(fo,'  pose [ %3.3f %3.3f 0.00%i 90.000 ] \n',xR(i),yR(i),i);
  fprintf(fo,'  localization "gps" \n');
  fprintf(fo,'  localization_origin [ 0 0 0 0 ] \n');
  fprintf(fo,') \n');

end

fprintf(fo,'\n');


%% Print waypoints on each goal/task point
xG = zeros(1,num_tasks); % initalize goal/task array. Will need these later
yG = zeros(1,num_tasks);

for i = 1:num_tasks  
    % Cell format can't be referenced by fprintf, so convert to matrix.
    xG(i) = cell2mat(tasks(i,2)); % x position is second column
    yG(i) = cell2mat(tasks(i,3)); % y position is third column
  fprintf(fo,'waypoint2m%i ( pose [  %d %d 0.000 0.000 ]) \n',i,xG(i),yG(i));
    % the "%d" references a signed integer of 32 bits
end
% waypoint2m ( pose [  -2 -5 0.000 0.000 ])



%% Obstacles

area = cell2mat(regions(:,2:end));  % The numbers defining the regions
maxPt = max(area(:));   % The map is a square, so the maximum our regions go
minPt = min(area(:));   % Square, so this is the minimum the regions go.

% num_obs = randi(obstacleNum,1); % random bumber of obstacles UP TO obstacleNum
xObs = zeros(obstacleNum,1);
yObs = zeros(obstacleNum,1);

fprintf(fo,'\n');

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

for i = 1:obstacleNum
   fprintf(fo,'barrel ( pose [ %i  %i  0.000 0.000 ] )\n',xObs(i),yObs(i));
end

fclose(fo);