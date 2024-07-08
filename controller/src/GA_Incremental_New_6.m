%Implementation of Clusters, Crossover and Mutation at abstracted plan
function [all_plan,plan,plan_state,plan_cost,num_spoint,initial_plan,num_of_changes,idx_change,trac_plan_cost,num_rep,t_dur,t_pop] = GA_Incremental_New_6(population_size,max_rep,mutation_rate,stop_cond,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,states_incr,events_incr,initial_state_incr,initial_state,events)
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
[path_abs]=popAbsCluster(60,events,numTasks,numRobots,4);
num_paths=length(path_abs);
population_size=num_paths;
aux_full=0;
while j<=num_paths
    [path_gen{j},path_events{j}]=createChromossome(path_abs(j),states_incr,num_fsm,initial_state_incr,event_list,events_incr);
    path_abs_full{j}=stripEventPathMod(path_events{j});
    aux_full=aux_full+checkAbsPath(path_abs_full{j},path_abs);
    j=j+1; %once it reaches the marked state, it completes one plan and goes to start the next plan
end

t_pop(j)=toc(t7);
aux_dup=0;
    
t6=tic;

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

tot_dur(1,1)=toc(t2);
t_dur(2,1)=0;
t_dur(3,1)=toc(t6);


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
%     
%     for i=1:length(cost)
%         prob_ind(i)=cost(i)/total_cost;
%     end
        limit_k=0.75;
        pos_couples=randperm(length(path_gen));
        ind=1;
        for i=1:2:(length(pos_couples)-1)
            par_1=pos_couples(i);
            par_2=pos_couples(i+1);
            
            choose=rand;
            
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

    ind=1;
    final_couples=randperm(length(couples));
    final_couples_trac{num_rep}=final_couples;
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
        
        path_abs_parent1=stripEventPathMod(parent_1_events);
        path_abs_parent2=stripEventPathMod(parent_2_events);
        
        [path_abs_cross]=crossOverAbs(path_abs_parent1,path_abs_parent2,events,numTasks);
        
        offspring_abs{ind}=path_abs_cross{1};
        ind=ind+1;
        offspring_abs{ind}=path_abs_cross{2};
        ind=ind+1;
                    
    end
    
  
      
    
    
    % Mutation %%%%%
    
    %At this part, we will apply yje mutation to part of the offspring
    %based on the mutation_rate we decide how many from the offpring will
    %suffer mutation
    mutation_idx_max=ceil(length(offspring_abs)*mutation_rate);
    %it randomly distributes the indexes of offspring
    mutation_idx_total=randperm(length(offspring_abs));
    %it selects until the total number of plans that will suffer mutation
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    mutation_idx_trac{num_rep}=mutation_idx;
    t3=tic;
    t4=tic;
    t5=tic;
    old_cost_mut=[];
    new_cost_mut=[];
    for i=1:length(mutation_idx)
        old_offspring=offspring_abs{mutation_idx(i)};
        offspring_abs{mutation_idx(i)}='';
        offspring_abs{mutation_idx(i)}=mutationAbs(old_offspring);
            

            t_dur(3,num_rep)=toc(t5);
    end
    
    for i=1:length(offspring_abs)
        
        path_j = convertToEvent(offspring_abs{i},events,numTasks);
        
        [offspring{i},offspring_event{i}] = createChromossome(path_j,states_incr,num_fsm,initial_state_incr,event_list,events_incr);
        
    end
    
%     
%     figure;
%     plot(diff_cost_mutt);
%     title('Difference cost between mutated offspring');
    
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