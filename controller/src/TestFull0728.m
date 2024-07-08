clear all;

addpath('src') %
rosshutdown;
rosinit('localhost');

run(['fsmdata.m']);
%run(['../FSMs/' foldName '/userdata' num2str(runningScenario) '.m']);
run(['userdata14.m']);

  for i=1:numRobots                              %Setup Each Robot
    robot{i} = struct;
    robot{i} = setupRobot(robot{i},i-1);   % i-1 because Stage starts with robot_0
    %Movebase fixes
    robot{i}.old_goal_X = 666;
    robot{i}.old_goal_Y = 666;
    robot_previous_location_x(i)=666;
    robot_previous_location_y(i)=666;
    goal_need_resend(i)=0;
    robot_change_count(i)=0;
    robot{i}.first_time = true; % Quarter goal flow control 
    robot{i}.calc_region = true;
    robot{i}.next_event = 's';
    robot{i}.next_reg = []; %fixes: Reference to non-existent field 'next_reg'.
    
    goal{i} = [];                                %Initialize goal to nothing
    robot{i}.cur_task = '';                      %Initialize cur_task to empty
  end
  
  robot_tasks=0;
  step_through_final = false;
  step_through_local = false;
  init_cost = zeros(1,numRobots);
  clear start_loc;

  pause(.5)                                       %Wait for roscore to handshake
  disp('Setup complete!')

  %% Setup

  try                                            %Test to see if Stage is Running
    robot{1} = updateLocations(robot{1});
  catch ME
    disp('Is Stage running?')
    rethrow(ME)
  end

  for i=1:numRobots                              %Update Robot Locations
    robot{i} = updateLocations(robot{i});
    start_loc(i,1) = robot{i}.X;
    start_loc(i,2) = robot{i}.Y;
  end

  
  abstracted = true;
  start_events_only = true;
  abstracted=1;
  start_events_only=1;
  tic
  [plan,plan_state,plan_cost] = GA_abstract(states,abstracted,start_events_only,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks);
  t=toc;
  
  run(['fsmdataIncremental.m']);
  
  clear start_loc; % delete cell matrix locations from GUI
  for i=1:numRobots                              %Update Robot Locations
    robot{i} = updateLocations(robot{i});
    start_loc(i,1) = robot{i}.X;
    start_loc(i,2) = robot{i}.Y;
  end

  % Alter menu options to run local Dijkstra
  abstracted = false;
  start_events_only = false;