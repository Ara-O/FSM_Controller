function aux = checkPlan(path_abs,states_incr,num_fsm,initial_state_incr,event_list,events_incr)
    ind_abs=1;
    cur_states=initial_state_incr; %for every path it starts at the initial state
    i=1;
    path_gen='';
    path_events='';
    path_gen{i}=cur_states; %save the first state
    aux=1;
    aux_init_a=0;
    aux_init_b=0;
    while ~detectEndState(cur_states,states_incr,num_fsm) %check if it didn't reach the final state
        transition_list = createTransitionList(states_incr,cur_states,num_fsm); %for the current state creates the transition list
        possible_transitions = findPossibleTransitions(transition_list,event_list);% from the transition list selects the possible events
        if aux
            [aux_event]=checkEventPathMod(possible_transitions,path_abs,ind_abs);
        else
            aux_event=0;
        end
        if aux_event == 0
            aux=0;
            break;
            %pos_trans=findEntryEventsMod(possible_transitions);
            pos_trans=possible_transitions;
            num_transitions = size(pos_trans); %verify the number of possible transitions
            idx_pot=randi([1 num_transitions(1)]);% select randomly one of the possible events
            detect_event=pos_trans{idx_pot,1}; %save the selected the transition/event 
        else
            idx_pot=aux_event;
            detect_event=possible_transitions{idx_pot,1}; %save the selected the transition/event 
            ind_abs=ind_abs+1;
        end
              
        path_events{i}=detect_event;
        cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%verify the state this transition takes
 
        index=findSameState(path_gen,cur_states,num_fsm);
        if isempty(index)
            i=i+1;
            path_gen{i}=cur_states;%saves this state, which will be verified to see if it is the marked state at the next run
        else
            old_path_single='';
            old_path_single=path_gen;
            path_gen='';
            old_event_single='';
            old_event_single=path_events;
            path_events='';
            path_gen={old_path_single{1,1:index}};
            cur_states=old_path_single{1,index};
            path_events={old_event_single{1:index-1}};
            i=index;
        end
        if strcmp(detect_event(end),'e')
            if strcmp(detect_event(1),'a')
                aux_init_a=1;
            else
                aux_init_b=1;
            end
        end
        if aux_init_a && aux_init_b
            aux=1;
            break;
        end
    end
end