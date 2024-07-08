function launchFileGenerator_mb(launchname,worldname, foldName, num_robots,num_tasks, num_regions, num_scenarios, robots_loc)
% Generates a launch file for use in ROS. Opens a stage world, navigation,
% and path planning nodes.
%   call: launchFileGenerator(launchname,worldname,foldName,num_robots)
% Variables requred for the launchfile generation:
%   launchname - the desired name for the launch file (with .launch)
%   worldname - the name of the world file (with .world)
%   foldName - name of folder to store launch file (with .fsm or .xxx)
%   num_robots - number of robots

%% Variables and file open
% remove .fsm

if contains(foldName, ".fsm")
    foldName = foldName(1:end-4);
end

robotsFileName = cellstr(["robots" num2str(num_tasks) num2str(num_regions) num2str(num_robots) num2str(str2num(num_scenarios), "%02d") ".launch"]);
robotsFileName = strrep(join(robotsFileName), " ", "");
% open file in: ../FSMs/fsmFileNameFolder/launchFileName
launchname = [launchname(1:end-7),'_mb.launch'];  % Take off '.launch', add _mb.launch
%lo = fopen(['../FSMs/' foldName '/' launchname],'w');
lo = fopen(['../FSMs/' foldName '/' launchname],'w');

% open path folder (FOR TESTING)
% lo = fopen(launchname, 'w');

%% Print to file
% fprintf(lo,'                                 \n');

fprintf(lo,'<launch> \n\n');
fprintf(lo,'<!-- start world -->\n\n');
fprintf(lo,'<!-- these are the arguments you can pass this launch file, for example paused:=true -->\n');
%% World
fprintf(lo,'<arg name="paused" default="false" />\n');
fprintf(lo,'<arg name="use_sim_time" default="true" />\n');
fprintf(lo,'<arg name="gui" default="true" />\n');
fprintf(lo,'<arg name="headless" default="false" />\n');
fprintf(lo,'<arg name="debug" default="false" />\n\n');

fprintf(lo,'<!-- We resume the logic in empty_world.launch, changing only the name of the world to be launched -->\n');
%Including files
fprintf(lo,'<include file="$(find gazebo_ros)/launch/empty_world.launch">\n');
fprintf(lo,'<arg name="world_name" value="$(find p3dx_gazebo)/worlds/feb2_scenario.world" />\n');
fprintf(lo,'<arg name="debug" value="$(arg debug)" />\n');
fprintf(lo,'<arg name="gui" value="$(arg gui)" />\n');
fprintf(lo,'<arg name="paused" value="$(arg paused)" />\n');
fprintf(lo,'<arg name="use_sim_time" value="$(arg use_sim_time)" />\n');
fprintf(lo,'<arg name="headless" value="$(arg headless)" />\n');
fprintf(lo,'</include>\n\n');
fprintf(lo,'<!-- include our robots -->\n');

%Include robots file
fprintf(lo,'<include file="$(find p3dx_gazebo)/launch/%s"/>\n', robotsFileName);
fprintf(lo,'</launch>');
fclose(lo);

%Robots file
%robotsFileNameParsed = strcat('../FSMs/', foldName, '/', robotsFileName);
robotsFileNameParsed = strcat('../FSMs/', foldName, '/', robotsFileName);

robotsFile = fopen(robotsFileNameParsed,'w');


fprintf(robotsFile,'<launch>\n\n');

for i= 1:num_robots
    %Loop per robot
    fprintf(robotsFile,' <!-- BEGIN ROBOT %d -->\n', i);
    fprintf(robotsFile,'<group ns="robot%d">\n', i);
    fprintf(robotsFile,'<param name="tf_prefix" value="robot%d_tf" />\n', i);
    fprintf(robotsFile,'<include file="$(find p3dx_gazebo)/launch/one_robot.launch" >\n');
    fprintf(robotsFile,'<arg name="init_pose" value="-x %f -y %f -z 0.0" />\n', robots_loc{i, 1}, robots_loc{i, 2});
    fprintf(robotsFile,'<arg name="robot_name"  value="robot%d" /></include>\n', i);
    fprintf(robotsFile,'</group>\n');
end
    fprintf(robotsFile,'</launch>\n\n');
fclose(robotsFile);



