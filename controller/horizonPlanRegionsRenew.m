function [path_state,path_event,final_region] = horizonPlanRegionsRenew(cur_states,final_entry1,states_incr,num_fsm,event_list,events_incr,numRegions,numRobots,initialRegion,numTasks,desired_region1)
region=zeros(numRobots,numRegions);
final_region=zeros(numRobots);
for i=1:length(initialRegion)
    final_region(i)=initialRegion(i);
    %     index=initialRegion(i)-numTasks;
    %     region(i,index)=1;
end
index=1;
aux_final1=0;
path_state{1}{1}=cur_states;
index_st=2;
index_ev=1;
aux_rob=0;
robot1=final_entry1(1);
aux1=0;
if strcmp(robot1,'a')
    actualRegion=initialRegion(1);
elseif strcmp(robot1,'b')
    actualRegion=initialRegion(2);
else
    actualRegion=initialRegion(3);
end

while aux_final1==0
    aux_pos_entry=1;
    aux_rob=0;
    if strcmp(robot1,'a')
        robot=2; %need to check the other robot
        if final_region(robot)==desired_region1
            aux_rob=2;
        elseif numRobots > 2
            robot=3; %need to check the other robot
            if final_region(robot)==desired_region1
                aux_rob=3;
            end
        end
    elseif strcmp(robot1,'b')
        robot=1; %need to check the other robot
        if final_region(robot)==desired_region1
            aux_rob=1;
        elseif numRobots > 2
            robot=3; %need to check the other robot
            if final_region(robot)==desired_region1
                aux_rob=3;
            end
        end
    else
        robot=2; %need to check the other robot
        if final_region(robot)==desired_region1
            aux_rob=2;
        else
            robot=1; %need to check the other robot
            if final_region(robot)==desired_region1
                aux_rob=1;
            end
        end
    end
    transition_list = createTransitionList(states_incr,cur_states,num_fsm);%check the possible transitions at this state
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    robot_entry=findEntryEvents(possible_transitions);
    num_transitions = size(robot_entry);%check the number of possible transitions
    if num_transitions(1)==0
        ju=34
    end
    if aux_final1==0 && aux_rob==0
        aux1=checkPosTransEvent(robot_entry,final_entry1);%check if the desired event is possible to happen
    end
    if aux1~=0
        detect_event=robot_entry{aux1,1};
        path_event{1}{index_ev}=detect_event;
        index_ev=index_ev+1;
        cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state that event takes
        path_state{1}{index_st}=cur_states;
        index_st=index_st+1;
        aux_final1=1;
        aux1=0;
    else
        if aux_rob~=0
            if aux_rob==1
                aux_rob1='a';
            elseif aux_rob==2
                aux_rob1='b';
            else
                aux_rob1='c';
            end
            
            pos_transitions_robot=findEventsRobot(robot_entry,aux_rob1);
            if isempty(pos_transitions_robot)
                aux_pos_entry=1;
            else
                aux_pos_entry=0;
                num_transitions_aux = size(pos_transitions_robot);%check the number of possible transitions
                pos_aux=randperm(num_transitions_aux(2));
                ind_rot=1;
                aux_entry_aux=0;
                while aux_entry_aux==0 && ind_rot<=num_transitions_aux(2)
                    detect_event=pos_transitions_robot{1,pos_aux(ind_rot)};
                    actualRegion=str2double(detect_event(2:end-1))-numTasks;
                    if strcmp(detect_event(1),'a')
                        robot=1;
                    elseif  strcmp(detect_event(1),'b')
                        robot=2;
                    else
                        robot=3;
                    end
                    if region(robot,actualRegion)<1
                        aux_entry_aux=1;
                        region(robot,actualRegion)=region(robot,actualRegion)+1;
                        aux_rob=0;
                        break;
                    end
                    ind_rot=ind_rot+1;
                end
                if aux_entry_aux==0
                    ind_rot=randi([1 num_transitions_aux(2)]);
                    detect_event=pos_transitions_robot{1,ind_rot};
                    actualRegion=str2double(detect_event(2:end-1))-numTasks;
                    if strcmp(detect_event(1),'a')
                        robot=1;
                    elseif  strcmp(detect_event(1),'b')
                        robot=2;
                    else
                        robot=3;
                    end
                    
                    region(robot,actualRegion)=region(robot,actualRegion)+1;
                    aux_rob=0;
                end
            end
            
        else
            if aux_final1==0
                robot1=final_entry1(1);
                if strcmp(robot1,'a')
                    robot=1;
                    aux1_region=findDesiredEntryEvent(robot_entry,robot1,desired_region1);
                elseif strcmp(robot1,'b')
                    robot=2;
                    aux1_region=findDesiredEntryEvent(robot_entry,robot1,desired_region1);
                else
                    robot=3;
                    aux1_region=findDesiredEntryEvent(robot_entry,robot1,desired_region1);
                end
            end
            
            if aux1_region ~=0
                detect_event=robot_entry{aux1_region,1};
                region(robot,desired_region1-numTasks)=region(robot,desired_region1-numTasks)+1;
                actualRegion=desired_region1-numTasks;
                aux1_region=0;
            else
                aux_entry=0;
                pos=randperm(num_transitions(1));
                ind_pot=1;
                while aux_entry==0 && ind_pot <= num_transitions(1)
                    detect_event=robot_entry{pos(ind_pot),1};
                    actualRegion=str2double(detect_event(2:end-1))-numTasks;
                    if strcmp(detect_event(1),'a')
                        robot=1;
                    elseif  strcmp(detect_event(1),'b')
                        robot=2;
                    else
                        robot=3;
                    end
                    if region(robot,actualRegion)<1
                        aux_entry=1;
                        region(robot,actualRegion)=region(robot,actualRegion)+1;
                        break;
                    end
                    ind_pot=ind_pot+1;
                end
                if aux_entry ==0
                    ind_pot=randi([1 num_transitions(1)]);
                    detect_event=robot_entry{ind_pot,1};
                    actualRegion=str2double(detect_event(2:end-1))-numTasks;
                    if strcmp(detect_event(1),'a')
                        robot=1;
                    elseif  strcmp(detect_event(1),'b')
                        robot=2;
                    else
                        robot=3;
                    end
                    region(robot,actualRegion)=region(robot,actualRegion)+1;
                end
                
            end
        end
        if aux_pos_entry
            aux_entry=0;
            pos=randperm(num_transitions(1));
            ind_pot=1;
            while aux_entry==0 && ind_pot <= num_transitions(1)
                detect_event=robot_entry{pos(ind_pot),1};
                actualRegion=str2double(detect_event(2:end-1))-numTasks;
                if strcmp(detect_event(1),'a')
                    robot=1;
                elseif  strcmp(detect_event(1),'b')
                    robot=2;
                else
                    robot=3;
                end
                if region(robot,actualRegion)<1
                    aux_entry=1;
                    region(robot,actualRegion)=region(robot,actualRegion)+1;
                    break;
                end
                ind_pot=ind_pot+1;
            end
            if aux_entry ==0
                ind_pot=randi([1 num_transitions(1)]);
                detect_event=robot_entry{ind_pot,1};
                actualRegion=str2double(detect_event(2:end-1))-numTasks;
                if strcmp(detect_event(1),'a')
                    robot=1;
                elseif  strcmp(detect_event(1),'b')
                    robot=2;
                else
                    robot=3;
                end
                region(robot,actualRegion)=region(robot,actualRegion)+1;
            end
            
        end
        
        final_region(robot)=actualRegion+numTasks;
        path_event{1}{index_ev}=detect_event;
        index_ev=index_ev+1;
        cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state that event takes
        index3=findSameState(path_state{1},cur_states,num_fsm);
        if isempty(index3)
            path_state{1}{index_st}=cur_states;%saves this state, which will be verified to see if it is the marked state at the next run
            index_st=index_st+1;
        else
            old_path_single='';
            old_path_single=path_state{1};
            path_state{1}='';
            old_event_single='';
            old_event_single=path_event{1};
            path_event{1}='';
            path_state{1}={old_path_single{1,1:index3}};
            cur_states=old_path_single{1,index3};
            path_event{1}={old_event_single{1:index3-1}};
            index_ev=index3;
            index_st=index3+1;
        end
    end
end
end