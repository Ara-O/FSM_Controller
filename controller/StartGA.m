% Start Script
% Author: Jonathon Kreska
% Version: 1.1
% Date: May 3, 2016
% Changelog:
%  1.0: Initial Release
%  1.1: Cleaned up code and Simplified

% Running this and selecting options will get the controllers ready for you

%% Clean-up
clear; close ALL; clc;

addpath('src') %Add functions to path

%% menu
% disp('Menu 1=yes 0=no')
% OFFLINE = logical(input('Running Offline? '));
% ABSTRACTED = logical(input('Abstracted Scenario? '));
% if ABSTRACTED
%   START_EVENTS_ONLY = logical(input('Start Events Only? '));
% else
%   START_EVENTS_ONLY = false;
% end
REGIONS_EXIST = logical(input('Are there regions? '));

%% Initialize

disp('Choose Scenario Name:')

if ~REGIONS_EXIST
  
  disp('1 = 4tasks2robots')
  disp('2 = 6tasks3robots')
  disp('3 = 10tasks3robots')
  disp('4 = 4tasksNoRegions1robot')
  disp('5 = 8tasksNoRegions1robot_rn')
  disp('6 = 16tasksNoRegions1robot_rn')

else
  
  disp('1 = 4tasks4regions')
  disp('2 = 4tasks9regions')
  disp('3 = 4tasks4regions1robot')
  disp('4 = 8tasks4Regions1robot')
  disp('5 = 8tasks9Regions1robot')
  disp('6 = 6tasks9regions')
  disp('7 = 6tasks9regions3robots')
  disp('8 = 10tasks9regions')
  disp('9 = 10tasks9regionsModular')
  disp('10 = 10tasks9regions3robots')
  disp('25 = 6tasks6regions')
  disp('32 = 6tasks9regions3')
  disp('24 = 12tasks9regions3robots')
  disp('78 = 14tasks9regions3robots')
  disp('0 = 8tasks9regions3robots')
  disp('56 = 6tasks9regions2robots')
  
  
end


choice = input('Choice: ','s'); %Get Scenario name from user

if ~REGIONS_EXIST
  if     choice == '1'
    foldName    = '4tasks2robots_rn';
    ABSfoldName = '4tasks2robotsABSTRACT_rn';
  elseif choice == '2'
    foldName    = '6tasks3robots_rn';
    ABSfoldName = '6tasks3robotsABSTRACT_rn';
  elseif choice == '3'
    foldName    = '10tasks3robots_rn';
    ABSfoldName = '10tasks3robotsABSTRACT_rn';
  elseif choice == '4'
    foldName    = '4tasksNoRegions1robot_rn';
    ABSfoldName = '4tasksNoRegions1robotABSTRACT_rn';
  elseif choice == '5'
    foldName    = '8tasksNoRegions1robot_rn';
    ABSfoldName = '8tasksNoRegions1robotABSTRACT_rn';
  elseif choice == '6'
    foldName    = '16tasksNoRegions1robot_rn';
    ABSfoldName = '16tasksNoRegions1robotABSTRACT_rn';
  else
    disp('You idiot! Try again!')
    a(0);
  end
  
INCREMENTAL = false;
  
elseif REGIONS_EXIST
  if     choice == '1'
