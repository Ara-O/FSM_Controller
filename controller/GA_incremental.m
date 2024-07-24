function [plan,plan_state,best_time] = GA_incremental(population_size,max_rep,mutation_rate,stop_cond,robot_tasks,initial_state_incr,states_incr,events_incr,start_loc,regions,numRegions,tasks,numTasks,numRobots)
EEC=0;

% Alter menu options to run local Dijkstra
abstracted = true;
start_events_only = false;

[~,num_fsm] = size(states_incr);

t_total=tic;
t_pop=tic;
event_path = [];
cur_states = initial_state_incr;
state_path = cur_states;

% global_state_path

[~,num_fsm] = size(states_incr);

a=0;
event_list = createEventFsmList(events_incr,num_fsm);

num_paths=population_size; %number of paths to be generated

ju=0;

for j=1:population_size
    event_path{j} = [];
    cur_states = initial_state_incr;
    state_path{j} = cur_states;
    a=0;
    i=1;
    u=1;
    cost(1,j)=0;
    robotLocation=[];
    cost_robot=[];
    cost_robot=zeros(numRobots,1);
    trans_mat=[];
    path=[];
    while a==0
        transition_list = createTransitionList(states_incr,cur_states,num_fsm);
        possible_transitions = findPossibleTransitions(transition_list,event_list);
        if i==1
            for i_r = 1:numRobots
                robotLocation{i,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
            end
        end
        
        if detectEndState(cur_states,states_incr,num_fsm)
            a=1;
            break; %Exit  LOOP
        end %
        num_events=length(possible_transitions);
        next_event_idx=randi([1 num_events]);
        
        next_event=possible_transitions{next_event_idx,1};
        pos_cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm);
        aux=0;
        for k=1:i
            loop=cellfun(@isequal,state_path{j}(k,:),pos_cur_states);
            if sum(loop)==num_fsm %equal state
                aux=1;
                u=k;
                break;
            end
        end
        if aux==1%remove loop
            if u<i-1
                %ju=state_path{j};
                state_path{j}(u+1:i,:)=[];
                i=u;
                %pause;
            end
        end
        if aux==0
            trans_mat{i,1}=cur_states;
            trans_mat{i,2}{1,1}=next_event;
            cur_states=pos_cur_states;
            state_path{j} = [state_path{j};cur_states];
            event_path{j} = [event_path{j};next_event];
            path(i)=i;
            trans_mat{i,2}{1,2}=i+1;
            i=i+1;
            event_bot = next_event(1)-96;
            %           next_event
            [transition_cost,~,new_X,new_Y] = ...
                calcTransitionCostGA(next_event,i-1,i,path,trans_mat,tasks,EEC,regions,numRegions,start_loc,...
                numTasks,abstracted,start_events_only,robotLocation{i-1,event_bot},robot_tasks,1);
            
            %           transition_cost
            
            for i_rob=1:numRobots
                if event_bot==i_rob
                    cost_robot(i_rob)=cost_robot(i_rob)+transition_cost;
                    robotLocation{i,event_bot} = [new_X,new_Y];
                else
                    robotLocation{i,i_rob} = robotLocation{i-1,i_rob};
                end
                
            end
            
            currBotLoad = cost_robot(event_bot);
            % Adds Idle cost only to event owner bot
            idle_cost = max(0,max(cost_robot(:)) - currBotLoad);
            % Bot next load = current load + idle cost
            cost_robot(event_bot) = cost_robot(event_bot) + idle_cost;
            
            
            
        end
    end
    cost(1,j)=max(cost_robot);
end

% for i=1:num_paths
%     %         fit_values(i)=path_total_cost(path_events{1,i});
%     [cost(1,i),fit_values_A(i),fit_values_B(i),fit_values_C(i)]=path_total_cost__21_07(event_path{i});
% end

[fit_values_rn{1}, idx_fit_aux{1}]=sort(cost(1,:));
best_plan(1)=fit_values_rn{1}(1);
best_plan_event{1}=event_path{idx_fit_aux{1}(1)};
aux_same_result=0;
num_rep=2;

t_end_pop=toc(t_pop);
t_evol=tic;
while num_rep<=max_rep && aux_same_result<=stop_cond
%     disp('Evolution Phase')
    num_spoint(num_rep)=0;
    num_sparent(num_rep)=0;
    %parents selection through tournament 2X2
    order=randperm(num_paths);
    for i=1:length(order)/2
        if cost(1,order(2*i-1))<cost(1,order(2*i))
            parents(i)=order(2*i-1);
        else
            parents(i)=order(2*i);
        end
    end
    
    %crossover
    offspring='';
