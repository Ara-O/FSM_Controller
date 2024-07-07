function [path,path_events]= createChromosomeRed(path_abs,states_incr,num_fsm,initial_state_incr,event_list,events_incr,numRobots)
i=1;
state_i=1;
event_i=1;
robot1=path_abs{1}{i}(1);
aux_finish=0;
cur_states=initial_state_incr;
detect_event=path_abs{1}{i}{1};
i=i+1;
finish_event{1}=strcat(path_abs{1}{i-1}{1}(1:end-1),'f');
path{state_i}=cur_states;
state_i=state_i+1;
path_events{event_i}{1}=detect_event;
event_i=event_i+1;
cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%verify the state this transition takes
path{state_i}=cur_states;
state_i=state_i+1;
while aux_finish< length(path_abs{1})
transition_list = createTransitionList(states_incr,cur_states,num_fsm); %for the current state creates the transition list
possible_transitions = findPossibleTransitions(transition_list,event_list);%
[aux_event]=checkEventPath(possible_transitions,path_abs,i);
while aux_event~=0
    idx_pot=aux_event;
    detect_event=possible_transitions{idx_pot,1}; %save the selected the transition/event
    i=i+1;
    %j=j+1;
    finish_event{end+1}=strcat(path_abs{1}{i-1}{1}(1:end-1),'f');
    path_events{event_i}=detect_event;
    event_i=event_i+1;
    cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%
    path{state_i}=cur_states;
    state_i=state_i+1;
    transition_list = createTransitionList(states_incr,cur_states,num_fsm); %for the current state creates the transition list
    possible_transitions = findPossibleTransitions(transition_list,event_list);%
    [aux_event]=checkEventPath(possible_transitions,path_abs,i);

end

if i-aux_finish-1==1
    final_event=finish_event{end};%strcat(path_abs{i-1}(1:end-1),'f');
    [path_state_middle,path_event_middle] = breathFirstEvent(cur_states,final_event,states_incr,num_fsm,event_list,events_incr);
    
    indPlan=randi([1 length(path_event_middle)]);
    
    path_events={path_events{1:end},path_event_middle{indPlan}{1:end}};
    path={path{1:end-1},path_state_middle{indPlan}{1:end}};
    state_i=length(path)+1;
    event_i=length(path_events)+1;
    cur_states=path{end};
    detect_event=final_event;
    aux_finish=aux_finish+1;
else
    final_event1=finish_event{end-1};
    final_event2=finish_event{end};   
    [path_state_middle,path_event_middle] = breathFirst2EventsParallelTrunck(cur_states,final_event1,final_event2,states_incr,num_fsm,event_list,events_incr);
    indPlan=randi([1 length(path_event_middle)]);
    path_events={path_events{1:end},path_event_middle{indPlan}{1:end}};
    path={path{1:end-1},path_state_middle{indPlan}{1:end}};
    state_i=length(path)+1;
    event_i=length(path_events)+1;
    cur_states=path{end};
    detect_event=path_events{end};
    aux_finish=aux_finish+2;
end
end