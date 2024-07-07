clear;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


%table_minitab=csvread('Minitab_08_18_3rep.csv');
foldName = '4tasks2robots4regions_rn';
ABSfoldName='4tasks2robots4regionsABSTRACT_rn';
runningScenario=13;
% 
% foldName = '8tasks9regions3robots_rn';
% ABSfoldName='8tasks9regions3robotsABSTRACT_rn';
% runningScenario=222;
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
          
  event_list = createEventFsmList(events_incr,num_fsms);
  
  step_through_final = false;
  step_through_local = false;  
  init_cost = zeros(1,numRobots);
  abstracted = false;
    start_events_only = false;


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
   
  
                %plan1={'b05s','a03s','b13e','a11e','b05f','b01s','a12e','b16e','a03f','a07s','b01f','b06s','a17e','a07f','a08s','b15e','a12e','b06f','b02s','b14e','a11e','a10e','a08f','a04s','a11e','a04f','b09e','b02f'};
                %plan1={'b05s','a03s','b13e','a11e','a12e','b05f','b01s','a03f','a07s','b16e','b01f','b06s','a17e','a07f','a04s','a12e','b15e','b06f','b02s','a11e','b14e','a04f','a08s','a10e','b09e','b02f','a08f'};
%                  plan1={'b05s','a03s','b13e','a11e','a12e','b05f','b01s','a03f','a07s','b16e','a17e','b01f','b06s','a07f','a08s','a12e','b15e','a13e','a10e','b06f','b02s','b14e','a08f','a04s','a11e','b09e','b02f','a04f'};
                 %plan1={'b05s','a03s','b13e','a11e','a12e','b05f','b01s','a03f','a07s','b16e','a17e','b01f','b06s','a07f','a08s','a12e','b15e','b06f','b02s','b14e','a13e','b09e','a10e','a08f','a04s','b02f','a11e','a04f'};
                   %plan1={'b05s','a03s','b13e','a11e','a12e','b05f','a03f','b01s','a07s','b16e','a17e','b01f','b06s','a07f','a08s','a12e','b15e','b06f','a13e','b02s','a10e','b14e','a08f','a04s','a11e','b09e','b02f','a04f'};	
%plan1={'b01s','a07s','a07f','b13e','a03s','b01f','b05s','a11e','b05f','b06s','a03f','a04s','a12e','a04f','a08s','b10e','b09e','a13e','b06f','b02s','b02f','a14e','a08f'};

%plan1={'a03s','b01s','a09e','b05e','a03f','a04s','a06e','b01f','b02s','a07e','a04f','b06e','a08e','a09e','b07e','a06e','b08e','b02f'}; %4tasks2robots6regions DijkstraIncremental
% plan1={'b03s','a01s','b05e','a09e','b03f','b04s','b06e','a12e','a13e','b07e','a01f','a02s','b04f','a12e','a09e','a02f'}; %4tasks2robots9regions DijkstraIncremental
%plan1={'b05s','a01s','b05f','b06s','a09e','a10e','b07e','b08e','a01f','a02s','a11e','b09e','a08e','b06f','b03s','b03f','b04s','a07e','b10e','b11e','a02f','b04f'}; %6tasks2robots6regions DijkstraIncremental
%plan1={'b01s','a05s','a11e','b13e','b01f','b02s','b12e','a14e','b11e','a15e','a05f','a06s','b02f','b03s','b08e','b09e','a14e','b03f','b04s','b08e','b11e','a13e','b04f','a06f'}; %6tasks2robots9regions DijkstraIncremental
%plan1={'a07s','b03s','b13e','a07f','a05s','b12e','a13e','a05f','a01s','b11e','b03f','b04s','a01f','a08s','b12e','a14e','a08f','a06s','a09e','a06f','a02s','b04f','a02f'};%8tasks2robots6regions DijkstraIncremental
%plan1={'b05s','a03s','b13e','a11e','b05f','b01s','a12e','b16e','a03f','a07s','b01f','b06s','a17e','a07f','a08s','b15e','a12e','b06f','b02s','b14e','a11e','a10e','a08f','a04s','a11e','a04f','b09e','b02f'}; %8tasks2robots9regions DijkstraIncremental
%plan1={'b01s','a03s','b08e','b01f','b02s','b07e','a08e','a03f','a04s','b06e','a05e','a04f','b02f'}; %4tasks2robots4regions DijkstraIncremental
%plan1={'b01s','a03s','b10e','b01f','b02s','a08e','b09e','a03f','a04s','b02f','b05s','b05f','b06s','a07e','a04f','b10e','b06f'}; %6tasks2robots4regions DijkstraIncremental
% plan1={'a05s','b01s','a05f','a03s','b10e','b01f','b02s','b11e','a10e','b12e','a03f','a06s','a06f','a04s','b02f','b07s','a11e','b07f','b08s','a04f','a10e','b11e','b08f'}; %8tasks2robots4regions Dijkstra Incremental

%plan1={'a07s','b03s','b13e','a07f','a05s','b12e','a13e','b11e','b03f','a05f','a01s','b04s','a01f','a08s','a14e','b12e','b04f','a08f','a06s','a09e','a06f','a02s','a02f'}; %8tasks2robots6regions GA Horizon
%plan1={'b05s','a03s','b13e','a11e','a12e','b05f','b01s','a03f','a07s','b16e','a17e','b01f','b06s','a07f','a08s','a12e','b15e','b06f','b02s','b14e','a13e','b09e','a10e','a08f','a04s','b02f','a11e','a04f'}; %8tasks2robots9regions GA Horizon
%plan1={'b01s','a03s','b08e','b01f','b02s','b07e','b06e','a08e','a03f','a04s','b02f','a05e','a04f'}; %4tasks2robots4regions GA Horizon
%plan1={'b01s','a03s','b10e','b01f','b02s','b09e','a08e','a03f','a04s','b02f','b05s','b05f','b06s','b10e','a07e','a04f','b06f'}; %6tasks2robots4regions GA Horizon
% plan1={'a05s','b01s','a05f','a03s','b10e','b01f','b02s','b11e','b12e','a10e','a03f','a06s','b02f','a06f','a04s','b07s','b07f','b08s','a11e','a04f','a10e','b11e','b08f'};% 8tasks2robots4regions GA Horizon
%plan1={'b05s','a03s','b13e','a11e','a12e','b05f','b01s','a03f','a07s','b16e','a17e','b01f','b06s','a07f','a08s','a12e','b15e','b06f','b02s','b14e','a13e','b09e','a10e','a08f','a04s','b02f','a11e','a04f'}; %8tasks2robots9regions GA Horizon
%plan1={'a03s','b01s','b05e','a09e','a03f','a04s','b01f','b02s','b06e','a08e','a07e','a04f','b09e','b08e','b02f'}; %4tasks2robots6regions GA Horizon

