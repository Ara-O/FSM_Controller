clear all;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %
table_minitab=readtable('ju3.xls');


for i_t=1:height(table_minitab)
    
    ABSfoldName=table_minitab{i_t,1}{1};
    runningScenario=table_minitab{i_t,2};
    fsm=table_minitab{i_t,3}{1};
    
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
    abstracted=false;
    start_events_only=false;
    t1=tic;
    a=3
    
    %                 [~,local_state_path,local_event_path,num_eval,total_cost_time,total_trans_list_time,total_pos_trans_time,total_force_start_events_time,total_update_event_time,total_create_event_path_time,total_satisf_path_time] = ...
    %                     localDijkstraIncrementalGA(cur_states,numRobots,states_incr,events_incr,...
    %                     tasks,regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robotLocations,robot_tasks);
    %                 aux_LD=1;
    a=2
    [~,local_state_path,local_event_path,num_eval2] = ...
        robotDijkstraGreedy(cur_states,numRobots,states_incr,events_incr,tasks,...
        regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robot_tasks); %,robotLocations,robot_tasks
    t_abs(i_num)=toc(t1);
    
    [path_gen,path_events] = createChromossomeMod2(local_event_path,states_incr,num_fsms,initial_state_incr,event_list,events_incr);
    [plan_cost,cost_trans,cost_extra]= path_cost_Incr(path_gen,path_events,start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
    
    
    %             table(i_t,1)=population_size_1;
    %             table(i_t,2)=mutation_rate_1;
    %             table(i_t,3)=stop_cond_1;
    table(i_t,1)= t_abs;
    table(i_t,2)=ABS_plan_cost;
    
    %i_t=i_t+1;
    
    
end
time = datestr(datetime);  

csvwrite(['../LogsAll/GreedyMono_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '.csv'],table);