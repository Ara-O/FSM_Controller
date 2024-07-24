 function [all_plan,plan,plan_state,plan_cost,num_spoint,initial_plan,num_of_changes,idx_change,trac_plan_cost,num_rep,t_dur,t_pop] = GA_Incremental_New_1(population_size,max_rep,mutation_rate,stop_cond,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,states_incr,events_incr,initial_state_incr,events)
num_of_changes=0;
abstracted = false;
start_events_only = false;
cost=[];
trac_plan_cost=0;
num_spoint=0;
num_paths=population_size; %number of paths to be generated
t2=tic;
j=1;
t7=tic;
[~,num_fsm] = size(states_incr);
event_list = createEventFsmList(events_incr,num_fsm);
while j<=num_paths
    cur_states=initial_state_incr;
    i=1;
    path_gen{j}='';
    path_events{j}='';
    path_gen{j}{i}=cur_states;
    while ~detectEndState(cur_states,states_incr,num_fsm)
        transition_list = createTransitionList(states_incr,cur_states,num_fsm);
        possible_transitions = findPossibleTransitions(transition_list,event_list);
        num_transitions = size(possible_transitions);      
        idx_pot=randi([1 num_transitions(1)]);
        detect_event=possible_transitions{idx_pot,1};        
        path_events{j}{i}=detect_event;
        cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);
        i=i+1; 
        path_gen{j}{i}=cur_states;
    end
    j=j+1;
end

t_pop(j)=toc(t7);
aux_dup=0;
    
t6=tic;
for i=1:length(path_gen)
    old_path_gen='';
    old_path_gen=path_gen{i};
    old_event_gen='';
    old_event_gen=path_events{i};
    path_gen{i}='';
    path_events{i}='';
    [path_gen{i},path_events{i}]=check_loops_fix_new_Incr(old_path_gen,old_event_gen,num_fsm); %remove the loops
    
end


old_gen='';
old_gen=path_gen;
old_even='';
old_even=path_events;
path_gen='';
path_events='';
[path_gen,path_events]=removeDup(old_gen,old_even);