% plan1={'a05s','b01s','b10e','a05f','a03s','b01f','b02s','b11e','a10e','b12e','a03f','a06s','a06f','a04s','b02f','b07s','b07f','b08s','a11e','a04f','a10e','b11e','b08f'}; %8tasks2robots4regions GA Mono

% plan1={'a05s','a05f','a07s','a12e','b10e','b01s','b01f','b03s','a07f','a06s','b03f','b04s','a09e','b11e','a10e','b04f','b02s','a06f','a08s','b12e','a11e','b02f','a08f'}; %8tasks2robots4regions Dijkstra Mono
%plan1={'b03s','a01s','b09e','a05e','b03f','a01f','b04s','a02s','a06e','b08e','a09e','b07e','a08e','b04f','a02f'};%4tasks2robots6regions GA Mono
% plan1={'b05s','a01s','b05f','b06s','a09e','a10e','b07e','b08e','a01f','a02s','a11e','b09e','a08e','b06f','b03s','b03f','b04s','a07e','b10e','b11e','a02f','b04f'};%6tasks2robots6regions Dijkstra Incremental
%plan1={'a03s','b10e','b01s','a08e','b01f','b02s','b09e','a03f','a04s','b02f','b05s','b05f','b06s','a07e','a04f','b10e','b06f'}; %6tasks2robots4regions Dijkstra Mono
% plan1={'b01s','a03s','b10e','b01f','b02s','a08e','b09e','b02f','a03f','b05s','b05f','b06s','a04s','b10e','a07e','a04f','b06f'}; %6tasks2robots4regions GA Mono
%plan1={'b01s','a03s','b10e','b01f','b02s','b09e','a08e','a03f','a04s','b02f','b05s','b05f','b06s','b10e','a07e','a04f','b06f'}; %6tasks2robots4regions GA Horizon

% plan1= {'b05s','a03s','b05f','b01s','a09e','b11e','a03f','a04s','b10e','b01f','b06s','a08e','b09e','b06f','b02s','a11e','b08e','b07e','a04f','b02f'}; %6taks2robots6regions GA Mono
%  plan1={'b05s','a01s','b05f','b06s','b07e','a09e','b08e','a10e','a01f','a02s','a11e','b09e','b06f','b03s','b03f','b04s','a12e','b08e','b11e','a07e','a02f','b04f'}; %6stasks2robots6regions GA Horizon
% 
% plan1={'b05s','a01s','b05f','b06s','b11e','a09e','b08e','a10e','b09e','a01f','a02s','b06f','b03s','a11e','b03f','b04s','a08e','b10e','b11e','a07e','a02f','b04f'};

%plan1={'b05s','a01s','b05f','b06s','a09e','b07e','b08e','a10e','a01f','a02s','a11e','b09e','a08e','b06f','b03s','b03f','b04s','a07e','b08e','a02f','b11e','b04f'};

% plan1={'b01s','a05s','a09e','a10e','b13e','b01f','b02s','b14e','a15e','b11e','a05f','a06s','a14e','b02f','b03s','b10e','b09e','a13e','a06f','b03f','b04s','b10e','b11e','b04f'}; %6tasks2robots9regions GA Horizon

%plan1={'b01s','a07s','a07f','b13e','a03s','b01f','b05s','a11e','b05f','b06s','a03f','a04s','a12e','a04f','a08s','b10e','b09e','a13e','b06f','b02s','b02f','a14e','a08f'}; %8tasks2robots6regions GA Mono
%plan1={'b05s','c03s','a01s','b05f','b06s','b12e','c14e','c03f','c04s','a10e','c13e','b17e','a01f','a07s','a07f','a08s','b16e','c12e','c11e','a13e','b15e','a12e','b06f','c04f','a08f','a02s','a17e','a02f'}; %8tasks9regions3robots Scenario:12 GA Horizon

% plan1={'b05s','c03s','a01s','b05f','b06s','c14e','a10e','b12e','c03f','c04s','a01f','a07s','a07f','a08s','c15e','c16e','a11e','b13e','a12e','c17e','b16e','a08f','a02s','b13e','c16e','b14e','c13e','c10e','b15e','a17e','c11e','c04f','b06f','a02f'}; %8tasks9regions3robots Scenario:12 Dijkstra Incremental
% 
% plan1={'b05s','c03s','a01s','b05f','b06s','c12e','a08e','b10e','a01f','a02s','c03f','c04s','a11e','b09e','b08e','b07e','a14e','c11e','b12e','c08e','a15e','a02f','b13e','c09e','c04f','b06f'}; %6tasks9regions3robots scenario:21 Dijkstra Incremental
% 
% plan1={'b05s','c01s','a03s','a14e','b05f','b06s','c10e','b12e','a03f','a04s','c01f','c07s','a13e','c07f','c08s','a14e','a09e','c13e','b11e','c12e','b10e','b13e','a10e','c08f','c02s','c17e','b14e','a11e','b15e','c02f','a04f','b06f'}; %8tasks9regions3robots scenario:10 Dijkstra Incremental
% 
% plan1={'c09s','b05s','a03s','c09f','c01s','b05f','b06s','a16e','b14e','b15e','c12e','a03f','a07s','c01f','c10s','c13e','c14e','a11e','a12e','c19e','c18e','a07f','a04s','a13e','c10f','c02s','a04f','a08s','a14e','c19e','c02f','a08f','b18e','b17e','b06f'}; %10tasks9regions3robots scenario:10 Dijkstra Incremental
% 
% plan1={'c05s','a07s','b09s','b16e','c05f','c01s','c01f','c11s','a07f','a03s', 'c18e','a14e','b21e','b09f','b10s','c11f','c12s','a03f','a08s','b20e','c17e','a15e','c12f','c06s','a08f','a04s','c16e','a14e','a17e','b19e','c06f','c02s','c21e','b10f','c02f','a20e','a04f'}; %12tasks9regions3robots scenario:10 Dijkstra Incremental
% 
% plan1={'a01s','b05s','c11s','a16e','c20e','a01f','a07s','b05f','b09s','a07f','a08s','a19e','a18e','c15e','c16e','c19e','b16e','c11f','c12s','a08f','a13s','c20e','a23e','b15e','b09f','b06s','a13f','a02s','c12f','c03s','b16e','b19e','c03f','c04s','a02f', 'a14s','a18e','c15e','c16e','b22e','a19e','b21e','b06f','b10s','b22e','b10f','c17e','c04f','a16e','b19e','a15e','a14f'}; %14tasks9regions3robots scenario:10 Dijkstra Incremental

