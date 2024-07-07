function [path_gen,path_events] = newCrossover(max_rep,parent,states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions)

num_r=size(initialRegions);
numRobots=num_r(2);
for kt=1:max_rep
    aux_initial=1;
    aux=1;
    if kt>1
        parent='';
        parent=new_event{1};
        new_event{1}='';
    end
    while aux
        ki=1;
        idx_cros(1)=randi([round((2+(length(parent)*(ki-1)/4))) round(((length(parent)*4/4)-1))]);
        if strcmp(parent{idx_cros(1)}(end),'e') || strcmp(parent{idx_cros(1)}(end),'f')
            aux=0;
        end
    end
    
    aux_all=2;
    aux_split=0;
    ju=0;
    while aux_all>0
        
        aux_split=1;
        aux_new=0;
        aux_all=2;
        
        for i=idx_cros(1)+1:length(parent)
            if ~strcmp(parent{i}(1),parent{idx_cros(1)}(1))
                idx_robot(1)=i;
                break;
            end
        end
        
        if idx_cros(1)==length(parent)
            aux_split=0;
            aux_all=0;
            break;
        else
            if i==length(parent)
                aux_split=0;
                aux_all=0;
                break;
            end
        end
        
        aux_entry_ai=0;
        aux_entry_bi=0;
        aux_entry_ci=0;
        aux_ai=0;
        aux_bi=0;
        aux_ci=0;
%         for j=idx_robot(1)-1:-1:idx_cros(1)
%             if strcmp(parent{j}(1),'a') && strcmp(parent{j}(end),'e') && aux_entry_ai==0
%                 aux_ai=str2double(parent{j}(2:end-1));
%                 aux_entry_ai=1;
%             elseif strcmp(parent{j}(1),'b') && strcmp(parent{j}(end),'e') && aux_entry_bi==0
%                 aux_bi=str2double(parent{j}(2:end-1));
%                 aux_entry_bi=1;
%             elseif strcmp(parent{j}(1),'c') && strcmp(parent{j}(end),'e') && aux_entry_ci==0
%                 aux_ci=str2double(parent{j}(2:end-1));
%                 aux_entry_ci=1;
%             end
%             if aux_entry_ai+aux_entry_bi+aux_entry_ci==numRobots
%                 break;
%             end
%         end
%         
%         aux_entry_a=0;
%         aux_entry_b=0;
%         aux_entry_c=0;
%         aux_a=0;
%         aux_b=0;
%         aux_c=0;
%         for j=idx_robot(1)+1:length(parent)
%            if strcmp(parent{j}(1),'a') && strcmp(parent{j}(end),'e') && aux_entry_a==0
%                aux_a=str2double(parent{j}(2:end-1));
%                aux_entry_a=1;
%            elseif strcmp(parent{j}(1),'b') && strcmp(parent{j}(end),'e') && aux_entry_b==0
%                aux_b=str2double(parent{j}(2:end-1));
%                aux_entry_b=1;
%            elseif strcmp(parent{j}(1),'c') && strcmp(parent{j}(end),'e') && aux_entry_c==0
%                aux_c=str2double(parent{j}(2:end-1));
%                aux_entry_c=1;
%            end
%            if aux_entry_a+aux_entry_b+aux_entry_c==numRobots
%                break;
%            end
%         end
%         
%         if numRobots==2
%             if aux_a==aux_bi || aux_b==aux_ai
%                 aux_split=0;
%                 aux_all=0;
%                 break;
%             end
%         else
%             if aux_a==aux_bi || aux_a==aux_ci || aux_b==aux_ai || aux_b==aux_ci || aux_c==aux_ai || aux_c==aux_bi
%                 aux_split=0;
%                 aux_all=0;
%                 break;
%             end
%         end
                
