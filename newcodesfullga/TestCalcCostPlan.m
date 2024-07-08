clear all;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


%table_minitab=csvread('Minitab_08_18_3rep.csv');

foldName = '6tasks9regions2robots_rn';
ABSfoldName='6tasks9regions2robotsABSTRACT_rn';
runningScenario=12;
  % Alter menu options to run local Dijkstra
  
  run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI
  run(['../FSMs/' ABSfoldName '/fsmdata.m'])       %Import FSM data from FSM GUI
  run(['../FSMs/' foldName '/fsmdataIncremental.m'])

[~,num_fsms] = size(states);
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

            
            
             population_size_1=50;%table_minitab(i_t,1);
             mutation_rate_1=0.4;%table_minitab(i_t,2);
             stop_cond_1=15;%table_minitab(i_t,3);
% 
 num_rep=1;
            
            ABS_event_path_1=[];
            ABS_state_path=[];
            ABS_plan_cost=[];
            t_abs=[];
   
  
                
             
                
                old_start=start_loc;
                
                clear start_loc;
                
                for i=1:numRobots                              %Update Robot Locations
                    %robot{i} = updateLocations(robot{i});
                    start_loc(i,1) = old_start{i,1};%robot{i}.X;
                    start_loc(i,2) = old_start{i,2};%robot{i}.Y;
                end
                plan1={'b01s','b09e','b01f','b02s','b08e','b02f','b03s','b07e','b03f','b04s','b12e','b04f','b05s','b13e','b05f','b06s','b14e','b15e','b06f'};
%                 plan1={'a12e','a05s','b09e','b01s','a13e','b01f','b02s','a05f','a06s','b08e','a14e','b02f','b03s','b07e','a15e','b03f','b04s','a06f','b12e','b04f'};
                %plan1={'b01s',	'b09e',	'a12e',	'a05s',	'a13e',	'b01f',	'b02s',	'a05f',	'a06s',	'b08e',	'a14e',	'b02f',	'b03s',	'b07e',	'a15e',	'b03f',	'b04s',	'a06f',	'b12e',	'b04f'};
                 %plan1={'a12e','a05s','b09e','b01s','a13e','b01f','b02s','a05f','a06s','b08e','a14e','b02f','b03s','b07e','a15e','b03f','b04s','a06f','b12e','b04f'};
                 %plan1={'a05s','b01s','a12e','b09e','a13e','b01f','b02s','b08e','a05f','a06s','b02f','b03s','b07e','a14e','b03f','b04s','b12e','a15e','b04f','a06f'};
                 %plan1={'b01s','a05s','b09e','a14e','a13e','b01f','b02s','a05f','a06s','a14e','b08e','b02f','b03s','b07e','a15e','b03f','b04s','b12e','a06f','b04f'};
                 plan2={'a05s','b01s','b09e','a14e','a13e','b01f','b02s','a05f','a06s','b08e','b02f','b03s','a14e','b07e','a15e', 'b03f','b04s','a06f','b12e','b04f'};
                 plan4={'a05s','b01s','a14e','a13e','b09e','b01f','b02s','a05f','a06s','b08e','b02f','b03s','a14e','b07e','a15e', 'b03f','b04s','a06f','b12e','b04f'};
                 plan5={'a05s','b01s','a14e','b09e','a13e','b01f','b02s','a05f','a06s','b08e','b02f','b03s','a14e','b07e','a15e', 'b03f','b04s','a06f','b12e','b04f'};
                 plan3={ 'a05s','b01s','a12e','b09e','b01f','b02s','a13e','a05f','a06s','a14e','b08e','b02f','b03s','b07e','b03f','b04s','a15e','a06f','b12e','b04f'};
                 %plan4={ 'b01s','a12e','a11e','a12e','a11e','a03s','a08e','b09e','b01f','b02s','a07e','b08e','a03f','a04s','b02f','a12e','a04f','a05s','a13e','a05f','a06s','a14e','a15e','a06f'};
                 %plan5={ 'b01s','a03s','a12e','b09e','b01f','a11e','a08e','b02s','a07e','b08e','a03f','a04s','b02f','a12e','a04f','a05s','a13e','a05f','a06s','a14e','a15e','a06f'};
                 %[plan_cost] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan);
                plan{1}={'a05s','b01s','a14e','a13e','a05f','a06s','b09e','b01f','b02s','b08e','b02f','b03s','a14e','a15e','a06f','b09e','a10e','b08e','b07e','b03f','b04s','a09e','b12e','b04f'};
                plan{2}={'a05s','b01s','a08e','b09e','b01f','a11e','b08e','a12e','a13e','a05f','a06s','b03s','a12e','b07e','b03f','b04s','a11e','b12e','a10e','b04f','a15e','b02s','a06f','b07e','b08e','b02f'};
                plan{3}={'b01s','a05s','b09e','b01f','b02s','a14e','a13e','a05f','a06s','b08e','b02f','b11e','a14e','a15e','b10e','a14e','b03s','b11e','a15e','b08e','a14e','b07e','a15e','a06f','b03f','b04s','b12e','b04f'};
                plan{4}={'b01s','a05s','b09e','b01f','b02s','a14e','a13e','a05f','a06s','b08e','b02f','b03s','a14e','a15e','a06f','b07e','b03f','b04s','b12e','b04f'};
                plan{5}={'b01s','a05s','b09e','b01f','b02s','a14e','a13e','a05f','a06s','b08e','b02f','b03s','a14e','b07e','a15e','a06f','b03f','b04s','b12e','b04f'};
                plan{6}={'a05s','b01s','b09e','b01f','b02s','a14e','a13e','a05f','a06s','a14e','b08e','b02f','b03s','b07e','a15e','a06f','b03f','b04s','b12e','b04f'};
                plan{7}={'a05s','b01s','b09e','b01f','b02s','a14e','a13e','a05f','a06s','a14e','b08e','b02f','b03s','b07e','a15e','b03f','a06f','b04s','b12e','b04f'};
                plan{8}={'a05s','b01s','b09e','b01f','b02s','a14e','a13e','a05f','a06s','a14e','b08e','b02f','b03s','a15e','b07e','b03f','b04s','a06f','b12e','b04f'};
                plan{9}={'a05s','b01s','b09e','b01f','b02s','a14e','a13e','a05f','a06s','a14e','b08e','b02f','b03s','b07e','a15e','b03f','b04s','a06f','b12e','b04f'};
                
                
%                 for i=1:length(plan)
%                     
%                     [plan_cost(i),cost_trans{i},cost_extra{i}] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan{i});
%                     
%                 end
                [plan_cost1,cost_trans1,cost_extra_1] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan1);
%                 [plan_cost2,cost_trans2,cost_extra_2] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan5);
                %[plan_cost3,cost_trans3,cost_extra3] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan3);
                %[plan_cost4] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan4);
                %[plan_cost5] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan5);