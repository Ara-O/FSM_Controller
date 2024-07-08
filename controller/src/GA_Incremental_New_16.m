%Implementation of Clusters,No Crossover and Mutation at Idle_Cost, choose
%randomly a state from the beginning til state chosed
%States Forcing a different transition
%Plan
function [all_plan,plan,plan_state,plan_cost,num_spoint,initial_plan,num_of_changes,idx_change,trac_plan_cost,num_rep,t_dur,t_pop] = GA_Incremental_New_15(population_size,max_rep,mutation_rate,stop_cond,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,states_incr,events_incr,initial_state_incr,initial_state,events)
num_of_changes=0;
abstracted = false;
start_events_only = false;
cost=[];
trac_plan_cost=0;
num_spoint=0;
num_paths=population_size; %number of paths to be generated
change_value=0;
j=1;

[~,num_fsm] = size(states_incr);
event_list = createEventFsmList(events_incr,num_fsm);
[path_abs]=popAbsCluster(100,events,numTasks,numRobots,4);
num_paths=length(path_abs);
population_size=num_paths;
aux_full=0;
tic;
while j<=num_paths
    [path_gen{j},path_events{j}]=createChromossome(path_abs(j),states_incr,num_fsm,initial_state_incr,event_list,events_incr);
    path_abs_full{j}=stripEventPathMod(path_events{j});
    aux_full=aux_full+checkAbsPath(path_abs_full{j},path_abs);
    j=j+1; %once it reaches the marked state, it completes one plan and goes to start the next plan
end
t_pop=toc;
aux_dup=0;
    

%for every plan generated it is necessary to remove possible loops in it
%for that, there is a function that receives the plan path of states and
%events and returns the plan without the loops
for i=1:length(path_gen)
    old_path_gen='';
    old_path_gen=path_gen{i};
    old_event_gen='';
    old_event_gen=path_events{i};
    path_gen{i}='';
    path_events{i}='';
    old_size(i)=length(old_path_gen);
    [path_gen{i},path_events{i}]=check_loops_fix_new_Incr(old_path_gen,old_event_gen,num_fsm); %remove the loops
    new_size(i)=length(path_gen{i});
end

diff=old_size-new_size;

figure
plot(diff);
title('Difference of size removing cycles');

old_gen='';
old_gen=path_gen;
old_even='';
old_even=path_events;
path_gen='';
path_events='';
%once the population is created and loops are removed, it removes any
%duplicated plan that might have at the population. The idea is to have a
%population with only different plans
[path_gen,path_events]=removeDup(old_gen,old_even);

