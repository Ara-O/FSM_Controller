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

robotsFileName = cellstr(["robots" num2str(num_tasks) num2str(num_regions) num2str(num_robots) num2str(str2num(num_scenarios), "%02d") ".launch.py"]);
mainFileName = cellstr(["main" num2str(num_tasks) num2str(num_regions) num2str(num_robots) num2str(str2num(num_scenarios), "%02d") ".launch.py"]);
robotsFileName = strrep(join(robotsFileName), " ", "");
% open file in: ../FSMs/fsmFileNameFolder/launchFileName
launchname = strrep(join(mainFileName), " ", ""); 
launchname = strcat('../FSMs/', foldName, '/', launchname);

lo = fopen(launchname,'w');

% open path folder (FOR TESTING)
% lo = fopen(launchname, 'w');

fprintf(lo, 'import os\n');
fprintf(lo, 'from launch import LaunchDescription\n');
fprintf(lo, 'from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription\n');
fprintf(lo, 'from launch.substitutions import LaunchConfiguration\n');
fprintf(lo, 'from launch.launch_description_sources import PythonLaunchDescriptionSource\n');
fprintf(lo, 'from ament_index_python.packages import get_package_share_directory\n\n');

fprintf(lo, 'def generate_launch_description():\n');
fprintf(lo, '    # Path to default world file\n');
fprintf(lo, "    default_world_file = os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'p3dx_navigation', 'maps', '%s')\n\n", worldname);

fprintf(lo, '    # Declare the launch arguments\n');
fprintf(lo, '    declared_arguments = [\n');
fprintf(lo, "        DeclareLaunchArgument('paused', default_value='false', description='Start the simulation paused'),\n");
fprintf(lo, "        DeclareLaunchArgument('world', default_value=default_world_file, description='World file to launch the robots in'),\n");
fprintf(lo, "        DeclareLaunchArgument('use_sim_time', default_value='true', description='Use simulation (Gazebo) clock'),\n");
fprintf(lo, "        DeclareLaunchArgument('gui', default_value='true', description='Run with GUI'),\n");
fprintf(lo, "        DeclareLaunchArgument('headless', default_value='false', description='Run headless (no GUI)'),\n");
fprintf(lo, "        DeclareLaunchArgument('debug', default_value='false', description='Enable debug mode'),\n");
fprintf(lo, '    ]\n\n');

fprintf(lo, '    # Path to the gazebo_ros launch file\n');
fprintf(lo, "    gazebo_ros_pkg = get_package_share_directory('gazebo_ros')\n");
fprintf(lo, "    gazebo_launch_file = os.path.join(gazebo_ros_pkg, 'launch', 'gazebo.launch.py\')\n\n");

fprintf(lo, '    # Include the Gazebo launch file\n');
fprintf(lo, '    start_gazebo = IncludeLaunchDescription(\n');
fprintf(lo, '        PythonLaunchDescriptionSource([gazebo_launch_file]),\n');
fprintf(lo, '        launch_arguments={\n');
fprintf(lo, "            'world': LaunchConfiguration('world'),\n");
fprintf(lo, "            'paused': LaunchConfiguration('paused'),\n");
fprintf(lo, "            'use_sim_time': LaunchConfiguration('use_sim_time'),\n");
fprintf(lo, "            'gui': LaunchConfiguration('gui'),\n");
fprintf(lo, "            'headless': LaunchConfiguration('headless'),\n");
fprintf(lo, "            'debug': LaunchConfiguration('debug'),\n");
fprintf(lo, '        }.items()\n');
fprintf(lo, '    )\n\n');

fprintf(lo, "    p3dx_robot_launch_file = os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'p3dx_gazebo', '%s')\n\n", robotsFileName{1});

fprintf(lo, '    robot = IncludeLaunchDescription(\n');
fprintf(lo, '        PythonLaunchDescriptionSource([p3dx_robot_launch_file])\n');
fprintf(lo, '    )\n\n');

fprintf(lo, '    return LaunchDescription(declared_arguments + [start_gazebo, robot])\n');

fclose(lo);

robotsFileNameParsed = strcat('../FSMs/', foldName, '/', robotsFileName);
robotsFile = fopen(robotsFileNameParsed, "w");

