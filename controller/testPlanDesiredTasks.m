function [finalPlan, PlanCost] = testPlanDesiredTasks(desired_tasks,cur_state,states,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robotTask,events)

EEC = 0;
ABSTRACTED=true;
indj=1;
indi=0;
iid=0;

finalPlan=cell(numTasks,1);
path_state=cell(numTasks+1,1);
path_state{1}=cur_state;
full_cost=zeros(numRobots,1);
robotLocation=cell(numRobots,1);
aux_robots=zeros(numRobots,1);

for i_r = 1:numRobots
    robotLocation{1,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
    %cost_robot(i_r)=0;
end

i=1;

while ~detectEndState(cur_state,states,num_fsms)

    transition_list = createTransitionList(states,cur_state,num_fsms);
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    possible_transitions=findDesiredEvents(possible_transitions,desired_tasks);
    
   
    num_transitions = size(possible_transitions);
    
    
    J_costs=[];
    new_pos=[];
    J_trans=[];
    trans_cost=[];
    idle=[];
    aux_start=0;
    aux_entry=0;
    aux_finish=0;
    
    
    J_trans=zeros(num_transitions(1),1);
    idle=zeros(num_transitions(1),1);
    J_costs=zeros(num_transitions(1),1);
    new_pos=zeros(num_transitions(1),2);
    trans_cost=zeros(num_transitions(1),numRobots);
    
    %     trans_cost=full_cost;
    for kk = 1:num_transitions(1) % iterate through the number of transitions
        trans_cost(kk,:)=full_cost(:);
        %       next_state = updateCurEvent(possible_transitions(kk),cur_state,events,states,num_fsms);
        next_event=possible_transitions{kk};
        
        event_bot = possible_transitions{kk}(1)-96;
        
        [transition_cost,~,new_X,new_Y] = ...
            calcTransitionCosTasks(next_event,indj,path_state{indj},finalPlan,states,tasks,EEC,regions,numRegions,start_loc,...
            numTasks,ABSTRACTED,start_events_only,robotLocation{indj,event_bot},robotTask,1);
        
        trans_cost(kk,event_bot)=full_cost(event_bot)+transition_cost;
        currBotLoad = trans_cost(kk,event_bot);
        % Adds Idle cost only to event owner bot
        idle_cost = max(0,max(trans_cost(kk,:)) - currBotLoad);
        % Bot next load = current load + idle cost
        idle(kk)=idle_cost;
        trans_cost(kk,event_bot) = trans_cost(kk,event_bot) + idle_cost;
        
        J_trans(kk)=trans_cost(kk,event_bot);
        J_costs(kk) =max(trans_cost(kk,:)); %J_costs(event_bot) + transition_cost;
        new_pos(kk,1)=new_X;
        
        new_pos(kk,2)=new_Y;
        
    end
    
    costs_min=min(J_costs);
    
    costs_index=find(J_costs==costs_min);
    
    if isempty(costs_index)
        ju=0000
    end
    index_trans=randi([1 length(costs_index)]);
    
%     finalPlan{indi}=possible_transitions{costs_index(index_trans)};
    
    indi=indi+1;
    indj=indj+1;
    iid=iid+1;
    idlefinal(iid)=idle(index_trans);
    
    cur_state = updateCurEvent(possible_transitions(costs_index(index_trans)),cur_state,events,states,num_fsms);
    
    next_event=possible_transitions{costs_index(index_trans)};
    
    path_state{indj}=cur_state;
    finalPlan{indi}=next_event;
    
    event_bot = next_event(1)-96;
    
    for ki = 1:numRobots
        robotLocation{indj,ki} = robotLocation{indj-1,ki}; %cur_state vs 1
    end
    
    robotLocation{indj,event_bot} = [new_pos(costs_index(index_trans),1) new_pos(costs_index(index_trans),2)]; %cur_state vs 1
    
    full_cost(event_bot)=J_trans(costs_index(index_trans));%trans_cost(costs_index(index_trans),event_bot);%%full_cost(event_bot,1)+J_trans(costs_index(index_trans));
    
end


PlanCost=max(full_cost);



end