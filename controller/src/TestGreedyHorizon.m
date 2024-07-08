clear;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


foldName = '4tasks2robots4regions_rn';
ABSfoldName='4tasks2robots4regionsABSTRACT_rn';
runningScenario=13;

% foldName = '6tasks9regions3robots_rn';
% ABSfoldName='6tasks9regions3robotsABSTRACT_rn';
% runningScenario=21;
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
start_loc1=start_loc;
old_start=start_loc;
% plan_abs{1}={{'b01s'},{'a03s'},{'b02s'},{'a04s'}};%4tasks2robots4regions scenario: 11,13,14,15
% plan_abs{1}={{'a01s'},{'b03s'},{'a02s'},{'b04s'}};%4tasks2robots4regions scenario: 12

% plan_abs{1}={{'a03s'},{'b01s'},{'a04s'},{'b02s'}};%4tasks2robots6regions
% plan_abs{1}={{'b03s'},{'a01s'},{'b04s'},{'a02s'}};%4tasks2robots9regions 13,11
% plan_abs{1}={{'b01s'},{'a03s'},{'b02s'},{'a04s'},{'b05s'},{'b06s'}};%6tasks2robots4regions scenario: 13
%  plan_abs{1}={{'b05s'},{'a01s'},{'b06s'},{'a02s'},{'b03s'},{'b04s'}};%6tasks2robots6regions scenario:13
% plan_abs{1}={{'b01s'},{'a05s'},{'b02s'},{'a06s'},{'b03s'},{'b04s'}};%6tasks2robots9regions scenario:13
%  plan_abs{1}={{'a05s'},{'b01s'},{'a03s'},{'b02s'},{'a06s'},{'a04s'},{'b07s'},{'b08s'}};%8tasks2robots4regions scenario:13
%  plan_abs{1}={{'a07s'},{'b03s'},{'a05s'},{'a01s'},{'b04s'},{'a08s'},{'a06s'},{'a02s'}};%8tasks2robots6regions scenario:13
 plan_abs{1}={{'b05s'},{'a03s'},{'b01s'},{'a07s'},{'b06s'},{'a08s'},{'b02s'},{'a04s'}}; %8tasks2robots9regions
%plan_abs{1}={{'b05s'},{'c03s'},{'a01s'},{'b06s'},{'c04s'},{'a07s'},{'a08s'},{'a02s'}}; %8tasks3robots9regions scenario:12

% plan_abs{1}={{'b05s'},{'c03s'},{'a01s'},{'b06s'},{'a02s'},{'c04s'}}; %6tasks9regions3robots scenario:21

% plan_abs{1}={{'b05s'},{'c01s'},{'a03s'},{'b06s'},{'a04s'},{'c07s'},{'c08s'},{'c02s'}}; %8tasks9regions3robots scenario:10

% plan_abs{1}={{'c09s'},{'b05s'},{'a03s'},{'c01s'},{'b06s'},{'a07s'},{'c10s'},{'a04s'},{'c02s'},{'a08s'}}; %10tasks9regions3robots scenario:10

% plan_abs{1}={{'c05s'},{'a07s'},{'b09s'},{'c01s'},{'c11s'},{'a03s'},{'b10s'},{'c12s'},{'a08s'},{'c06s'},{'a04s'},{'c02s'}}; %12tasks9regions3robots scenario:10

% plan_abs{1}={{'a01s'},{'b05s'},{'c11s'},{'a07s'},{'b09s'},{'a08s'},{'c12s'},{'a13s'},{'b06s'},{'a02s'},{'c03s'},{'c04s'},{'a14s'},{'b10s'}}; %14tasks9regions3robots scenario:10

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
plan_final_aux='';
robot_tasks=zeros(numRobots,1);
old_tasks=zeros(numRobots,1);
aux_start_events='';
first=1;
tasks_finish=zeros(1,numTasks);

