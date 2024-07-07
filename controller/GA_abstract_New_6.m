function [plan,plan_state,plan_cost,num_spoint,initial_plan,num_of_changes] = GA_abstract_New_6(population_size,max_rep,mutation_rate,stop_cond,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks)
num_of_changes=0;
abstracted = true;
start_events_only = true;
cost=[];
num_paths=population_size; %number of paths to be generated
for j=1:population_size
    aux=1;
    act_state=1;% always start from the initial state
    i=1;
    n=1;
    while aux
        path_gen{j}(i)=act_state; %save at the state being analyzed
        if states{act_state,3} %verify if it is a marked state, if is then stop searching
            aux=0;
            break;
        end
        sz=size(states{act_state,2}); %between all the possible transitions from the state
%         if sz>1 % a state with more than one path to choose
%             divergent_states{j}(n)=act_state;
%             idx_divergent_state{j}(n)=i;
%             n=n+1;
%         end
        rng('shuffle');
        r = randi([1 sz(1,1)],1,1); %choose a random one
        next_state= states{act_state,2}(r,2); %save the state
        path_events{j}{i}= states{act_state,2}(r,1); %save the tansitions' event
        i=i+1;
        act_state=str2double(next_state);
    end
end
aux_dup=0;
%check if there are loops in the path
for i=1:length(path_gen)
    old_path_gen='';
    old_path_gen=path_gen{i};
    old_event_gen='';
    old_event_gen=path_events{i};
    path_gen{i}='';
    path_events{i}='';
    [path_gen{i},path_events{i}]=check_loops_fix_new(old_path_gen,old_event_gen); %remove the loops
end

%now, we have paths without loops