for i=1:length(path_gen)  
    cost(1,i)=0;
    [cost(1,i),cost_trans{1}{i},cost_extra{1}{i}]= path_cost_Incr(path_gen{i},path_events{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
end

t_dur(1,1)=toc(t2);
t_dur(2,1)=0;
t_dur(3,1)=toc(t6);
%now, we have paths without loops   
    
[fit_values_rn{1}, idx_fit_aux{1}]=sort(cost(1,:));

best_plan(1)=fit_values_rn{1}(1);
initial_plan=best_plan(1);
best_event{1}=path_events{idx_fit_aux{1}(1)};
aux_same_result=0;
num_rep=2;

old_g=path_gen;
old_ev=path_events;
old_cost_extra=cost_extra;
cost_extra='';
path_gen='';
path_events='';

for i=1:length(idx_fit_aux{1})
    path_events{i}=old_ev{idx_fit_aux{1}(i)};
    path_gen{i}=old_g{idx_fit_aux{1}(i)};
    cost_extra{1}{i}=old_cost_extra{1}{idx_fit_aux{1}(i)};
end


while num_rep<max_rep && aux_same_result<stop_cond

%     num_spoint(num_rep)=0;
    pop_size=length(path_gen);
   
    offspring='';
    offspring_event='';
    cost_off=cost;
    cost_trans_off{num_rep}=cost_trans{num_rep-1}; 
    cost_extra_off{num_rep}=cost_extra{num_rep-1};
    
    %mutation

    mutation_idx_max=ceil(length(path_gen)*mutation_rate);
    %rng('shuffle');
    mutation_idx_total=randperm(length(path_gen));
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
%     mutation_idx=[1:mutation_idx_max];
%     mutation_idx(length(mutation_idx)+1)=1;
    t3=tic;
    t4=tic;
    for i=1:length(mutation_idx)
            mut_off='';
            mut_off=path_gen{mutation_idx(i)};
            mut_off_events='';
            mut_off_events=path_events{mutation_idx(i)};
            A=cost_extra_off{num_rep}{mutation_idx(i)};
            potential_nodes=[];
            pot_nodes=[];


            if mutation_idx(i)> fix(population_size/2)
                %rng('shuffle');
                idx_mut=randi([2 fix((length(mut_off))/2)]);
            else
                %rng('shuffle');
                idx_mut=randi([(fix((length(mut_off))/2)+1) (length(mut_off)-1)]);
            end

            
            offspring{i}='';
            offspring_event{i}='';
            offspring{i}={mut_off{1,1:idx_mut-1}};
            kj=idx_mut;
            offspring_event{i}={mut_off_events{1:idx_mut-2}};
            cur_states=mut_off{1,idx_mut-1};
            %detect_event=mut_off_events{idx_mut-1};
            %offspring_event{i}{kj-1}=detect_event;
            %cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);
            %offspring{i}{kj}=cur_states;
            while ~detectEndState(cur_states,states_incr,num_fsm)
                transition_list = createTransitionList(states_incr,cur_states,num_fsm);
                possible_transitions = findPossibleTransitions(transition_list,event_list);
                num_transitions = size(possible_transitions);
                idx_pot=randi([1 num_transitions(1)]);
                detect_event=possible_transitions{idx_pot,1};
                offspring_event{i}{kj-1}=detect_event;
                cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);
                offspring{i}{kj}=cur_states;
                kj=kj+1;
                
            end
            t5=tic;
            old_offspring='';
            old_offspring=offspring{i};
            old_offspring_event='';
            old_offspring_event=offspring_event{i};
            offspring{i}='';
            offspring_event{i}='';
            [offspring{i},offspring_event{i}]=check_loops_fix_new_Incr(old_offspring,old_offspring_event,num_fsm);
            cost_off(1,i)=0;
            cost_trans_off{num_rep}{i}=[];
            cost_extra_off{num_rep}{i}=[];
            [cost_off(1,i),cost_trans_off{num_rep}{i},cost_extra_off{num_rep}{i}]= path_cost_Incr(offspring{i},offspring_event{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
        t_dur(3,num_rep)=toc(t5);
    end
    t_dur(2,num_rep)=toc(t4);

   
    
    old_path='';
    old_path=path_gen;
    old_events='';
    old_events=path_events;

    
    max_path=length(old_path);
    
    for i_x=1:length(offspring)
        old_path{max_path+i_x}=offspring{i_x};
        old_events{max_path+i_x}=offspring_event{i_x};
    end
    
    old_gen='';
    old_gen=old_path;
    old_even='';
    old_even=old_events;
    old_path='';
    old_events='';
    [old_path,old_events]=removeDup(old_gen,old_even);

    for i=1:length(old_path)
        cost_aux(1,i)=0;
        [cost_aux(1,i),cost_trans_aux{num_rep}{i},cost_extra_aux{num_rep}{i}]= path_cost_Incr(old_path{i},old_events{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
    end
    
    
        
%     if ~isempty(cost_off)
%         cost_aux=[cost cost_off];
%         cost_trans_aux{num_rep}=[cost_trans{num_rep-1} cost_trans_off{num_rep}];
%         cost_extra_aux{num_rep}=[cost_extra{num_rep-1} cost_extra_off{num_rep}];
%     else
%         cost_aux=cost;
%         cost_trans_aux{num_rep}=[cost_trans{num_rep-1}];
%         cost_extra_aux{num_rep}=[cost_extra{num_rep-1}];
%     end
    
   
    aux_old_gen=old_path;
    aux_old_event=old_events;
    aux_old_cost=cost_aux;
    aux_old_cost_trans=cost_trans_aux{num_rep};
    aux_old_cost_extra=cost_extra_aux{num_rep}; 
    
    [fit_values_rn_aux{num_rep}, idx_fit_aux_2{num_rep}]=sort(cost_aux);
    cost=[];
    cost_trans{num_rep}=[];
    cost_extra{num_rep}=[];
    path_gen='';
    path_events='';
    max_path_2=length(old_path);
    
    if max_path_2 > population_size
        limit=population_size;
    else
        limit=max_path_2;
    end
%limit=population_size;
    for i=1:limit
        path_gen{i}=old_path{idx_fit_aux_2{num_rep}(i)};
        path_events{i}=old_events{idx_fit_aux_2{num_rep}(i)};
        cost(1,i)=cost_aux(idx_fit_aux_2{num_rep}(i));
        cost_trans{num_rep}{i}=cost_trans_aux{num_rep}{idx_fit_aux_2{num_rep}(i)};
        cost_extra{num_rep}{i}=cost_extra_aux{num_rep}{idx_fit_aux_2{num_rep}(i)};
    end
    
    cost_aux=[];

    [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(cost);
    
    if fit_values_rn{num_rep}(1)==best_plan(num_rep-1)
        aux_same_result=aux_same_result+1;
        best_plan(num_rep)=best_plan(num_rep-1);
    else
        num_of_changes=num_of_changes+1;
        idx_change(num_of_changes)=num_rep;
        aux_same_result=0;
        if fit_values_rn{num_rep}(1)< best_plan(num_rep-1)
            best_plan(num_rep)=fit_values_rn{num_rep}(1);
            trac_plan_cost(num_of_changes,1)=best_plan(num_rep-1);
            trac_plan_cost(num_of_changes,2)=best_plan(num_rep);
        else
            best_plan(num_rep)=fit_values_rn{num_rep}(1);
            %pause;
        end
    end
     t_dur(1,num_rep)=toc(t3);

    [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(cost);
    best_event{num_rep}=path_events{idx_fit_aux{num_rep}(1)};
    num_rep=num_rep+1;
end
if num_of_changes==0
    idx_change=0;
    trac_plan_cost=0;
end
plan=path_events{idx_fit_aux{num_rep-1}(1)};
plan_state=path_gen{idx_fit_aux{num_rep-1}(1)};
all_plan=best_event;
plan_cost=cost(1);
end