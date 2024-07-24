clear;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


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


robot_tasks = num2cell(NaN(1,numRobots));

step_through_final = false;
step_through_local = false;
init_cost = zeros(1,numRobots);

abstracted = false;
start_events_only = false;

pause(.5)                                       %Wait for roscore to handshake
disp('Setup complete!')


i_t=1;



cur_states = initial_state_incr;
state_path = cur_states;

max_rep_1=50000;




population_size_1=25;%table_minitab(i_t,1);
mutation_rate_1=0.4;%table_minitab(i_t,2);
stop_cond_1=15;%table_minitab(i_t,3);
%
num_rep=1;

ABS_event_path_1=[];
ABS_state_path=[];
ABS_plan_cost=[];
t_abs=[];



i_num=1;
index=0;
old_start=start_loc;
% plan_abs{1}={{'b01s'},{'a03s'},{'b02s'},{'a04s'}};%4tasks2robots4regions scenario: 11,13,14,15
% plan_abs{1}={{'a01s'},{'b03s'},{'a02s'},{'b04s'}};%4tasks2robots4regions scenario: 12

%plan_abs{1}={{'a03s'},{'b01s'},{'a04s'},{'b02s'}};%4tasks2robots6regions
% plan_abs{1}={{'b03s'},{'a01s'},{'b04s'},{'a02s'}};%4tasks2robots9regions 13,11
% plan_abs{1}={{'b01s'},{'a03s'},{'b02s'},{'a04s'},{'b05s'},{'b06s'}};%6tasks2robots4regions scenario: 13
%  plan_abs{1}={{'b05s'},{'a01s'},{'b06s'},{'a02s'},{'b03s'},{'b04s'}};%6tasks2robots6regions scenario:13
% plan_abs{1}={{'b01s'},{'a05s'},{'b02s'},{'a06s'},{'b03s'},{'b04s'}};%6tasks2robots9regions scenario:13
%  plan_abs{1}={{'a05s'},{'b01s'},{'a03s'},{'b02s'},{'a06s'},{'a04s'},{'b07s'},{'b08s'}};%8tasks2robots4regions scenario:13
%  plan_abs{1}={{'a07s'},{'b03s'},{'a05s'},{'a01s'},{'b04s'},{'a08s'},{'a06s'},{'a02s'}};%8tasks2robots6regions scenario:13
%  plan_abs{1}={{'b05s'},{'a03s'},{'b01s'},{'a07s'},{'b06s'},{'a08s'},{'b02s'},{'a04s'}}; %8tasks2robots9regions
%plan_abs{1}={{'b05s'},{'c03s'},{'a01s'},{'b06s'},{'c04s'},{'a07s'},{'a08s'},{'a02s'}}; %8tasks3robots9regions scenario:12

% plan_abs{1}={{'b05s'},{'c03s'},{'a01s'},{'b06s'},{'a02s'},{'c04s'}}; %6tasks9regions3robots scenario:21

% plan_abs{1}={{'b05s'},{'c01s'},{'a03s'},{'b06s'},{'a04s'},{'c07s'},{'c08s'},{'c02s'}}; %8tasks9regions3robots scenario:10

% plan_abs{1}={{'c09s'},{'b05s'},{'a03s'},{'c01s'},{'b06s'},{'a07s'},{'c10s'},{'a04s'},{'c02s'},{'a08s'}}; %10tasks9regions3robots scenario:10

% plan_abs{1}={{'c05s'},{'a07s'},{'b09s'},{'c01s'},{'c11s'},{'a03s'},{'b10s'},{'c12s'},{'a08s'},{'c06s'},{'a04s'},{'c02s'}}; %12tasks9regions3robots scenario:10

plan_abs{1}={{'a01s'},{'b05s'},{'c11s'},{'a07s'},{'b09s'},{'a08s'},{'c12s'},{'a13s'},{'b06s'},{'a02s'},{'c03s'},{'c04s'},{'a14s'},{'b10s'}}; %14tasks9regions3robots scenario:10

%plan_abs{1}={{'a01s'},{'b05s'},{'c11s'},{'a07s'},{'b09s'},{'a08s'},{'c12s'},{'a13s'},{'b06s'},{'a02s'},{'c03s'},{'c04s'},{'a14s'},{'b10s'}}; %14tasks9regions3robots scenario:12

% plan_abs{1}={{'a11s'},{'c03s'},{'b07s'},{'a12s'},{'c01s'},{'a09s'},{'c04s'},{'b05s'},{'a10s'},{'b06s'},{'c02s'},{'b08s'}}; %12tasks9regions3robots scenario:12

% plan_abs{1}={{'c05s'},{'b03s'},{'a09s'},{'c07s'},{'b01s'},{'a10s'},{'c06s'},{'b04s'},{'c08s'},{'a11s'},{'b02s'},{'a12s'}}; %12tasks9regions3robots scenario:14

