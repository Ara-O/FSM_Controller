function [path_state,path_event] = breathFirst2EventsParallel(root,final_entry1,final_entry2,states_incr,num_fsm,event_list,events_incr)
list=[];%states to be searched
pop_list=[];%order states were searched
list(1)=1;
ind_level=0;
level(1)=ind_level;
check_states='';%states that were searched
pos_states{1}=root;%states that were visited at the process, not necessarily searched yet
distance=0;
list_state(1)=0; %save the parent of the state, root has parent 0
list_event{1}='root'; %
list_finish(1,1)=0;
list_finish(2,1)=0;
aux_event=0;
aux_event1=0; %auxiliary to check if the desired event is available to happen
aux_event2=0;
while ~isempty(list) 
    aux_event1=0; %auxiliary to check if the desired event is available to happen
    aux_event2=0;
    cur_states=pos_states{list(1)};%take the first element from the list
    check_states{end+1}=cur_states;%save it at the list of searched ones
    pop_list(end+1)=list(1);%save it at the list of searched by its index
    ind_p=length(pop_list);
    aux_ii=pop_list(ind_p);
    aux_i=0;
    while list_state(aux_ii)~=0
        aux_i=aux_i+1;
        aux_ii=list_state(aux_ii);
    end
    ind_level=aux_i+1;
    distance=distance+1;
    list(1)=[];%delete the first position of the list
    transition_list = createTransitionList(states_incr,cur_states,num_fsm);%check the possible transitions at this state
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    robot_entry=findEntryEventsMod(possible_transitions);%findEventsRobot(possible_transitions,robot);%select olny the transitions available for the desired robot
    if ~isempty(robot_entry)%if there are possible transition
        aux1=checkPosTransEvent(robot_entry,final_entry1);%check if the desired event is possible to happen
        aux2=checkPosTransEvent(robot_entry,final_entry2);
        if aux1==0 && aux2==0%if not
            num_transitions = size(robot_entry);%check the number of possible transitions
            for i=1:num_transitions(1)
                detect_event=robot_entry{i,1}; %check the event
                new_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state that event takes
                if ~checkStateDF(check_states,new_states,num_fsm) %check if the state was already searched
                    ind=length(pos_states);%check the last index
                    pos_states{end+1}=new_states;%save the state at the list of visited states (it is not a list of searched states) it is just to keep a relation between index and state
                    level(end+1)=ind_level;
                    list_state(end+1)=pop_list(end);%save the parent of this state
                    list_event{end+1}=detect_event;%save the event that took to this state
                    list(end+1)=ind+1;%add to the list of states to be searched the state
                    list_finish(1,end+1)=0;
                    list_finish(2,end)=0;
                end
            end
        else % if the desired event is available to happen at the searched state
            %aux_event=1;% mark auxiliary as 1
            if aux1~=0
                aux_event1=1;
                num_transitions = size(robot_entry);%check the number of possible transitions1
                for i=1:num_transitions(1)
                    detect_event=robot_entry{i,1}; %check the event
                    new_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state that event takes
                    if ~checkStateDF(check_states,new_states,num_fsm) %check if the state was already searched
                        ind=length(pos_states);%check the last index
                        pos_states{end+1}=new_states;%save the state at the list of visited states (it is not a list of searched states) it is just to keep a relation between index and state
                        level(end+1)=ind_level;
                        list_state(end+1)=pop_list(end);%save the parent of this state
                        list_event{end+1}=detect_event;%save the event that took to this state
                        list(end+1)=ind+1;%add to the list of states to be searched the state

                        if i==aux1
                            list_finish(1,end+1)=1;
                        else
                            list_finish(1,end+1)=0;
                        end
                        list_finish(2,end)=0;
                    end
                end
            else
                aux_event2=1;
                num_transitions = size(robot_entry);%check the number of possible transitions
                for i=1:num_transitions(1)
                    detect_event=robot_entry{i,1}; %check the event
                    new_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state that event takes
                    if ~checkStateDF(check_states,new_states,num_fsm) %check if the state was already searched
                        ind=length(pos_states);%check the last index
                        pos_states{end+1}=new_states;%save the state at the list of visited states (it is not a list of searched states) it is just to keep a relation between index and state
                        level(end+1)=ind_level;
                        list_state(end+1)=pop_list(end);%save the parent of this state
                        list_event{end+1}=detect_event;%save the event that took to this state
                        list(end+1)=ind+1;%add to the list of states to be searched the state
                        list_finish(1,end+1)=0;
                        
                        if i==aux2
                            list_finish(2,end)=1;
                        else
                            list_finish(2,end)=0;
                        end
                    end
                end

            end
        end
        if aux_event1==1
            ind_fim=length(list_finish);
            while ind_fim>1
                if list_finish(2,list_state(ind_fim))==1
                    aux_event=1;
                    break;
                else
                    ind_fim=list_state(ind_fim);
                end
            end
        elseif aux_event2==1
            ind_fim=length(list_finish);
            while ind_fim>1
                if list_finish(1,list_state(ind_fim))==1
                    aux_event=1;
                    break;
                else
                    ind_fim=list_state(ind_fim);
                end
            end
        end
    else
        ju=1;
    end
    if aux_event==1
        if aux_event1==1
            done_event=final_entry1;
            detect_event=robot_entry{aux1,1};%take the detected event as the desired event
            list_finish(1,end+1)=1;
            list_finish(2,end)=0;
        else
            done_event=final_entry2;
            detect_event=robot_entry{aux2,1};%take the detected event as the desired event
            list_finish(1,end+1)=0;
            list_finish(2,end)=1;
        end

        new_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state the event takes to
        pos_states{end+1}=new_states;% add the state to the list of visited states
        list_state(end+1)=pop_list(end);%save the parent of the state
        list_event{end+1}=detect_event;%save the event that took to this state
        
        %check_states{end+1}=new_states;
        break;
    end