%plan1={'b05s','c03s','a01s','b05f','b06s','c12e','b10e','a08e','c03f','a01f','a02s','c04s','c07e','a09e','b15e','a10e','c08e','b14e','a15e','c09e','b13e','a02f','b06f','c04f'}; %6atsks9regions3robots scenario:21 GA Horizon

%plan1={'b05s','c01s','a03s','a14e','b05f','b06s','b12e','a03f','a04s','c10e','a09e','c01f','c07s','b13e','c07f','c08s','c11e','a10e','c12e','b16e','c08f','c02s','b15e','a11e','c17e','b06f','a04f','c02f'}; %8tasks9regions3robots scenario:10 GA Horizon

%plan1={'c09s','b05s','a03s','c09f','c01s','b05f','b06s','a16e','b14e','c12e','a03f','a07s','b15e','c01f','c10s','c13e','c14e','b18e','a11e','c19e','b17e','c18e','a12e','b06f','a07f','a04s','a13e','c10f','c02s','c19e','a04f','a08s','a14e','c02f','a08f'}; %10tasks9regions3robots scenario:10 GA Horizon

%plan1={'a01s','b05s','c11s','a16e','c20e','a01f','a07s','c19e','a07f','b05f','b09s','a08s','c11f','c12s','c22e','a19e','b16e','c21e','c20e','a18e','c12f','a08f','a13s','b15e','a23e','b09f','b06s','a13f','a02s','c03s','c03f','c04s','c19e','a02f','a14s','a22e','c16e','b20e','a19e','b21e','c17e','a16e','a15e','c04f','b06f','b10s','a14f','b22e','b10f'}; % 14tasks9regions3robots scenario: 10 GA Horizon

%plan1={'c05s','a07s','b09s','b16e','a07f','c05f','c01s','c01f','c11s','a03s','c18e','a14e','b21e','b09f','b10s','b20e','a03f','c11f','c12s','a08s','c17e','a15e','b19e','b10f','c12f','c06s','a08f','a04s','c16e','a14e','a17e','c06f','c02s','c21e','a20e','a04f','c02f'};%12tasks9regions3robots scenario:10 GA Horizon

%plan1={'c09s','b05s','a03s','c09f','c01s','c12e','b05f','b06s','b14e','a16e','b15e','c01f','a03f','a07s','c10s','a11e','b18e','c15e','b17e','c18e','a12e','b06f','a07f','a04s','a13e','c10f','c02s','c19e','a04f','a08s','a14e','c02f','a08f'};

% plan1={'a01s','b05s','c11s','c20e','a16e','b05f','a01f','a07s','b09s','a07f','a08s','c19e','a15e','a20e','c11f','c12s','a15e','a16e','c20e','a19e','b16e','c12f','b15e','a18e','b09f','a08f','a13s','b06s','a23e','c19e','b20e','a13f','a02s','c03s','b21e','a02f','b06f','c20e','c03f','c04s','a14s','b10s','a18e','a19e','b22e','c15e','c16e','a20e','b10f','c17e','a15e','c04f','a14f'}; % 14tasks9regions3robots scenario: 12 GA Horizon

% plan1={'a11s','c03s','b07s','a18e','a11f','a12s','a17e','c14e','a12f','c03f','c01s','a09s','a20e','c13e','b14e','c01f','c04s','c18e','a21e','b17e','b07f','b05s','c19e','a09f','a10s','b14e','a16e','a17e','c20e','c04f','b13e','b05f','b06s','c02s','b14e','a18e','a19e','b15e','b16e','c21e','a10f','b06f','b08s','b15e','c02f','b08f'};%12tasks9regions3robots scenario:12 GA Horizon Pop:20

% plan1={'a11s','c03s','b07s','a18e','c14e','a11f','a12s','a17e','c03f','c01s','c13e','a12f','a09s','b16e','a18e','b17e','a19e','a20e','c01f','c04s','c18e','b07f','b05s','b14e','b13e','a17e','a16e','a21e','c19e','c20e','a09f','a10s','b05f','b06s','b14e','c04f','c02s','a16e','a17e','c21e','a20e','b15e','b16e','b06f','b08s','b17e','b14e','b15e','c02f','a19e','b08f','a10f'}; %12tasks9regions3robots scenario:12 Dijkstra Incrmental

% plan1={'a11s','c03s','b07s','a18e','a11f','a12s','c14e','c03f','c01s','c13e','a17e','c01f','a12f','a09s','c04s','c18e','a20e','b14e','a21e','a09f','b17e','c19e','b07f','b05s','a10s','a16e','c20e','b18e','a17e','b13e','c04f','b05f','b06s','c02s','c21e','b14e','a18e','c02f','a19e','b15e','a10f','b16e','b06f','b08s','b15e','b08f'};%12tasks9regions3robots scenario:12 GA Horizon Pop:25

% plan1={'c05s','b03s','a09s','c05f','c07s','b14e','a20e','a21e','c18e','b03f','b01s','c17e','a09f','a10s','b13e','a20e','c07f','c06s','b01f','b04s','b14e','c16e','b17e','a19e','c06f','c08s','a10f','a11s','a18e','b20e','b04f','b02s','a11f','a12s','a17e','a12f','b21e','c15e','c08f','b02f'}; %12tasks9regions3robots scenario:14 Dijkstra Incremental

% plan1={'c05s','b03s','a09s','c05f','c07s','b14e','a16e','c18e','c17e','a21e','b03f','b01s','b13e','a09f','a10s','a20e','c07f','c06s','c16e','a19e','b01f','b04s','b18e','a10f','c06f','c08s','a11s','c15e','b17e','c08f','b20e','a18e','b04f','b02s','b21e','a11f','a12s','a17e','b02f','a12f'}; %12tasks9regions3robots scenario:14 GA Horizon Pop:20

% plan1={'c05s','b03s','a09s','c05f','c07s','a16e','b14e','c18e','c17e','a21e','a09f','b03f','b01s','a10s','a20e','c07f','c06s','b13e','c16e','a19e','b01f','b04s','b18e','c06f','c08s','b17e','a10f','a11s','a18e','b20e','c15e','b04f','b02s','c08f','a11f','a12s','a17e','b21e','b02f','a12f'};%12tasks9regions3robots scenario:14 GA Horizon Pop:40