while sum(tasks_finish)~=numTasks
%     robot_tasks=zeros(numRobots,1);
    plan_final='';
    robot_used=zeros(numRobots,1);
    for i=1:numRobots                              %Update Robot Locations
        %robot{i} = updateLocations(robot{i});
        start_loc(i,1) = old_start{i,1};%robot{i}.X;
        start_loc(i,2) = old_start{i,2};%robot{i}.Y;
    end
    j=0;
    if length(aux_start_events)~=length(plan_final_aux)
        diff=length(plan_final_aux)-length(aux_start_events);
        for ij=(length(plan_final_aux)-diff+1):length(plan_final_aux)
            j=j+1;
            plan_final{1}{j}{1}=plan_final_aux{ij}{1};
            event_bot=plan_final_aux{ij}{1}(1)-96;
            robot_used(event_bot,1)=1;
            if robot_tasks(event_bot,1)==0
                robot_tasks(event_bot,1)=str2double(plan_final_aux{ij}{1}(2:end-1));
            end
        end
    end
    while index<length(plan_abs{1})
        index=index+1;
        event_bot =plan_abs{1}{index}{1}(1)-96;
        if robot_used(event_bot,1)==1
            index=index-1;
            break;
        else
            j=j+1;
            plan_final{1}{j}{1}=plan_abs{1}{index}{1};
            if robot_tasks(event_bot,1)==0
                robot_tasks(event_bot,1)=str2double(plan_abs{1}{index}{1}(2:end-1));
            elseif robot_tasks(event_bot,1)==old_tasks(event_bot,1)
                 robot_tasks(event_bot,1)=str2double(plan_abs{1}{index}{1}(2:end-1));
            end
            robot_used(event_bot,1)=1;
        end

    end
    for im=1:numRobots
        if robot_used(im,1)==0 && robot_tasks(im,1)==0
            robot_tasks(im,1)=old_tasks(im,1);
        end
    end
            
    t1=tic;
    [cost,local_state_path{i_num},local_event_path{i_num}] = ...
        robotDijkstraGreedyNew2Horizon(tasks_finish,plan_final,initial_state_incr,numRobots,states_incr,events_incr,tasks,...
        regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robot_tasks);
    t_abs(i_num)=toc(t1);
    
    first=0;
    len_horizon=length(local_event_path{i_num});
    if ~isempty(plan_final)
    plan_final_aux=plan_final{1};
    end
    
    for i=1:len_horizon
        if strcmp(local_event_path{i_num}{i}(end),'f')
            event_bot=local_event_path{i_num}{i}(1)-96;
            numTask=str2double(local_event_path{i_num}{i}(2:end-1));
            tasks_finish(1,numTask)=1;
            if robot_tasks(event_bot,1)==str2double(local_event_path{i_num}{i}(2:end-1))
                old_tasks(event_bot,1)=robot_tasks(event_bot,1);
                robot_tasks(event_bot,1)=0;
            else
                first=1;
            end
            break;
        end
    end

    final_event_path{i_num}={local_event_path{i_num}{1:i}};
    final_state_path{i_num}={local_state_path{i_num}{1:i+1}};
    
    aux_start_events=stripEventPathMod(final_event_path{i_num});
    
    [cost(i_num),cost_trans,cost_extra,robotLocation] = path_cost_Incr_Loc(final_state_path{i_num},final_event_path{i_num},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
    
    
    for i=1:numRobots
        old_start{i,1}=robotLocation{end,i}(1);
        old_start{i,2}=robotLocation{end,i}(2);
    end
    
    initial_state_incr=final_state_path{i_num}{end};
    i_num=i_num+1;
end
for i=1:numRobots                              %Update Robot Locations
    %robot{i} = updateLocations(robot{i});
    start_loc(i,1) = start_loc1{i,1};%robot{i}.X;
    start_loc(i,2) = start_loc1{i,2};%robot{i}.Y;
end

k_eve=1;
k_state=1;
for i=1:i_num-1
    
    for j=1:length(final_event_path{i})
        event_path{k_eve}=final_event_path{i}{j};
        k_eve=k_eve+1;
        state_path{k_state}=final_state_path{i}{j};
        k_state=k_state+1;
    end
    state_path{k_state}=final_state_path{i}{j+1};
    k_state=k_state+1;
end

 [plan_cost,cost_trans,cost_extra]= path_cost_Incr(state_path,event_path,start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);

    
        