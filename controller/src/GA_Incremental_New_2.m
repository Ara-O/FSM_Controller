 function [all_plan,plan,plan_state,plan_cost,num_spoint,initial_plan,num_of_changes,idx_change,trac_plan_cost,num_rep,t_dur,t_pop] = GA_Incremental_New_2(population_size,max_rep,mutation_rate,stop_cond,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,states_incr,events_incr,initial_state_incr,events)
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
    cur_states=initial_state_incr; %for every path it starts at the initial state
    i=1;
    path_gen{j}='';
    path_events{j}='';
    path_gen{j}{i}=cur_states; %save the first state
    while ~detectEndState(cur_states,states_incr,num_fsm) %check if it didn't reach the final state
        transition_list = createTransitionList(states_incr,cur_states,num_fsm); %for the current state creates the transition list
        possible_transitions = findPossibleTransitions(transition_list,event_list);% from the transition list selects the possible events
        num_transitions = size(possible_transitions); %verify the number of possible transitions     
        idx_pot=randi([1 num_transitions(1)]);% select randomly one of the possible events
        detect_event=possible_transitions{idx_pot,1}; %save the selected the transition/event       
        path_events{j}{i}=detect_event;
        cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);%verify the state this transition takes
        i=i+1; 
        path_gen{j}{i}=cur_states;%saves this state, which will be verified to see if it is the marked state at the next run
    end
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

old_g=path_gen;
old_ev=path_events;
old_cost_extra=cost_extra;
cost_extra='';
path_gen='';
path_events='';

%it organizes the population based on their sorted cost
for i=1:length(idx_fit_aux{1})
    path_events{i}=old_ev{idx_fit_aux{1}(i)};
    path_gen{i}=old_g{idx_fit_aux{1}(i)};
    cost_extra{1}{i}=old_cost_extra{1}{idx_fit_aux{1}(i)};
end


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
    cost_off=cost;
    cost_trans_off{num_rep}=cost_trans{num_rep-1}; 
    cost_extra_off{num_rep}=cost_extra{num_rep-1};
    
    % Crossover %%
    
    %randomly distributes the indexes of population
    possible_couples=randperm(length(path_gen));
    
    total_cost=sum(1./cost);
