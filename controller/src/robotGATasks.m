function [best_cost,plan] = ...
    robotGATasks(cur_state,numRobots,states,events,tasks,regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robotTasks, sizePop, mutRate, stopCond, maxRep, num_fsms)


event_list = createEventFsmList(events,num_fsms);
plan_event=cell(maxRep,1);
% plan_state{1,:}=cell(1,sizePop);
plan_masked=cell(maxRep,1);
cost=zeros(maxRep,sizePop);
best_plan=zeros(maxRep,1);
best_event=cell(maxRep,sizePop);
fit_values_rn=cell(maxRep,1); 
idx_fit_aux=cell(maxRep,1);

[plan_event{1}, plan_masked{1}, cost(1,:)] = createPopulation(sizePop,cur_state,states,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robotTasks,events);


%we sort out the paths based on their cost value,from smaller to biggest cost
[fit_values_rn{1}, idx_fit_aux{1}]=sort(cost(1,:));

%save the plan with smallest cost as the best plan
best_plan(1)=fit_values_rn{1}(1);
initial_plan=best_plan(1);
best_event{1}=plan_event{idx_fit_aux{1}(1)};

selected=zeros(1,(sizePop/2));
num_off=ceil(length(selected)*mutRate);
offspring=cell(1,num_off);
offspring_event=cell(1,num_off);
cost_off=zeros(1,num_off);
limit_k=0.75;
choose=0.5;
num_rep=1;
aux_same=0;


while aux_same < stopCond && num_rep < maxRep
    %selection 2-Tournament
    pos_couples=randperm(sizePop);
    
    ind=1;
    
    
    
    for i=1:2:(length(pos_couples)-1)
        par_1=pos_couples(i);
        par_2=pos_couples(i+1);
        
        if choose > limit_k
            if cost(num_rep,par_1) > cost(num_rep,par_2)
                selected(ind)=par_1;
            else
                selected(ind)=par_2;
            end
        else
            if cost(num_rep,par_1) < cost(num_rep,par_2)
                selected(ind)=par_1;
            else
                selected(ind)=par_2;
            end
        end
        ind=ind+1;
    end
    
    
    for i=1:length(selected)
%         offspring{i}=plan_masked{num_rep}{selected(i)};
%         offspring_event{i}=plan_event{num_rep}{selected(i)};
%         cost_off(i)=cost(num_rep,selected(i));
%         for j=1:numTasks
%             
%             ind_ev=randi([2 (length(plan_event{num_rep}{selected(i)}))]);
%             aux_change=offspring{i}(ind_ev-1);
%             offspring{i}(ind_ev-1)=offspring{i}(ind_ev);
%             offspring{i}(ind_ev)=aux_change;
%             
%         end
            
%         index=zeros(round(numTasks/2),1);
        possible_ind=randperm(numTasks);
        index=possible_ind(1:round(numTasks));
%         for j=1:round(numTasks/2)
%             index(j)=possible_ind(j);%randi([1 (length(plan_event{num_rep,selected(i)}))]);
%             
%             %         index1=randi([1 (length(plan_event{num_rep,selected(i)}))]);
%             %         index2=randi([1 (length(plan_event{num_rep,selected(i)}))]);
%         end
        
        index=sort(index);
        limit_low=1;
        if index(end)< numTasks
            part=cell(length(index)+1,1);
        else
            part=cell(length(index),1);
        end
        for j=1:length(index)
            part{j}={plan_masked{num_rep}{selected(i)}{limit_low:index(j)}};
            limit_low=index(j)+1;
        end
        
        if limit_low<=numTasks
            part{j+1}={plan_masked{num_rep}{selected(i)}{limit_low:end}};
            
        end
        order=randperm(length(part));
        offspring{i}=part{order(1)};
        
        for j=2:length(order)
            offspring{i}=[offspring{i},part{order(j)}];
        end

       
        offspring_event{i}=convertToTasks(offspring{i},numTasks);
        cost_off(i)=calcCostPlanTasks(offspring_event{i},numRobots,start_loc,tasks);
    end

    
    
    mutation_idx_max=ceil(length(selected)*mutRate);
    %it randomly distributes the indexes of offspring
    mutation_idx_total=randperm(length(selected));
    %it selects until the total number of plans that will suffer mutation
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    num_mut=ceil(0.4*(numTasks-2)/2);
    off_j=length(selected);
    for i=1:length(mutation_idx)
        
        indexmut=randperm(length(offspring{mutation_idx(i)}),num_mut);
        off_j=off_j+1;
        offspring{off_j}=offspring{mutation_idx(i)};
        for k=1:num_mut
            
            
            event=offspring{off_j}{indexmut(k)};
            aux_rob=event(1)-96;
            new_robot=randi([1 numRobots]);
            
            while new_robot==aux_rob
                new_robot=randi([1 numRobots]);
            end
            
            aux=0;
            for j=1:length(offspring{off_j})
                if strcmp(offspring{off_j}{j},event)
                    aux=aux+1;
                    offspring{off_j}{j}(1)=char(new_robot+96);
                end
                if aux==2
                    break;
                end
            end
        end
        
        offspring_event{off_j}= convertToTasks(offspring{off_j},numTasks);
        cost_off(off_j)=calcCostPlanTasks(offspring_event{off_j},numRobots,start_loc,tasks);
    end
    
    old_pop=plan_event{num_rep};
    old_mask=plan_masked{num_rep};
    old_cost=cost(num_rep,:);
    full_cost=[cost(num_rep,:),cost_off];
    
    num_rep=num_rep+1;
    
    [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(full_cost);
    
%     plan_event{num_rep,:}=cell(1,sizePop);
%     plan_masked{num_rep,:}=cell(1,sizePop);
%     cost(num_rep,:)=zeros(1,sizePop);
    
    
    for i=1:sizePop
        
        if idx_fit_aux{num_rep}(i)>sizePop
            index=idx_fit_aux{num_rep}(i)-sizePop;
            plan_event{num_rep}{i}=offspring_event{index};
            plan_masked{num_rep}{i}=offspring{index};
            cost(num_rep,i)=cost_off(index);
        else
            index=idx_fit_aux{num_rep}(i);
            plan_event{num_rep}{i}=old_pop{index};
            plan_masked{num_rep}{i}=old_mask{index};
            cost(num_rep,i)=old_cost(index);
        end
        
    end
    
    best_plan(num_rep)=cost(num_rep,1);
    
    if cost(num_rep,1) < best_plan(num_rep-1)
        aux_same=0;
    else
        aux_same=aux_same+1;
    end
    
  
    best_event{num_rep}=plan_event{num_rep}{1};
    
end

best_cost=best_plan(num_rep);
plan=best_event{num_rep};
end


