function [path_events] = newCrossover3New(max_rep,parent,states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions)

num_r=size(initialRegions);
numRobots=num_r(2);

for kt=1:max_rep
    aux_split=0;
    tent=3;
    if kt>1
        parent='';
        parent=new_event{1};
        new_event{1}='';
    end
    while aux_split==0 && tent > 0
        aux_initial=1;
        aux=1;

        while aux
            ki=1;
            idx_cros(1)=randi([round((2+(length(parent)*(ki-1)/4))) round(((length(parent)*4/4)-1))]);
            if strcmp(parent{idx_cros(1)}(end),'e') || strcmp(parent{idx_cros(1)}(end),'f')
                aux=0;
            end
        end
        
        
        
        aux_split=1;
        aux_new=0;
        aux_all=2;
        idx_robot(1)=0;
        for i=idx_cros(1)+1:length(parent)
            if ~strcmp(parent{i}(1),parent{idx_cros(1)}(1))
                idx_robot(1)=i;
                break;
            end
        end
        
        if idx_cros(1)==length(parent)
            aux_split=0;
            aux_all=0;
            %         break;
        else
            if idx_robot(1)==length(parent) || idx_robot(1)==0
                aux_split=0;
                aux_all=0;
                %             break;
            end
        end
         if aux_split
        if strcmp(parent{idx_robot(1)}(end),'e')
            %verify if the entry event at idx_cros is the first entry event
            %of the robot
            for j=idx_cros(1)-1:-1:1
                if strcmp(parent{idx_cros(1)}(1),parent{j}(1))
                    if strcmp(parent{j}(end),'e')
                        aux_initial=0;
                        break;
                    else
                        aux_initial=1;
                    end
                end
            end
            %if it is the first event, verify if the entry event at
            %idx_robot is not for the initial region of the robot
            if aux_initial==1
                if strcmp(parent{idx_cros(1)}(1),'a')
                    if str2double(parent{idx_robot(1)}(2:end-1))==initialRegions(1)
                        aux_split=0;
                        aux_all=0;
                        %                     break;
                    end
                elseif strcmp(parent{idx_cros(1)}(1),'b')
                    if str2double(parent{idx_robot(1)}(2:end-1))==initialRegions(2)
                        aux_split=0;
                        aux_all=0;
                        %                     break;
                    end
                else
                    if str2double(parent{idx_robot(1)}(2:end-1))==initialRegions(3)
                        aux_split=0;
                        aux_all=0;
                        %                     break;
                    end
                end
            end
            %check if the entry event at idx_robot is the same as the entry
            %event of a different robot at the first part of the plan
            if aux_split
                aux_i=zeros(1,numRobots);
                for k=idx_cros(1)-1:-1:1
                    if ~strcmp(parent{k}(1),parent{idx_robot(1)}(1)) && strcmp(parent{k}(end),'e') && aux_i(1,double(parent{k}(1))-96)==0
                        aux_i(1,double(parent{k}(1))-96)=1;
                        if strcmp(parent{k}(2:end-1),parent{idx_robot(1)}(2:end-1))
                            aux_split=0;
                            break;
                        end
                    end
                    if sum(aux_i)==numRobots-1
                        break;
                    end
                end
            end
            %check if the entry event at idx_robot is not for the same region for an entry event of another robot at
            %the middle of the plan
            %since the robot at idx_robot is the first event with a
            %different robot than idx_cros, it is expected that all entry
            %events at the middle of the plan are related to the robot of
            %idx_cros
            if aux_split
                for k=idx_cros(1):idx_robot(1)-1
                    if strcmp(parent{k}(end),'e')
                        if strcmp(parent{k}(2:end-1),parent{idx_robot(1)}(2:end-1))
                            aux_split=0;
                            break;
                        end
                    end
                end
            end
            
            if aux_split
                for k=idx_robot(1)+1:length(parent)
                    if strcmp(parent{k}(end),'e')
                        if strcmp(parent{k}(1),parent{idx_robot(1)}(1))
                            break;
                        else
                           if strcmp(parent{k}(2:end-1),parent{idx_robot(1)}(2:end-1))
                               aux_split=0;
                               break;
                           end
                        end
                    end
                end
            end
        end
         end
        if aux_split
            aux_f=zeros(1,numRobots);
            for k=idx_robot(1)-1:-1:idx_cros(1)
                if strcmp(parent{k}(end),'e')
                    aux_f(1,double(parent{k}(1))-96)=1;
                    for j=idx_robot(1)+1:length(parent)
                        if strcmp(parent{j}(end),'e')
                            if strcmp(parent{j}(1),parent{k}(1))
                                break;
                            else
                                if strcmp(parent{j}(2:end-1),parent{k}(2:end-1))
                                    aux_split=0;
                                    break;
                                end
                            end
                        end
                    end
                    
                end
                if sum(aux_f)==numRobots-1
                    break;
                end
            end
        end
        
%         if aux_split==0
%             tent=tent-1;
            if aux_all==0
                break;
            end
%         end
    end
    
    if aux_split==0
        new_event{1}=parent;
    else
        new_event{1}={parent{1:idx_cros(1)-1},parent{idx_robot(1)},parent{idx_cros(1):idx_robot(1)-1},parent{idx_robot(1)+1:end}};
    end
end

% if ju==1
%     new_event{1}='';
%     new_event{1}=parent;
% end
plan=stripEventPathMod(new_event{1});

% if length(plan) > 6
%     ju=2
% end
% if checkPlan(new_event)
     path_events=new_event{1};
% else
%     path_events='';
% end
%[path_gen,path_events] = createChromossomeMod(parent,new_event,states_incr,num_fsm,initial_state_incr,event_list,events_incr);
end

