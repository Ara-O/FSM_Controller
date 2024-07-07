%Test Dijkstra Monolithic
clear;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


table_minitab=readtable('ju3.xls');

for i_t=11:15%height(table_minitab)
    
    ABSfoldName=table_minitab{i_t,1}{1};
    runningScenario=table_minitab{i_t,2};
    fsm=table_minitab{i_t,3}{1};
        
    run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI
    run(['../FSMs/' ABSfoldName '/' fsm '.m'])       %Import FSM data from FSM GUI
    %run(['../FSMs/' foldName '/' fsmInc '.m' ])
    
%     [~,num_fsms] = size(states);
    %NEED TO REMOVE THIS LATER
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
    
    t1=tic;
    [~,local_state_path,local_event_path,num_eval2] = ...
        robotDijkstraIncrementalNewHash(cur_states,numRobots,states_incr,events_incr,tasks,...
        regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robot_tasks); %,robotLocations,robot_tasks
    
    table(i_t,1)=toc(t1);
    
    abstracted=false;
    start_events_only=true;
     plan_cost=calcCostPlanTasks(local_event_path,numRobots,start_loc,tasks);  
%     [path_gen,path_events] = createChromossomeMod2(local_event_path,states_incr,num_fsms,initial_state_incr,event_list,events_incr);
%     [plan_cost,cost_trans,cost_extra]= path_cost_Incr(path_gen,path_events,start_loc,states_incr,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
    
    table(i_t,2)=plan_cost;
end
            
time = datestr(datetime);  

csvwrite(['../LogsAll/DijkstraTasks_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '.csv'],table);
