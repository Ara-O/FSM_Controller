function robot = setupRobot(robot,num)
% Author: Jonathon Kreska
% Version: 1.0
% Date: December 16, 2015
% Changelog:
%  1.0: Initial Release
% Current Capability:
%  Returns the robot cell matrix updated with ROS publisher of goals and
%  subscriber to odometry.
% Input:
%  robot = cell matrix of robot{num}
%  num = the current robot number
% Output:
%  robot = updated cell matrix of robot{num}

%Subscriber to Stage Odometry
robotSubName = [ '/robot' char(num+48) '/odom'];
robot.odom_sub = rossubscriber(robotSubName,rostype.nav_msgs_Odometry);

%Publish goals to Movebase
robotPubName = [ '/robot' char(num+48) '/move_base_simple/goal'];
robot.goal_pub =  rospublisher(robotPubName);
robot.goal_msg=rosmessage(robot.goal_pub);