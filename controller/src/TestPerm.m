clear all;
close all;
% rosshutdown;
% rosinit('localhost');

addpath('src') %


table_minitab=readtable('ju4.xls');
testagain=[8 14 15 17 25 31 32];

i_t=11;
% for i=1: length(testagain)
%     i_t=testagain(i);
    ABSfoldName=table_minitab{i_t,1}{1};
    runningScenario=table_minitab{i_t,2};
    fsm=table_minitab{i_t,3}{1};
    sizePop=table_minitab{i_t,4}+50;
    stopCond=table_minitab{i_t,5}+30;
    maxRep=table_minitab{i_t,6}+100;
    if i_t >= 10
        sizePop=60;%table_minitab{i_t,4};
        stopCond=50;%table_minitab{i_t,5};
        maxRep=table_minitab{i_t,6}+50;
        if i_t >= 25
            sizePop=sizePop+100;
%             stopCond=stopCond;
            maxRep=maxRep+100;
%             if i_t >= 29
%                 sizePop=sizePop+250;
%             end
        end
    end
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
    
sizePop=630;
aux_robots=zeros(sizePop,numRobots);
% pop=cell(sizePop,1);
% cost=zeros(sizePop,1);

pairTasks=numTasks/2;

num_dup=0;

probRobot=zeros(numRobots,1);

share=floor(pairTasks/numRobots);
diff=mod(pairTasks,numRobots);
shareRobots_default=zeros(numRobots,1);
for i=1:numRobots
    probRobot(i)=i*(1/numRobots);
    shareRobots_default(i)=share;
    
end

plans=zeros(sizePop,pairTasks);
robots_assigned=zeros(sizePop,pairTasks);
% plans_abs=cell(sizePop,pairTasks);

j=1;

shareRobots=zeros(numRobots,1);
desired_tasks=cell(sizePop,numRobots);
while j<=sizePop
    shareRobots=shareRobots_default;
    ind_extra=randi(numRobots);
    shareRobots(ind_extra,1)=share+diff;
    for i=1:pairTasks        
        aux_rob=0;
        while aux_rob==0
            coin=rand;
            for k=1:numRobots
                if coin <= probRobot(k)
                    if aux_robots(j,k) < shareRobots(k,1)
                        aux_rob=1;
                        task_rob=i+(i-1);
                        desired_tasks{j,k}(end+1)=task_rob;
                        aux_robots(j,k)=aux_robots(j,k)+1;
                        plans(j,i)=k;
                        break;
                    else
                        break;
                    end
                end
            end
        end
    end

    aux_dup=0;
    for jj=1:j-1
        if (sum(plans(j,:)==plans(jj,:))==pairTasks)
            aux_dup=1;
            num_dup=num_dup+1;
            for ll=1:numRobots
                desired_tasks{j,ll}=[];
            end
            aux_robots(j,:)=0;
            break;
        end
    end
    if aux_dup==0
        j=j+1;
    end
end



ind=0;
num_desired=length(desired_tasks);
cost_plan=cell(num_desired,numRobots);
all_possible=cell(num_desired,numRobots);
for kk=1:num_desired
    for i=1:numRobots
        all_possible{kk,i}=desired_tasks{kk,i};%perms(desired_tasks{kk,i});
        num_all=size(all_possible{kk,i});
        cost_plan{kk,i}=zeros(num_all(1),num_all(2));
        for j=1:num_all(1)
            robot_location=start_loc(i,:);
            for k=1:num_all(2)
                taskNum=all_possible{kk,i}(j,k);
                [taskX,taskY,~] = getTaskLocation(taskNum,tasks);
                robX=robot_location(1);
                robY=robot_location(2);
                
                cost_plan{kk,i}(j,k)= cost_plan{kk,i}(j,k)+ sqrt((robX-taskX)^2+(robY-taskY)^2);
                robot_location(1)=taskX;
                robot_location(2)=taskY;
            end
        end
        
    end
end

% for i=1:length(cost_plan)
%     for j=1:numRobots
%         cost_robot(j)=min(cost_plan{i,j});
% %         index_rob{i,j}=find(cost_plan{i,j}==cost_robot(j));
%     end
%     max_cost(i)=min(cost_robot);
% end
% 
% min_plan=min(max_cost);
% 
% index_plan=find(max_cost==min_plan);
% for k=1:length(index_plan)
% for j=1:numRobots
% choose_tasks{k,j}=all_possible{index_plan(k),j};%(index_rob{index_plan,j},:);
% end
% end
index_plan=(1:sizePop);
for j=1:length(index_plan)
[pop_desired{j},cost_desired(j)] = testPlanTasks({desired_tasks{index_plan(j),:}},cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);
end

plans_abs=cell(length(index_plan),factorial(numTasks/2));
costs=zeros(length(index_plan),factorial(numTasks/2));
pop=cell(length(index_plan),factorial(numTasks/2));
for k=1:length(index_plan)
    numRobTasks(k,1)=length(desired_tasks{index_plan(k),1});
    for i=2:numRobots
        numRobTasks(k,i)=numRobTasks(k,i-1)+length(desired_tasks{index_plan(k),i});
    end
end

index_tasks=(1:pairTasks);

for k=1:length(index_plan)
    order=perms(index_tasks);
    for j=1:length(order)
        for kk=1:pairTasks
            for i=1:numRobots
                if order(j,kk)<=numRobTasks(k,i)
                    numTasksRobb=length(desired_tasks{index_plan(k),i});
                    indexTask=order(j,kk)-numRobTasks(k,i)+numTasksRobb;
                    task_rob=desired_tasks{index_plan(k),i}(indexTask);
                    robot=i;
                    
                    if task_rob<10
                        plans_abs{k,j}{kk}=strcat(char(robot+96),'0',num2str(task_rob),'s');
                    else
                        plans_abs{k,j}{kk}=strcat(char(robot+96),num2str(task_rob),'s');
                    end
                    break;
                end
            end
        end
         [pop{k,j},costs(k,j)] = testPlan(plans_abs{k,j}(:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);
    
    end
end