% --- Header imports ---
fprintf(robotsFile, "import os\n");
fprintf(robotsFile, "from launch import LaunchDescription\n");
fprintf(robotsFile, "from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription, GroupAction\n");
fprintf(robotsFile, "from launch_ros.actions import PushRosNamespace, SetParameter, Node\n");
fprintf(robotsFile, "from launch.substitutions import LaunchConfiguration\n");
fprintf(robotsFile, "from launch.launch_description_sources import PythonLaunchDescriptionSource\n");
fprintf(robotsFile, "from ament_index_python.packages import get_package_share_directory\n\n");

% --- Function start ---
fprintf(robotsFile, "def generate_launch_description():\n");
fprintf(robotsFile, "    one_robot_launch_file = os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'p3dx_gazebo', 'one_robot.launch.py')\n");
fprintf(robotsFile, "    default_map_file = os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'p3dx_navigation', 'maps', 'feb2_world.yaml')\n\n");

% --- create_robot_group function ---
fprintf(robotsFile, "    def create_robot_group(robot_index, robot_name, tf_prefix, init_pose):\n");
fprintf(robotsFile, "        return GroupAction([\n");
fprintf(robotsFile, "            IncludeLaunchDescription(\n");
fprintf(robotsFile, "                PythonLaunchDescriptionSource([one_robot_launch_file]),\n");
fprintf(robotsFile, "                launch_arguments={\n");
fprintf(robotsFile, "                    'init_pose': init_pose,\n");
fprintf(robotsFile, "                    'robot_name': robot_name,\n");
fprintf(robotsFile, "                    'robot_index': robot_index,\n");
fprintf(robotsFile, "                    'model': os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'urdf', robot_name + '.xacro')\n");
fprintf(robotsFile, "                }.items()\n");
fprintf(robotsFile, "            ),\n");
fprintf(robotsFile, "        ])\n\n");

% --- Generate robot groups ---
for i = 1:num_robots
    x = robots_loc{i, 1};
    y = robots_loc{i, 2};
    fprintf(robotsFile, "    robot%d_group = create_robot_group('%d', 'robot%d', 'robot%d_tf', '-x %.4f -y %.4f -z 0.0')\n", ...
        i, i, i, i, x, y);
end
fprintf(robotsFile, "\n");

% --- LaunchDescription setup ---
fprintf(robotsFile, "    ld = LaunchDescription([\n");
fprintf(robotsFile, "        DeclareLaunchArgument(\n");
fprintf(robotsFile, "            'map_file',\n");
fprintf(robotsFile, "            default_value=default_map_file,\n");
fprintf(robotsFile, "            description='The map that the robot will be localized in'\n");
fprintf(robotsFile, "        ),\n");

fprintf(robotsFile, "        Node(\n");
fprintf(robotsFile, "            package='nav2_map_server',\n");
fprintf(robotsFile, "            executable='map_server',\n");
fprintf(robotsFile, "            name='map_server',\n");
fprintf(robotsFile, "            output='screen',\n");
fprintf(robotsFile, "            parameters=[{\n");
fprintf(robotsFile, "                'use_sim_time': True,\n");
fprintf(robotsFile, "                'topic_name': 'map',\n");
fprintf(robotsFile, "                'frame_id': 'map',\n");
fprintf(robotsFile, "                'yaml_filename': LaunchConfiguration('map_file')\n");
fprintf(robotsFile, "            }]\n");
fprintf(robotsFile, "        ),\n");

% --- Add robot groups to LaunchDescription ---
for i = 1:num_robots
    fprintf(robotsFile, "        robot%d_group,\n", i);
end

% --- lifecycle_manager node ---
fprintf(robotsFile, "        Node(\n");
fprintf(robotsFile, "            package='nav2_lifecycle_manager',\n");
fprintf(robotsFile, "            executable='lifecycle_manager',\n");
fprintf(robotsFile, "            name='lifecycle_manager_map',\n");
fprintf(robotsFile, "            output='screen',\n");
fprintf(robotsFile, "            parameters=[{\n");
fprintf(robotsFile, "                'use_sim_time': True,\n");
fprintf(robotsFile, "                'bond_timeout': 0.0,\n");
fprintf(robotsFile, "                'autostart': True,\n");
fprintf(robotsFile, "                'node_names': ['map_server'");
for i = 1:num_robots
    fprintf(robotsFile, ", 'robot%d/amcl'", i);
end
fprintf(robotsFile, "]\n");
fprintf(robotsFile, "            }]\n");
fprintf(robotsFile, "        )\n");
fprintf(robotsFile, "    ])\n\n");

% --- Return statement ---
fprintf(robotsFile, "    return ld\n");

fclose(robotsFile);