% plan_abs{1}={{'c01s'},{'a03s'},{'b05s'},{'c09s'},{'a07s'},{'b06s'},{'c10s'},{'a08s'},{'a04s'},{'c02s'}}; %10tasks9regions3robots Scenario:11

% plan_abs{1}={{'a01s'},{'b03s'},{'a02s'},{'b04s'}};%4tasks2robots6regions scenario: 11
%  plan_abs{1}={{'b03s'},{'a01s'},{'b04s'},{'a02s'}};%4tasks2robots6regions scenario: 12
% plan_abs{1}={{'a03s'},{'b01s'},{'a04s'},{'b02s'}};%4tasks2robots9regions scenario: 12
%   plan_abs{1}={{'b03s'},{'a01s'},{'b04s'},{'a02s'}};%4tasks2robots9regions scenario: 14

% plan_abs{1}={{'b05s'},{'a03s'},{'b06s'},{'b01s'},{'a04s'},{'b02s'}}; %6tasks2robots4regions scenario:12

% plan_abs{1}={{'b05s'},{'a03s'},{'b01s'},{'a04s'},{'b06s'},{'b02s'}};%6tasks2robots4regions scenario:14

% plan_abs{1}={{'b05s'},{'a01s'},{'b03s'},{'a02s'},{'b06s'},{'b04s'}};%6tasks2robots6regions scenario:11,12

% plan_abs{1}={{'b05s'},{'a01s'},{'b06s'},{'a02s'},{'b03s'},{'b04s'}};%6tasks2robots6regions scenario:15

% plan_abs{1}={{'a03s'},{'b01s'},{'a04s'},{'b02s'},{'a05s'},{'a06s'}}; %6tasks2robots9regions scenario:11
% plan_abs{1}={{'a05s'},{'b01s'},{'a07s'},{'a06s'},{'b02s'},{'a03s'},{'a08s'},{'a04s'}}; %8tasks2robots4regions scenario:14

clear start_loc;
plan_final='';

while index <= length(plan_abs{1})
    for i=1:numRobots                              %Update Robot Locations
        %robot{i} = updateLocations(robot{i});
        start_loc(i,1) = old_start{i,1};%robot{i}.X;
        start_loc(i,2) = old_start{i,2};%robot{i}.Y;
    end
    
    if isempty(plan_final) && index<length(plan_abs{1})
        plan_final{1}{1}{1}=plan_abs{1}{index+1}{1};
         index=index+1;
    end
    aux_abs=1;
    while index<=length(plan_abs{1})-1 && aux_abs
        index=index+1;
        for i=1:length(plan_final{1})
            if strcmp(plan_abs{1}{index}{1}(1),plan_final{1}{i}{1}(1))
                aux_abs=0;
                index=index-1;
                break;
            end
        end
        if aux_abs
            plan_final{1}{end+1}{1}=plan_abs{1}{index}{1};
        end
    end
    if index == length(plan_abs{1})
        if strcmp(plan_abs{1}{end}{1}(1:end-1),plan_final{1}{1}{1}(1:end-1))
            index=index+1;
        end
    end
    t1=tic;
    [all_plan{i_num},ABS_event_path_1{i_num},ABS_state_path{i_num},ABS_plan_cost(i_num),num_spoint{i_num},initial_plan(i_num),num_of_changes(i_num),idx_change{i_num},trac_plan_cost{i_num},num_rep(i_num),t_dur{i_num},t_pop{i_num}] = GA_Horizon_New_02(plan_final,population_size_1,max_rep_1,mutation_rate_1,stop_cond_1,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,states_incr,events_incr,initial_state_incr,initial_state,events);
    t_abs(i_num)=toc(t1);
    
    len_horizon=length(ABS_event_path_1{i_num});
    
    for i=1:len_horizon
        if strcmp(ABS_event_path_1{i_num}{i}(end),'f')
            break;
        end
    end
    plan_final_aux=plan_final;
    plan_final='';
    aux_i=1;
    for j=1:length(plan_final_aux{1})
        if ~strcmp(plan_final_aux{1}{j}{1}(1),ABS_event_path_1{i_num}{i}(1))
            plan_final{1}{aux_i}{1}=strcat(plan_final_aux{1}{j}{1}(1:end-1),'f');
            aux_i=aux_i+1;
        end
    end
    final_event_path{i_num}={ABS_event_path_1{i_num}{1:i}};
    final_state_path{i_num}={ABS_state_path{i_num}{1:i+1}};
    
    [cost(i_num),cost_trans,cost_extra,robotLocation] = path_cost_Incr_Loc(final_state_path{i_num},final_event_path{i_num},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
    
    
    for i=1:numRobots
        old_start{i,1}=robotLocation{end,i}(1);
        old_start{i,2}=robotLocation{end,i}(2);
    end
    initial_state_incr=final_state_path{i_num}{end};
    i_num=i_num+1;
end