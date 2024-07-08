%TEST GA Monolithic

clear;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


%table_minitab=csvread('Minitab_08_18_3rep.csv');

foldName = '14tasks9regions3robots_rn';
ABSfoldName='14tasks9regions3robotsABSTRACT_rn';
runningScenario=10;
  % Alter menu options to run local Dijkstra
  
  run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI
  run(['../FSMs/' ABSfoldName '/fsmdata.m'])       %Import FSM data from FSM GUI
  run(['../FSMs/' foldName '/fsmdataIncremental.m'])

[~,num_fsms] = size(states_incr);
%NEED TO REMOVE THIS LATER
EEC = 0;

%   for i=1:numRobots                              %Setup Each Robot
%     robot{i} = struct;
%     robot{i} = setupRobot(robot{i},i);   % i-1 because Stage starts with robot_0
%     %Movebase fixes
%     robot{i}.old_goal_X = 666;
%     robot{i}.old_goal_Y = 666;
%     robot_previous_location_x(i)=666;
%     robot_previous_location_y(i)=666;
%     goal_need_resend(i)=0;
%     robot_change_count(i)=0;
%     robot{i}.first_time = true; % Quarter goal flow control 
%     robot{i}.calc_region = true;
%     robot{i}.next_event = 's';
%     robot{i}.next_reg = []; %fixes: Reference to non-existent field 'next_reg'.
%     
%     goal{i} = [];                                %Initialize goal to nothing
%     robot{i}.cur_task = '';                      %Initialize cur_task to empty
%   end
  
  % Stores the robots current tasks to send to localDijkstra
  robot_tasks = num2cell(NaN(1,numRobots));
  
  % Need to send robots current location to Dijkstra
%   for kk = 1:numRobots
%       robot_tasks{kk} = robot{kk}.cur_task(4:end);
%   end
          
  
  
  step_through_final = false;
  step_through_local = false;  
  init_cost = zeros(1,numRobots);
  


  pause(.5)                                       %Wait for roscore to handshake
  disp('Setup complete!')
  
  
  cur_states = initial_state_incr;
  state_path = cur_states;
  
  max_rep_1=50000;
  %population_size_1=table_minitab(i_t,1);
  %mutation_rate_1=table_minitab(i_t,2);
  %stop_cond_1=table_minitab(i_t,3);
  
  
  
  population_size_1=55;%table_minitab(i_t,1);
  mutation_rate_1=0.4;%table_minitab(i_t,2);
  stop_cond_1=15;%table_minitab(i_t,3);
  %
  num_rep=10;
  
  ABS_event_path_1=[];
  ABS_state_path=[];
  ABS_plan_cost=[];
  t_abs=[];
  
  old_start=start_loc;
  
  clear start_loc;
  
  for i_num=1:num_rep
      
     
      
%       old_start=start_loc;
%       
%       clear start_loc;
      
      for i=1:numRobots                              %Update Robot Locations
          %robot{i} = updateLocations(robot{i});
          start_loc(i,1) = old_start{i,1};%robot{i}.X;
          start_loc(i,2) = old_start{i,2};%robot{i}.Y;
      end
      