%         for j=idx_cros(1)-1:-1:1
%             if strcmp(parent{idx_cros(1)}(1),parent{j}(1))
%                 if strcmp(parent{j}(end),'e')
%                     aux_initial=0;
%                     break;
%                 else
%                     aux_initial=1;
%                 end
%             end
%         end
%         
%         if aux_initial==1
%             if strcmp(parent{idx_cros(1)}(1),'a')
%                 if str2double(parent{idx_robot(1)}(2:end-1))==initialRegions(1)
%                     aux_split=0;
%                     aux_all=0;
%                     break;
%                 end
%             elseif strcmp(parent{idx_cros(1)}(1),'b')             
%                 if str2double(parent{idx_robot(1)}(2:end-1))==initialRegions(2)
%                     aux_split=0;
%                     aux_all=0;
%                     break;
%                 end
%             else
%                 if str2double(parent{idx_robot(1)}(2:end-1))==initialRegions(3)
%                     aux_split=0;
%                     aux_all=0;
%                     break;
%                 end
%             end
%         end
        
        if aux_split==1 % it is a feasible flip point
            
            if strcmp(parent{idx_cros(1)}(2:end),parent{idx_robot(1)}(2:end)) %check if the events are for the same entry region
                for i=idx_cros(1)+1:length(parent)%if so look for a new point
                    if strcmp(parent{i}(1),parent{idx_cros(1)}(1))
                        if strcmp(parent{i}(end),'e') || strcmp(parent{i}(end),'f')
                            idx_cros(1)=i;
                            break;
                        end
                    end
                end
                if idx_cros(1)==length(parent)
                    aux_split=0;
                    aux_all=0;
                    break;
                else
                    if i==length(parent)
                        aux_split=0;
                        aux_all=0;
                        break;
                    end
                end
            else %if the events are not for the same region
                
                aux_forward=0;
                
                
                if strcmp(parent{idx_cros(1)}(end),'e')% if the chosen point event is an entry event
                    aux_split=1; %it will happen the flip
                    for i=idx_robot(1)+1:length(parent)%takes the next entry event from the second robot
                        if strcmp(parent{i}(1),parent{idx_robot(1)}(1)) && strcmp(parent{i}(end),'e')
                            idx_robot(2)=i;
                            aux_forward=1;
                            break;
                        end
                    end
                    %         else
                    %             aux_all=aux_all-1;
                end
                
                aux_backward=0;
                
                if strcmp(parent{idx_robot(1)}(end),'e') %if the second point is an entry event
                    aux_split=1;
                    for i=idx_cros(1)-1:-1:1 %takes the next entry event
                        if strcmp(parent{i}(1),parent{idx_cros(1)}(1)) && strcmp(parent{i}(end),'e')
                            idx_cros(2)=i;
                            aux_backward=1;
                            break;
                        end
                    end
                    %         else
                    %             aux_all=aux_all-1;
                end
                
                aux_middle=0;
                %aux_new=0;
                if aux_backward
                    aux_middle=0;
                    for i=idx_cros(1):idx_robot(1)-1
                        if strcmp(parent{i}(2:end),parent{idx_robot(1)}(2:end)) %check if in the middle there is an event for the same entry region
                            aux_middle=1;
                            break;
                        end
                    end
                    if aux_middle==1
                        aux_new=1;
                        for j=idx_cros(1)+1:length(parent)
                            if strcmp(parent{j}(1),parent{idx_cros(1)}(1))
                                if strcmp(parent{j}(end),'e') || strcmp(parent{i}(end),'f')
                                    idx_cros(1)=j;
                                    %                                 idx_cros(2)=[];
                                    aux_forward=0;
                                    break;
                                end
                                
                            end
                        end
                        if idx_cros(1)==length(parent)
                            aux_split=0;
                            aux_all=0;
                            break;
                        else
                            if i==length(parent)
                                aux_split=0;
                                aux_all=0;
                                break;
                            end
                        end
                        
                    else %aux_middle=0, it can do the change
                        if strcmp(parent{idx_robot(1)}(2:end),parent{idx_cros(2)}(2:end)) %check if there is no same entry region in backward
                            aux_new=1;
                            for i=idx_cros(1)+1:length(parent)
                                if strcmp(parent{i}(1),parent{idx_cros(1)}(1))
                                    if strcmp(parent{i}(end),'e') || strcmp(parent{i}(end),'f')
                                        idx_cros(1)=i;
                                        %                                     idx_cros(2)=[];
                                        aux_backward=0;
                                        aux_forward=0;
                                        break;
                                    end
                                    
                                end
                            end
                            if idx_cros(1)==length(parent)
                                aux_split=0;
                                aux_all=0;
                                break;
                            else
                                if i==length(parent)
                                    aux_split=0;
                                    aux_all=0;
                                    break;
                                end
                            end
                        else %if there is no back same entry event, it can realize the change
                            aux_all=aux_all-1;
                        end
                    end
                else %if it is not an entry event, it can do the change
                    aux_all=aux_all-1;
                    
                end
                
                if aux_new==0 %if there was no need to look for a new point, it can check to do the next change
                    if aux_forward %if there is need to check if the change can be done forward
                        if strcmp(parent{idx_cros(1)}(2:end),parent{idx_robot(2)}(2:end)) %if there is same entry event
                            aux_new=1;
                            for i=idx_cros(1)+1:length(parent)
                                if strcmp(parent{i}(1),parent{idx_cros(1)}(1))%look for a new point for flip
                                    if strcmp(parent{i}(end),'e') || strcmp(parent{i}(end),'f')
                                        idx_cros(1)=i;
                                        %                                     idx_cros(2)=[];
                                        aux_forward=0;
                                        aux_backward=0;
                                        break;
                                    end
                                end
                            end
                            if idx_cros(1)==length(parent)
                                aux_split=0;
                                aux_all=0;
                                break;
                            else
                                if i==length(parent)
                                    aux_split=0;
                                    aux_all=0;
                                    break;
                                end
                            end
                        else %if there is not the same entry region, it can do the change
                            aux_all=aux_all-1;
                        end
                    else %if there is no need to check the forward, can d the change
                        aux_all=aux_all-1;
                    end
                end
                
            end
        end
        %here relaunch the loop... if there is a new point of cross, it will
        %look for the new robot cross point
    end
    
    
    if aux_split==0
        new_event{1}=parent;
    else
        new_event{1}={parent{1:idx_cros(1)-1},parent{idx_robot(1)},parent{idx_cros(1):idx_robot(1)-1},parent{idx_robot(1)+1:end}};
    end
end

if ju==1
    new_event{1}='';
    new_event{1}=parent;
end
plan=stripEventPathMod(new_event{1});

% if length(plan) > 6
%     ju=2
% end
% if checkPlan(new_event)
%     path_events=new_event{1};
% else
%     path_events='';
% end
[path_gen,path_events] = createChromossomeMod(parent,new_event,states_incr,num_fsm,initial_state_incr,event_list,events_incr);
end

