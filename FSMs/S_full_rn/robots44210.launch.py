import os
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription, GroupAction
from launch_ros.actions import PushRosNamespace, SetParameter, Node
from launch.substitutions import LaunchConfiguration
from launch.launch_description_sources import PythonLaunchDescriptionSource
from ament_index_python.packages import get_package_share_directory

def generate_launch_description():
    one_robot_launch_file = os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'p3dx_gazebo', 'one_robot.launch.py')
    default_map_file = os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'p3dx_navigation', 'maps', 'feb2_world.yaml')

    def create_robot_group(robot_index, robot_name, tf_prefix, init_pose):
        return GroupAction([
            IncludeLaunchDescription(
                PythonLaunchDescriptionSource([one_robot_launch_file]),
                launch_arguments={
                    'init_pose': init_pose,
                    'robot_name': robot_name,
                    'robot_index': robot_index,
                    'model': os.path.join(get_package_share_directory('udm_pioneer_p3dx'), 'urdf', robot_name + '.xacro')
                }.items()
            ),
        ])

    robot1_group = create_robot_group('1', 'robot1', 'robot1_tf', '-x -0.7706 -y -1.8233 -z 0.0')
    robot2_group = create_robot_group('2', 'robot2', 'robot2_tf', '-x 1.9664 -y -2.4864 -z 0.0')

    ld = LaunchDescription([
        DeclareLaunchArgument(
            'map_file',
            default_value=default_map_file,
            description='The map that the robot will be localized in'
        ),
        Node(
            package='nav2_map_server',
            executable='map_server',
            name='map_server',
            output='screen',
            parameters=[{
                'use_sim_time': True,
                'topic_name': 'map',
                'frame_id': 'map',
                'yaml_filename': LaunchConfiguration('map_file')
            }]
        ),
        robot1_group,
        robot2_group,
        Node(
            package='nav2_lifecycle_manager',
            executable='lifecycle_manager',
            name='lifecycle_manager_map',
            output='screen',
            parameters=[{
                'use_sim_time': True,
                'bond_timeout': 0.0,
                'autostart': True,
                'node_names': ['map_server', 'robot1/amcl', 'robot2/amcl']
            }]
        )
    ])

    return ld