%plan1={'c01s','a03s','b05s','c12e','a16e','b05f','c01f','c09s','c11e','a03f','a07s','b06s','c09f','c10s','b14e','c12e','a11e','b19e','c13e','a12e','c14e','b18e','a07f','a08s','a13e','c19e','b17e','b06f','c18e','a14e','c10f','a08f','a04s','c02s','a13e','c19e','a04f','c02f'}; %10tasks9regions3robots scenario:11 GA Horizon Pop:20

% plan1={'c01s','a03s','b05s','c12e','a16e','c01f','c09s','a03f','a07s','b05f','b06s','c11e','a15e','c09f','c10s','b14e','a12e','b15e','c16e','a07f','a08s','a13e','b12e','b11e','a12e','c17e','a15e','b16e','c18e','a14e','a08f','a04s','c10f','c02s','a13e','c19e','c02f','b17e','a04f','b06f'}; %10tasks9regions3robots scenario:11 Dijkstra Incremental


%plan1={'b05s','a03s','b05f','a12e','a03f','b01s','b08e','b01f','b06s','b09e','b10e','b15e','b14e','b13e','b06f','b02s','a04s','a11e','a12e','b14e','b15e','b02f','a13e','c12e','c11e','b14e','c08e','c09e','b11e','b08e','c10e','b07e','c09e','b12e','c10e','c11e','a14e','a15e','a10e','a09e','a04f'};

% plan1={'c01s','a03s','b05s','c12e','a16e','b05f','c01f','c09s','c11e','a03f','a07s','b06s','b14e','c09f','c10s','a15e','a12e','b15e','a07f','a08s','b16e','b17e','c16e','a15e','b06f','a14e','c15e','a08f','a04s','a13e','c18e','c10f','c02s','c19e','a04f','c02f'};
% plan1={'b09e','b12e','b01s','b13e','b01f','b02s','b08e','b09e','b02f','a03s','b10e','a05e','a03f','a04s','a06e','b05e','a09e','a08e','b10e','b09e','a07e','a04f'};
% plan1={'b11e','b14e','b05s','b15e','b05f','b01s','b10e','b11e','b14e','a11e','a03s','a10e','a09e','b11e','a03f','a04s','a10e','b12e','b13e','a11e','a04f','a12e','b01f','b06s','b06f','b02s','b14e','b11e','b02f'};

% plan1={'a01s','a08e','b06e','b03s','a01f','a02s','b05e','a07e','b08e','a06e','b03f','b04s','b05e','a02f','b04f'}; % 4tasks2robots4regions scenario:12 Dijkstra Incremental

% plan1={'a01s','b03s','a08e','a01f','a02s','a05e','b08e','a06e','b03f','b04s','a02f','b05e','b04f'}; % 4tasks2robots4regions scenario:12 GA Hierar

% plan1={'a01s','b03s','a08e','a01f','a02s','a05e','a06e','b08e','b03f','b04s','b05e','a02f','b04f'}; % 4tasks2robots4regions scenario:12 GA Horizon

% plan1={'a03s','a08e','a03f','a01s','a01f','a04s','a05e','a04f','a02s','a06e','a02f'}; % 4tasks2robots4regions scenario:13 Greedy

% plan1={'b01s','b08e','a06e','a07e','b01f','b03s','b03f','b02s','b05e','b06e','b02f','b04s','b05e','b04f'}; % 4tasks2robots4regions scenario:11 Greedy

% plan1={'b01s','a03s','b08e','b01f','b02s','b07e','a08e','b06e','a03f','a04s','b02f','a05e','a04f'}; % 4tasks2robots4regions scenario:11 GA Horizon

% plan1={'b08e','b01s','b01f','b02s','b07e','b06e','b02f','a03s','a08e','a03f','a04s','a05e','a04f'};% 4tasks2robots4regions scensrio:12 Greedy

% plan1={'b01s','a03s','b08e','b01f','b02s','b07e','b06e','a08e','a03f','a04s','b02f','a05e','a04f'}; % 4tasks2robots4regions scenario:14 GA Horizon

% plan1={'a03s','a08e','a03f','a01s','a01f','a02s','a05e','a06e','a02f','a04s','a05e','a04f'};% 4tasks2robots4regions scenario:14 Greedy

% plan1={'a08e','a03s','a03f','a01s','b06e','a01f','a02s','a07e','b05e','b08e','a06e','a05e','b07e','a06e','a02f','a04s','a05e','a04f'}; % 4tasks2robots4regions Scenario:15 Greedy

% plan1={'b01s','a03s','b08e','b01f','b02s','b07e','b06e','a08e','a03f','a04s','b02f','a05e','a04f'}; % 4tasks2robots4regions scenario:15 GA Horizon

% plan1={'a05e','a01s','a01f','a02s','a06e','a09e','a08e','a02f','a03s','a07e','b05e','a06e','a09e','a03f','a04s','b10e','a06e','a07e','a04f'}; % 4tasks2robots6regions scenario:13 Greedy
% plan1={'a01s','b03s','a05e','a01f','a02s','a06e','b09e','b03f','b04s','b08e','a09e','b07e','a08e','b04f','a02f'};% 4tasks2robots6regions scenario:11 GA Horizon
% plan1={'a01s','a05e','a01f','a03s','a06e','a09e','a03f','a02s','a08e','a02f','a04s','a07e','a04f'}; %4tasks2robots6regions scenario:11 Greedy
% plan1={'b03s','a01s','b09e','b03f','b04s','b08e','a05e','b07e','a01f','a02s','a06e','a09e','a08e','b04f','a02f'}; %4tasks2robots6regions scenario:12 GA Horizon
% plan1={'a09e','a03s','a03f','a01s','a06e','a05e','a01f','a02s','a06e','a09e','a08e','a02f','a04s','a09e','a06e','a07e','a04f'};%4tasks2robots6regions scenario:12 Greedy 
% plan1={'b09e','b12e','b01s','b13e','b01f','b02s','b08e','b09e','b02f','a03s','b10e','a05e','a03f','a04s','a06e','b05e','a09e','a08e','b10e','b09e','a07e','a04f'}; % 4tasks2robots9regions scenario:13 Greedy
% plan1={'b03s','a01s','a07e','a08e','b05e','b03f','b04s','b06e','a13e','a01f','a02s','a12e','a09e','b07e','b04f','a02f'};% 4tasks2robots9regions scenario:11 GA Horizon

% plan1={'b05e','b03s','b03f','b04s','b10e','a05e','b09e','b06e','b07e','a10e','a09e','a12e','a01s','a13e','a08e','b04f','a13e','a01f','a02s','a12e','a09e','a02f'};% 4tasks2robots9regions scenario:11 Greedy
% plan1={'a03s','b01s','b11e','b12e','a05e','a03f','a04s','a06e','b13e','a07e','b01f','b02s','a04f','b12e','b09e','b02f'};% 4tasks2robots9regions scenario:12 GA Horizon