%     foldName    = '4tasks4regions_rn';
%     ABSfoldName = '4tasks4regionsABSTRACT_rn';
foldName    = '4tasks2robots4regions_rn';
    ABSfoldName = '4tasks2robots4regionsABSTRACT_rn';
  elseif choice == '2'
    foldName    = '4tasks9regions_rn';
    ABSfoldName = '4tasks9regionsABSTRACT_rn';
  elseif choice == '3'
    foldName = '4tasks4regions1robot_rn';
    ABSfoldName = '4tasks4regions1robotABSTRACT_rn';
  elseif choice == '4'
    foldName = '8tasks4Regions1robot_rn';
    ABSfoldName = '8tasks4Regions1robotABSTRACT_rn' ;
  elseif choice == '5'
    foldName = '8tasks9Regions1robot_rn';
    ABSfoldName = '8tasks9Regions1robotABSTRACT_rn' ;
  elseif choice == '6'
    foldName = '6tasks9regions_rn';
    ABSfoldName = '6tasks9regionsABSTRACT_rn' ;
  elseif choice == '7'
    foldName = '6tasks9regions3robots_rn';
    ABSfoldName = '6tasks9regions3robotsABSTRACT_rn'; 
    %INCREMENTAL = true;
  elseif choice == '8'
    foldName = '10tasks9regions_rn';
    ABSfoldName = '10tasks9regionsABSTRACT_rn'; 
    %INCREMENTAL = true;
  elseif choice == '9'
    foldName = '10tasks9regionsModular_rn';
    ABSfoldName = '10tasks9regionsABSTRACT_rn'; 
    %INCREMENTAL = true;    
  elseif choice == '10'
    foldName = '10tasks9regions3robots_rn';
    ABSfoldName = '10tasks9regions3robotsABSTRACT_rn';
  elseif choice == '25'
    foldName = '6tasks6regions_rn';
    ABSfoldName = '6tasks6regionsABSTRACT_rn';
  elseif choice == '32'
    foldName = '6tasks9regions3_rn';
    ABSfoldName = '6tasks9regions3ABSTRACT_rn';
  elseif choice == '0'
    foldName = '8tasks9regions3robots_rn';
    ABSfoldName = '8tasks9regions3robotsABSTRACT_rn';
   elseif choice == '24'
    foldName = '12tasks9regions3robots_rn';
    ABSfoldName = '12tasks9regions3robotsABSTRACT_rn';
  elseif choice == '78'
    foldName = '14tasks9regions3robots_rn';
    ABSfoldName = '14tasks9regions3robotsABSTRACT_rn';
   elseif choice == '56'
    foldName = '6tasks9regions2robots_rn';
    ABSfoldName = '6tasks9regions2robotsABSTRACT_rn';
  else
    disp('You idiot! Try again!')
    a(0);
  end
  

else
  disp('INVALID OPTIONS! Try again!')
  a(0);
  
end

% time = datestr(datetime);
% if ABSTRACTED
%   fid = fopen(['../Logs/' ABSfoldName '_results_log_' time(1:11) '_' time(13:14) time(16:17) '.txt'],'w');
% else
%   fid = fopen(['../Logs/' foldName '_results_log_' time(1:11) '_' time(13:14) time(16:17) '.txt'],'w');
% end

menuFlag = false;
while ~menuFlag
  menu = input('1 for single, 2 for batch: ','s');
  if strcmp(menu,'1')
    scenNumStart = input('Input Scenario Number: ','s'); %Get Scenario num from user
    scenNumFinish = scenNumStart;
    menuFlag = true;
  elseif strcmp(menu,'2')
    scenNumStart = input('Input Scenario Start Number: ','s'); %Get Scenario num from user
    scenNumFinish = input('Input Scenario Finish Number: ','s');
    menuFlag = true;
  else 
    menuFlag = false;
  end
end

runningScenario = str2double(scenNumStart);

% if OFFLINE
%   run('just_calc_opt.m')
% 
% else
  rosshutdown; %Shutdown MATLAB ros node if it exists

  wait = input(['Please load up scenario ' num2str(runningScenario) ', then press Enter']);
  
  run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI
  run(['../FSMs/' ABSfoldName '/fsmdata.m'])       %Import FSM data from FSM GUI
  run(['../FSMs/' foldName '/fsmdataIncremental.m'])       %Import FSM data from FSM GUI
  
rosinit('localhost');
[~,num_fsms] = size(states);
%NEED TO REMOVE THIS LATER
EEC = 0;



t_total=tic;
t_pop=tic;
event_path = [];
cur_states = initial_state_incr;
state_path = cur_states;

  for i=1:numRobots                              %Setup Each Robot
    robot{i} = struct;
    %robot{i} = setupRobot(robot{i},i-1);   % i-1 because Stage starts with robot_0
    robot{i} = setupRobot(robot{i},i);
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

%global_state_path

populationsize = 2;
tic
[ABS_event_path_1,ABS_state_path,ABS_plan_cost] = GA_abstract_New_9(populationsize,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks);
t=toc;

 clear start_loc; % delete cell matrix locations from GUI
  
  % Get locations again
  for i=1:numRobots                              %Update Robot Locations
      robot{i} = updateLocations(robot{i});
      start_loc(i,1) = robot{i}.X;
      start_loc(i,2) = robot{i}.Y;
  end
  
  [plan,plan_state,best_time] = GA_incremental(robot_tasks,initial_state_incr,states_incr,events_incr,start_loc,regions,numRegions,tasks,numTasks,numRobots);
  
  

