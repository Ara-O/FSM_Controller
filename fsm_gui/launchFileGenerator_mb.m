function launchFileGenerator_mb(launchname,worldname, foldName, num_robots)
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
foldName = foldName(1:end-4);
% open file in: ../FSMs/fsmFileNameFolder/launchFileName
launchname = [launchname(1:end-7),'_mb.launch'];  % Take off '.launch', add _mb.launch
lo = fopen(['../FSMs/' foldName '/' launchname],'w');
% open path folder (FOR TESTING)
% lo = fopen(launchname, 'w');

%% Print to file
% fprintf(lo,'                                 \n');

fprintf(lo,'<!-- This launch file was automatically generated -->  \n\n');
fprintf(lo,'<launch>                                       \n');
fprintf(lo,'  <param name="/use_sim_time" value="true"/>   \n\n');
%% World
fprintf(lo,'<!-- Open the world -->  \n');
fprintf(lo,'  <node pkg="stage_ros" type="stageros" name="IGVC_stage" args="$(find fsm_controller)/FSMs/%s/%s" output="screen">\n',foldName,worldname);
fprintf(lo,'     <!--for each robot, we need to change base_scan to scan             --> \n');
fprintf(lo,'     <!-- for each robot, we need to change cmd_vel to move_base/cmd_vel --> \n');

%    <remap from="/robot_0/base_scan" to="/robot_0/scan" />   
%   <remap from="/robot_0/cmd_vel" to="/robot_0/move_base/cmd_vel" /> 
for i = 1:num_robots
    curr = num2str(i-1);
    fprintf(lo,'  <remap from="/robot_%s/base_scan" to="/robot_%s/scan" />            \n',curr,curr);
    fprintf(lo,'  <remap from="/robot_%s/cmd_vel" to="/robot_%s/move_base/cmd_vel" /> \n',curr,curr);

end
fprintf(lo,'  </node>                                                    \n\n');
%% move_base

fprintf(lo,'<!-- Start move_base for each robot -->                        \n');
fprintf(lo,'<!-- Each group declare one robot   -->                        \n');

for i = 1:num_robots
  curr = num2str(i-1);  % Convert number to string to use in launch file

  fprintf(lo,' <group ns = "robot_%s">                                     \n',curr);
  fprintf(lo,'  <param name="tf_prefix" value="robot_%s" />                \n',curr);
  fprintf(lo,'  <arg name="no_static_map" default="true"/>                 \n');
  fprintf(lo,'  <arg name="base_global_planner" default="navfn/NavfnROS"/> \n');
  fprintf(lo,'  <arg name="base_local_planner" default="dwa_local_planner/DWAPlannerROS"/> \n\n');

  fprintf(lo,'  <node pkg="move_base" type="move_base" respawn="false" name="move_base" output="screen" > <!-- Change node name--> \n\n');

  fprintf(lo,'    <param name="base_global_planner" value="$(arg base_global_planner)"/>         \n');
  fprintf(lo,'    <param name="base_local_planner" value="$(arg base_local_planner)"/>           \n');
  fprintf(lo,'    <rosparam file="$(find husky_navigation)/config/planner.yaml" command="load"/> \n\n');

  fprintf(lo,'    <rosparam file="$(find husky_navigation)/config/costmap_common.yaml" command="load" ns="global_costmap" /> \n');
  fprintf(lo,'    <rosparam file="$(find husky_navigation)/config/costmap_common.yaml" command="load" ns="local_costmap" /> \n\n');

  fprintf(lo,'    <rosparam file="$(find husky_navigation)/config/costmap_local.yaml" command="load" ns="local_costmap" /> \n');
  fprintf(lo,'    <param name="local_costmap/width" value="10.0"/>          \n');
  fprintf(lo,'    <param name="local_costmap/height" value="10.0"/>         \n\n');
   
  fprintf(lo,'    <rosparam file="$(find husky_navigation)/config/costmap_global_static.yaml" command="load" ns="global_costmap" unless="$(arg no_static_map)"/> \n\n');

  fprintf(lo,'    <rosparam file="$(find husky_navigation)/config/costmap_global_laser.yaml" command="load" ns="global_costmap" if="$(arg no_static_map)"/> \n');
  fprintf(lo,'    <param name="global_costmap/width" value="200.0" if="$(arg no_static_map)"/>  \n');
  fprintf(lo,'    <param name="global_costmap/height" value="200.0" if="$(arg no_static_map)"/> \n\n');

  fprintf(lo,'    <remap from="cmd_vel" to="~cmd_vel" />                   \n');
  fprintf(lo,'  </node>                                                   \n');
  fprintf(lo,' </group>                                                   \n\n');

end    % End move_base generation per robot

fprintf(lo,'                                                               \n');

%% Global Navigation
% (simple_navigation_goals)
fprintf(lo,'<!-- open movebasegoal for each robot  --> \n');

for i = 1:num_robots
  curr = num2str(i-1);

  %   <node pkg="simple_navigation_goals" type="matgoal_movebasegoal_0" name="matgoalTOmovebasegoal_0" output="screen" ns="robot_0">
  fprintf(lo,'  <node pkg="simple_navigation_goals" type="matgoal_movebasegoal_%s" name="matgoalTOmovebasegoal_%s"  output="screen" ns = "robot_%s"> \n',curr,curr,curr);
  fprintf(lo,'  </node> \n');

end % End global navigation per robot

fprintf(lo,'\n');
fprintf(lo,'</launch>');

fclose(lo);

% The format of a launch file is:
% <!-- This is a comment -->
% <launch> starts a launch file
% </launch> ends a launch file
% <node stuffstuffstuff> opens a node with the stuff parameters
% </node> indicates the end of the node commands