%with a population formed only by different individuals, it calculates the
%cost for each individual
for i=1:length(path_gen)  
    cost(1,i)=0;
    [cost(1,i),cost_trans{1}{i},cost_extra{1}{i}]= path_cost_Incr(path_gen{i},path_events{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
end

%plot cost of population to see the distribution of it
figure;
plot(cost);
title('Cost Initial Population');


%we sort out the paths based on their cost value,from smaller to biggest cost   
[fit_values_rn{1}, idx_fit_aux{1}]=sort(cost(1,:));

%save the plan with smallest cost as the best plan
best_plan(1)=fit_values_rn{1}(1);
initial_plan=best_plan(1);
best_event{1}=path_events{idx_fit_aux{1}(1)};

aux_same_result=0;
num_rep=2;

% old_g=path_gen;
% old_ev=path_events;
% old_cost_extra=cost_extra;
% cost_extra='';
% path_gen='';
% path_events='';

%it organizes the population based on their sorted cost
% for i=1:length(idx_fit_aux{1})
%     path_events{i}=old_ev{idx_fit_aux{1}(i)};
%     path_gen{i}=old_g{idx_fit_aux{1}(i)};
%     cost_extra{1}{i}=old_cost_extra{1}{idx_fit_aux{1}(i)};
% end


%this is the main part of the genetic algorithm code. It keeps running
%until the number of repetitions doesn't reach the maximum number allowed
%or if the number of the same result of best plan is kept underr the value
%set as stop condition
while num_rep<max_rep && aux_same_result<stop_cond

    %since we are removing duplicates from the population, we can not
    %assume the population size is kept the same as set prior, so we grab
    %the actual population size
    pop_size=length(path_gen);
   
    offspring='';
    offspring_event='';
    %cost_off=cost;
    cost_trans_off{num_rep}=cost_trans{num_rep-1}; 
    cost_extra_off{num_rep}=cost_extra{num_rep-1};
    
    % Crossover %%
    
    %randomly distributes the indexes of population
    pos_couples=randperm(length(path_gen));
    
    total_cost=sum(1./cost);
    t1=tic;
        limit_k=0.75;
        pos_couples=randperm(length(path_gen));
        ind=1;
        for i=1:2:(length(pos_couples)-1)
            par_1=pos_couples(i);
            par_2=pos_couples(i+1);
            
            choose=0.5;
            
            if choose > limit_k
                if cost(par_1) > cost(par_2)
                    couples(ind)=par_1;
                else
                    couples(ind)=par_2;
                end
            else
                if cost(par_1) < cost(par_2)
                    couples(ind)=par_1;
                else
                    couples(ind)=par_2;
                end
            end
            ind=ind+1;
        end
        t_dur(1,num_rep)=toc(t1);
    ind=1;
    final_couples=randperm(length(couples));
    final_couples_trac{num_rep}=final_couples;
    t2=tic;
    for i=1:2:(length(couples)-1)
        p1=couples(final_couples(i));
        p2=couples(final_couples(i+1));
        
        parent_1='';
        parent_2='';
        parent_1_events='';
        parent_2_events='';
        parent_1=path_gen{p1}; %save the plan-states for parent 1
        parent_1_events=path_events{p1};%save the plan-events for parent 1
        parent_2=path_gen{p2};%save the plan-states for parent 2
        parent_2_events=path_events{p2};%save the plan-events for parent 2
        
        cost_parent_1=cost(p1);%save the cost of plan of parent 1
        cost_parent_2=cost(p2);%save the cost of plan of parent 2
        
        
        jindex=[]; %array to select the position where parents share same state
        %it looks for the position where parents share the same states. The
        %function chooseSameState finds all shared states and randomly
        %choose one of these shared states to be the position where the
        %crossover will occurr
        [jindex,num_same]=chooseSameState(parent_1,parent_2,num_fsm);
        
        num_same_states{num_rep,i}=num_same;
        if ~isempty(jindex) %check if there is a shared state
            
            %if there is a shared state, it crops the parent 1 until that
            %state and grab the end part from parent 2
            total_cost_parents{num_rep}(ind)=cost_parent_1;
            
            if mod(change_value,5)~=0 && aux_same_result<10
            old_offspring={parent_1{1:jindex(1)},parent_2{jindex(2)+1:end}};
            old_offspring_event={parent_1_events{1:jindex(1)-1},parent_2_events{jindex(2):end}};                   
            
            [offspring{ind},offspring_event{ind}]=check_loops_fix_new_Incr(old_offspring,old_offspring_event,num_fsm);
            
            if mod(num_rep,2)==0
                [offspring{ind},offspring_event{ind}] = newCrossover(3,offspring_event{ind},states_incr,num_fsm,initial_state_incr,event_list,events_incr);
            end
            else
                [offspring{ind},offspring_event{ind}] = newCrossover(3,parent_1_events,states_incr,num_fsm,initial_state_incr,event_list,events_incr);
            end
            ind=ind+1;
            total_cost_parents{num_rep}(ind)=cost_parent_1;
            % as second offspring, it takes the beginning of parent 2 and
            % end of parent 1
            
            if mod(change_value,5) ~=0 && aux_same_result<10
                old_offspring='';
                old_offspring_event='';
                old_offspring={parent_2{1:jindex(2)},parent_1{jindex(1)+1:end}};
                old_offspring_event={parent_2_events{1:jindex(2)-1},parent_1_events{jindex(1):end}};
                [offspring{ind},offspring_event{ind}]=check_loops_fix_new_Incr(old_offspring,old_offspring_event,num_fsm);
                if mod(num_rep,2)==0
                    [offspring{ind},offspring_event{ind}] = newCrossover(3,offspring_event{ind},states_incr,num_fsm,initial_state_incr,event_list,events_incr);
                end
           else
                [offspring{ind},offspring_event{ind}] = newCrossover(3,parent_2_events,states_incr,num_fsm,initial_state_incr,event_list,events_incr);
            end
            
            ind=ind+1;
            
        end
        
    end
    

    t_dur(2,num_rep)=toc(t2);
    
    for kr=1:length(offspring)
        [cost_aux_off,cost_trans_aux_off,cost_extra_aux_off]= path_cost_Incr(offspring{kr},offspring_event{kr},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
        total_cost_off_cros{num_rep}(kr)=cost_aux_off;
    end
    
    old_path_1='';
    old_path_1=path_gen;
    old_events_1='';
    old_events_1=path_events;
    
    
    max_path=length(old_path_1);
    
    for i_x=1:length(offspring)
        old_path_1{max_path+i_x}=offspring{i_x};
        old_events_1{max_path+i_x}=offspring_event{i_x};
    end
  
    old_gen='';
    old_gen=old_path_1;
    old_even='';
    old_even=old_events_1;
    old_path_1='';
    old_events_1='';
    %once the population is created and loops are removed, it removes any
    %duplicated plan that might have at the population. The idea is to have a
    %population with only different plans
    [old_path_1,old_events_1]=removeDup(old_gen,old_even);
    
    num_previous=length(old_gen);
    num_post=length(old_path_1);
    
    eficiency_crossover(num_rep,1)=num_previous;
    eficiency_crossover(num_rep,2)=num_post;
    
    
    % Mutation %%%%%
    
    %At this part, we will apply yje mutation to part of the offspring
    %based on the mutation_rate we decide how many from the offpring will
    %suffer mutation
    
    t3=tic;
    mutation_rate=0;
    if mod(change_value,5)==0 || aux_same_result>10
        mutation_rate=0.2;
    end
    mutation_idx_max=ceil(length(offspring)*mutation_rate);
    %it randomly distributes the indexes of offspring
    mutation_idx_total=randperm(length(offspring));
    %it selects until the total number of plans that will suffer mutation
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    mutation_idx_trac{num_rep}=mutation_idx;

    old_cost_mut=[];
    new_cost_mut=[];
    
%     if aux_same_result > 50
%         for i=1:length(mutation_idx)
%             old_offspring=stripEventPathMod(offspring_event{mutation_idx(i)});
%             old_offspring_abs=convertToMask(old_offspring);
%             offspring{mutation_idx(i)}='';
%             offspring_event{mutation_idx(i)}='';
%             offspring_abs=mutationAbs(old_offspring_abs);
%             path_j = convertToEvent(offspring_abs,events,numTasks);
%             [offspring{mutation_idx(i)},offspring_event{mutation_idx(i)}] = createChromossome(path_j,states_incr,num_fsm,initial_state_incr,event_list,events_incr);
%             
%             
%         end
%     else
        for i=1:length(mutation_idx)
           cost_extra_aux_off=[];
            
            [cost_aux_off,cost_trans_aux_off,cost_extra_aux_off]= path_cost_Incr(offspring{mutation_idx(i)},offspring_event{mutation_idx(i)},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
            
            
            
            mut_off='';
            mut_off=offspring{mutation_idx(i)};
            offspring{mutation_idx(i)}='';
            mut_off_events='';
            mut_off_events=offspring_event{mutation_idx(i)};
            offspring_event{mutation_idx(i)}='';
            
            A=cost_extra_aux_off;
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
                idx_mut=randi([2 (length(mut_off)-1)]);
            end
            
            
            %idx_mut=randi([2 idx_mut1]);
            
            
            
            offspring{mutation_idx(i)}={mut_off{1,1:idx_mut-1}}; %it saves the plan til the previous states
            kj=idx_mut;
            offspring_event{mutation_idx(i)}={mut_off_events{1:idx_mut-2}};
            cur_states=mut_off{1,idx_mut-1};
            cur_trans=mut_off_events{idx_mut-1};
            aux_trans=1;
            while ~detectEndState(cur_states,states_incr,num_fsm)
                transition_list = createTransitionList(states_incr,cur_states,num_fsm);
                possible_transitions = findPossibleTransitions(transition_list,event_list);
                num_transitions = size(possible_transitions);
                idx_pot=randi([1 num_transitions(1)]);
                detect_event=possible_transitions{idx_pot,1};
                if aux_trans==1
                    while strcmp(cur_trans,detect_event)
                        idx_pot=randi([1 num_transitions(1)]);
                        detect_event=possible_transitions{idx_pot,1};
                    end
                    aux_trans=2;
                end
                offspring_event{mutation_idx(i)}{kj-1}=detect_event;
                cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);
                index=findSameState(offspring{mutation_idx(i)},cur_states,num_fsm);
                if isempty(index)
                    offspring{mutation_idx(i)}{kj} =cur_states;%saves this state, which will be verified to see if it is the marked state at the next run
                    kj=kj+1;
                else
                    old_path_single='';
                    old_path_single=offspring{mutation_idx(i)};
                    offspring{mutation_idx(i)}='';
                    old_event_single='';
                    old_event_single=offspring_event{mutation_idx(i)};
                    path_events{j}='';
                    offspring{mutation_idx(i)}={old_path_single{1,1:index}};
                    cur_states=old_path_single{1,index};
                    offspring_event{mutation_idx(i)}={old_event_single{1:index-1}};
                    kj=index+1;
                end
                
            end
        end
%     end

    for kr=1:length(offspring)
      [cost_aux_off,cost_trans_aux_off,cost_extra_aux_off]= path_cost_Incr(offspring{kr},offspring_event{kr},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
       total_cost_off{num_rep}(kr)=cost_aux_off; 
    end
    diff_cros{num_rep}=total_cost_off_cros{num_rep}-total_cost_parents{num_rep};
    diff_mut{num_rep}=total_cost_off{num_rep}-total_cost_off_cros{num_rep};
    %total_off{num_rep}=offspring_event;
    mut_id{num_rep}=mutation_idx;
    t_dur(3,num_rep)=toc(t3);
   
    

   
    
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
    
    efficiency_mut(num_rep,1)=length(old_gen);
    efficiency_mut(num_rep,2)=length(old_path);

    cost_aux=[];
    for i=1:length(old_path)
        cost_aux(1,i)=0;
        if isempty(old_events{i})
            ju=11;
        end
        [cost_aux(1,i),cost_trans_aux{num_rep}{i},cost_extra_aux{num_rep}{i}]= path_cost_Incr(old_path{i},old_events{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
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
        aux_same_result
        aux_same_result=0;
        if fit_values_rn{num_rep}(1)< best_plan(num_rep-1)
            change_value=change_value+1;
            best_plan(num_rep)=fit_values_rn{num_rep}(1);
            trac_plan_cost(num_of_changes,1)=best_plan(num_rep-1)
            trac_plan_cost(num_of_changes,2)=best_plan(num_rep)
        else
            best_plan(num_rep)=fit_values_rn{num_rep}(1);
            %pause;
        end
    end
    
    if aux_same_result > 100
        ju=1;
    end

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