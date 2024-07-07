function [costs,path_state,path_events] = ...
  robotDijkstraGreedyNew1(cur_state,numRobots,states,events,tasks,regions,numRegions,start_loc,numTasks,ABSTRACTED,start_events_only,robot_tasks)
% Updated by: Daniel Burke
% Version: 1.2
% Date: May 3, 2016
% Changelog:
%  1.0: Takes the incremental cur_state, states, and events list, and 
%  eliminates unnecessary input like EEC and init_cost. Builds the full
%  fsm �on-the-fly� in the variable trans_mat to eliminate the need to 
%  store a full fsm for the main controller. 

% Current Capability:
%  This function uses a Dijkstra's Algorithm to determine an optimal path
%  through an FSM. It has been modified to take incremental FSMs as input.
% Acknowledgements:
%  This function was based on the following MATLAB File Exchange function:
%  https://www.mathworks.com/matlabcentral/fileexchange/20025-dijkstra-s-minimum-cost-path-algorithm
%  It was then modified by Kaylah Berndt to calculate costs, idle, and
%  tiebreakers for multiple robots. 
%  After this, it was tailored to the robot scenarios and simplified for speed.
num_eval=0;
a=3
event_path='';
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


% Initializations
iTable = NaN(n,1);  % cost table
minCost = Inf(n,1);
isSettled = false(n,1);
path = num2cell(NaN(n,1));
botTable = NaN(n,numRobots);  % Individual robot costs matrix
I = 1;
minCost(I) = 0;
iTable(I) = 0;
botTable(I,:) = 0;
isSettled(I) = true;
path(I) = {I};
robotLocation = num2cell(NaN(n,numRobots));
%robotTask = NaN(n,numRobots);
% Sets up the robots initial locations
for i = 1:numRobots
    robotLocation{1,i} = [start_loc(i,1) start_loc(i,2)]; %cur_state vs 1
end
for i=1:numRobots    
    robotRegions(i)= str2double(whichRegion(start_loc(i,1),start_loc(i,2),numRegions,regions));
end
for i=1:numTasks
    bot_task=i;
    [taskX,taskY,~] = getTaskLocation(bot_task,tasks);
    tasksRegions(i)=str2double(whichRegion(taskX,taskY,numRegions,regions));
end

region=zeros(numRobots,numRegions-numTasks);
tasks_finish=zeros(1,numTasks);
event_list = createEventFsmList(events,num_fsms);

desiredRegion=zeros(numRobots,1);
path_state{1}=cur_state;

j=1;
i=1;
costs=0;
path_events='';
full_cost=zeros(numRobots,1);

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
    %     [possible_transitions] = forceStartEvents(path{I},possible_transitions,trans_mat);
    start_transitions=findStartEvents(possible_transitions);
    
    if ~isempty(start_transitions)
        aux_start=1;
        num_transitions = size(start_transitions);

        J_trans=zeros(num_transitions(1),1);
        J_costs=zeros(num_transitions(1),1);
        new_pos=zeros(num_transitions(1),2);
        trans_cost=zeros(num_transitions(1),numRobots);
        %     trans_cost=full_cost;
        for kk = 1:num_transitions(1) % iterate through the number of transitions
            trans_cost(kk,:)=full_cost(:,1);
            %       next_state = updateCurEvent(possible_transitions(kk),cur_state,events,states,num_fsms);
            next_event=start_transitions{kk};
            
            event_bot = start_transitions{kk}(1)-96;
            
            [transition_cost,~,new_X,new_Y] = ...
                calcTransitionCostGAANew(next_event,cur_state,path_events,j,path_state,states,tasks,0,regions,numRegions,start_loc,...
                numTasks,0,1,robotLocation{j,event_bot},robot_tasks,1,tasks_finish,robotRegions,desiredRegion,numRobots);
            
            trans_cost(kk,event_bot)=full_cost(event_bot,1)+transition_cost;
            currBotLoad = trans_cost(kk,event_bot);
            % Adds Idle cost only to event owner bot
            idle_cost = max(0,max(trans_cost(kk,:)) - currBotLoad);
            % Bot next load = current load + idle cost
            trans_cost(kk,event_bot) = trans_cost(kk,event_bot) + idle_cost;
            
            J_trans(kk)=transition_cost;
            J_costs(kk) =transition_cost;%trans_cost(kk,event_bot); %J_costs(event_bot) + transition_cost;
            new_pos(kk,1)=new_X;
            new_pos(kk,2)=new_Y;
        end
        
    else
%         finish_transitions=findFinishEvents(possible_transitions);
        