%        cluster={{{'b01s'},{'a03s'},{'b02s'},{'a04s'}}}; %4tasks2robots4regions scenario:13,11,14,15
%       cluster={{{'a01s'},{'b03s'},{'a02s'},{'b04s'}}};%4tasks2robots4regions scenario: 12
%       cluster={{{'a03s'},{'b01s'},{'a04s'},{'b02s'}}}; %4tasks2robots6regions scenario:13
%       cluster={{{'a01s'},{'b03s'},{'a02s'},{'b04s'}}};%4tasks2robots6regions scenario: 11
%       cluster={{{'b03s'},{'a01s'},{'b04s'},{'a02s'}}}; %4tasks2robots6regions scenario: 12
%       cluster={{{'b03s'},{'a01s'},{'b04s'},{'a02s'}}}; %4tasks2robots9regions scenario: 13,11,14
%       cluster={{{'a03s'},{'b01s'},{'a04s'},{'b02s'}}};%4tasks2robots9regions scenario: 12
%       cluster={{{'b01s'},{'a03s'},{'b02s'},{'a04s'},{'b05s'},{'b06s'}}}; %6tasks2robots4regions Scenario:13
%       cluster={{{'b05s'},{'a03s'},{'b06s'},{'b01s'},{'a04s'},{'b02s'}}}; %6tasks2robots4regions scenario:12
%       cluster={{{'b05s'},{'a03s'},{'b01s'},{'a04s'},{'b06s'},{'b02s'}}};%6tasks2robots4regions scenario:14
%       cluster={{{'b05s'},{'a01s'},{'b06s'},{'a02s'},{'b03s'},{'b04s'}}};%6tasks2robots6regions scenario:13
%       cluster={{{'b05s'},{'a01s'},{'b03s'},{'a02s'},{'b06s'},{'b04s'}}};%6tasks2robots6regions scenario:11
%       cluster={{{'b01s'},{'a05s'},{'b02s'},{'a06s'},{'b03s'},{'b04s'}}};%6tasks2robots9regions scenario:13
%       cluster={{{'a03s'},{'b01s'},{'a04s'},{'b02s'},{'a05s'},{'a06s'}}}; %6tasks2robots9regions scenario:11
%       cluster={{{'a05s'},{'b01s'},{'a03s'},{'b02s'},{'a06s'},{'a04s'},{'b07s'},{'b08s'}}};%8tasks2robots4regions scenario:13
%       cluster={{{'a05s'},{'b01s'},{'a07s'},{'a06s'},{'b02s'},{'a03s'},{'a08s'},{'a04s'}}}; %8tasks2robots4regions scenario:14
%       cluster={{{'a07s'},{'b03s'},{'a05s'},{'a01s'},{'b04s'},{'a08s'},{'a06s'},{'a02s'}}};%8tasks2robots6regions scenario:13
%       cluster={{{'b05s'},{'a03s'},{'b01s'},{'a07s'},{'b06s'},{'a08s'},{'b02s'},{'a04s'}}}; %8tasks2robots9regions scenario:13
%       cluster={{{'b05s'},{'c03s'},{'a01s'},{'b06s'},{'a02s'},{'c04s'}}}; %6tasks9regions3robots scenario:21
%       cluster={{{'b05s'},{'c01s'},{'a03s'},{'b06s'},{'a04s'},{'c07s'},{'c08s'},{'c02s'}}}; %8tasks3robots9regions scenario:10
%       cluster={{{'c09s'},{'b05s'},{'a03s'},{'c01s'},{'b06s'},{'a07s'},{'c10s'},{'a04s'},{'c02s'},{'a08s'}}}; %10tasks3robots9regions scenario:10
%       cluster={{{'c05s'},{'a07s'},{'b09s'},{'c01s'},{'c11s'},{'a03s'},{'b10s'},{'c12s'},{'a08s'},{'c06s'},{'a04s'},{'c02s'}}}; %12tasks9regions3robots scenario:10
      cluster={{{'a01s'},{'b05s'},{'c11s'},{'a07s'},{'b09s'},{'a08s'},{'c12s'},{'a13s'},{'b06s'},{'a02s'},{'c03s'},{'c04s'},{'a14s'},{'b10s'}}}; %14tasks9regions3robots scenario:10
      t1=tic;
      
      [all_plan{i_num},ABS_event_path_1{i_num},ABS_state_path{i_num},ABS_plan_cost(i_num,1),num_spoint{i_num},initial_plan(i_num),num_of_changes(i_num),idx_change{i_num},trac_plan_cost{i_num},num_rep(i_num),t_dur{i_num},t_pop{i_num}] = GA_Incremental_New_30(cluster,population_size_1,max_rep_1,mutation_rate_1,stop_cond_1,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,states_incr,events_incr,initial_state_incr,initial_state,events);
      
      t_abs(i_num,1)=toc(t1);
      
      table_a(i_num,1)=population_size_1;
      table_a(i_num,2)=mutation_rate_1;
      table_a(i_num,3)=stop_cond_1;
      table_a(i_num,4)= t_abs(i_num);
      table_a(i_num,5)=ABS_plan_cost(i_num);
      table_a(i_num,6)=num_of_changes(i_num);
      table_a(i_num,7)=mean(num_spoint{i_num});
      
  end
            
            
            %i_t=i_t+1;
            
            
    %end
    
time = datestr(datetime);  

%csvwrite(['../LogsGA/' ABSfoldName 'scenario_' num2str(runningScenario) '_rep_' num2str(45) '_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '.csv'],table);
