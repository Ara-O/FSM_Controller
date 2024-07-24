%clear all;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %

fsm='fsmdata';
sizePop=population_size_1;
stopCond=stop_cond_1;
maxRep=max_rep_1;

mutRate=1;%table_minitab{i_t,7};

run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI
run(['../FSMs/' ABSfoldName '/' fsm '.m'])       %Import FSM data from FSM GUI
%run(['../FSMs/' foldName '/' fsmInc '.m' ])

EEC = 0;

step_through_final = false;
step_through_local = false;
init_cost = zeros(1,numRobots);


[~,num_fsms] = size(states_incr);
event_list = createEventFsmList(events_incr,num_fsms);
cur_states = initial_state_incr;
state_path = cur_states;


old_start=start_loc;

clear start_loc;

for i=1:numRobots                              %Update Robot Locations
    %robot{i} = updateLocations(robot{i});
    start_loc(i,1) = old_start{i,1};%robot{i}.X;
    start_loc(i,2) = old_start{i,2};%robot{i}.Y;
end



robotLocations = NaN(numRobots,2);

% Stores the robots current tasks to send to localDijkstra
robot_tasks = num2cell(NaN(1,numRobots));

% Need to send robots current location to Dijkstra
for kk = 1:numRobots
    robotLocations(kk,1) = start_loc(i,1);
    robotLocations(kk,2) = start_loc(i,2);
    %                     robot_tasks{kk} = robot{kk}.cur_task(4:end);
end

abstracted=true;
start_events_only=true;
abstracted=true;
start_events_only=true;
tic;
[plan_cost,local_event_path] = ...
    robotGATasks(cur_states,numRobots,states_incr,events_incr,tasks,...
    regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robot_tasks,sizePop, mutRate, stopCond,maxRep, num_fsms); %,robotLocations,robot_tasks
t_abs(1)=toc;


table(1,1)=t_abs(1);
table(1,2)=plan_cost;
for i=1:2*num_fsms
    table2{1,i}=string(local_event_path{i});
end




time = datestr(datetime);

csvwrite(['../LogsAll/GATasks_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '.csv'],table);