for i=1:length(path_gen)
    
    cost(1,i)=0;
    robotLocation=[];
    cost_robot=[];
    cost_robot=zeros(numRobots,1);
    for j=1:length(path_gen{i})-1
        act_state=path_gen{i}(j);
        next_state=path_gen{i}(j+1);
        if j==1
            for i_r = 1:numRobots
                robotLocation{j,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
            end
        end
        next_event=path_events{i}{j}{1};
        
        
        event_bot = next_event(1)-96;
        currBotLoad = cost_robot(event_bot);
        for w = 1:numRobots  % Bot next load = current load + idle cost
            cost_robot(w) = cost_robot(w) + max(0,currBotLoad - cost_robot(w));
        end
        %path_events{i}{j}{1,1}
        [transition_cost,~,new_X,new_Y] = ...
            calcTransitionCost(next_event,act_state,next_state,path_gen{i}(1:j),states,tasks,0,regions,numRegions,start_loc,...
            numTasks,abstracted,start_events_only,robotLocation{j,event_bot},robot_tasks,0);
        
        cost_robot(event_bot)=cost_robot(event_bot)+transition_cost;
        
        for jj = 1:numRobots
            robotLocation{j+1,jj} = robotLocation{j,jj};
            cost_trans{1}{i}(jj,j)=0;
            %robotTask(J,jj) = robotTask(I,jj);
        end
        cost_trans{1}{i}(event_bot,j)=transition_cost;
        robotLocation{j+1,event_bot} = [new_X,new_Y];
    end
    cost(1,i)=max(cost_robot);
end
%find the events
% for i=1:num_paths
%     %         fit_values(i)=path_total_cost(path_events{1,i});
%     [cost(1,i),fit_values_A(i),fit_values_B(i),fit_values_C(i)]=path_total_cost(path_events{1,i});
% end

[fit_values_rn{1}, idx_fit_aux{1}]=sort(cost(1,:));

best_plan(1)=fit_values_rn{1}(1);
initial_plan=best_plan(1);
best_event{1}=path_events{idx_fit_aux{1}(1)};
aux_same_result=0;
num_rep=2;

old_g=path_gen;
old_ev=path_events;
path_gen='';
path_events='';
for i=1:length(idx_fit_aux{1})
    path_events{i}=old_ev{idx_fit_aux{1}(i)};
    path_gen{i}=old_g{idx_fit_aux{1}(i)};
end

ju=9

while num_rep<max_rep && aux_same_result<stop_cond

    num_spoint(num_rep)=0;
    num_sparent(num_rep)=0;
    %parents selection through tournament 2X2
    rng('shuffle');
    order=randperm(population_size);
    for i=1:length(order)/2
        if cost(1,order(2*i-1))<cost(1,order(2*i))
            parents(i)=order(2*i-1);
        else
            parents(i)=order(2*i);
        end
    end
    
    %crossover
    offspring='';
    i_off=1;
    for i=1:length(parents)/2
        parent_1=path_gen{parents(2*i-1)};
        parent_2=path_gen{parents(2*i)};
        k=1;
        cross_point='';
        
        for j=2:length(parent_1)-1%looking for same point,that can't be start or finish node
            for m=2:length(parent_2)-1
%                 if parent_1(j)==parent_2(m)
%                     cross_point{k}(1)=j;
%                     cross_point{k}(2)=m;
%                     k=k+1;
%                 else
                    aux_off=ismember({num2str(parent_2(m))},[states{parent_1(j),2}(:,2)]);
                    if aux_off %
                        aux_off_2= ismember({num2str(parent_1(j+1))},[states{parent_2(m-1),2}(:,2)]);
                        if aux_off_2
                            cross_point{k}{1}=j;
                            cross_point{k}{2}=m-1;
                            for t=1:length(states{parent_1(j),2}(:,2))
                                if parent_2(m)==str2num(states{parent_1(j),2}{t,2})
                                    cross_point{k}{3}= states{parent_1(j),2}{t,1};
                                end
                            end
                            for t=1:length(states{parent_2(m-1),2}(:,2))
                                if parent_1(j+1)==str2num(states{parent_2(m-1),2}{t,2})
                                    cross_point{k}{4}= states{parent_2(m-1),2}{t,1};
                                end
                            end
                            k=k+1;
                        end
                    end
                            
%                 end
            end
        end
        if ~isempty(cross_point)
            idx=randi([1 length(cross_point)]);
%             first_parent1='';
%             second_parent1='';
%             first_parent2='';
%             second_parent2='';
%             first_parent1=cost_trans{num_rep-1}{parents(2*i-1)}(:,1:cross_point{idx}{1}-1);
%             second_parent1=cost_trans{num_rep-1}{parents(2*i-1)}(:,cross_point{idx}{1}:end);
%             first_parent2=cost_trans{num_rep-1}{parents(2*i)}(:,1:cross_point{idx}{2}-1);
%             second_parent2=cost_trans{num_rep-1}{parents(2*i)}(:,cross_point{idx}{2}:end);
%             if max(sum(first_parent1')) <= max(sum(first_parent2'))
%                 if max(sum(second_parent1')) <= max(sum(second_parent2'))
%                         offspring{i_off}=parent_1;
%                         offspring_event{i_off}=path_events{parents(2*i-1)};
%                 else
%                     offspring{i_off}=[parent_1(1:cross_point{idx}{1}),parent_2(cross_point{idx}{2}+1:end)];
%                     offspring_event{i_off}={path_events{parents(2*i-1)}{1:cross_point{idx}{1}-1},{cross_point{idx}{3}},path_events{parents(2*i)}{cross_point{idx}{2}+1:end}};
%                 end
%             else
%                 if max(sum(second_parent1')) <= max(sum(second_parent2'))
%                     offspring{i_off}=[parent_2(1:cross_point{idx}{2}),parent_1(cross_point{idx}{1}+1 :end)];
%                     offspring_event{i_off}={path_events{parents(2*i)}{1:cross_point{idx}{2}-1},{cross_point{idx}{4}},path_events{parents(2*i-1)}{cross_point{idx}{1}+1:end}};
%                 else
%                     offspring{i_off}=parent_2;
%                     offspring_event{i_off}=path_events{parents(2*i)};
%                 end
%             end
            offspring{i_off}=[parent_1(1:cross_point{idx}{1}),parent_2(cross_point{idx}{2}+1:end)];
            offspring_event{i_off}={path_events{parents(2*i-1)}{1:cross_point{idx}{1}-1},{cross_point{idx}{3}},path_events{parents(2*i)}{cross_point{idx}{2}+1:end}};
            offspring{i_off+1}=[parent_2(1:cross_point{idx}{2}),parent_1(cross_point{idx}{1}+1 :end)];
            offspring_event{i_off+1}={path_events{parents(2*i)}{1:cross_point{idx}{2}-1},{cross_point{idx}{4}},path_events{parents(2*i-1)}{cross_point{idx}{1}+1:end}};
            i_off=i_off+1;
            num_spoint(num_rep)=num_spoint(num_rep)+1;
%         else
%             offspring{2*i-1}=parent_1;
%             offspring_event{2*i-1}=path_events{parents(2*i-1)};
%             offspring{2*i}= parent_2;
%             offspring_event{2*i}=path_events{parents(2*i)};
%             num_sparent(num_rep)=num_sparent(num_rep)+1;
        end
    end
    
    
    for i=1:length(offspring)
        old_offspring='';
        old_offspring=offspring{i};
        old_offspring_event='';
        old_offspring_event=offspring_event{i};
        offspring_event{i}='';
        [offspring{i},offspring_event{i}]=check_loops_fix_new(old_offspring,old_offspring_event);
    end
    
    cost_off=[];
    
    for i=1:length(offspring)
        
        cost_off(1,i)=0;
        robotLocation=[];
        cost_robot=[];
        cost_robot=zeros(numRobots,1);
        for j=1:length(offspring{i})-1
            act_state=offspring{i}(j);
            next_state=offspring{i}(j+1);
            if j==1
                for i_r = 1:numRobots
                    robotLocation{j,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
                end
            end
            
            next_event=offspring_event{i}{j}{1,1} ;
            event_bot = next_event(1)-96;
            currBotLoad = cost_robot(event_bot);
            for w = 1:numRobots  % Bot next load = current load + idle cost
                cost_robot(w) = cost_robot(w) + max(0,currBotLoad - cost_robot(w));
            end
            %path_events{i}{j}{1,1}
            [transition_cost,~,new_X,new_Y] = ...
                calcTransitionCost(next_event,act_state,next_state,offspring{i}(1:j),states,tasks,0,regions,numRegions,start_loc,...
                numTasks,abstracted,start_events_only,robotLocation{j,event_bot},robot_tasks,0);
            
            cost_robot(event_bot)=cost_robot(event_bot)+transition_cost;
            
            for jj = 1:numRobots
                robotLocation{j+1,jj} = robotLocation{j,jj};
                cost_trans_off{num_rep}{i}(jj,j)=0;
                %robotTask(J,jj) = robotTask(I,jj);
            end
            
            robotLocation{j+1,event_bot} = [new_X,new_Y];
            cost_trans_off{num_rep}{i}(event_bot,j)=transition_cost;
        end
        cost_off(1,i)=max(cost_robot);
    end
    
    if ~isempty(cost_off)
        cost_aux=[cost cost_off];
        cost_trans_aux{num_rep}=[cost_trans{num_rep-1} cost_trans_off{num_rep}];
    else
        cost_aux=cost;
        cost_trans_aux{num_rep}=[cost_trans{num_rep-1}];
    end
    
    old_path='';
    old_path=path_gen;
    old_events='';
    old_events=path_events;
    max_path=length(old_path);
    for i_x=1:length(offspring)
        old_path{max_path+i_x}=offspring{i_x};
        old_events{max_path+i_x}=offspring_event{i_x};
    end
    
    %mutation
    %mutation_rate=0.4;
    mutation_idx_max=ceil(length(old_path)*mutation_rate);
    rng('shuffle');
    mutation_idx_total=randperm(length(old_path));
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    
    for i=1:length(mutation_idx)
        if mutation_idx(i)>1
            mut_off='';
            mut_off=old_path{mutation_idx(i)};
            mut_off_events='';
            mut_off_events=old_events{mutation_idx(i)};
            rng('shuffle');
            idx_mut=randi([1 (length(mut_off)-1)]);
            node_mut=mut_off(idx_mut);
            old_path{mutation_idx(i)}='';
            old_events{mutation_idx(i)}='';
            old_path{mutation_idx(i)}=mut_off(1:idx_mut);
            old_events{mutation_idx(i)}={mut_off_events{1:idx_mut-1}};
            aux=1;
            act_state=node_mut;% always start from the initial state
            ind=idx_mut+1;
            while aux
                if states{act_state,3} %verify if it is a marked state, if is then stop searching
                    aux=0;
                    break;
                end
                sz=size(states{act_state,2}); %between all the possible transitions from the state
                %           if sz>1 % a state with more than one path to choose
                %               divergent_states{j}(n)=act_state;
                %               idx_divergent_state{j}(n)=i;
                %               n=n+1;
                %           end
                rng('shuffle')
                r = randi([1 sz(1,1)],1,1); %choose a random one
                %             next_state= states{act_state,2}(r,2); %save the state
                %             %path_events{j}{i}= states{act_state,2}(r,1); %save the tansitions' event
                %             ind=ind+1;
                %             act_state=str2double(next_state);
                next_state= states{act_state,2}(r,2); %save the state
                old_events{mutation_idx(i)}{ind-1}= {states{act_state,2}{r,1}}; %save the tansitions' event
                act_state=str2double(next_state);
                old_path{mutation_idx(i)}(ind)=act_state; %save at the state being analyzed
                ind=ind+1;
            end
            old_offspring='';
            old_offspring=old_path{mutation_idx(i)};
            old_offspring_event='';
            old_offspring_event=old_events{mutation_idx(i)};
            old_path{mutation_idx(i)}='';
            old_events{mutation_idx(i)}='';
            [old_path{mutation_idx(i)},old_events{mutation_idx(i)}]=check_loops_fix_new(old_offspring,old_offspring_event);
            
            
            robotLocation=[];
            cost_robot=[];
            cost_robot=zeros(numRobots,1);
            for j=1:length(old_path{mutation_idx(i)})-1
                act_state=old_path{mutation_idx(i)}(j);
                next_state=old_path{mutation_idx(i)}(j+1);
                if j==1
                    for i_r = 1:numRobots
                        robotLocation{j,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
                    end
                end
                
                next_event=old_events{mutation_idx(i)}{j}{1,1} ;
                event_bot = next_event(1)-96;
                currBotLoad = cost_robot(event_bot);
                for w = 1:numRobots  % Bot next load = current load + idle cost
                    cost_robot(w) = cost_robot(w) + max(0,currBotLoad - cost_robot(w));
                end
                %path_events{i}{j}{1,1}
                [transition_cost,~,new_X,new_Y] = ...
                    calcTransitionCost(next_event,act_state,next_state,old_path{mutation_idx(i)}(1:j),states,tasks,0,regions,numRegions,start_loc,...
                    numTasks,abstracted,start_events_only,robotLocation{j,event_bot},robot_tasks,0);
                
                cost_robot(event_bot)=cost_robot(event_bot)+transition_cost;
                
                for jj = 1:numRobots
                    robotLocation{j+1,jj} = robotLocation{j,jj};
                    cost_trans_aux{num_rep}{mutation_idx(i)}(jj,j)=0;
                    %robotTask(J,jj) = robotTask(I,jj);
                end
                
                robotLocation{j+1,event_bot} = [new_X,new_Y];
                cost_trans_aux{num_rep}{mutation_idx(i)}(event_bot,j)=transition_cost;
            end
            cost_aux(1,mutation_idx(i))=max(cost_robot);
            
        end
    end

    
    [fit_values_rn_aux{num_rep}, idx_fit_aux_2{num_rep}]=sort(cost_aux);
    cost=[];
    cost_trans{num_rep}=[];
    
    for i=1:num_paths
        path_gen{i}=old_path{idx_fit_aux_2{num_rep}(i)};
        path_events{i}=old_events{idx_fit_aux_2{num_rep}(i)};
        cost(1,i)=cost_aux(idx_fit_aux_2{num_rep}(i));
        cost_trans{num_rep}{i}=cost_trans_aux{num_rep}{idx_fit_aux_2{num_rep}(i)};
    end
    
    

    
    [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(cost);
    
    if fit_values_rn{num_rep}(1)==best_plan(num_rep-1)
        aux_same_result=aux_same_result+1;
        best_plan(num_rep)=best_plan(num_rep-1);
        ju=1
    else
        num_of_changes=num_of_changes+1;
        aux_same_result=0;
        if fit_values_rn{num_rep}(1)< best_plan(num_rep-1)
            best_plan(num_rep)=fit_values_rn{num_rep}(1);
            ju=2
        else
            best_plan(num_rep)=fit_values_rn{num_rep}(1);
            ju=5
        end
    end
    
%     if aux_same_result > stop_cond/4 && aux_same_result< stop_cond/2 %force some mutation
%             %mutation
%             mutation_rate_1=0.5;
%             mutation_idx_max=ceil(length(path_gen)*mutation_rate_1);
%             rng('shuffle');
%             mutation_idx_total=randperm(length(path_gen));
%             mutation_idx=mutation_idx_total(1:mutation_idx_max);
%             mutation_idx=[];
%             mutation_idx=1;
%             u=21;
%             cost_aux_3=100000;
%             while u< 20 && cost_aux_3>cost(1,1)
%                 for i=1:length(mutation_idx)
%                     if mutation_idx(i) == 1
%                         aux_mut_state='';
%                         aux_mut_event='';
%                         mut_off='';
%                         mut_off=path_gen{mutation_idx(i)};
%                         mut_off_events='';
%                         mut_off_events=path_events{mutation_idx(i)};
%                         rng('shuffle');
%                         idx_mut=1;%randi([1 ceil((length(mut_off)-1)/2)]);
%                         node_mut=mut_off(idx_mut);
%                         aux_mut_state=mut_off(1:idx_mut);
%                         aux_mut_event={mut_off_events{1:idx_mut-1}};
%                         aux=1;
%                         act_state=node_mut;% always start from the initial state
%                         ind=idx_mut+1;
%                         while aux
%                             if states{act_state,3} %verify if it is a marked state, if is then stop searching
%                                 aux=0;
%                                 break;
%                             end
%                             sz=size(states{act_state,2}); %between all the possible transitions from the state
%                             %           if sz>1 % a state with more than one path to choose
%                             %               divergent_states{j}(n)=act_state;
%                             %               idx_divergent_state{j}(n)=i;
%                             %               n=n+1;
%                             %           end
%                             rng('shuffle');
%                             r = randi([1 sz(1,1)],1,1); %choose a random one
%                             %             next_state= states{act_state,2}(r,2); %save the state
%                             %             %path_events{j}{i}= states{act_state,2}(r,1); %save the tansitions' event
%                             %             ind=ind+1;
%                             %             act_state=str2double(next_state);
%                             next_state= states{act_state,2}(r,2); %save the state
%                             aux_mut_event{ind-1}= {states{act_state,2}{r,1}}; %save the tansitions' event
%                             act_state=str2double(next_state);
%                             aux_mut_state(ind)=act_state; %save at the state being analyzed
%                             ind=ind+1;
%                         end
%                         old_offspring='';
%                         old_offspring= aux_mut_state ;
%                         old_offspring_event='';
%                         old_offspring_event=aux_mut_event;
%                         aux_mut_state='';
%                         aux_mut_event='';
%                         [aux_mut_state,aux_mut_event]=check_loops_fix_new(old_offspring,old_offspring_event);
%                         
%                         
%                         robotLocation=[];
%                         cost_robot=[];
%                         cost_robot=zeros(numRobots,1);
%                         for j=1:length(aux_mut_state)-1
%                             act_state=aux_mut_state(j);
%                             next_state=aux_mut_state(j+1);
%                             if j==1
%                                 for i_r = 1:numRobots
%                                     robotLocation{j,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
%                                 end
%                             end
%                             
%                             next_event=aux_mut_event{j}{1,1} ;
%                             event_bot = next_event(1)-96;
%                             currBotLoad = cost_robot(event_bot);
%                             for w = 1:numRobots  % Bot next load = current load + idle cost
%                                 cost_robot(w) = cost_robot(w) + max(0,currBotLoad - cost_robot(w));
%                             end
%                             %path_events{i}{j}{1,1}
%                             [transition_cost,~,new_X,new_Y] = ...
%                                 calcTransitionCost(next_event,act_state,next_state,aux_mut_state(1:j),states,tasks,0,regions,numRegions,start_loc,...
%                                 numTasks,abstracted,start_events_only,robotLocation{j,event_bot},robot_tasks,0);
%                             
%                             cost_robot(event_bot)=cost_robot(event_bot)+transition_cost;
%                             
%                             for jj = 1:numRobots
%                                 robotLocation{j+1,jj} = robotLocation{j,jj};
%                                 %robotTask(J,jj) = robotTask(I,jj);
%                             end
%                             
%                             robotLocation{j+1,event_bot} = [new_X,new_Y];
%                         end
%                         
%                         cost_aux_3=max(cost_robot);
%                         if cost_aux_3<cost(1,mutation_idx(i))
%                             path_gen{mutation_idx(i)}='';
%                             path_events{mutation_idx(i)}='';
%                             cost(1,mutation_idx(i))=cost_aux_3;
%                             path_gen{mutation_idx(i)}=aux_mut_state;
%                             path_events{mutation_idx(i)}=aux_mut_event;
%                             u=101;
%                         end
%                     end
%                 end
%                 u=u+1;
%             end
%             [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(cost);
%             
%             fit_values_rn{num_rep}(1)
%             best_plan(num_rep)
%             
%             if fit_values_rn{num_rep}(1)==best_plan(num_rep)
%                 %aux_same_result=aux_same_result+1;
%                 %best_plan(num_rep)=best_plan(num_rep-1);
%                 ju=2
%             else                
%                 if fit_values_rn{num_rep}(1)< best_plan(num_rep)
%                     aux_same_result=0;
%                     best_plan(num_rep)=fit_values_rn{num_rep}(1);
%                     ju=1
%                 end
%             end
%         
%     end
    [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(cost);
     best_event{num_rep}=path_events{idx_fit_aux{num_rep}(1)};
    num_rep=num_rep+1;
end

plan=path_events{idx_fit_aux{num_rep-1}(1)};
plan_state=path_gen{idx_fit_aux{num_rep-1}(1)};
plan_cost=cost(1);
end