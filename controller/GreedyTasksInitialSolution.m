function [cost_final,path_state,path_events,solutionRobots,solutionRobotsCost] = ...
  GreedyTasksInitialSolution(cur_state,numRobots,states,events,tasks,regions,numRegions,start_loc,numTasks,ABSTRACTED,start_events_only,robot_tasks)


[~,num_fsms] = size(states);
%NEED TO REMOVE THIS LATER
EEC = 0;
n = 1;
end_unsettled = true;
end_states = double.empty;
%isDone = false(1,numRobots);

% Initialize output variables
costs = zeros(1,1);
paths = num2cell(NaN(1,1));
robotTask=zeros(1,numRobots);
% Find the minimum costs and paths using Dijkstra's Algorithm

% solutionRobots=zeros(numRobots,numTasks);
% solutionRobotCost=zeros(numRobots,numTasks);
solutionRobots=cell(numRobots,1);
solutionRobotsCost=cell(numRobots,1);

indexRobotsTask=zeros(numRobots,1);

robotLocation = num2cell(NaN(n,numRobots));
%robotTask = NaN(n,numRobots);
% Sets up the robots initial locations
for i = 1:numRobots
    robotLocation{1,i} = [start_loc(i,1) start_loc(i,2)]; %cur_state vs 1
end
% for i=1:numRobots    
%     robotRegions(i)= str2double(whichRegion(start_loc(i,1),start_loc(i,2),numRegions,regions));
% end
for i=1:numTasks
    bot_task=i;
    [taskX,taskY,~] = getTaskLocation(bot_task,tasks);
    tasksRegions(i)=str2double(whichRegion(taskX,taskY,numRegions,regions));
end

% region=zeros(numRobots,numRegions-numTasks);
% tasks_finish=zeros(1,numTasks);
event_list = createEventFsmList(events,num_fsms);

% desiredRegion=zeros(numRobots,1);
path_state{1}=cur_state;

j=1;
i=1;
costs=zeros(numRobots,1);
path_events='';
full_cost=zeros(1,numRobots);

while ~detectEndState(cur_state,states,num_fsms)
    
    J_costs=[];
    new_pos=[];
    J_trans=[];
    trans_cost=[];
    aux_start=0;
    aux_entry=0;
    aux_finish=0;
    
    transition_list = createTransitionList(states,cur_state,num_fsms);
    possible_transitions = findPossibleTransitions(transition_list,event_list); 
    
    num_trans=size(transition_list);
    num_transitions = size(possible_transitions);
    
    
    J_trans=zeros(num_transitions(1),1);
    J_costs=zeros(num_transitions(1),1);
    new_pos=zeros(num_transitions(1),2);
    trans_cost=zeros(num_transitions(1),numRobots);
    %     trans_cost=full_cost;
    for kk = 1:num_transitions(1) % iterate through the number of transitions
        trans_cost(kk,:)=full_cost(1,:);
        %       next_state = updateCurEvent(possible_transitions(kk),cur_state,events,states,num_fsms);
        next_event=possible_transitions{kk};
        
        event_bot = possible_transitions{kk}(1)-96;
        [transition_cost,~,new_X,new_Y] = ...
          calcTransitionCosTasks(next_event,j,path_state{j},path_events,states,tasks,EEC,regions,numRegions,start_loc,...
          numTasks,ABSTRACTED,start_events_only,robotLocation{j,event_bot},robotTask,1); 
        
        trans_cost(kk,event_bot)=full_cost(1,event_bot)+transition_cost;
        currBotLoad = trans_cost(kk,event_bot);
        % Adds Idle cost only to event owner bot
        idle_cost = max(0,max(trans_cost(kk,:)) - currBotLoad);
        % Bot next load = current load + idle cost
        trans_cost(kk,event_bot) = trans_cost(kk,event_bot) + idle_cost;
        
        J_trans(kk)=transition_cost;
        J_costs(kk) =max(trans_cost(kk,:)); %J_costs(event_bot) + transition_cost;
        new_pos(kk,1)=new_X;
        new_pos(kk,2)=new_Y;
        
        
    end
    
    
    j=j+1;
    
    costs_min=min(J_costs);
    
    if isempty(costs_min)
        ju=6
        
    end
    
    costs_index=find(J_costs==costs_min);
    
    if length(costs_index) > 1 || isempty(costs_index)
        ju='help';
        
    end
    
    index_trans=randi([1 length(costs_index)]);
    
    path_events{i}=possible_transitions{costs_index(index_trans)};
    
    i=i+1;
    
    cur_state = updateCurEvent(possible_transitions(costs_index(index_trans)),cur_state,events,states,num_fsms);
    
    path_state{j}=cur_state;
    
    event_bot = possible_transitions{costs_index(index_trans)}(1)-96;
    chooseTask=str2double(possible_transitions{costs_index(index_trans)}(end-2:end-1));
%     indexRobotsTask(event_bot,1)=indexRobotsTask(event_bot,1)+1;
    
%     desiredRegion(event_bot,1)=tasksRegions(str2double(possible_transitions{costs_index(index_trans)}(2:end-1)));
    
    for k = 1:numRobots
        robotLocation{j,k} = robotLocation{j-1,k}; %cur_state vs 1
    end
    
    solutionRobots{event_bot}(end+1)=chooseTask;
%     solutionRobots(event_bot,chooseTask)=indexRobotsTask(event_bot,1);
    
    %     robotLocation{j,:} = robotLocation{j-1,:}; %cur_state vs 1
    
    robotLocation{j,event_bot} = [new_pos(costs_index(index_trans),1) new_pos(costs_index(index_trans),2)]; %cur_state vs 1
    
    full_cost(1,event_bot)=trans_cost(costs_index(index_trans),event_bot);%%full_cost(event_bot,1)+J_trans(costs_index(index_trans));
    solutionRobotsCost{event_bot}(end+1)=J_trans(costs_index(index_trans));
%     solutionRobotCost(event_bot,chooseTask)=J_trans(costs_index(index_trans));
end
      cost_final=max(full_cost);  
end

  
  

  
  
  

        
    