% plan1={'b05e','b03s','b03f','b04s','b10e','a05e','b09e','b06e','b07e','a06e','b08e','a05e','a10e','b09e','b06e','b07e','a09e','a12e','a13e','a01s','a01f','a02s','a12e','a09e','a02f','b04f'}; % 4tasks2robots9regions scenario:12 Greedy

% plan1={'b03s','a01s','b05e','a09e','a12e','b03f','b04s','a13e','b06e','b07e','a01f','a02s','b04f','a12e','a09e','a02f'}; %4tasks2robots9regions scenario:14 GA Horizon

%plan1={'b09e','b12e','b13e','b01s','b01f','b02s','b08e','b09e','b02f','a03s','a07e','b06e','a08e','b07e','a09e','a06e','a05e','a03f','a04s','a10e','a09e','a06e','b08e','a07e','a04f'};%4tasks2robots9regions scenario:14 Greedy

% plan1={'b01s','a03s','b10e','b01f','b02s','b09e','a08e','a03f','a04s','b02f','b05s','b05f','b06s','a07e','b10e','a04f','b06f'}; %6tasks2robots4regions scenario:13 GA Horizon

% plan1={'a08e','b10e','a09e','b01s','b01f','b02s','b07e','a10e','b08e','b09e','b02f','b05s','b05f','b03s','b08e','b03f','b04s','b07e','a09e','a08e','b04f','b06s','b10e','b06f'};%6tasks2robots4regions scenario:13 Greedy

% plan1={'b05s','a03s','b05f','b06s','a08e','b10e','a03f','b06f','b01s','a04s','b01f','b02s','a07e','b09e','a04f','b02f'}; %6tasks2robots4regions scenario:12 GA Horizon

% plan1={'b08e','b03s','b03f','a01s','b09e','a10e','a01f','a02s','a07e','a08e','b05s','b05f','b06s','b10e','b06f','b04s','a09e','b07e','b04f','a02f'}; %6tasks2robots4regions scenario:12 Greedy

% plan1={'b05s','a03s','b05f','b01s','b10e','a08e','a03f','a04s','b01f','b06s','b06f','b02s','a07e','b09e','a04f','b02f'};%6tasks2robots4regions scenario:14 GA Horizon

% plan1={'a03s','a08e','a03f','a01s','a07e','b08e','a10e','b07e','a01f','a02s','a09e','a02f','a05s','a05f','a04s','a08e','b10e','a07e','a04f','a06s','b09e','b08e','a10e','a06f'}; %6tasks2robots4regions scenario:14 Greedy

% plan1={'b05s','b05f','b06s','b11e','a09e','a10e','a03s','b08e','a09e','a03f','a01s','a10e','a01f','a04s','a11e','a04f','a02s','a12e','a07e','b11e','a02f','b08e','b09e','b06f'}; %6tasks2robots6regions scenario:13 Greedy
% plan1={'b05s','a01s','b05f','b03s','b07e','a11e','b08e','a10e','b09e','a01f','a02s','a11e','b03f','b06s','b06f','b04s','a12e','b08e','b11e','a07e','a02f','b04f'}; %6tasks2robots6regions scenario:11 GA Horizon
% plan1={'b05s','b05f','b03s','b11e','a07e','b08e','b09e','b03f','b06s','b06f','b01s','b10e','b01f','b04s','b11e','b04f','b02s','b12e','a08e','b07e','b02f'};%6tasks2robots6regions scenario:11 Greedy
% plan1={'b05s','a01s','b05f','b03s','b07e','a09e','b08e','a10e','b09e','a01f','a02s','b03f','b06s','b06f','b04s','a11e','a08e','b10e','b11e','a07e','a02f','b04f'};%6tasks2robots6regions scenario:12 GA Horizon
% plan1={'a11e','a10e','a01s','a01f','a02s','a11e','a08e','b05s','b05f','b06s','a07e','b11e','b08e','b09e','b06f','b03s','a02f','b03f','b04s','b10e','b11e','b04f'};%6tasks2robots6regions scenario:12 Greedy
% plan1={'b05s','a01s','b05f','b06s','b11e','a09e','b08e','a10e','b09e','a01f','a02s','b06f','b03s','b03f','b04s','a11e','b08e','a12e','b11e','a07e','a02f','b04f'}; %6tasks2robots6regions scenario:15 GA Horizon 
% plan1={'b11e','a07e','a05s','a12e','a05f','a01s','a07e','a08e','b12e','a11e','a10e','a01f','a03s','a09e','a03f','a06s','a06f','a04s','a08e','a11e','a04f','a02s','b07e','a12e','b08e','a07e','a02f'}; %6tasks2robots6regions scenario:15 Greedy
% plan1={'b01s','a05s','a09e','b13e','a10e','b01f','b02s','a15e','b12e','b11e','a05f','a06s','a14e','b02f','b03s','b08e','b09e','a13e','a06f','b03f','b04s','b10e','b11e','b04f'}; %6tasks2robots9regions scenario:13 GA Horizon
% plan1={'b11e','b14e','b05s','b15e','b05f','b01s','b10e','b11e','b14e','a11e','a03s','a10e','a09e','b11e','a03f','a04s','a10e','b12e','b13e','a11e','a04f','a12e','b01f','b06s','b06f','b02s','b14e','b11e','b02f'};%6tasks2robots9regions scenario:13 Greedy
% plan1={'a03s','b01s','b13e','a09e','a03f','a04s','b01f','b02s','b14e','a08e','b11e','b02f','b14e','a11e','a04f','a05s','a10e','a15e','a05f','a06s','b11e','a14e','a13e','b10e','a06f'};%6tasks2robots9regions scenario:11 GA Horizon
% plan1={'a09e','a03s','a03f','a05s','a08e','a11e','a10e','b13e','a11e','a14e','b12e','a15e','b13e','b14e','a10e','b11e','a15e','a05f','a04s','a10e','b14e','a11e','a04f','a01s','a12e','b11e','a13e','b14e','b15e','a01f','a06s','a06f','a02s','a14e','a11e','a02f'};%6tasks2robots9regions scenario:11 Greedy
% plan1={'a05s','b01s','a05f','a03s','b10e','b01f','b02s','b11e','a10e','b12e','a03f','a06s','b02f','a06f','a04s','b07s','b07f','b08s','a11e','a04f','a10e','b11e','b08f'}; %8tasks2robots4regions scenario:13 GA Horizon
% plan1={'a03s','a10e','a03f','a01s','a01f','b07s','b12e','a04s','a11e','a04f','a05s','a10e','b07f','b08s','b11e','a09e','a05f','a02s','a12e','a02f','a06s','a09e','b08f','a10e','a06f'}; %8tasks2robots4regions scenario:13 Greedy
% plan1={'a05s','b01s','a05f','a07s','b10e','a12e','b01f','a07f','a06s','b02s','a11e','b09e','a10e','b12e','a06f','a03s','b02f','a03f','a08s','a11e','a08f','a04s','a04f'};%8tasks2robots4regions scenario:14 GA Horizon
% plan1={'a05s','a05f','a07s','a12e','a07f','a06s','a09e','a10e','b12e','a06f','a01s','a01f','a03s','a03f','a08s','a11e','b09e','a08f','a04s','a04f','a02s','a12e','b10e','b11e','a02f'}; %8tasks2robots4regions scenario:14 Greedy
% plan1={'a07s','b03s','a07f','a05s','b09e','a13e','b10e','b11e','a05f','a01s','b03f','b04s','a01f','a08s','a14e','b12e','b04f','a08f','a06s','a09e','a06f','a02s','a02f'};%8tasks2robots6regions scenario:13 GA Horizon
% plan1={'a01s','a13e','a01f','a05s','a05f','a03s','a12e','a11e','a03f','a04s','a12e','a04f','a07s','a11e','a10e','a07f','a02s','a09e','a02f','a06s','a06f','a08s','b13e','a14e','a08f'};%8tasks2robots6regions scenario:13 Greedy
% plan1={'b05s','a03s','b13e','a11e','a12e','b05f','b01s','a03f','a07s','b16e','a17e','b01f','b06s','a07f','a08s','b15e','a16e','a13e','b06f','b02s','b14e','a10e','b09e','a08f','a04s','b02f','a11e','a04f'};%8tasks2robots9regions scenario:13 GA Horizon
% plan1={'b13e','b16e','b15e','a13e','a12e','a05s','a11e','b16e','b01s','b01f','b07s','b17e','b07f','b03s','b12e','b03f','b02s','b13e','a12e','b10e','b09e','b02f','b08s','b10e','b08f','b04s','b11e','a13e','b04f','a10e','b12e','a13e','a05f','a06s','a16e','a15e','a06f'};%8tasks2robots9regions scenario:13 Greedy
% plan1={'b05s','c03s','a01s','b05f','b06s','c12e','b10e','c03f','a08e','c07e','b15e','a01f','a02s','c04s','a11e','b14e','c08e','b13e','a14e','c09e','a15e','b06f','a02f','c04f'}; %6tasks3robots9regions scenario:21 pop:15 GA Horizon

