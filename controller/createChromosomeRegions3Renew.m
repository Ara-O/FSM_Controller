function [path,path_events]= createChromosomeRegions3Renew(path_abs,states_incr,num_fsm,initial_state_incr,event_list,events_incr,numRobots,numTasks,taskRegions,initialRegions,numRegions)
i=1;
state_i=1;
event_i=1;
desired_region1=0;
desired_region2=0;
desired_region3=0;
% robot1=path_abs{1}{i}(1);
aux_finish=0;
cur_states=initial_state_incr;
detect_event=path_abs{1}{i}{1};
i=i+1;
finish_event{1}=strcat(path_abs{1}{i-1}{1}(1:end-1),'f');
path{state_i}=cur_states;
state_i=state_i+1;
path_events{event_i}=detect_event;
event_i=event_i+1;
cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%verify the state this transition takes
path{state_i}=cur_states;
state_i=state_i+1;
task=str2num(detect_event(2:end-1));
if strcmp(detect_event(1),'a')
    desired_region1(end+1)=taskRegions(task);
elseif strcmp(detect_event(1),'b')
    desired_region2(end+1)=taskRegions(task);
else
    desired_region3(end+1)=taskRegions(task);
end
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
    task=str2num(finish_event{end}(2:end-1));
    if strcmp(finish_event{end}(1),'a')
        desired_region1(end+1)=taskRegions(task);
    elseif strcmp(finish_event{end}(1),'b')
        desired_region2(end+1)=taskRegions(task);
    else
        desired_region3(end+1)=taskRegions(task);
    end        
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
    if strcmp(final_event(1),'a')
        desired_region=desired_region1(end);
    elseif strcmp(final_event(1),'b')
        desired_region=desired_region2(end);
    else
        desired_region=desired_region3(end);
    end
    [path_state_middle,path_event_middle,initialRegions] = horizonPlanRegionsRenew(cur_states,final_event,states_incr,num_fsm,event_list,events_incr,numRegions,numRobots,initialRegions,numTasks,desired_region);
    indPlan=randi([1 length(path_event_middle)]);
    path_events={path_events{1:end},path_event_middle{indPlan}{1:end}};
    path={path{1:end-1},path_state_middle{indPlan}{1:end}};
    state_i=length(path)+1;
    event_i=length(path_events)+1;
    cur_states=path{end};
    detect_event=path_events{end};
    aux_finish=aux_finish+1;
elseif i-aux_finish-1==2
    final_event1=finish_event{end-1};
    if strcmp(final_event1(1),'a')
        des_region1=desired_region1(end);
        robot1='a';
    elseif strcmp(final_event1(1),'b')
        des_region1=desired_region2(end);
        robot1='b';
    else
        des_region1=desired_region3(end);
        robot1='c';
    end
    final_event2=finish_event{end};
    if strcmp(final_event2(1),'a')
        des_region2=desired_region1(end);
        robot2='a';
    elseif strcmp(final_event2(1),'b')
        des_region2=desired_region2(end);
        robot2='b';
    else
        des_region2=desired_region3(end);
        robot2='c';
    end
    [path_state_middle,path_event_middle,initialRegions] = horizonPlanRegionsParallel3Renew(cur_states,final_event1,final_event2,states_incr,num_fsm,event_list,events_incr,numRegions,numRobots,initialRegions,numTasks,des_region1,des_region2,robot1,robot2);
    indPlan=randi([1 length(path_event_middle)]);
    path_events={path_events{1:end},path_event_middle{indPlan}{1:end}};
    path={path{1:end-1},path_state_middle{indPlan}{1:end}};
    state_i=length(path)+1;
    event_i=length(path_events)+1;
    cur_states=path{end};
    detect_event=path_events{end};
    aux_finish=aux_finish+2;
else
    final_event1=finish_event{end-2};
    if strcmp(final_event1(1),'a')
        des_region1=desired_region1(end);
        robot1='a';
    elseif strcmp(final_event1(1),'b')
        des_region1=desired_region2(end);
        robot1='b';
    else
        des_region1=desired_region3(end);
        robot1='c';
    end
    final_event2=finish_event{end-1};
    if strcmp(final_event2(1),'a')
        des_region2=desired_region1(end);
        robot2='a';
    elseif strcmp(final_event2(1),'b')
        des_region2=desired_region2(end);
        robot2='b';
    else
        des_region2=desired_region3(end);
        robot2='c';
    end
    final_event3=finish_event{end};
    if strcmp(final_event3(1),'a')
        des_region3=desired_region1(end);
        robot3='a';
    elseif strcmp(final_event3(1),'b')
        des_region3=desired_region2(end);
        robot3='b';
    else
        des_region3=desired_region3(end);
        robot3='c';
    end
    [path_state_middle,path_event_middle,initialRegions] = horizonPlanRegionsParallel3RobotsRenew(cur_states,final_event1,final_event2,final_event3,states_incr,num_fsm,event_list,events_incr,numRegions,numRobots,initialRegions,numTasks,des_region1,des_region2,des_region3,robot1,robot2,robot3);
    indPlan=randi([1 length(path_event_middle)]);
    path_events={path_events{1:end},path_event_middle{indPlan}{1:end}};
    path={path{1:end-1},path_state_middle{indPlan}{1:end}};
    state_i=length(path)+1;
    event_i=length(path_events)+1;
    cur_states=path{end};
    detect_event=path_events{end};
    aux_finish=aux_finish+3;
end

    
end
