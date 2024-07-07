function check_states = breathFirstEntry(cur_states,check_states,states_incr,num_fsm,event_list,events_incr)
list='';
list{end+1}=cur_states;

while ~isempty(list)
if ~checkStateDF(check_states,cur_states,num_fsm)
    check_states{end+1}=cur_states;
    transition_list = createTransitionList(states_incr,cur_states,num_fsm);
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    robot_entry=findEntryRobot(possible_transitions,robot);
    
    if ~isempty(robot_entry)
        if checkPosTransEvent(robot_entry,final_entry)==0
            num_transitions = size(robot_entry);
            for i=1:num_transitions(1)
                detect_event=robot_entry{i,1};
                new_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);
            end
        end
    end
end        