% plan1={'b05s','c01s','a03s','a14e','b05f','b06s','b12e','a03f','a04s','b13e','c10e','b16e','a13e','c01f','c07s','c07f','c08s','b15e','a12e','b06f','a11e','c13e','a04f','c12e','c08f','c02s','c17e','c02f'}; %8tasks3robots9regions scenario:10 GA Horizon
% plan1={'c09s','b05s','a03s','c09f','c01s','b05f','b06s','b14e','a16e','b15e','c12e','c01f','a03f','a07s','c10s','c13e','c14e','b18e','a15e','a12e','c19e','b17e','c18e','b06f','a07f','a04s','a13e','c10f','c02s','c19e','a04f','a08s','a14e','c02f','a08f'}; %10tasks3robots9regions scenario: 10 GA Horizon Pop:25
% plan1={'c05s','a07s','b09s','b16e','a07f','c05f','c01s','c01f','c11s','a03s','c18e','b21e','a14e','b09f','b10s','b20e','a03f','c11f','c12s','a08s','c17e','b19e','c12f','c06s','b10f','a15e','c16e','a08f','a04s','a14e','a17e','c06f','c02s','c21e','a20e','a04f','c02f'}; %12tasks3robots9regions scenario:10 GA Horizon Pop:25
% plan1={'a01s','b05s','c11s','c20e','b05f','a16e','c19e','a01f','a07s','b09s','c11f','a07f','a08s','c12s','c20e','a19e','b16e','a18e','b15e','c12f','b09f','a08f','a13s','b06s','a23e','c19e','b20e','a13f','a02s','c03s','a02f','b21e','c20e','b06f','c03f','c04s','a14s','b10s','a18e','a19e','b22e','c15e','c16e','b10f','c17e','a20e','c04f','a15e','a14f'}; %14tasks3robots9regions scenario:10 GA Horizon Pop:25

% plan1={'c09s','b05s','a03s','c09f','c07s','b05f','b01s','a16e','a03f','a04s','b12e','b01f','b02s','a15e','c16e','c11e','b13e','c12e','c07f','c08s','b14e','c13e','a12e','b19e','b02f','b06s','c14e','c08f','c10s','a13e','a04f','b18e','c19e','b17e','b06f','c18e','c10f'};
% plan1={'a01s','b05s','c11s','a16e','b05f','a01f','a07s','b09s','c20e','a07f','a08s','c19e','c11f','c12s','c20e','a19e','b16e','a18e','c12f','a08f','a13s','b15e','b09f','b06s','a23e','a13f','a02s','c03s','c03f','c04s','a02f','a14s','a18e','a19e','b16e','c15e','a18e','b19e','c16e','b20e','a19e','c17e','a16e','b21e','c04f','b06f','b10s','a15e','a14f','b22e','b10f'};

% plan1={'a03s','b01s','a08e','a03f','a04s','a05e','b08e','b01f','b02s','a04f','b07e','b06e','b02f'}; %44211 

