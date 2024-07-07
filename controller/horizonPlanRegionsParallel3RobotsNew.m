function [path_state,path_event,final_region,aux_final1,aux_final2,aux_final3,aux1_region,aux2_region,aux3_region] = horizonPlanRegionsParallel3RobotsNew(cur_states,final_entry1,final_entry2,final_entry3,states_incr,num_fsm,event_list,events_incr,numRegions,numRobots,initialRegion,numTasks,desired_region1,desired_region2,desired_region3,aux_final1,aux_final2,aux_final3,aux1_region,aux2_region,aux3_region)
region=zeros(numRobots,numRegions-numTasks);
index_ev=1;
index_st=1;
final_region=zeros(numRobots);
for i=1:length(initialRegion)
    final_region(i)=initialRegion(i);
%     index=initialRegion(i)-numTasks;
%     region(i,index)=1;
end
robot1=final_entry1(1);
robot2=final_entry2(1);
robot3=final_entry3(1);
% aux_final1=0;
% aux_final2=0;
% aux_final3=0;
% aux1_region=0;
% aux2_region=0;
% aux3_region=0;
path_state{1}{index_st}=cur_states;
index_st=index_st+1;
while aux_final1==0 && aux_final2==0 && aux_final3==0
    transition_list = createTransitionList(states_incr,cur_states,num_fsm);%check the possible transitions at this state
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    robot_entry=findEntryEvents(possible_transitions);
    num_transitions = size(robot_entry);%check the number of possible transitions
    if aux_final1==0
        aux1=checkPosTransEvent(robot_entry,final_entry1);%check if the desired event is possible to happen
    end
    if aux_final2==0
        aux2=checkPosTransEvent(robot_entry,final_entry2);
    end
    if aux_final3==0
        aux3=checkPosTransEvent(robot_entry,final_entry3);
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
    elseif aux2~=0
        detect_event=robot_entry{aux2,1};
        path_event{1}{index_ev}=detect_event;
        index_ev=index_ev+1;
        cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state that event takes
        path_state{1}{index_st}=cur_states;
        index_st=index_st+1;
        aux2=0;
        aux_final2=1;
    elseif aux3 ~=0
        detect_event=robot_entry{aux3,1};
        path_event{1}{index_ev}=detect_event;
        index_ev=index_ev+1;
        cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%check to which state that event takes
        path_state{1}{index_st}=cur_states;
        index_st=index_st+1;
        aux3=0;
        aux_final3=1;
    else
        if aux_final1==0

            robot1=final_entry1(1);
            if strcmp(robot1,'a')
                robot=1;
            elseif strcmp(robot1,'b')
                robot=2;
            else
                robot=3;
                
            end
            aux1_region=findDesiredEntryEvent(robot_entry,robot1,desired_region1);
            
        elseif aux_final2==0
            robot2=final_entry2(1);
            if strcmp(robot2,'a')
                robot=1;
            elseif strcmp(robot2,'b')
                robot=2;
            else
                robot=3;
                
            end
            aux2_region=findDesiredEntryEvent(robot_entry,robot2,desired_region2);
        elseif aux_final3==0
            robot3=final_entry3(1);
            if strcmp(robot3,'a')
                robot=1;
            elseif strcmp(robot3,'b')
                robot=2;
            else
                robot=3;
                
            end
            aux3_region=findDesiredEntryEvent(robot_entry,robot3,desired_region3);
            
        end
        if aux1_region ~=0
            detect_event=robot_entry{aux1_region,1};
            if strcmp(detect_event(1),'a')
                robot=1;
                region(robot,desired_region1-numTasks)=region(robot,desired_region1-numTasks)+1;
                actualRegion=desired_region1-numTasks;
            elseif  strcmp(detect_event(1),'b')
                robot=2;
                region(robot,desired_region1-numTasks)=region(robot,desired_region1-numTasks)+1;
                actualRegion=desired_region1-numTasks;
            else
                robot=3;
                region(robot,desired_region1-numTasks)=region(robot,desired_region1-numTasks)+1;
                actualRegion=desired_region1-numTasks;
            end
            
            aux1_region=0;
        elseif aux2_region ~=0
            detect_event=robot_entry{aux2_region,1};
            if strcmp(detect_event(1),'a')
                robot=1;
                region(robot,desired_region2-numTasks)=region(robot,desired_region2-numTasks)+1;
                actualRegion=desired_region2-numTasks;
            elseif  strcmp(detect_event(1),'b')
                robot=2;
                region(robot,desired_region2-numTasks)=region(robot,desired_region2-numTasks)+1;
                actualRegion=desired_region2-numTasks;
            else
                robot=3;
                region(robot,desired_region2-numTasks)=region(robot,desired_region2-numTasks)+1;
                actualRegion=desired_region2-numTasks;
            end
            aux2_region=0;
        elseif aux3_region ~=0
            detect_event=robot_entry{aux3_region,1};
            if strcmp(detect_event(1),'a')
                robot=1;
                region(robot,desired_region3-numTasks)=region(robot,desired_region3-numTasks)+1;
                actualRegion=desired_region3-numTasks;
            elseif  strcmp(detect_event(1),'b')
                robot=2;
                region(robot,desired_region3-numTasks)=region(robot,desired_region3-numTasks)+1;
                actualRegion=desired_region3-numTasks;
            else
                robot=3;
                region(robot,desired_region3-numTasks)=region(robot,desired_region3-numTasks)+1;
                actualRegion=desired_region3-numTasks;
            end
            aux3_region=0;
            
            
        else
            
            aux_rob=0;
            pos=randperm(num_transitions(1));
            ind_pot=1;
            aux_entry=0;
            while aux_entry==0 && ind_pot<=num_transitions(1)
