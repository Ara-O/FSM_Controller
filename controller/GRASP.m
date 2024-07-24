clear all;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


table_minitab=readtable('ju4.xls');


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

    abstracted=true;
    start_events_only=true;
    

pairTasks=numTasks/2;


% plans_abs=cell(sizePop,pairTasks);

j=0;


MaxRep=numTasks*3/2;


track=0;

t1=tic;

while track <= MaxRep
    
% while j<=sizePop
%     shareRobots=shareRobots_default;
%     ind_extra=randi(numRobots);
%     shareRobots(ind_extra,1)=share+diff;
%     for i=1:pairTasks        
%         aux_rob=0;
%         while aux_rob==0
%             coin=rand;
%             for k=1:numRobots
%                 if coin <= probRobot(k)
%                     if aux_robots(j,k) < shareRobots(k,1)
%                         aux_rob=1;
%                         task_rob=i+(i-1);
%                         desired_tasks{j,k}(end+1)=task_rob;
%                         aux_robots(j,k)=aux_robots(j,k)+1;
%                         plans(j,i)=k;
%                         break;
%                     else
%                         break;
%                     end
%                 end
%             end
%         end
%     end
% 
%     aux_dup=0;
%     for jj=1:j-1
%         if (sum(plans(j,:)==plans(jj,:))==pairTasks)
%             aux_dup=1;
%             num_dup=num_dup+1;
%             for ll=1:numRobots
%                 desired_tasks{j,ll}=[];
%             end
%             aux_robots(j,:)=0;
%             break;
%         end
%     end
%     if aux_dup==0
%         j=j+1;
%     end
% end
j=j+1;
[plan_greedy{j},cost_aux(j)]=GreedyOddTasks(cur_states,numRobots,states_incr,events_incr,tasks,...
        regions,numRegions,start_loc,numTasks,abstracted,start_events_only); %,robotLocations,robot_tasks

%I create a random desired_tasks distribution. Later, I will change that to
%be Greedy Randomized

%Now that I have a task distribution I will run a local-search to get a
%"good" solution for that distribution. My first solution will be the
%greedy solution for this distribution

% [pop_desired{j},cost_desired(j)] = testPlanTasks({desired_tasks{j-1,:}},cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);

%Now that I have my first solution, I will run 2-opt until I get a better
%solution. For that, I will run 2-opt only to the odd events, plan_abs. So
%I will need to extract that from pop_desired

 [pop_desired{j},cost_desired(j)] = testPlan(plan_greedy{j},cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);

plan_abs{j}=plan_greedy{j};%extractPlanOdd(pop_desired{j},numTasks);



[finalPlan{j}, cost(j)] = twoOpt(plan_abs{j},cost_desired(j),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);

track=track+1;
end
table_results(i_t,1)=min(cost);
table_results(i_t,2)=toc(t1);
end