%         if ~isempty(finish_transitions)
%             aux_finish=1;
%             num_transitions = size(finish_transitions);
%             J_trans=zeros(num_transitions(1),1);
%             J_costs=zeros(num_transitions(1),1);
%             new_pos=zeros(num_transitions(1),2);
%             trans_cost=zeros(num_transitions(1),numRobots);
%             %     trans_cost=full_cost;
%             for kk = 1:num_transitions(1) % iterate through the number of transitions
%                 trans_cost(kk,:)=full_cost(:,1);
%                 %       next_state = updateCurEvent(possible_transitions(kk),cur_state,events,states,num_fsms);
%                 next_event=finish_transitions{kk};
%                 
%                 event_bot = finish_transitions{kk}(1)-96;
%                 
%                 [transition_cost,~,new_X,new_Y] = ...
%                     calcTransitionCostGAANew(next_event,cur_state,path_events,j,path_state,states,tasks,0,regions,numRegions,start_loc,...
%                     numTasks,ABSTRACTED,start_events_only,robotLocation{j,event_bot},robot_tasks,1);
%                 
%                 trans_cost(kk,event_bot)=full_cost(event_bot,1)+transition_cost;
%                 currBotLoad = trans_cost(kk,event_bot);
%                 % Adds Idle cost only to event owner bot
%                 idle_cost = max(0,max(trans_cost(kk,:)) - currBotLoad);
%                 % Bot next load = current load + idle cost
%                 trans_cost(kk,event_bot) = trans_cost(kk,event_bot) + idle_cost;
%                 
%                 J_trans(kk)=transition_cost;
%                 J_costs(kk) =transition_cost;%trans_cost(kk,event_bot); %J_costs(event_bot) + transition_cost;
%                 new_pos(kk,1)=new_X;
%                 new_pos(kk,2)=new_Y;
%             end
%         else
            aux_entry=1;
            num_transitions = size(possible_transitions);
            J_trans=zeros(num_transitions(1),1);
            J_costs=zeros(num_transitions(1),1);
            new_pos=zeros(num_transitions(1),2);
            trans_cost=zeros(num_transitions(1),numRobots);
            %     trans_cost=full_cost;
            for kk = 1:num_transitions(1) % iterate through the number of transitions
                trans_cost(kk,:)=full_cost(:,1);
                %       next_state = updateCurEvent(possible_transitions(kk),cur_state,events,states,num_fsms);
                next_event=possible_transitions{kk};
                
                event_bot = possible_transitions{kk}(1)-96;
                
                [transition_cost,~,new_X,new_Y] = ...
                    calcTransitionCostGAANew(next_event,cur_state,path_events,j,path_state,states,tasks,0,regions,numRegions,start_loc,...
                    numTasks,ABSTRACTED,start_events_only,robotLocation{j,event_bot},robot_tasks,1,tasks_finish,robotRegions,desiredRegion,numRobots);
                
                trans_cost(kk,event_bot)=full_cost(event_bot,1)+transition_cost;
                currBotLoad = trans_cost(kk,event_bot);
                % Adds Idle cost only to event owner bot
                idle_cost = max(0,max(trans_cost(kk,:)) - currBotLoad);
                % Bot next load = current load + idle cost
                trans_cost(kk,event_bot) = trans_cost(kk,event_bot) + idle_cost;
                
                J_trans(kk)=transition_cost;
                J_costs(kk) =transition_cost;%trans_cost(kk,event_bot); %J_costs(event_bot) + transition_cost;
                new_pos(kk,1)=new_X;
                new_pos(kk,2)=new_Y;
            end
%         end
            
    end

    if aux_start
        
        j=j+1;
        
        costs_min=min(J_costs);
               
