function robot = updateLocations(robot)
% Author: Jonathon Kreska
% Version: 1.0
% Date: December 16, 2015
% Changelog:
%  1.0: Initial Release
% Current Capability:
%  Reads the latest Odometry messages of the current robot and returns the robot 
%  cell matrix updated with the current X,Y position and converted angle 
%  direction of the current robot
% Input:
%  robot = cell matrix of robot
% Output:
%  robot = updated cell matrix of robot

%disp(robot.odom_sub.LatestMessage.Pose.Pose.Position.X)
%disp(robot.odom_sub.LatestMessage.Pose.Pose.Position.Y)

robot.X = robot.odom_sub.LatestMessage.Pose.Pose.Position.X;
robot.Y = robot.odom_sub.LatestMessage.Pose.Pose.Position.Y;

%disp(robot.odom_sub.LatestMessage.Pose.Pose.Orientation.X)
%disp(robot.odom_sub.LatestMessage.Pose.Pose.Orientation.Y)
%disp(robot.odom_sub.LatestMessage.Pose.Pose.Orientation.Z)
%disp(robot.odom_sub.LatestMessage.Pose.Pose.Orientation.W)

x = robot.odom_sub.LatestMessage.Pose.Pose.Orientation.X;
y = robot.odom_sub.LatestMessage.Pose.Pose.Orientation.Y;
z = robot.odom_sub.LatestMessage.Pose.Pose.Orientation.Z;
w = robot.odom_sub.LatestMessage.Pose.Pose.Orientation.W;
theta = quat2axang([w x y z]);
if theta(3) < 0
  robot.THETA = 2*pi - theta(4);
else 
  robot.THETA = theta(4);
end