import os
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription
from launch.substitutions import LaunchConfiguration
from launch.launch_description_sources import PythonLaunchDescriptionSource
from ament_index_python.packages import get_package_share_directory

def generate_launch_description():
    # Path to default world file
    default_world_file = os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'p3dx_navigation', 'maps', 'S_full_rn10.world')

    # Declare the launch arguments
    declared_arguments = [
        DeclareLaunchArgument('paused', default_value='false', description='Start the simulation paused'),
        DeclareLaunchArgument('world', default_value=default_world_file, description='World file to launch the robots in'),
        DeclareLaunchArgument('use_sim_time', default_value='true', description='Use simulation (Gazebo) clock'),
        DeclareLaunchArgument('gui', default_value='true', description='Run with GUI'),
        DeclareLaunchArgument('headless', default_value='false', description='Run headless (no GUI)'),
        DeclareLaunchArgument('debug', default_value='false', description='Enable debug mode'),
    ]

    # Path to the gazebo_ros launch file
    gazebo_ros_pkg = get_package_share_directory('gazebo_ros')
    gazebo_launch_file = os.path.join(gazebo_ros_pkg, 'launch', 'gazebo.launch.py')

    # Include the Gazebo launch file
    start_gazebo = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([gazebo_launch_file]),
        launch_arguments={
            'world': LaunchConfiguration('world'),
            'paused': LaunchConfiguration('paused'),
            'use_sim_time': LaunchConfiguration('use_sim_time'),
            'gui': LaunchConfiguration('gui'),
            'headless': LaunchConfiguration('headless'),
            'debug': LaunchConfiguration('debug'),
        }.items()
    )

    p3dx_robot_launch_file = os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'p3dx_gazebo', 'robots44210.launch.py')

    robot = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([p3dx_robot_launch_file])
    )

    return LaunchDescription(declared_arguments + [start_gazebo, robot])
