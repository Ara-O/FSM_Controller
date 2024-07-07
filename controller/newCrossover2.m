function [path_gen,path_events] = newCrossover2(max_rep,parent,states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions)

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
            aux_entry_i=zeros(1,numRobots);
            aux_i=zeros(1,numRobots);
            for j=idx_cros(1)-1:-1:1
                if strcmp(parent{j}(1),'a') && strcmp(parent{j}(end),'e') && aux_entry_i(1,1)==0
                    aux_i(1,1)=str2double(parent{j}(2:end-1));
                    aux_entry_i(1,1)=1;
                elseif strcmp(parent{j}(1),'b') && strcmp(parent{j}(end),'e') && aux_entry_i(1,2)==0
                    aux_i(1,2)=str2double(parent{j}(2:end-1));
                    aux_entry_i(1,2)=1;
                elseif strcmp(parent{j}(1),'c') && strcmp(parent{j}(end),'e') && aux_entry_i(1,3)==0
                    aux_i(1,3)=str2double(parent{j}(2:end-1));
                    aux_entry_i(1,3)=1;
                end
                if sum(aux_entry_i)==numRobots
                    break;
                end
            end
            
            aux_entry_mi=zeros(1,numRobots);
            aux_mi=zeros(1,numRobots);
            for j=idx_cros(1):idx_robot(1)-1
                if strcmp(parent{j}(1),'a') && strcmp(parent{j}(end),'e') && aux_entry_mi(1,1)==0
                    aux_mi(1,1)=str2double(parent{j}(2:end-1));
                    aux_entry_mi(1,1)=1;
                elseif strcmp(parent{j}(1),'b') && strcmp(parent{j}(end),'e') && aux_entry_mi(1,2)==0
                    aux_mi(1,2)=str2double(parent{j}(2:end-1));
                    aux_entry_mi(1,2)=1;
                elseif strcmp(parent{j}(1),'c') && strcmp(parent{j}(end),'e') && aux_entry_mi(1,3)==0
                    aux_mi(1,3)=str2double(parent{j}(2:end-1));
                    aux_entry_mi(1,3)=1;
                end
                if sum(aux_entry_mi)==numRobots
                    break;
                end
            end
            
            
            aux_entry_mf=zeros(1,numRobots);
            aux_mf=zeros(1,numRobots);
            for j=idx_robot(1)-1:-1:idx_cros(1)
                if strcmp(parent{j}(1),'a') && strcmp(parent{j}(end),'e') && aux_entry_mf(1,1)==0
                    aux_mf(1,1)=str2double(parent{j}(2:end-1));
                    aux_entry_mf(1,1)=1;
                elseif strcmp(parent{j}(1),'b') && strcmp(parent{j}(end),'e') && aux_entry_mf(1,2)==0
                    aux_mf(1,2)=str2double(parent{j}(2:end-1));
                    aux_entry_mf(1,2)=1;
                elseif strcmp(parent{j}(1),'c') && strcmp(parent{j}(end),'e') && aux_entry_mf(1,3)==0
                    aux_mf(1,3)=str2double(parent{j}(2:end-1));
                    aux_entry_mf(1,3)=1;
                end
                if sum(aux_entry_mf)==numRobots
                    break;
                end
            end
            
            aux_entry_f=zeros(1,numRobots);
            aux_f=zeros(1,numRobots);
            for j=idx_robot(1)+1:length(parent)
                if strcmp(parent{j}(1),'a') && strcmp(parent{j}(end),'e') && aux_entry_f(1,1)==0
                    aux_f(1,1)=str2double(parent{j}(2:end-1));
                    aux_entry_f(1,1)=1;
                elseif strcmp(parent{j}(1),'b') && strcmp(parent{j}(end),'e') && aux_entry_f(1,2)==0
                    aux_f(1,2)=str2double(parent{j}(2:end-1));
                    aux_entry_f(1,2)=1;
                elseif strcmp(parent{j}(1),'c') && strcmp(parent{j}(end),'e') && aux_entry_f(1,3)==0
                    aux_f(1,3)=str2double(parent{j}(2:end-1));
                    aux_entry_f(1,3)=1;
                end
                if sum(aux_entry_f)==numRobots
                    break;
                end
            end
            
            
            
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
        end
        if aux_split
            for k=1:numRobots
                if str2double(parent{idx_robot(1)}(2:end-1))==aux_i(1,k)
                    aux_split=0;
                    aux_all=0;
                    break;
                end
            end
        end
        if aux_split
            for k=1:numRobots
                if str2double(parent{idx_robot(1)}(2:end-1))==aux_mi(1,k)
                    aux_split=0;
                    aux_all=0;
                    break;
                end
            end
        end
        
        if aux_split
            for k=1:numRobots
                for j=1:numRobots
                    if aux_mf ~=0
                        if aux_mf(1,k)==aux_f(1,j)
                            aux_split=0;
                            aux_all=0;
                            break;
                        end
                    end
                end
                if aux_all==0
                    break;
                end
            end
        end
        if aux_split==0
            tent=tent-1;
        end
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
%     path_events=new_event{1};
% else
%     path_events='';
% end
[path_gen,path_events] = createChromossomeMod(parent,new_event,states_incr,num_fsm,initial_state_incr,event_list,events_incr);
end

