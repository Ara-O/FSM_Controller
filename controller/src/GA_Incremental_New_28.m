%Implementation of Clusters,Crossover, Flipping and Mutation at Idle_Cost
%Flipping happens at the result of crossover and generates a new offspring
%Mutation happens at the result of crossover and flipping and it also
%generates new offspring. It only happens few times. If the same_result is
%bigger than 30 it creates totally new offspring based on the start events
%of the chosen plans for mutation
%Plan
function [all_plan,plan,plan_state,plan_cost,num_spoint,initial_plan,num_of_changes,idx_change,trac_plan_cost,num_rep,t_dur,t_pop] = GA_Incremental_New_28(population_size,max_rep,mutation_rate,stop_cond,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,states_incr,events_incr,initial_state_incr,initial_state,events)
num_of_changes=0;
abstracted = false;
start_events_only = false;
cost=[];
trac_plan_cost=0;
num_spoint=0;
num_paths=population_size; %number of paths to be generated
change_value=0;
j=1;
for i=1:numRobots    
initialRegions(i)= str2double(whichRegion(start_loc(i,1),start_loc(i,2),numRegions,regions));
end
for i=1:numTasks
    bot_task=i;
    [taskX,taskY,~] = getTaskLocation(bot_task,tasks);
    tasksRegions(i)=str2double(whichRegion(taskX,taskY,numRegions,regions));
end
[~,num_fsm] = size(states_incr);
event_list = createEventFsmList(events_incr,num_fsm);
[path_abs]=popAbsFull(population_size,numTasks,numRobots);
num_paths=length(path_abs);
population_size=num_paths;
aux_full=0;
tic;
while j<=num_paths
    [path_gen{j},path_events{j}]=createChromosomeRegions3(path_abs(j),states_incr,num_fsm,initial_state_incr,event_list,events_incr,numRobots,numTasks,tasksRegions,initialRegions,numRegions);
%     path_abs_full{j}=stripEventPathMod(path_events{j});
%     aux_full=aux_full+checkAbsPath(path_abs_full{j},path_abs);
    j=j+1; %once it reaches the marked state, it completes one plan and goes to start the next plan
end
t_pop=toc;
aux_dup=0;
    

%with a population formed only by different individuals, it calculates the
%cost for each individual
for i=1:length(path_gen)  
    cost(1,i)=0;
    [cost(1,i),cost_trans{1}{i},cost_extra{1}{i}]= path_cost_Incr_New(path_events{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
end


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
    pop_size=length(path_events);
   
    offspring='';
    offspring_event='';
    %cost_off=cost;
    cost_trans_off{num_rep}=cost_trans{num_rep-1}; 
    cost_extra_off{num_rep}=cost_extra{num_rep-1};
    
    % Crossover %%

    t1=tic;

    t_dur(1,num_rep)=toc(t1);
    ind=1;

    t2=tic;
    for i=1:pop_size
       
        parent_1='';
        parent_1_events='';
        parent_1_events=path_events{i};%save the plan-events for parent 1
        
        
        
%         offspring{ind}=parent_1;
        offspring_event{ind}=parent_1_events;
        %             if change_value >=1
        %                 ind=ind+1;
        %                 [offspring{ind},offspring_event{ind}] = newCrossover(1,offspring_event{ind-1},states_incr,num_fsm,initial_state_incr,event_list,events_incr);
        ind=ind+1;
        [offspring_event{ind}] = newCrossover3New(3,offspring_event{ind-1},states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions);
        ind=ind+1;
        [offspring_event{ind}] = newCrossover3New(1,offspring_event{ind-1},states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions);
        %             end
        ind=ind+1;
        [offspring_event{ind}] = newCrossover3New(6,offspring_event{ind-3},states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions);
        %             end
        ind=ind+1;
        
    end
    
    t_dur(2,num_rep)=toc(t2);
    
   
    old_events_1='';
    old_events_1=path_events;
    
    
    max_path=length(old_events_1);
    
  
    
    % Mutation %%%%%
    
    %At this part, we will apply yje mutation to part of the offspring
    %based on the mutation_rate we decide how many from the offpring will
    %suffer mutation
    
    t3=tic;
    
    %mutation_rate=0;
    %if mod(change_value,2)==0 || aux_same_result>3
     %   mutation_rate=0.3;
%         if aux_same_result>5
%             mutation_rate=0.5;
%         end
    %end
    mutation_idx_max=ceil(length(offspring_event)*mutation_rate);
    %it randomly distributes the indexes of offspring
    mutation_idx_total=randperm(length(offspring_event));
    %it selects until the total number of plans that will suffer mutation
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    mutation_idx_trac{num_rep}=mutation_idx;
    
    old_cost_mut=[];
    new_cost_mut=[];
    if aux_same_result>=0
        for i=1:length(mutation_idx)
            old_offspring=stripEventPathMod(offspring_event{mutation_idx(i)});
            old_offspring_abs=convertToMask(old_offspring);
            %offspring{mutation_idx(i)}='';
            %offspring_event{mutation_idx(i)}='';
            old_offspring_abs1=mutationMask(old_offspring_abs,numRobots);
            offspring_abs=mutationAbs(old_offspring_abs1);
            path_j = convertToEvent(offspring_abs,events,numTasks);
            
            [offspring{ind},offspring_event{ind}] =createChromosomeRegions3(path_j,states_incr,num_fsm,initial_state_incr,event_list,events_incr,numRobots,numTasks,tasksRegions,initialRegions,numRegions);
            ind=ind+1;
            [offspring_event{ind}] = newCrossover3New(3,offspring_event{ind-1},states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions);
            ind=ind+1;
            [offspring_event{ind}] = newCrossover3New(1,offspring_event{ind-2},states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions);
            ind=ind+1;
            [offspring_event{ind}] = newCrossover3New(6,offspring_event{mutation_idx(i)},states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions);
            ind=ind+1;
        end
    else
        for i=1:length(mutation_idx)
            [offspring_event{ind}] = newCrossover3New(1,offspring_event{mutation_idx(i)},states_incr,num_fsm,initial_state_incr,event_list,events_incr,initialRegions);
            ind=ind+1;

        end
    end
    
    mut_id{num_rep}=mutation_idx;
    t_dur(3,num_rep)=toc(t3);
    
    old_events='';
    old_events=path_events;

    
    max_path=length(old_events);
    
    for i_x=1:length(offspring_event)
        old_events{max_path+i_x}=offspring_event{i_x};
    end
    

    


    cost_aux=[];
    for i=1:length(old_events)
        cost_aux(1,i)=0;
        if isempty(old_events{i})
            ju=11;
        end
        [cost_aux(1,i),cost_trans_aux{num_rep}{i},cost_extra_aux{num_rep}{i}]= path_cost_Incr_New(old_events{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
    end
   

    
    [fit_values_rn_aux{num_rep}, idx_fit_aux_2{num_rep}]=sort(cost_aux);
    cost=[];
    cost_trans{num_rep}=[];
    cost_extra{num_rep}=[];
    path_events='';
    max_path_2=length(old_events);
    
    if max_path_2 > population_size
        limit=population_size;
    else
        limit=max_path_2;
    end
    limit_half=limit;%ceil(3*limit/4);
%limit=population_size;
%if max_path_2<population_size
    for i=1:limit_half
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
            diff_plan(change_value)=best_plan(num_rep-1)-best_plan(num_rep);
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
plan_state="";
all_plan=best_event;
plan_cost=cost(1);
end