function [cost_final,path_state,path_events] = ...
  robotDijkstraGreedyTasksMultiPath(cur_state,numRobots,states,events,tasks,regions,numRegions,start_loc,numTasks,ABSTRACTED,start_events_only,robot_tasks)


[~,num_fsms] = size(states);
%NEED TO REMOVE THIS LATER
EEC = 0;
n = 1;

robotTask=zeros(1,numRobots);

% Find the minimum costs and paths using Dijkstra's Algorithm

initial_state=cur_state;

robotLocation = num2cell(NaN(n,numRobots));
%robotTask = NaN(n,numRobots);
% Sets up the robots initial locations
for i = 1:numRobots
    robotLocation{1,i} = [start_loc(i,1) start_loc(i,2)]; %cur_state vs 1
end

event_list = createEventFsmList(events,num_fsms);


transition_list = createTransitionList(states,cur_state,num_fsms);
initial_transitions = findPossibleTransitions(transition_list,event_list);

% num_trans=size(transition_list);
num_paths = size(initial_transitions);

cost_final=zeros(num_paths(1),1);

path_state=cell(num_paths(1),numTasks+1);

path_events=cell(num_paths(1),numTasks);

full_cost=zeros(num_paths(1),numRobots);

kp=0;

for k=1:num_paths(1)
    
    next_event=initial_transitions{k};
    
    cur_state = updateCurEvent(next_event,initial_state,events,states,num_fsms);
    
    transition_list = createTransitionList(states,cur_state,num_fsms);
    possible_transitions2 = findPossibleTransitions(transition_list,event_list);
    
    num_transitions2 = size(possible_transitions2);
    
    for ik=1:num_transitions2(1)
        
        kp=kp+1;
        
        cur_state=initial_state;
        
        for i = 1:numRobots
            robotLocation{1,i} = [start_loc(i,1) start_loc(i,2)]; %cur_state vs 1
        end
        j=1;
        i=1;
        
        path_state{kp,j}=cur_state;
        
        next_event=initial_transitions{k};
        
        event_bot =next_event(1)-96;
        
        [transition_cost,~,new_X,new_Y] = ...
            calcTransitionCosTasks(next_event,j,path_state{kp,j},path_events,states,tasks,EEC,regions,numRegions,start_loc,...
            numTasks,ABSTRACTED,start_events_only,robotLocation{j,event_bot},robotTask,1);
        
        full_cost(kp,event_bot)=transition_cost;
        
        path_events{kp,i}=next_event;
        
        i=i+1;
        j=j+1;
        
        cur_state = updateCurEvent(next_event,cur_state,events,states,num_fsms);
        
        path_state{kp,j}=cur_state;
        
        for ki = 1:numRobots
            robotLocation{j,ki} = robotLocation{j-1,ki}; %cur_state vs 1
        end
        
        robotLocation{j,event_bot}=[new_X, new_Y];
        
        next_event=possible_transitions2{ik};
        
        event_bot =next_event(1)-96;
        
        [transition_cost,~,new_X,new_Y] = ...
            calcTransitionCosTasks(next_event,j,path_state{kp,j},path_events,states,tasks,EEC,regions,numRegions,start_loc,...
            numTasks,ABSTRACTED,start_events_only,robotLocation{j,event_bot},robotTask,1);
        
        full_cost(kp,event_bot)=full_cost(kp,event_bot)+transition_cost;
        
        currBotLoad = full_cost(kp,event_bot);
        % Adds Idle cost only to event owner bot
        idle_cost = max(0,max(full_cost(kp,:)) - currBotLoad);
        % Bot next load = current load + idle cost
        full_cost(kp,event_bot) = full_cost(kp,event_bot) + idle_cost;

        path_events{kp,i}=next_event;
        
        i=i+1;
        j=j+1;
        
        cur_state = updateCurEvent(next_event,cur_state,events,states,num_fsms);
        
        path_state{kp,j}=cur_state;
        
        for ki = 1:numRobots
            robotLocation{j,ki} = robotLocation{j-1,ki}; %cur_state vs 1
        end
        
        robotLocation{j,event_bot}=[new_X, new_Y];
   
    while ~detectEndState(cur_state,states,num_fsms)

        
        transition_list = createTransitionList(states,cur_state,num_fsms);
        possible_transitions = findPossibleTransitions(transition_list,event_list);
        
        num_transitions = size(possible_transitions);
        
        J_costs=[];
        new_pos=[];
        J_trans=[];
        trans_cost=[];
        aux_start=0;
        aux_entry=0;
        aux_finish=0;
        
        
        J_trans=zeros(num_transitions(1),1);
        J_costs=zeros(num_transitions(1),1);
        new_pos=zeros(num_transitions(1),2);
        trans_cost=zeros(num_transitions(1),numRobots);
        %     trans_cost=full_cost;
        for kk = 1:num_transitions(1) % iterate through the number of transitions
            trans_cost(kk,:)=full_cost(kp,:);
            %       next_state = updateCurEvent(possible_transitions(kk),cur_state,events,states,num_fsms);
            next_event=possible_transitions{kk};
            
            event_bot = possible_transitions{kk}(1)-96;
            [transition_cost,~,new_X,new_Y] = ...
                calcTransitionCosTasks(next_event,j,path_state{kp,j},path_events,states,tasks,EEC,regions,numRegions,start_loc,...
                numTasks,ABSTRACTED,start_events_only,robotLocation{j,event_bot},robotTask,1);
            
            trans_cost(kk,event_bot)=full_cost(kp,event_bot)+transition_cost;
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
        
        costs_index=find(J_costs==costs_min);
        
        
        index_trans=randi([1 length(costs_index)]);
        
        path_events{kp,i}=possible_transitions{costs_index(index_trans)};
        
        i=i+1;
        
        cur_state = updateCurEvent(possible_transitions(costs_index(index_trans)),cur_state,events,states,num_fsms);
        
        path_state{kp,j}=cur_state;
        
        event_bot = possible_transitions{costs_index(index_trans)}(1)-96;
               
        for ki = 1:numRobots
            robotLocation{j,ki} = robotLocation{j-1,ki}; %cur_state vs 1
        end
        
        robotLocation{j,event_bot} = [new_pos(costs_index(index_trans),1) new_pos(costs_index(index_trans),2)]; %cur_state vs 1
        
        full_cost(kp,event_bot)=trans_cost(costs_index(index_trans),event_bot);%%full_cost(event_bot,1)+J_trans(costs_index(index_trans));
        
    end
    cost_final(kp)=max(full_cost(kp,:));
    end
end
end