%         costs=costs+costs_min;
        
        costs_index=find(J_costs==costs_min);
        
        index_trans=randi([1 length(costs_index)]);
        
        path_events{i}=start_transitions{costs_index(index_trans)};
        
        i=i+1;
        
        cur_state = updateCurEvent(start_transitions(costs_index(index_trans)),cur_state,events,states,num_fsms);
        
        path_state{j}=cur_state;
        
        event_bot = start_transitions{costs_index(index_trans)}(1)-96;
        
        desiredRegion(event_bot,1)=tasksRegions(str2double(start_transitions{costs_index(index_trans)}(2:end-1)));
        
        for k = 1:numRobots
            robotLocation{j,k} = robotLocation{j-1,k}; %cur_state vs 1
        end
        
        %     robotLocation{j,:} = robotLocation{j-1,:}; %cur_state vs 1
        
        robotLocation{j,event_bot} = [new_pos(costs_index(index_trans),1) new_pos(costs_index(index_trans),2)]; %cur_state vs 1
        
        full_cost(event_bot,1)=trans_cost(costs_index(index_trans),event_bot);%%full_cost(event_bot,1)+J_trans(costs_index(index_trans));
        
    elseif aux_finish
        
         j=j+1;
        
        costs_min=min(J_costs);
               
        costs=costs+costs_min;
        
        costs_index=find(J_costs==costs_min);
        
        index_trans=randi([1 length(costs_index)]);
        
        path_events{i}=finish_transitions{costs_index(index_trans)};
        i=i+1;
        
        cur_state = updateCurEvent(finish_transitions(costs_index(index_trans)),cur_state,events,states,num_fsms);
        
        path_state{j}=cur_state;
        
        event_bot = finish_transitions{costs_index(index_trans)}(1)-96;
        
        actualRegion=desiredRegion(event_bot,1)-numTasks;

        robotRegions(1,event_bot)=desiredRegion(event_bot);
        region(event_bot,actualRegion)=region(event_bot,actualRegion)+1;
        
        for k = 1:numRobots
            robotLocation{j,k} = robotLocation{j-1,k}; %cur_state vs 1
        end
        num_task=str2double(finish_transitions{costs_index(index_trans)}(2:end-1));
        tasks_finish(1,num_task)=1;
        %     robotLocation{j,:} = robotLocation{j-1,:}; %cur_state vs 1
        
        robotLocation{j,event_bot} = [new_pos(costs_index(index_trans),1) new_pos(costs_index(index_trans),2)]; %cur_state vs 1
        
        full_cost(event_bot,1)=trans_cost(costs_index(index_trans),event_bot);%%full_cost(event_bot,1)+J_trans(costs_index(index_trans));
        
        
    else
        %if there aren't start events or finish events, it goes and choose
        %one of the entry events avoiding that a robot enters a region more
        %than one time if it doesn't need to
                
        [costs_sort,index_sort]=sort(J_costs);
        
        aux_region=1;
        index_aux=0;
        while aux_region && index_aux <length(index_sort)
            
            index_aux=index_aux+1;
            
            if strcmp(possible_transitions{index_sort(index_aux)}(end),'f')
                num_task=str2double(possible_transitions{index_sort(index_aux)}(2:end-1));
                tasks_finish(1,num_task)=1;
                aux_region=0;
                break;
            else
                
                event_bot = possible_transitions{index_sort(index_aux)}(1)-96;
                actualRegion=str2double(possible_transitions{index_sort(index_aux)}(2:end-1))-numTasks;
                
                if region(event_bot,actualRegion)<3
                    aux_region=0;
                    robotRegions(event_bot)=str2double(possible_transitions{index_sort(index_aux)}(2:end-1));
                    region(event_bot,actualRegion)=region(event_bot,actualRegion)+1;
                    break;
                else
                    for ik=1:numRobots
                        if event_bot ~=ik
                            if robotRegions(event_bot)==desiredRegion(ik,1)
                                aux_region=0;
                                robotRegions(event_bot)=str2double(possible_transitions{index_sort(index_aux)}(2:end-1));
                                region(event_bot,actualRegion)=region(event_bot,actualRegion)+1;
                                break;
                            end
                        end
                    end
                end
            end
            


        end
        
        %if all possible entry events were already done, it chooses the min
        %cost one
        
        
        
        if aux_region
            index_aux=1;
            event_bot = possible_transitions{index_sort(index_aux)}(1)-96;
            actualRegion=str2double(possible_transitions{index_sort(index_aux)}(2:end-1))-numTasks;  
            robotRegions(event_bot)=str2double(possible_transitions{index_sort(index_aux)}(2:end-1));
            region(event_bot,actualRegion)=region(event_bot,actualRegion)+1;
        else
            event_bot = possible_transitions{index_sort(index_aux)}(1)-96;
        end
        
        
        costs=costs+costs_sort(index_aux);
        
        path_events{i}=possible_transitions{index_sort(index_aux)};
        
        i=i+1;
        
        cur_state = updateCurEvent(possible_transitions(index_sort(index_aux)),cur_state,events,states,num_fsms);
        
        j=j+1;
        
        path_state{j}=cur_state;
        
        
        for k = 1:numRobots
            robotLocation{j,k} = robotLocation{j-1,k}; %cur_state vs 1
        end
        
        robotLocation{j,event_bot} = [new_pos(index_sort(index_aux),1) new_pos(index_sort(index_aux),2)]; %cur_state vs 1
        
        full_cost(event_bot,1)=trans_cost(index_sort(index_aux),event_bot);%%full_cost(event_bot,1)+J_trans(costs_index(index_trans));
        
        ju=1
        
    end
    
end
ju=5

end

  
  

  
  
  

        
    