%                 detect_event=robot_entry{pos(ind_pot),1};
                aux_rob=0;
                while aux_rob==0 && ind_pot<=num_transitions(1)
                    detect_event=robot_entry{pos(ind_pot),1};
                    if strcmp(detect_event(1),robot1)&& ~aux_final1
                        aux_rob=1;
                        break;
                    end
                    if strcmp(detect_event(1),robot2)&& ~aux_final2
                        aux_rob=1;
                        break;
                    end
                    if strcmp(detect_event(1),robot3)&& ~aux_final3
                        aux_rob=1;
                        break;
                    end
                    if (~aux_final1 && aux_final2) ||(~aux_final1 && aux_final3)
                        

                            if strcmp(robot1,'a')
                                robot=2; %need to check the other robot
                                if final_region(robot)==desired_region1
                                    aux_rob=1;
                                    break;
                                else
                                    robot=3;
                                    if final_region(robot)==desired_region1
                                        aux_rob=1;
                                        break;
                                    end
                                end
                            elseif strcmp(robot1,'b')
                                robot=1; %need to check the other robot
                                if final_region(robot)==desired_region1
                                    aux_rob=1;
                                    break;
                                else
                                    robot=3;
                                    if final_region(robot)==desired_region1
                                        aux_rob=1;
                                        break;
                                    end
                                end
                            else
                                robot=1; %need to check the other robot
                                if final_region(robot)==desired_region1
                                    aux_rob=1;
                                    break;
                                else
                                    robot=2;
                                    if final_region(robot)==desired_region1
                                        aux_rob=1;
                                        break;
                                    end
                                end
                            end
                        
                    elseif (~aux_final2 && aux_final1) || (~aux_final2 && aux_final3)
                         if strcmp(robot2,'a')
                                robot=2; %need to check the other robot
                                if final_region(robot)==desired_region2
                                    aux_rob=1;
                                    break;
                                else
                                    robot=3;
                                    if final_region(robot)==desired_region2
                                        aux_rob=1;
                                        break;
                                    end
                                end
                         elseif strcmp(robot2,'b')
                             robot=1; %need to check the other robot
                             if final_region(robot)==desired_region2
                                 aux_rob=1;
                                 break;
                             else
                                 robot=3;
                                 if final_region(robot)==desired_region2
                                     aux_rob=1;
                                     break;
                                 end
                             end
                         else
                             robot=1; %need to check the other robot
                             if final_region(robot)==desired_region2
                                 aux_rob=1;
                                 break;
                             else
                                 robot=2;
                                 if final_region(robot)==desired_region2
                                     aux_rob=1;
                                     break;
                                 end
                             end
                         end
                         
                         
                    elseif (~aux_final3 && aux_final1) || (~aux_final3 && aux_final2)
                        if strcmp(robot3,'a')
                            robot=2; %need to check the other robot
                            if final_region(robot)==desired_region3
                                aux_rob=1;
                                break;
                            else
                                robot=3;
                                if final_region(robot)==desired_region3
                                    aux_rob=1;
                                    break;
                                end
                            end
                        elseif strcmp(robot3,'b')
                            robot=1; %need to check the other robot
                            if final_region(robot)==desired_region3
                                aux_rob=1;
                                break;
                            else
                                robot=3;
                                if final_region(robot)==desired_region3
                                    aux_rob=1;
                                    break;
                                end
                            end
                        else
                            robot=1; %need to check the other robot
                            if final_region(robot)==desired_region3
                                aux_rob=1;
                                break;
                            else
                                robot=2;
                                if final_region(robot)==desired_region3
                                    aux_rob=1;
                                    break;
                                end
                            end
                        end

                    end
                    ind_pot=ind_pot+1;
                end
                if aux_rob==0
                    ju=3;
                end
                actualRegion=str2double(detect_event(2:end-1))-numTasks;
                if strcmp(detect_event(1),'a')
                    robot=1;
                elseif strcmp(detect_event(1),'b')
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
            index_st=index3+1;
            index_ev=index3;
            
            %i=index3;
        end
    end
end