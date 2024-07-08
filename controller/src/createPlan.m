function [path_event, path_state, cost] = createPlan(cur_state,states,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robotTask,events)

EEC=0;
path_event=cell(numTasks,1);
path_state=cell(numTasks+1,1);
path_state{1}=cur_state;
i=0;
j=1;
cost_robot=zeros(numRobots,1);
robotLocation=cell(numRobots,1);
aux_robots=zeros(numRobots,1);
for i_r = 1:numRobots
    robotLocation{i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
    cost_robot(i_r)=0;
end

while ~detectEndState(cur_state,states,num_fsms)
    
    transition_list = createTransitionList(states,cur_state,num_fsms);
    possible_trans = findPossibleTransitions(transition_list,event_list);

    possible_transitions=tasksAllRobots(possible_trans,aux_robots, numRobots, numTasks);
    
    if isempty(possible_transitions)
        ju=000
        
    end
    
    num_transitions = size(possible_transitions);
    
    index_trans=randi([1 num_transitions(1)]);
    
    i=i+1;
    
    next_event=possible_transitions{index_trans};
    if isempty(next_event)
        ju=000
        
    end
    task_event= str2double(next_event(end-2:end-1));
     event_bot = next_event(1)-96;
    if mod(task_event,2)
        aux_robots(event_bot)=aux_robots(event_bot)+1;
    end
    
   
    
    path_event{i}=next_event;
    
   
    
    [transition_cost,~,new_X,new_Y] = ...
        calcTransitionCosTasks(next_event,j,path_state{j},path_event,states,tasks,EEC,regions,numRegions,start_loc,...
        numTasks,abstracted,start_events_only,robotLocation{event_bot},robotTask,1);
    
    cost_robot(event_bot)=cost_robot(event_bot)+transition_cost;
    
    currBotLoad = cost_robot(event_bot);

    idle_cost = max(0,max(cost_robot(:)) - currBotLoad);
    %         end
    
    cost_robot(event_bot)=cost_robot(event_bot)+idle_cost;
    
    for jj = 1:numRobots
        robotLocation{jj} = robotLocation{jj};
    end
    
    robotLocation{event_bot} = [new_X,new_Y];

    cur_state = updateCurEvent(path_event{i},cur_state,events,states,num_fsms);
    
    j=j+1;
    
    path_state{j}=cur_state;
      
end
 cost=max(cost_robot);
end