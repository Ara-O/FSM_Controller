clear all;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


table_minitab=readtable('ju4.xls');


 i_t= 14; %1:height(table_minitab)
    
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

    abstracted=true;
    start_events_only=true;
    

pairTasks=numTasks/2;


% plans_abs=cell(sizePop,pairTasks);

j=0;
 [cost_final,path_state,path_events,solutionRobots,solutionRobotCost]=GreedyTasksInitialSolution(cur_states,numRobots,states_incr,events_incr,tasks,...
                    regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robot_tasks); %,robotLocations,robot_tasks



MaxRep=numTasks*3/2;

%coisas que eu tenho que fazer
% 1- criar solucao inicial - Fazer com Greedy
% 2- criar os metodos de remocao
% 3- criar os metodos de insercao
% 4- criar roulete wheel para decidir qual metodo vai ser escolhido
% 5- criar metodos de otimizacao- Local Search
% A solucao vai ser um cell array com uma posicao para cada robo? 
% ou eu devo fazer uma matriz, acho q vou fazer matriz para evitar
% converter de string para numero
% 

% track=0;
% 
% t1=tic;
% 
% while track <= MaxRep
%     
% 
% j=j+1;
% [plan_greedy{j},cost_aux(j)]=GreedyOddTasks(cur_states,numRobots,states_incr,events_incr,tasks,...
%         regions,numRegions,start_loc,numTasks,abstracted,start_events_only); %,robotLocations,robot_tasks
% 
% 
% table_results(i_t,1)=min(cost);
% table_results(i_t,2)=toc(t1);
% end