% plan1={'a01s','b03s','a08e','b06e','a01f','a02s','b05e','a07e','b08e','a06e','b03f','b04s','b05e','a02f','b04f'}; %44212
% 
% plan1={'b01s','a03s','b08e','b01f','b02s','b07e','a08e','a03f','a04s','b06e','a05e','b02f','a04f'}; %44214
% 
% plan1={'b01s','a03s','b08e','b01f','b02s','b07e','a08e','a03f','a04s','b06e','b02f','a05e','a04f'}; %44215
% 
% plan1={'a01s','b03s','a05e','a01f','a02s','b09e','a06e','b03f','b04s','b08e','a09e','b07e','a08e','b04f','a02f'}; %46211
% 
% plan1={'b03s','a01s','b09e','b03f','b04s','a05e','a01f','a02s','b06e','a10e','b07e','a09e','b04f','a08e','a02f'}; %46212
% 
% plan1={'b03s','a01s','a09e','b05e','b03f','b04s','b06e','a12e','a13e','b07e','a01f','a02s','a12e','a09e','b04f','a02f'}; %49211
% 
% plan1={'a03s','b01s','a05e','a03f','a04s','a06e','b09e','b08e','a07e','b13e','b01f','b02s','a04f','b12e','b09e','b02f'}; %49212
% 
% plan1={'b03s','a01s','a07e','b05e','a08e','b03f','b04s','b06e','a13e','b07e','a01f','a02s','b04f','a08e','a09e','a02f'}; %49214
% 
% plan1={'b05s','a03s','b05f','b06s','a08e','b10e','b06f','b01s','a03f','a04s','b01f','b02s','a07e','b09e','b02f','a04f'}; %64212
% 
% plan1={'b05s','a03s','b05f','b01s','a08e','b10e','a03f','a04s','b01f','b06s','a07e','b06f','b02s','a04f','b09e','b02f'}; %64214
% 
% plan1={'b05s','a01s','b05f','b03s','b07e','a09e','b08e','a10e','a01f','a02s','a11e','b09e','a08e','b03f','b06s','b06f','b04s','a07e','a02f','b10e','b11e','b04f'}; %66211
% 
% plan1={'b05s','a01s','b05f','b03s','a11e','a10e','b07e','b08e','a01f','a02s','a11e','b09e','a08e','b03f','b06s','b06f','b04s','a07e','b08e','b11e','a02f','b04f'}; %66212
% 
% plan1={'b05s','a01s','b05f','b06s','b07e','a11e','b08e','a10e','a01f','a02s','a11e','b09e','a08e','b06f','b03s','b03f','b04s','a07e','b10e','a02f','b11e','b04f'}; %66215
% 
% plan1={'a03s','b01s','a09e','b13e','a03f','a04s','b01f','b02s','a08e','a11e','a04f','a05s','a14e','a15e','b14e','a05f','a06s','b11e','a14e','b02f','a13e','a06f'}; %69211
% 
% plan1={'a03s','b05s','a09e','a03f','a04s','b13e','b14e','a10e','a11e','a04f','a01s','a12e','a13e','b15e','b05f','b06s','a01f','a02s','a14e','a11e','b14e','a02f','b13e','b06f'}; %69212
% 
% plan1={'a03s','b05s','b13e','b14e','a09e','a03f','a04s','a08e','a11e','a04f','a01s','a12e','b15e','a13e','b05f','b06s','a01f','a02s','a12e','a11e','b14e','a02f','b13e','b06f'}; %69214
% 
% plan1={'b01s','a05s','a11e','b13e','b01f','b02s','b12e','a14e','b11e','a15e','a05f','a06s','b02f','b03s','a14e','b08e','b09e','a13e','b03f','b04s','b08e','b11e','a06f','b04f'}; %69215
% 
% plan1={'a05s','b01s','a05f','a07s','b10e','a12e','a07f','a06s','b01f','b02s','a09e','b11e','a10e','a06f','a03s','b12e','a03f','a08s','a11e','a08f','a04s','a04f','b02f'}; %84214
% 
% plan1={'a05s','b07s','a05f','a06s','b12e','b07f','b08s','b11e','a10e','a06f','a03s','b08f','b01s','a03f','a04s','b12e','b09e','a11e','b10e','b01f','b02s','b09e','b12e','a04f','b02f'}; %84215
% 
% plan1={'a03s','b01s','b13e','a11e','a03f','a04s','b01f','b07s','b10e','a12e','b07f','b02s','a04f','a05s','b09e','a13e','b02f','b08s','a05f','a06s','b14e','a10e','a09e','b08f','a06f'}; %86211
% 
% plan1={'a03s','b01s','a11e','b13e','a03f','a04s','b01f','b02s','a12e','b14e','a04f','a05s','b09e','b02f','b07s','a13e','b10e','b07f','b08s','a05f','a06s','b09e','b14e','a10e','a09e','b08f','a06f'}; %86212
% 
% plan1={'a03s','b01s','a11e','a03f','a04s','b13e','a12e','b01f','b07s','b10e','a04f','a05s','b07f','b02s','a13e','b09e','b02f','b08s','a05f','a06s','b14e','a10e','b08f','a09e','a06f'}; %86214
% 
% plan1={'b05s','a03s','b13e','a11e','b05f','b01s','a03f','a04s','b01f','b07s','a12e','b10e','b07f','b06s','b09e','b06f','b02s','b02f','b08s','a04f','b14e','b08f'}; %86215
% 
% plan1={'a03s','b05s','a11e','a12e','b13e','a03f','a07s','b05f','b01s','a17e','b16e','a07f','a08s','b01f','b06s','b15e','a12e','b06f','b02s','a13e','b14e','a10e','a08f','a04s','a11e','b09e','b02f','a04f'}; %89211
% 
% plan1={'a05s','b07s','a13e','b15e','a05f','a01s','b16e','b17e','a16e','a01f','a06s','b07f','b03s','a15e','b12e','a06f','a02s','b03f','b04s','a14e','b11e','b04f','b08s','b10e','a09e','b08f','a02f'}; %89212
% 
% plan1={'a03s','b05s','a11e','a12e','b13e','a03f','a07s','b05f','b01s','a17e','a07f','a04s','a12e','b16e','b01f','b06s','b15e','b06f','b02s','b14e','a11e','b09e','a04f','a08s','b02f','a10e','a08f'}; %89214
% 
% plan1={'b05s','a03s','b13e','b05f','b01s','a11e','b16e','a12e','a03f','a07s','b01f','b06s','b15e','a17e','a07f','a08s','b06f','b02s','a12e','b14e','a11e','a10e','a08f','a04s','a11e','a04f','b09e','b02f'}; %89215

% plan1={'b05s','a01s','c03s','a15e','b05f','b06s','a01f','a02s','c08e','a14e','b08e','c03f','c04s','c09e','a13e','b07e','c10e','b12e','a12e','c04f','a02f','b13e','b06f'}; %693111

% plan1={'b05s','a03s','c01s','b05f','b06s','a13e','c08e','c11e','b10e','a03f','a04s','c01f','c02s','c12e','a14e','a11e','c07e','b15e','b14e','c02f','b06f','a08e','a04f'}; %693222

% plan1={'a05s','b07s','c03s','b12e','a16e','c10e','a05f','a01s','a15e','c13e','b17e','c12e','b07f','b08s','a01f','a06s','c03f','c04s','b16e','b13e','c11e','a16e','b10e','a13e','a06f','a02s','b09e','c10e','b08f','b14e','c09e','a10e','a02f','c04f'}; %893111

