%TEST GA Monolithic

clear;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %

%Default was ju2
table_minitab=readtable('ju7.xls');

%for i_t=34:height(table_minitab)
for i_t=1:height(table_minitab)

    foldName = table_minitab{i_t,1}{1};
    ABSfoldName=table_minitab{i_t,2}{1};
    runningScenario=table_minitab{i_t,3};
    fsm=table_minitab{i_t,4}{1};
    fsmInc=table_minitab{i_t,5}{1};
    population_size_1=table_minitab{i_t,6};
    mutation_rate_1=0.6;
    stop_cond_1=20;
    max_rep_1=1000;
    num_repet=5;
    
    
    
    run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI
    run(['../FSMs/' ABSfoldName '/' fsm '.m'])       %Import FSM data from FSM GUI
    run(['../FSMs/' foldName '/' fsmInc '.m' ])
    
    [~,num_fsms] = size(states);
    %NEED TO REMOVE THIS LATER
    EEC = 0;
    
    step_through_final = false;
    step_through_local = false;
    init_cost = zeros(1,numRobots);
    
    
    
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
    robot_tasks = zeros(numRobots,1);
    
    
    t_abs=[];
    plan_cost=[];
    
    for i_num=1:num_repet
        
        t1=tic;
        [all_plan{i_num},local_event_path,local_state_path,ABS_plan_cost(i_num),num_spoint{i_num},initial_plan(i_num),num_of_changes(i_num),idx_change{i_num},trac_plan_cost{i_num},num_rep(i_num),t_dur{i_num},t_pop{i_num}] = GA_Incremental_New_31(population_size_1,max_rep_1,mutation_rate_1,stop_cond_1,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,states_incr,events_incr,initial_state_incr,initial_state,events);
        t_abs(i_num)=toc(t1);
        
        abstracted=false;
        start_events_only=false;
        
        [plan_cost(i_num),cost_trans,cost_extra]= path_cost_Incr(local_state_path,local_event_path,start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);


    
    end
    
    table1(i_t,:)=t_abs;
    table2(i_t,:)=plan_cost;
    
    table(i_t,1)=mean(t_abs);
    table(i_t,2)=mean(plan_cost);
    
    
    
end

    
time = datestr(datetime);  

csvwrite(['../LogsAll/GAMono_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '.csv'],table);
csvwrite(['../LogsAll/Time/GAMonoTime_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '.csv'],table1);
csvwrite(['../LogsAll/Costs/GAMonoCost_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '.csv'],table2);