%     disp('Crossover Operation')
    for i=1:length(parents)/2
        parent_1=state_path{parents(2*i-1)};
        parent_1_event=event_path{parents(2*i-1)};
        parent_2=state_path{parents(2*i)};
        parent_2_event=event_path{parents(2*i)};
        k=1;
        cross_point='';
        
        for j=2:length(parent_1)-1%looking for same point,that can't be start or finish node
            for m=2:length(parent_2)-1
                crossp=strcmp(parent_1(j,:),parent_2(m,:));
                if sum(crossp)==num_fsm %equal state
                    cross_point{k}(1)=j;
                    cross_point{k}(2)=m;
                    k=k+1;
                end
            end
        end
        if ~isempty(cross_point)
            idx=randi([1 length(cross_point)]);
            offspring_aux=[];
            offspring_event_aux=[];
            offspring_aux=[parent_1(1:cross_point{idx}(1),:);parent_2(cross_point{idx}(2)+1:end,:)];
            offspring_event_aux=[parent_1_event(1:cross_point{idx}(1)-1,:);parent_2_event(cross_point{idx}(2):end,:)];
            offspring{2*i}=[parent_2(1:cross_point{idx}(2),:);parent_1(cross_point{idx}(1)+1:end,:)];
            offspring_event{2*i}=[parent_2_event(1:cross_point{idx}(2)-1,:);parent_1_event(cross_point{idx}(1):end,:)];
            [offspring{2*i-1},offspring_event{2*i-1},aux_dup]=remove_cycles(offspring_aux,offspring_event_aux,num_fsm);
            ju=ju+aux_dup;
            offspring_aux=[];
            offspring_event_aux=[];
            offspring_aux=[parent_2(1:cross_point{idx}(2),:);parent_1(cross_point{idx}(1)+1:end,:)];
            offspring_event_aux=[parent_2_event(1:cross_point{idx}(2)-1,:);parent_1_event(cross_point{idx}(1):end,:)];
            [offspring{2*i},offspring_event{2*i},aux_dup]=remove_cycles(offspring_aux,offspring_event_aux,num_fsm);
            ju=ju+aux_dup;
            num_spoint(num_rep)=num_spoint(num_rep)+1;
        else
            offspring{2*i-1}=parent_1;
            offspring_event{2*i-1}=parent_1_event;
            offspring{2*i}= parent_2;
            offspring_event{2*i}= parent_2_event;
            num_sparent(num_rep)=num_sparent(num_rep)+1;
        end
    end
    