% plan1={'c01s','a07s','b03s','c01f','c05s','a14e','a15e','b10e','b13e','c14e','a07f','a08s','a16e','c05f','c06s','b03f','b04s','b12e','a13e','c15e','c16e','a10e','b13e','a11e','c17e','b16e','c12e','c06f','c02s','a08f','b17e','b04f','a10e','c11e','c02f'}; %893222

% plan1={'a05s','b03s','c07s','a05f','a01s','b03f','b11s','c07f','c09s','a20e','a21e','c14e','b16e','b11f','b04s','a01f','a02s','c09f','c10s','a20e','b21e','c17e','c10f','c08s','c14e','a17e','b20e','c15e','c16e','b04f','b12s','a18e','a02f','a06s','b19e','a17e','b18e','a14e','c21e','b12f','c08f','a06f'}; %1293111

% plan1={'b09s','a07s','c01s','a14e','b09f','b05s','c18e','b16e','a07f','a11s','a15e','b05f','b03s','b21e','a16e','a11f','a08s','b03f','b04s','b20e','b17e','a21e','c19e','c01f','c02s','b04f','b10s','a08f','a12s','c18e','b10f','b06s','a20e','b14e','c17e','b13e','a12f','b18e','c16e','b19e','c15e','c02f','b06f'}; %1293222

% plan1= {'a03s','b01s','a09e','b05e','a03f','a04s','a06e','b01f','b02s','a07e','b06e','a04f','a08e','a09e','b07e','a06e','b08e','b02f'};

%plan1={'a03s','b01s','a09e','b05e','a03f','a04s','b01f','b02s','a06e','a07e','b06e','a04f','a08e','a09e','b07e','a06e','b08e','b02f'};

% plan1={'b01s','a03s','b08e','b01f','b02s','b07e','a08e','a03f','a04s','b06e','a05e','b02f','a04f'};

% plan1={'a03s','b01s','a08e','a03f','a04s','a05e','b08e','b01f','b02s','a04f','b07e','b06e','b02f'};

% plan1={'a03s','b01s','a08e','a03f','a04s','a05e','b08e','b01f','b02s','a04f','b07e','b06e','b02f'};

% plan1={'a03s','b01s','b13e','a11e','a03f','a04s','b01f','b07s','b10e','a12e','b07f','b02s','a04f','a05s','b09e','a13e','b02f','b08s','a05f','a06s','b14e','a10e','a09e','b08f','a06f'};
% 
% plan1={'a03s','b01s','b13e','a11e','a03f','a04s','b01f','b07s','b10e','a12e','b07f','b02s','a04f','a05s','b09e','a13e','b02f','b08s','a05f','a06s','b14e','a10e','a09e','b08f','a06f'}
% 
% plan1={'a03s','b01s','b13e','a11e','a03f','a04s','b01f','b07s','b10e','a12e','b07f','b02s','a04f','a05s','b09e','a13e','b02f','b08s','a05f','a06s','b14e','a10e','a09e','b08f','a06f'}
% 
% plan1={'a03s','b01s','b13e','a11e','a03f','a04s','b01f','b07s','b10e','a12e','b07f','b02s','a04f','a05s','b09e','a13e','b02f','b08s','a05f','a06s','b14e','a10e','a09e','b08f','a06f'}
% 
% plan1={'a03s','b01s','b13e','a11e','a03f','a04s','b01f','b07s','b10e','a12e','b07f','b02s','a04f','a05s','b09e','a13e','b02f','b08s','a05f','a06s','b14e','a10e','a09e','b08f','a06f'}

% plan1={'b05s','a01s','b05f','b03s','b07e','a09e','b08e','a10e','a01f','a02s','a11e','b09e','a08e','b03f','b06s','b06f','b04s','a07e','a02f','b10e','b11e','b04f'};
% plan1={'b05s','a01s','b05f','b03s','b07e','a09e','b08e','a10e','a01f','a02s','a11e','b09e','a08e','b03f','b06s','b06f','b04s','a07e','a02f','b10e','b11e','b04f'};
%  plan1={'c01s','a07s','b03s','c01f','c05s','a14e','a15e','b10e','b13e','c14e','a07f','a08s','a16e','c05f','c06s','b03f','b04s','b12e','c15e','a13e','c16e','a10e','b13e','a11e','c17e','b16e','c12e','c06f','c02s','b17e','a08f','b04f','a10e','c11e','c02f'};
%plan1={'c01s','a07s','b03s','c01f','c05s','a14e','b12e','a15e','b13e','c14e','a07f','a08s','c05f','c06s','b03f','b04s','b12e','c13e','a14e','a09e','b17e','c12e','c06f','c02s','a10e','b04f','c11e','c02f','c12e','a11e','a08f'};
% plan1={'c01s','a07s','b03s','c01f','c05s','a14e','b12e','a15e','b13e','c14e','a07f','a08s','c05f','c06s','b03f','b04s','b12e','c13e','a14e','a09e','b17e','c12e','c06f','c02s','a10e','b04f','c11e','c02f','c12e','a11e','a08f'};
%  plan1={'c01s','a07s','b03s','c01f','c05s','a14e','b12e','a15e','c14e','b13e','a07f','a08s','c05f','c06s','b03f','b04s','a16e','b12e','c15e','a13e','c16e','a10e','b13e','c17e','a11e','b16e','c12e','c06f','c02s','a08f','b17e','b04f','a10e','c11e','c02f'};
plan1={'b01s','a03s','b08e','b01f','b02s','b07e','a08e','a03f','a04s','b06e','a05e','a04f','b02f'};
old_start=start_loc;
                
                clear start_loc;
                
                for i=1:numRobots                              %Update Robot Locations
                    %robot{i} = updateLocations(robot{i});
                    start_loc(i,1) = old_start{i,1};%robot{i}.X;
                    start_loc(i,2) = old_start{i,2};%robot{i}.Y;
                end

                
                [path_gen,path_events] = createChromossomeMod2(plan1,states_incr,num_fsms,initial_state_incr,event_list,events_incr);

                [plan_cost,cost_trans,cost_extra]= path_cost_Incr(path_gen,path_events,start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
                
                
                
%                 for i=1:length(plan)
%                     
%                     [plan_cost(i),cost_trans{i},cost_extra{i}] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan{i});
%                     
%                 end
%                 [plan_cost1,cost_trans1,cost_extra_1] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan1);
%                 [plan_cost2,cost_trans2,cost_extra_2] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan5);
                %[plan_cost3,cost_trans3,cost_extra3] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan3);
                %[plan_cost4] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan4);
                %[plan_cost5] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan5);