function [path_state,path_event,final_region] = horizonPlanRegionsRobots(cur_states,final_entry1,states_incr,num_fsm,event_list,events_incr,numRegions,numRobots,initialRegion,numTasks,desired_region1)
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
robot1=final_entry1(1);
robots={robot1};
while aux_final1==0
    transition_list = createTransitionList(states_incr,cur_states,num_fsm);%check the possible transitions at this state
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    robot_entry=findEntryEventsRobot(possible_transitions,robots);
    num_transitions = size(robot_entry);%check the number of possible transitions
    if aux_final1==0
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
            aux_rob=0;
            pos=randperm(num_transitions(1));
            ind_pot=1;
            aux_entry=0;
            while aux_entry==0 && ind_pot<=num_transitions(1)
                detect_event=robot_entry{pos(ind_pot),1};
                aux_rob=0;
                while aux_rob==0 && ind_pot<=num_transitions(1)
                    detect_event=robot_entry{pos(ind_pot),1};
                    if strcmp(detect_event(1),robot1)&& ~aux_final1
                        aux_rob=1;
                        break;
                    end
                    if strcmp(robot1,'a')
                        robot=2; %need to check the other robot
                        if initialRegion(robot)==desired_region1
                            aux_rob=1;
                            break;
                        elseif numRobots > 2
                            robot=3; %need to check the other robot
                            if initialRegion(robot)==desired_region1
                                aux_rob=1;
                                break;
                            end
                            
                        end
                    elseif strcmp(robot1,'b')
                        robot=1; %need to check the other robot
                        if initialRegion(robot)==desired_region1
                            aux_rob=1;
                            break;
                        elseif numRobots > 2
                            robot=3; %need to check the other robot
                            if initialRegion(robot)==desired_region1
                                aux_rob=1;
                                break;
                            end
                            
                        end
                    else
                        robot=2; %need to check the other robot
                        if initialRegion(robot)==desired_region1
                            aux_rob=1;
                            break;
                        else
                            robot=1; %need to check the other robot
                            if initialRegion(robot)==desired_region1
                                aux_rob=1;
                                break;
                            end
                            
                        end
                    end

%                     if strcmp(detect_event(1),robot2)&& ~aux_final2
%                         aux_rob=1;
%                         break;
%                     end
                    ind_pot=ind_pot+1;
                end
                if aux_rob==0
                    ju=3;
                end
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
                %detect_event=robot_entry{pos(ind_pot),1};
            end
            if aux_entry==0
                ind_pot=randi([1 num_transitions(1)]);
                detect_event=robot_entry{ind_pot,1};
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