%     disp('Mutation Operation')
    %mutation
    %mutation_rate=0.1;
    mutation_idx_max=ceil(length(offspring)*mutation_rate);
    mutation_idx_total=randperm(length(offspring));
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    %
    for i=1:length(mutation_idx)
        mut_off='';
        mut_off=offspring{mutation_idx(i)};
        mut_off_event= offspring_event{mutation_idx(i)};
        idx_mut=randi([1 length(mut_off)]);
        node_mut=mut_off(idx_mut,:);
        offspring{mutation_idx(i)}='';
        offspring_event{mutation_idx(i)}='';
        if idx_mut==1
            offspring{mutation_idx(i)}=[];
            offspring{mutation_idx(i)}=mut_off(1:idx_mut,:);
            offspring_event{mutation_idx(i)}=[];
            offspring_event{mutation_idx(i)}=mut_off_event(1:idx_mut,:);
            cur_states=mut_off(idx_mut,:);
        else
            offspring{mutation_idx(i)}=[];
            offspring{mutation_idx(i)}=mut_off(1:idx_mut-1,:);
            offspring_event{mutation_idx(i)}=[];
            offspring_event{mutation_idx(i)}=mut_off_event(1:idx_mut-1,:);
            cur_states=mut_off(idx_mut-1,:);
        end
        a=0;
        
        while a==0
            transition_list = createTransitionList(states_incr,cur_states,num_fsm);
            possible_transitions = findPossibleTransitions(transition_list,event_list);
            
            
            if detectEndState(cur_states,states_incr,num_fsm)
                a=1;
                break; %Exit  LOOP
            end %
            num_events=length(possible_transitions);
            next_event_idx=randi([1 num_events]);
            
            next_event=possible_transitions{next_event_idx,1};
            pos_cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm);
            aux=0;
            m=size(offspring{mutation_idx(i)});
            for k=1:m(1)
                loop=cellfun(@isequal,offspring{mutation_idx(i)}(k,:),pos_cur_states);
                if sum(loop)==num_fsm %equal state
                    aux=1;
                    u=k;
                    break;
                end
            end
            if aux==1%remove loop
                if u<m(1)-1
                    %ju=state_path{j};
                    offspring{mutation_idx(i)}(u+1:m(1),:)=[];
                    offspring_event{mutation_idx(i)}(u+1:m(1),:)=[];
                    m=u;
                    %pause;
                end
            end
            if aux==0
                cur_states=pos_cur_states;
                offspring{mutation_idx(i)} = [offspring{mutation_idx(i)};cur_states];
                offspring_event{mutation_idx(i)} = [offspring_event{mutation_idx(i)};next_event];
                
                
                m(1)=m(1)+1;
            end
        end
    end
    
    
    
    
    
    for i=1:length(offspring)
        cost_off(1,i)=0;
        robotLocation=[];
        cost_robot=[];
        trans_mat=[];
        path=[];
        cost_robot=zeros(numRobots,1);
        for j=1:length(offspring{i})-1
            if j==1
                for i_r = 1:numRobots
                    robotLocation{j,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
                end
            end
            
            cur_states=offspring{i}(j,:);
            next_event=offspring_event{i}(j,:);
            %pos_cur_states=offspring{i}{j+1};
            trans_mat{j,1}=cur_states;
            trans_mat{j,2}{1,1}=next_event;
            %cur_states=pos_cur_states;
            %             state_path{j} = [state_path{j};cur_states];
            %             event_path{j} = [event_path{j};next_event];
            path(j)=j;
            trans_mat{j,2}{1,2}=j+1;
            %i=i+1;
            event_bot = offspring_event{i}(j,1)-96;
            [transition_cost,~,new_X,new_Y] = ...
                calcTransitionCostGA(next_event,j,j+1,path,trans_mat,tasks,EEC,regions,numRegions,start_loc,...
                numTasks,abstracted,start_events_only,robotLocation{j,event_bot},robot_tasks,1);
            %             next_event
            %             transition_cost
            for i_rob=1:numRobots
                if event_bot==i_rob
                    cost_robot(i_rob)=cost_robot(i_rob)+transition_cost;
                    robotLocation{j+1,event_bot} = [new_X,new_Y];
                else
                    robotLocation{j+1,i_rob} =robotLocation{j,i_rob} ;
                end
            end
            currBotLoad = cost_robot(event_bot);
            % Adds Idle cost only to event owner bot
            idle_cost = max(0,max(cost_robot(:)) - currBotLoad);
            % Bot next load = current load + idle cost
            cost_robot(event_bot) = cost_robot(event_bot) + idle_cost;
            
        end
        cost_off(1,i)=max(cost_robot);
    end
    
    
    path_gen='';
    path_gen_event='';
    path_gen=[state_path,offspring];
    path_gen_event=[event_path,offspring_event];
    state_path='';
    offspring='';
    event_path='';
    offspring_event='';
    %      for i=1:length(path_gen)
    %         %         fit_values(i)=path_total_cost(path_events{1,i});
    %         [cost_aux(num_rep,i),fit_aux_values_A(i),fit_aux_values_B(i),fit_aux_values_C(i)]=path_total_cost__21_07(path_gen_event{i});
    %     end
    
    %
%     disp('Selection of the next population')
    cost_aux=[cost cost_off];
    [fit_values_rn_aux{num_rep}, idx_fit_aux_2{num_rep}]=sort(cost_aux);
    cost=[];
    for i=1:num_paths
        state_path{i}=path_gen{idx_fit_aux_2{num_rep}(i)};
        event_path{i}=path_gen_event{idx_fit_aux_2{num_rep}(i)};
        cost(1,i)=cost_aux(idx_fit_aux_2{num_rep}(i));
    end
    
    
    
    [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(cost);
    %
    if fit_values_rn{num_rep}(1)==best_plan(num_rep-1)
%         disp('Same optimal value')
        aux_same_result=aux_same_result+1;
        best_plan(num_rep)=best_plan(num_rep-1);
        best_plan_event{num_rep}=event_path{idx_fit_aux{num_rep}(1)};
    else
        aux_same_result=0;
%         disp('New optimal value!')
        if fit_values_rn{num_rep}(1)< best_plan
            best_plan(num_rep)=fit_values_rn{num_rep}(1);
            best_plan_event{num_rep}=event_path{idx_fit_aux{num_rep}(1)};
        end
    end
    num_rep=num_rep+1;
end
t_end_evol=toc(t_evol);
t_end_total=toc(t_total);
plan=event_path{idx_fit_aux{num_rep-1}(1)};
plan_state=state_path{idx_fit_aux{num_rep-1}(1)};
% disp('Total time optimization')
% disp(t_end_total)
% disp('Best plan')
% disp(plan)
% disp('Best time')
% disp(best_plan(num_rep-1))
best_time=best_plan(num_rep-1);
end