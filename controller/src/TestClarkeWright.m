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
        robotLocations(kk,1) = start_loc(kk,1);
        robotLocations(kk,2) = start_loc(kk,2);
        %                     robot_tasks{kk} = robot{kk}.cur_task(4:end);
    end
    
    abstracted=true;
    start_events_only=true;
    ind=0;
    tasksRobots=zeros(numRobots,numTasks);
    for i=1:numRobots
        robX=robotLocations(i,1);
        robY=robotLocations(i,2);
        for j=1:numTasks
            indt=j+(j-1);
            taskX=tasks{j,2};
            taskY=tasks{j,3};
            tasksRobots(i,j)=sqrt(((robX-taskX)^2)+((robY-taskY)^2)); 
            ind=ind+1;
            tasksAll(ind,1)=sqrt(((robX-taskX)^2)+((robY-taskY)^2));
            tasksAll(ind,2)=i;
            tasksAll(ind,3)=j;
        end
    end
    
    [valueAll,indexAll]=sort(tasksAll(:,1));
   
    orderingAll(:,1)=tasksAll(indexAll,1);
    orderingAll(:,2)=tasksAll(indexAll,2);
    orderingAll(:,3)=tasksAll(indexAll,3);
    
   
    
    pairsTasks=NaN(numTasks,numTasks);
    ind=0;
    for i=1:numTasks
        taskX1=tasks{i,2};
        taskY1=tasks{i,3};
        for j=1:numTasks
            taskX2=tasks{j,2};
            taskY2=tasks{j,3};
            pairsTasks(i,j)=sqrt(((taskX1-taskX2)^2)+((taskY1-taskY2)^2));
            if i==j
                pairsTasks(i,j)=Inf;
            end
            ind=ind+1;
            pairsTasksAll(ind,1)=sqrt(((taskX1-taskX2)^2)+((taskY1-taskY2)^2));
            pairsTasksAll(ind,2)=i;
            pairsTasksAll(ind,3)=j;
            
        end
    end
    ind=0;
    for i=1:numTasks
        ind=ind+1;
        [closePair(ind,:),closePair(ind+1,:)]=sort(pairsTasks(i,:));
       ind=ind+1;
    end
    
    [valuesTasks, indexTasks]=sort(pairsTasksAll(:,1));
    
    orderingTasks(:,1)=pairsTasksAll(indexTasks,1);
    orderingTasks(:,2)=pairsTasksAll(indexTasks,2);
    orderingTasks(:,3)=pairsTasksAll(indexTasks,3);
    
    
    savingsRobots=cell(1,numRobots);
    indj=0;
    for i=1:numRobots
        ind=0;
        for j=1:numTasks
            for k=j+1:numTasks
                ind=ind+1;
                indj=indj+1;
                savingsRobots{i}(ind,1)=tasksRobots(i,j)+tasksRobots(i,k)-pairsTasks(j,k);
                savingsRobots{i}(ind,2)=j;
                savingsRobots{i}(ind,3)=k;
                savingsRobots{i}(ind,4)=tasksRobots(i,j);
                savingsRobots{i}(ind,5)=tasksRobots(i,k);
                savingsRobots{i}(ind,6)=pairsTasks(j,k);
                alltasks(indj,1)=tasksRobots(i,j)+tasksRobots(i,k)-pairsTasks(j,k);
                alltasks(indj,2)=j;
                alltasks(indj,3)=k;
                alltasks(indj,4)=i;
                alltasks(indj,5)=min(tasksRobots(i,j),tasksRobots(i,k))+pairsTasks(j,k);
                alltasks(indj,6)=tasksRobots(i,j);
                alltasks(indj,7)=tasksRobots(i,k);
                alltasks(indj,8)=pairsTasks(j,k);
            end
        end
    end
    
[values,index]=sort(alltasks(:,1),'descend');

