                          clear all;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


%table_minitab=csvread('Minitab_08_18_3rep.csv');

foldName = '6tasks9regions3robots_rn';
ABSfoldName='6tasks9regions3robotsABSTRACT_rn';
runningScenario=21;
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

  %% Setup

%   try                                            %Test to see if Stage is Running
%     robot{1} = updateLocations(robot{1});
%   catch ME
%     disp('Is Stage running?')
%     rethrow(ME)
%   end

 %pop_size=[4;8;16;32;48;64];
 %mut_rate=[0.1;0.2;0.4;0.6];
 %stop_cond=[5;10;15;20;25;30];
i_t=1;

% i_pop=4;
% i_rate=1;
% i_stop=1;


  %for i_t=1:length(table_minitab)
     %i_t=1;

            cur_states = initial_state_incr;
            state_path = cur_states;
            
            max_rep_1=50000;
            %population_size_1=table_minitab(i_t,1);
            %mutation_rate_1=table_minitab(i_t,2);
            %stop_cond_1=table_minitab(i_t,3);

            
            
             population_size_1=25;%table_minitab(i_t,1);
             mutation_rate_1=0.4;%table_minitab(i_t,2);
             stop_cond_1=15;%table_minitab(i_t,3);
% 
 num_rep=1;
            
            ABS_event_path_1=[];
            ABS_state_path=[];
            ABS_plan_cost=[];
            t_abs=[];
   
            for i_num=1:num_rep
                
                i_num   
                
                old_start=start_loc;
                
                clear start_loc;
                
                for i=1:numRobots                              %Update Robot Locations
                    %robot{i} = updateLocations(robot{i});
                    start_loc(i,1) = old_start{i,1};%robot{i}.X;
                    start_loc(i,2) = old_start{i,2};%robot{i}.Y;
                end
                
                t1=tic;
                [all_plan{i_num},ABS_event_path_1{i_num},ABS_state_path{i_num},ABS_plan_cost(i_num),num_spoint{i_num},initial_plan(i_num),num_of_changes(i_num),idx_change{i_num},trac_plan_cost{i_num},num_rep(i_num),t_dur{i_num},t_pop{i_num}] = GA_Incremental_New_30(population_size_1,max_rep_1,mutation_rate_1,stop_cond_1,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,states_incr,events_incr,initial_state_incr,initial_state,events);
                t_abs(i_num)=toc(t1);
                
            table_a(i_num,1)=population_size_1;
            table_a(i_num,2)=mutation_rate_1;
            table_a(i_num,3)=stop_cond_1;
            table_a(i_num,4)= t_abs(i_num);
            table_a(i_num,5)=ABS_plan_cost(i_num);
            table_a(i_num,6)=num_of_changes(i_num);
            table_a(i_num,7)=mean(num_spoint{i_num});
                
            end
            
            table(i_t,1)=population_size_1;
            table(i_t,2)=mutation_rate_1;
            table(i_t,3)=stop_cond_1;
            table(i_t,4)= mean(t_abs);
            table(i_t,5)=mean(ABS_plan_cost);
            
            %i_t=i_t+1;
            
            
    %end
    
time = datestr(datetime);  

%csvwrite(['../LogsGA/' ABSfoldName 'scenario_' num2str(runningScenario) '_rep_' num2str(45) '_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '.csv'],table);
