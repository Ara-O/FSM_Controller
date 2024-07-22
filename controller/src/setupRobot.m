function robot = setupRobot(num)
    % Author: Jonathon Kreska, Ara Oladipo
    % Version: 2.0
    % Date: June 20, 2024
    % Changelog:
    %  1.0: Initial Release
    %  2.0: Upgrade to use ROS2
    % Current Capability:
    %  Returns the robot cell matrix updated with ROS publisher of goals and
    %  subscriber to odometry.
    % Input:
    %  num = the current robot number
    % Output:
    %  robot = struct with updated ROS subscriber and publisher

    % Initialize the structure to hold ROS objects
    robot = struct();
    
    % Define topic names based on robot number
    robotSubName = ['/robot' char(num+48) '/odom'];
    robotPubName = ['/robot' char(num+48) '/goal_pose'];
    
    % Create ROS 2 node
    robot.node = ros2node(['robot' char(num+48)]);
    
    % Create ROS 2 subscriber for odometry
    robot.odom_sub = ros2subscriber(robot.node, robotSubName, 'nav_msgs/Odometry');
    
    % Create ROS 2 publisher for goal poses
    robot.goal_pub = ros2publisher(robot.node, robotPubName, 'geometry_msgs/PoseStamped');
    robot.goal_msg = ros2message(robot.goal_pub);
end