%     
%     for i=1:length(cost)
%         prob_ind(i)=cost(i)/total_cost;
%     end
    ind=1;
    while ind <= length(path_gen)
        choose_1=total_cost*rand;
        full=0;
        for j=1:length(path_gen)
            full=full+(1/cost(j));
            if full>=choose_1
                p1=j;
                break;
            end
        end
        choose_2=total_cost*rand;        
        full=0;
        for j=1:length(path_gen)
            full=full+(1/cost(j));
            if full>=choose_2
                p2=j;
                break;
            end
        end

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
        jindex=chooseSameState(parent_1,parent_2,num_fsm);
        
        if ~isempty(jindex) %check if there is a shared state
            
            %if there is a shared state, it crops the parent 1 until that
            %state and grab the end part from parent 2
            old_offspring={parent_1{1:jindex(1)},parent_2{jindex(2)+1:end}};
            old_offspring_event={parent_1_events{1:jindex(1)-1},parent_2_events{jindex(2):end}}; 
            
            [offspring{ind},offspring_event{ind}]=check_loops_fix_new_Incr(old_offspring,old_offspring_event,num_fsm);
            ind=ind+1;
            % as second offspring, it takes the beginning of parent 2 and
            % end of parent 1
            old_offspring='';
            old_offspring_event='';
            old_offspring={parent_2{1:jindex(2)},parent_1{jindex(1)+1:end}};
            old_offspring_event={parent_2_events{1:jindex(2)-1},parent_1_events{jindex(1):end}};           
            [offspring{ind},offspring_event{ind}]=check_loops_fix_new_Incr(old_offspring,old_offspring_event,num_fsm);
            ind=ind+1;
            
        else 
            if cost_parent_1 < cost_parent_2
                offspring{ind}=parent_1;
                offspring_event{ind}=parent_1_events;
                ind=ind+1;
            else
                offspring{ind}=parent_2;
                offspring_event{ind}=parent_2_events;
                ind=ind+1;
            end
        end
              
    end
    
    for i=1:length(offspring)
        [cost_off(1,i),cost_trans_off{num_rep}{i},cost_extra_off{num_rep}{i}]= path_cost_Incr(offspring{i},offspring_event{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
    end
    

    
    [fit_values_off, idx_fit_off]=sort(cost_off);
    
    old_offspring=''
    old_offspring=offspring;
    offspring='';
    old_offspring_event='';
    old_offspring_event=offspring_event;
    offspring_event='';
    old_cost_off=cost_off;
    cost_off=[];

    for i=1:length(old_offspring)
        offspring{i}=old_offspring{idx_fit_off(i)};
        offspring_event{i}=old_offspring_event{idx_fit_off(i)};
        cost_off(1,i)=old_cost_off(1,idx_fit_off(i));
    end
    
    figure;
    plot(cost_off);
    title('Cost Offspring prior Mutation');
    
      
    
    
    % Mutation %%%%%
    
    %At this part, we will apply yje mutation to part of the offspring
    %based on the mutation_rate we decide how many from the offpring will
    %suffer mutation
    mutation_idx_max=ceil(length(offspring)*mutation_rate);
    %it randomly distributes the indexes of offspring
    mutation_idx_total=randperm(length(offspring));
    %it selects until the total number of plans that will suffer mutation
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    t3=tic;
    t4=tic;
    for i=1:length(mutation_idx)
            mut_off='';
            mut_off=offspring{mutation_idx(i)};
            offspring{mutation_idx(i)}='';
            mut_off_events='';
            mut_off_events=offspring_event{mutation_idx(i)};
            offspring_event{mutation_idx(i)}='';
            %A=cost_extra_off{num_rep}{mutation_idx(i)};
            potential_nodes=[];
            pot_nodes=[];
            
            %randomly choose a position at the plan to be the mutation
            %point, from where it will start to create a new path
            if mutation_idx(i)> length(offspring)/2 %it is a offspring with high cost
                idx_mut=randi([2 ceil((length(mut_off)-1)/2)]); 
            else
                idx_mut=randi([ceil((length(mut_off)-1)/2) (length(mut_off)-1)]); 
            end
            

           
            offspring{mutation_idx(i)}={mut_off{1,1:idx_mut-1}}; %it saves the plan til the previous states
            kj=idx_mut;
            offspring_event{mutation_idx(i)}={mut_off_events{1:idx_mut-2}};
            cur_states=mut_off{1,idx_mut-1};
            
            while ~detectEndState(cur_states,states_incr,num_fsm)
                transition_list = createTransitionList(states_incr,cur_states,num_fsm);
                possible_transitions = findPossibleTransitions(transition_list,event_list);
                num_transitions = size(possible_transitions);
                idx_pot=randi([1 num_transitions(1)]);
                detect_event=possible_transitions{idx_pot,1};
                offspring_event{mutation_idx(i)}{kj-1}=detect_event;
                cur_states = updateCurEvent(detect_event,cur_states,events_incr,states_incr,num_fsm);
                offspring{mutation_idx(i)}{kj}=cur_states;
                kj=kj+1;
                
            end
            t5=tic;
            old_offspring='';
            old_offspring=offspring{mutation_idx(i)};
            old_offspring_event='';
            old_offspring_event=offspring_event{mutation_idx(i)};
            offspring{mutation_idx(i)}='';
            offspring_event{mutation_idx(i)}='';
            [offspring{mutation_idx(i)},offspring_event{mutation_idx(i)}]=check_loops_fix_new_Incr(old_offspring,old_offspring_event,num_fsm);
            old_cost_mut(1,i)=cost_off(1,mutation_idx(i));
            cost_off(1,mutation_idx(i))=0;
            cost_trans_off{num_rep}{i}=[];
            cost_extra_off{num_rep}{i}=[];
            [cost_off(1,mutation_idx(i)),cost_trans_off{num_rep}{i},cost_extra_off{num_rep}{i}]= path_cost_Incr(offspring{mutation_idx(i)},offspring_event{mutation_idx(i)},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
            new_cost_mut(1,i)=cost_off(1,mutation_idx(i));
            t_dur(3,num_rep)=toc(t5);
    end
    
    diff_cost_mutt=old_cost_mut-new_cost_mut;
    
    figure;
    plot(diff_cost_mutt);
    title('Difference cost between mutated offspring');
    
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