orderingsavings(:,1)=alltasks(index,1);
orderingsavings(:,2)=alltasks(index,2);
orderingsavings(:,3)=alltasks(index,3);
orderingsavings(:,4)=alltasks(index,4);
orderingsavings(:,5)=alltasks(index,5);
orderingsavings(:,6)=alltasks(index,6);
orderingsavings(:,7)=alltasks(index,7);
orderingsavings(:,8)=alltasks(index,8);
% 
% [valuesCost,indexCost]=sort(alltasks(:,5));
% 
costsA=savingsRobots{1,1}(:,1);
[valuesA,indexA]=sort(costsA,'descend');
orderingA(:,1)=valuesA;
orderingA(:,2)=savingsRobots{1,1}(indexA,2);
orderingA(:,3)=savingsRobots{1,1}(indexA,3);
orderingA(:,4)=savingsRobots{1,1}(indexA,4);
orderingA(:,5)=savingsRobots{1,1}(indexA,5);
orderingA(:,6)=savingsRobots{1,1}(indexA,6);
% 
% orderingCost(:,1)=alltasks(indexCost,1);
% orderingCost(:,2)=alltasks(indexCost,2);
% orderingCost(:,3)=alltasks(indexCost,3);
% orderingCost(:,4)=alltasks(indexCost,4);
% orderingCost(:,5)=alltasks(indexCost,5);
% orderingCost(:,6)=alltasks(indexCost,6);
% orderingCost(:,7)=alltasks(indexCost,7);
% orderingCost(:,8)=alltasks(indexCost,8);

ind=0;
for i=1:numRobots
    for j=1:numTasks
        for k=j+1:numTasks
            ind=ind+1;
            savingsPairs(ind,1)=max(tasksRobots(i,k),tasksRobots(i,j))-pairsTasks(j,k);
            savingsPairs(ind,2)=j;
            savingsPairs(ind,3)=k;
            savingsPairs(ind,4)=i;
        end
    end
end

[valuesPairs,indexPairs]=sort(savingsPairs(:,1));

orderingPairs(:,1)=savingsPairs(indexPairs,1);
orderingPairs(:,2)=savingsPairs(indexPairs,2);
orderingPairs(:,3)=savingsPairs(indexPairs,3);
orderingPairs(:,4)=savingsPairs(indexPairs,4);

 indexA=find(orderingAll(:,2)==1);
    indexB=find(orderingAll(:,2)==2);
    indexC=find(orderingAll(:,2)==3);
    
    AllRA(:,1)=orderingAll(indexA,1);
    AllRA(:,2)=orderingAll(indexA,3);
    
    AllRB(:,1)=orderingAll(indexB,1);
    AllRB(:,2)=orderingAll(indexB,3);
    
    AllRC(:,1)=orderingAll(indexC,1);
    AllRC(:,2)=orderingAll(indexC,3);
    
    for i=2:numTasks/2
        if AllRA(i-1,2)< AllRA(i,2)
            AllRA(i,3)=pairsTasks(AllRA(i-1,2),AllRA(i,2));
        else
            AllRA(i,3)=pairsTasks(AllRA(i,2),AllRA(i-1,2));
        end
        if AllRB(i-1,2)< AllRB(i,2)
            AllRB(i,3)=pairsTasks(AllRB(i-1,2),AllRB(i,2));
        else
            AllRB(i,3)=pairsTasks(AllRB(i,2),AllRB(i-1,2));
        end
        if AllRC(i-1,2)< AllRC(i,2)
            AllRC(i,3)=pairsTasks(AllRC(i-1,2),AllRC(i,2));
        else
            AllRC(i,3)=pairsTasks(AllRC(i,2),AllRC(i-1,2));
        end
    end
    
    plans_abs=cell(1,factorial(numTasks/2));
costs=zeros(1,factorial(numTasks/2));
pop=cell(1,factorial(numTasks/2));
    
    
    
%     desired_tasks={[7,9],[3,13],[5,11,1]};
%     numRobTasks(1)=length(desired_tasks{1,1});
%     for i=2:numRobots
%         numRobTasks(i)=numRobTasks(i-1)+length(desired_tasks{1,i});
%     end
%     
%     index_tasks=(1:numTasks/2);
%     order=perms(index_tasks);
%     for j=1:length(order)
%         for kk=1:numTasks/2
%             for i=1:numRobots
%                 if order(j,kk)<=numRobTasks(i)
%                     numTasksRobb=length(desired_tasks{1,i});
%                     indexTask=order(j,kk)-numRobTasks(i)+numTasksRobb;
%                     task_rob=desired_tasks{1,i}(indexTask);
%                     robot=i;
%                     
%                     if task_rob<10
%                         plans_abs{1,j}{kk}=strcat(char(robot+96),'0',num2str(task_rob),'s');
%                     else
%                         plans_abs{1,j}{kk}=strcat(char(robot+96),num2str(task_rob),'s');
%                     end
%                     break;
%                 end
%             end
%         end
%         [pop{1,j},costs(1,j)] = testPlan(plans_abs{1,j}(:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);
%         
%     end
