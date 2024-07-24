function [plan,plan_state,plan_cost] = GA_abstract_New(population_size,max_rep,mutation_rate,stop_cond,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks)
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
        if sz>1 % a state with more than one path to choose
            divergent_states{j}(n)=act_state;
            idx_divergent_state{j}(n)=i;
            n=n+1;
        end
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
            %robotTask(J,jj) = robotTask(I,jj);
        end
        
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
aux_same_result=0;
num_rep=2;

while num_rep<max_rep && aux_same_result<stop_cond

    num_spoint(num_rep)=0;
    num_sparent(num_rep)=0;
    %parents selection through tournament 2X2
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
                if parent_1(j)==parent_2(m)
                    cross_point{k}(1)=j;
                    cross_point{k}(2)=m;
                    k=k+1;
                end
            end
        end
        if ~isempty(cross_point)
            idx=randi([1 length(cross_point)]);
            offspring{i_off}=[parent_1(1:cross_point{idx}(1)),parent_2(cross_point{idx}(2)+1:end)];
            offspring_event{i_off}={path_events{parents(2*i-1)}{1:cross_point{idx}(1)-1},path_events{parents(2*i)}{cross_point{idx}(2):end}};
            offspring{i_off+1}=[parent_2(1:cross_point{idx}(2)),parent_1(cross_point{idx}(1)+1 :end)];
            offspring_event{i_off+1}={path_events{parents(2*i)}{1:cross_point{idx}(2)-1},path_events{parents(2*i-1)}{cross_point{idx}(1):end}};
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
    
    %mutation
    %mutation_rate=0.4;
    mutation_idx_max=ceil(length(offspring)*mutation_rate);
    mutation_idx_total=randperm(length(offspring));
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    
    for i=1:length(mutation_idx)
        mut_off='';
        mut_off=offspring{mutation_idx(i)};
        mut_off_events='';
        mut_off_events=offspring_event{mutation_idx(i)};
        idx_mut=randi([2 (length(mut_off)-1)]);
        node_mut=mut_off(idx_mut);
        offspring{mutation_idx(i)}='';
        offspring_event{mutation_idx(i)}='';
        offspring{mutation_idx(i)}=mut_off(1:idx_mut);
        offspring_event{mutation_idx(i)}={mut_off_events{1:idx_mut-1}};
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
            r = randi([1 sz(1,1)],1,1); %choose a random one
%             next_state= states{act_state,2}(r,2); %save the state
%             %path_events{j}{i}= states{act_state,2}(r,1); %save the tansitions' event
%             ind=ind+1;
%             act_state=str2double(next_state);
            next_state= states{act_state,2}(r,2); %save the state
            offspring_event{mutation_idx(i)}{ind-1}= {states{act_state,2}{r,1}}; %save the tansitions' event            
            act_state=str2double(next_state);
            offspring{mutation_idx(i)}(ind)=act_state; %save at the state being analyzed
            ind=ind+1;
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
    
    
    
    
    path_gen_old='';
    path_gen_old=path_gen;
    path_gen='';
    path_events_old='';
    path_events_old=path_events;
    path_events='';
%     for i=1:length(parents)
%         path_gen{i}=path_gen_old{parents(i)}; %copy parents to the new population
%         path_events{i}=path_events_old{parents(i)};
%     end
    max_path=length(path_gen_old);
    for i=1:length(offspring)
        path_gen_old{max_path+i}=offspring{i};
        path_events_old{max_path+i}=offspring_event{i};
    end
    %check the path of events for offsprings
    
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
            %robotTask(J,jj) = robotTask(I,jj);
        end
        
        robotLocation{j+1,event_bot} = [new_X,new_Y];
    end
    cost_off(1,i)=max(cost_robot);
end

if ~isempty(cost_off)    
    cost_aux=[cost cost_off];
else
    cost_aux=cost;
end
    
%     for i=1:length(path_events_old)
%                 fit_values(i)=path_total_cost(path_events{1,i});
%         [cost_aux(num_rep,i),fit_aux_values_A(i),fit_aux_values_B(i),fit_aux_values_C(i)]=path_total_cost(path_events_old{1,i});
%     end
    
    [fit_values_rn_aux{num_rep}, idx_fit_aux_2{num_rep}]=sort(cost_aux);
    cost=[];
    
    for i=1:num_paths
        path_gen{i}=path_gen_old{idx_fit_aux_2{num_rep}(i)};
        path_events{i}=path_events_old{idx_fit_aux_2{num_rep}(i)};
        cost(1,i)=cost_aux(idx_fit_aux_2{num_rep}(i));
    end
    
    

    
    [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(cost);
    
    if fit_values_rn{num_rep}(1)==best_plan(num_rep-1)
        aux_same_result=aux_same_result+1;
        best_plan(num_rep)=best_plan(num_rep-1);
    else
        aux_same_result=0;
        if fit_values_rn{num_rep}(1)< best_plan
            best_plan(num_rep)=fit_values_rn{num_rep}(1);
        end
    end
    
    num_rep=num_rep+1;
end

plan=path_events{idx_fit_aux{num_rep-1}(1)};
plan_state=path_gen{idx_fit_aux{num_rep-1}(1)};
plan_cost=cost(1);
end