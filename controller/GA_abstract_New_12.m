function [plan,plan_state,plan_cost,num_spoint,initial_plan,num_of_changes,idx_change,trac_plan_cost,num_rep,t_dur,t_pop] = GA_abstract_New_12(population_size,max_rep,mutation_rate,stop_cond,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks)
num_of_changes=0;
abstracted = true;
start_events_only = true;
cost=[];
trac_plan_cost=0;
num_spoint=0;
num_paths=population_size; %number of paths to be generated
t2=tic;
for j=1:population_size
    aux=1;
    act_state=1;% always start from the initial state
    i=1;
    n=1;
    t7=tic;
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
        %rng('shuffle');   
        r = randi([1 sz(1,1)],1,1);%choose a random one
        next_state= states{act_state,2}(r,2); %save the state
        path_events{j}{i}= states{act_state,2}(r,1); %save the tansitions' event
        i=i+1;
        act_state=str2double(next_state);
    end
    t_pop(j)=toc(t7);
end
aux_dup=0;
%check if there are loops in the path
t6=tic;
for i=1:length(path_gen)
    old_path_gen='';
    old_path_gen=path_gen{i};
    old_event_gen='';
    old_event_gen=path_events{i};
    path_gen{i}='';
    path_events{i}='';
    [path_gen{i},path_events{i}]=check_loops_fix_new(old_path_gen,old_event_gen); %remove the loops
    cost(1,i)=0;
    [cost(1,i),cost_trans{1}{i},cost_extra{1}{i}]= path_cost(path_gen{i},path_events{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);

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
path_gen='';
path_events='';

for i=1:length(idx_fit_aux{1})
    path_events{i}=old_ev{idx_fit_aux{1}(i)};
    path_gen{i}=old_g{idx_fit_aux{1}(i)};
end


while num_rep<max_rep && aux_same_result<stop_cond

%     num_spoint(num_rep)=0;
    pop_size=length(path_gen);
   
    offspring=path_gen;
    offspring_event=path_events;
    cost_off=cost;
    cost_trans_off{num_rep}=cost_trans{num_rep-1}; 
    cost_extra_off{num_rep}=cost_extra{num_rep-1};
    
    %mutation

    mutation_idx_max=ceil(length(offspring)*mutation_rate);
    %rng('shuffle');
    mutation_idx_total=randperm(length(offspring));
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    %mutation_idx=[1:mutation_idx_max];
    t3=tic;
    t4=tic;
    for i=1:length(mutation_idx)
            mut_off='';
            mut_off=offspring{mutation_idx(i)};
            mut_off_events='';
            mut_off_events=offspring_event{mutation_idx(i)};
            A=cost_extra{num_rep-1}{mutation_idx(i)};
            potential_nodes=[];
            pot_nodes=[];

            for kk=1:numRobots
                CC=[];
                CC=find(A(kk,:)~=0);
                if ~isempty(CC)
                    c=length(potential_nodes);
                    for ij=1:length(CC)
                     potential_nodes(1,c+ij)=CC(1,ij);
                    end
                    
                end

            end
            
            if ~isempty(potential_nodes)
                pot_nodes=unique(potential_nodes);
                %rng('shuffle');
                idx_pot=randi([1 length(pot_nodes)]);
                idx_mut=pot_nodes(idx_pot);
                
            else
                if mutation_idx(i)> fix(population_size/2)
                    %rng('shuffle');
                    idx_mut=randi([2 fix((length(mut_off))/2)]);
                else
                    %rng('shuffle');
                    idx_mut=randi([fix((length(mut_off))/2) (length(mut_off))]);
                end
            end
            
            
            node_mut=mut_off(idx_mut-1);
            offspring{mutation_idx(i)}='';
            offspring_event{mutation_idx(i)}='';
            offspring{mutation_idx(i)}=mut_off(1:idx_mut-1);
            offspring_event{mutation_idx(i)}={mut_off_events{1:idx_mut-2}};
            aux=1;
            act_state=node_mut;% always start from the initial state
            ind=idx_mut;
            while aux
                if states{act_state,3} %verify if it is a marked state, if is then stop searching
                    aux=0;
                    break;
                end
                sz=size(states{act_state,2}); %between all the possible transitions from the state
                %rng('shuffle')
                r = randi([1 sz(1,1)],1,1); %choose a random one
                next_state= states{act_state,2}(r,2); %save the state
                offspring_event{mutation_idx(i)}{ind-1}= {states{act_state,2}{r,1}}; %save the tansitions' event
                act_state=str2double(next_state);
                offspring{mutation_idx(i)}(ind)=act_state; %save at the state being analyzed
                ind=ind+1;
            end
            t5=tic;
            old_offspring='';
            old_offspring=offspring{mutation_idx(i)};
            old_offspring_event='';
            old_offspring_event=offspring_event{mutation_idx(i)};
            offspring{mutation_idx(i)}='';
            offspring_event{mutation_idx(i)}='';
            [offspring{mutation_idx(i)},offspring_event{mutation_idx(i)}]=check_loops_fix_new(old_offspring,old_offspring_event);
            cost_off(1,mutation_idx(i))=0;
            cost_trans_off{num_rep}{mutation_idx(i)}=[];
            cost_extra_off{num_rep}{mutation_idx(i)}=[];
            [cost_off(1,mutation_idx(i)),cost_trans_off{num_rep}{mutation_idx(i)},cost_extra_off{num_rep}{mutation_idx(i)}]= path_cost(offspring{mutation_idx(i)},offspring_event{mutation_idx(i)},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
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
    
     
    if ~isempty(cost_off)
        cost_aux=[cost cost_off];
        cost_trans_aux{num_rep}=[cost_trans{num_rep-1} cost_trans_off{num_rep}];
        cost_extra_aux{num_rep}=[cost_extra{num_rep-1} cost_extra_off{num_rep}];
    else
        cost_aux=cost;
        cost_trans_aux{num_rep}=[cost_trans{num_rep-1}];
        cost_extra_aux{num_rep}=[cost_extra{num_rep-1}];
    end
    
   
    aux_old_gen=old_path;
    aux_old_event=old_events;
    aux_old_cost=cost_aux;
    aux_old_cost_trans=cost_trans_aux{num_rep};
    aux_old_cost_extra=cost_extra_aux{num_rep};
    
    old_path='';
    old_events='';
    cost_aux=[];
    cost_trans_aux{num_rep}=[];
    cost_extra_aux{num_rep}=[];
    
    old_path{1}=aux_old_gen{1};
    old_events{1}=aux_old_event{1};
    cost_aux(1)=aux_old_cost(1);
    cost_trans_aux{num_rep}{1}=aux_old_cost_trans{1};
    cost_extra_aux{num_rep}{1}=aux_old_cost_extra{1};
    
    for ik=2:length(aux_old_gen)
        b=length(old_path);
        auxk=1;
        for il=1:b
            if sum(aux_old_gen{ik}==old_path{il})>=length(old_path{1})
                auxk=0;
                break;
            end
        end
        if auxk
            old_path{b+1}=aux_old_gen{ik};
            old_events{b+1}=aux_old_event{ik};
            cost_aux(b+1)=aux_old_cost(ik);
            cost_trans_aux{num_rep}{b+1}=aux_old_cost_trans{ik};
            cost_extra_aux{num_rep}{b+1}=aux_old_cost_extra{ik};
        end
    end

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
plan_cost=cost(1);
end