end
ind=length(list_state);%the last event added is the state reached by the desired event
i=1;
while list_state(ind) ~=0 %verify if it is not the root
    path(1,i)=ind;%save the state
    ind=list_state(ind);%check the parent of the state
    i=i+1;
end
%path(i) has all states from the last reached one til the first reached by
%the root, but it doesn't have the root
j=1;
path_state{1}{1}=root;%save the root
for i=length(path(1,:)):-1:1
    path_state{1}{end+1}=pos_states{path(1,i)};%save the visited states
    path_event{1}{j}=list_event{path(1,i)};%save the events that lead to the visited states
    j=j+1;
end
%path_event should have one element less than path_state

%Now, I need to check if there is any other path with the same number of
%events. For that I need to check the parent of the last state. At path,
%first element is the last state to be visited, so its parent is the second
%element
list_to_check=[];
if length(path)>=2
    index=path(2); %parent of the last state visited by the path
    state_level=level(index);%check its level. It can be '0', it means we are at the root. Or any other value
    %if it is zero, I look for states that has the root as parent, if it is
    %something other than zero, I look for the states that are at the same
    %level
    list_to_check=[];
    if state_level ~= 0
        for i=1:length(list)
            if level(list(i))==state_level %check at the list of states to be searched, the ones that have same parent as the parent of last state
                list_to_check(i)=list(i);
            else
                break;
            end
        end
    end
end
%needs to finish this part here where it looks for other paths with the
%same number of events
ind_path=1;
if ~isempty(list_to_check)
    for j=1:length(list_to_check)
        aux_event=0;
        aux_event1=0;
        aux_event2=0;
        cur_states=pos_states{list_to_check(j)};
        transition_list = createTransitionList(states_incr,cur_states,num_fsm);%check the possible transitions at this state
        possible_transitions = findPossibleTransitions(transition_list,event_list);
        num_transitions = size(possible_transitions);%check the number of possible transitions
        robot_entry=possible_transitions;%findEventsRobot(possible_transitions,robot);%select olny the transitions available for the desired robot
        if ~isempty(robot_entry)%if there are possible transition
            aux1=checkPosTransEvent(robot_entry,final_entry1);%check if the desired event is possible to happen
            aux2=checkPosTransEvent(robot_entry,final_entry2);
            
            if aux1~=0
                aux_event1=1;
                detect_event=robot_entry{aux1,1}; %check the event
                new_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state that event takes
                pos_states{end+1}=new_states;%save the state at the list of visited states (it is not a list of searched states) it is just to keep a relation between index and state
                list_state(end+1)=list_to_check(j);%save the parent of this state
                list_event{end+1}=detect_event;%save the event that took to this state
                list_finish(1,end+1)=1;
                list_finish(2,end)=0;
                
            else
                if aux2~=0
                    aux_event2=1;
                    detect_event=robot_entry{aux2,1}; %check the event
                    new_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state that event takes
                    pos_states{end+1}=new_states;%save the state at the list of visited states (it is not a list of searched states) it is just to keep a relation between index and state
                    list_state(end+1)=list_to_check(j);%save the parent of this state
                    list_event{end+1}=detect_event;%save the event that took to this state
                    list_finish(1,end+1)=0;
                    list_finish(2,end)=1;
                else
                    
                end
            end
        end
        if aux_event1==1
            ind_fim=length(list_state);
            while ind_fim>1
                if list_finish(2,list_state(ind_fim))==1
                    aux_event=1;
                    break;
                else
                    ind_fim=list_state(ind_fim);
                end
            end
        elseif aux_event2==1
            ind_fim=length(list_state);
            while ind_fim>1
                if list_finish(1,list_state(ind_fim))==1
                    aux_event=1;
                    break;
                else
                    ind_fim=list_state(ind_fim);
                end
            end
        end
        if aux_event==1
            ind_path=ind_path+1;
            ind=length(list_state);%the last event added is the state reached by the desired event
            k=1;
            while list_state(ind) ~=0 %verify if it is not the root
                path(ind_path,k)=ind;%save the state
                ind=list_state(ind);%check the parent of the state
                k=k+1;
            end
            k=1;
            path_state{ind_path}{1}=root;%save the root
            for w=length(path(ind_path,:)):-1:1
                path_state{ind_path}{end+1}=pos_states{path(ind_path,w)};%save the visited states
                path_event{ind_path}{k}=list_event{path(ind_path,w)};%save the events that lead to the visited states
                k=k+1;
            end
        end
    end
end
end