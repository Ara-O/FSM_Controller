function [best_cost,plan,cost] = ...
    robotGATasksNew(cur_states,numRobots,states_incr,event_incr,tasks,regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robot_tasks, sizePop, mutRate, stopCond, maxRep, num_fsms)

event_list = createEventFsmList(event_incr,num_fsms);
plan_event=cell(maxRep,sizePop);
plan_masked=cell(maxRep,1);
plan_tasks=cell(maxRep,1);
robots_assigned=cell(maxRep,1);
cost=zeros(maxRep,sizePop);
best_plan=zeros(maxRep,1);
best_event=cell(maxRep,sizePop);
fit_values_rn=cell(maxRep,1); 
idx_fit_aux=cell(maxRep,1);
taskRobot=cell(maxRep,1);

[plan_event(1,:), cost(1,:),plan_tasks{1},robots_assigned{1}] = createPopulationRobots(sizePop,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,event_incr);


%we sort out the paths based on their cost value,from smaller to biggest cost
% [fit_values_rn{1}, idx_fit_aux{1}]=sort(cost(1,:));

[cost(1,:), idx_fit_aux{1}]=sort(cost(1,:));
%save the plan with smallest cost as the best plan

best_plan(1)=cost(1,1);

initial_plan=best_plan(1);

best_event{1}=plan_event{idx_fit_aux{1}(1)};
numSelected=sizePop;
selected=zeros(numSelected,1);
num_off=ceil(length(selected)*mutRate);

cost_off=zeros(1,num_off);
limit_k=0.75;
choose=0.5;
num_rep=1;
aux_same=0;

probPlans=zeros(sizePop,1);

numPairs=numTasks/2;

prob_rob=zeros(numRobots,1);
for i=1:numRobots
    prob_rob(i)=i*(1/numRobots);
end

offspringTasks=zeros(numSelected,numPairs);
offspringRobots=zeros(numSelected,numPairs);

% parentTasks=zeros(numSelected,numTasks/2);
% parentRobots=zeros(numSelected,numTasks/2);
aux_off=zeros(maxRep,1);
aux_worse=zeros(maxRep,2);
aux_copy=zeros(maxRep,1);
while aux_same < stopCond && num_rep < maxRep

    [proCost, indexProb]=sort(cost(num_rep,:));
    
    totalCost=sum(cost(num_rep,:));
    previous_prob=0;
    
    for i=1:sizePop
        probPlans(i)=previous_prob+proCost(i)/totalCost;
        previous_prob=previous_prob+proCost(i)/totalCost;
    end
    
    i=1;
    while i<numSelected
        coin=rand;
        for j=1:sizePop
            if coin <= probPlans(j)
                sel=indexProb(j);
                break;
            end
        end
        aux_dup=0;
        for k=1:i-1
            if selected(k)==sel
                aux_dup=1;
                break;
            end
        end
        if aux_dup==0
            selected(i)=sel;
            i=i+1;
        end
    end
    
    %makes sure the best one is kept
    selected(i)=indexProb(1);
    

%     indexCouple=randperm(length(selected));
    
    ind=0;
    ind_f=0;
    for i=1:2:length(selected)-1
        
%         parentTasks1=plan_tasks{num_rep}(selected(indexCouple(i)),:);
%         parentTasks2=plan_tasks{num_rep}(selected(indexCouple(i+1)),:);
%         
%         parentRobots1=robots_assigned{num_rep}(selected(indexCouple(i)),:);
%         parentRobots2=robots_assigned{num_rep}(selected(indexCouple(i+1)),:);

        parentTasks1=plan_tasks{num_rep}(selected(i),:);
        parentTasks2=plan_tasks{num_rep}(selected(i+1),:);
        
        parentEvent1=plan_event{num_rep,selected(i)};
        parentEvent2=plan_event{num_rep,selected(i+1)};
        
        cost1=cost(num_rep,selected(i));
        cost2=cost(num_rep,selected(i+1));
        
        parentRobots1=robots_assigned{num_rep}(selected(i),:);
        parentRobots2=robots_assigned{num_rep}(selected(i+1),:);

        ind=ind+1;
        offspringTasks(ind,:)=parentTasks1;
        offspringRobots(ind,:)=parentRobots2;
        
        [offspring_event(ind,:),cost_off(ind)]=completeTask(offspringTasks(ind,:),offspringRobots(ind,:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,event_incr);

        
        
        %         pointCross=randi([1 (numPairs-1)]);
%         
%         ind=ind+1;
%         offspring=[parentTasks1(1:pointCross),parentTasks2(pointCross+1:end)];        
%         offspringTasks(ind,:)=checkInf(offspring,numPairs);
%         offspringRobots(ind,:)=[parentRobots1(1:pointCross),parentRobots2(pointCross+1:end)];
        
%         coin=rand;
%         if coin > 0.3
%             index=randperm(numPairs,1);
%             
%             coin_rob=rand;
%             
%             for k=1:numRobots
%                 if coin_rob < prob_rob(k)
%                     offspringRobots(ind,index)=k;
%                 end
%             end
%         end
        
        
%         [offspring_event(ind,:),cost_off(ind)]=completeTask(offspringTasks(ind,:),offspringRobots(ind,:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,event_incr);
if cost_off(ind)==cost1 || cost_off(ind)==cost2
    aux_copy(num_rep,1)=aux_copy(num_rep,1)+1;
end
        if cost_off(ind) > cost(num_rep,end)
            offspring_event{ind}=parentEvent1;
            offspringTasks(ind,:)=parentTasks1;
            offspringRobots(ind,:)= parentRobots1;
            cost_off(ind)= cost1;
            aux_worse(num_rep,1)=aux_worse(num_rep,1)+1;
            
        end
        

        
%         ind=ind+1;
%         offspring=[parentTasks2(1:pointCross),parentTasks1(pointCross+1:end)];
%         offspringTasks(ind,:)=checkInf(offspring,numPairs);
%         offspringRobots(ind,:)=[parentRobots2(1:pointCross),parentRobots1(pointCross+1:end)];
        
%         coin=rand;
%         if coin > 0.5
%             index=randperm(numPairs,1);
%             
%             coin_rob=rand;
%             
%             for k=1:numRobots
%                 if coin_rob < prob_rob(k)
%                     offspringRobots(ind,index)=k;
%                 end
%             end
%         end
        
ind=ind+1;
offspringTasks(ind,:)=parentTasks2;
offspringRobots(ind,:)=parentRobots1;

[offspring_event(ind,:),cost_off(ind)]=completeTask(offspringTasks(ind,:),offspringRobots(ind,:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,event_incr);

%         [offspring_event(ind,:),cost_off(ind)]=completeTask(offspringTasks(ind,:),offspringRobots(ind,:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,event_incr);
if cost_off(ind)==cost1 || cost_off(ind)==cost2
    aux_copy(num_rep,1)=aux_copy(num_rep,1)+1;
end
        if cost_off(ind) > cost(num_rep,end)
            offspring_event{ind}=parentEvent2;
            offspringTasks(ind,:)=parentTasks2;
            offspringRobots(ind,:)= parentRobots2;
            cost_off(ind)= cost2;
            aux_worse(num_rep,2)=aux_worse(num_rep,2)+1;
            
        end
        

                
    end
    
%     for i=1:ind
%         coin=rand;        
%         if coin > 0.5
%             index=randperm(numPairs,1);
%             
%             coin_rob=rand;
%             
%             for k=1:numRobots
%                 if coin_rob < prob_rob(k)
%                     offspringRobots(i,index)=k;
%                 end
%             end
%         end       
%     end
%     
%     [offspring_event,cost_off]=completeTask(offspringTasks,offspringRobots,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,event_incr);
%     
    
%     old_pop=plan_event(num_rep,:);
%     old_robots_assigned=robots_assigned{num_rep};
%     old_tasks=plan_tasks{num_rep};
%     old_cost=cost(num_rep,:);
%     full_cost=[cost(num_rep,:),cost_off];
%     old_task=taskRobot{num_rep};
    
    num_rep=num_rep+1;
    
    [cost(num_rep,:), idx_fit_aux{num_rep}]=sort(cost_off');
    
%      [aux_ht, idx_fit_aux{num_rep}]=sort(full_cost);
    
    i=0;
    if cost(num_rep,1) > cost(num_rep-1,1)
        i=i+1;
        index=idx_fit_aux{num_rep-1}(1);
        plan_event{num_rep,i}=plan_event{num_rep-1,index};
        plan_tasks{num_rep}(i,:)=plan_tasks{num_rep-1}(index,:);
        robots_assigned{num_rep}(i,:)=robots_assigned{num_rep-1}(index,:);
        cost(num_rep,i)=cost(num_rep-1,i);
        aux_off(num_rep,1)=aux_off(num_rep,1)+1;
        
    end
    
    while i<sizePop
        i=i+1;
        index=idx_fit_aux{num_rep}(i);
        plan_event{num_rep,i}=offspring_event{index};
        plan_tasks{num_rep}(i,:)=offspringTasks(index,:);
        robots_assigned{num_rep}(i,:)=offspringRobots(index,:);
%         cost(num_rep,i)=cost_off(index);
    end
%     for i=1:sizePop
%         if idx_fit_aux{num_rep}(i)>sizePop
%             index=idx_fit_aux{num_rep}(i)-sizePop;
%             plan_event{num_rep,i}=offspring_event{index};
%             plan_tasks{num_rep}(i,:)=offspringTasks(index,:);
%             robots_assigned{num_rep}(i,:)=offspringRobots(index,:);
%             cost(num_rep,i)=cost_off(index);
%             aux_off(num_rep-1,1)=aux_off(num_rep-1,1)+1;
%         else
%             index=idx_fit_aux{num_rep}(i);
%             plan_event{num_rep,i}=old_pop{index};
%             plan_tasks{num_rep}(i,:)=old_tasks(index,:);
%             robots_assigned{num_rep}(i,:)=old_robots_assigned(index,:);
%             cost(num_rep,i)=old_cost(index);
% 
%         end
%     end

%     i=i+1;
%     jt=1;
%     while i<=sizePop && jt <=length(idx_fit_aux{num_rep})
%         auxAdd=0;
%         if idx_fit_aux{num_rep}(jt)>sizePop
%             index=idx_fit_aux{num_rep}(jt)-sizePop;
%             taskRobCheck=taskRobotOff(index,:);
%             
%             for jk=1:i-1
%                 if (sum(taskRobCheck==taskRobotaux(jk,:))==numTasks/2)
%                     auxAdd=1;
%                     break;
%                 end
%             end
%             if auxAdd==0
%                 plan_event{num_rep}{i}=offspring_event{index};
%                 plan_masked{num_rep}{i}=offspring{index};
%                 cost(num_rep,i)=cost_off(index);
%                 taskRobotaux(i,:)=taskRobCheck;
%                 i=i+1;
%             end
%         else
%             index=idx_fit_aux{num_rep}(jt);
%             taskRobCheck=old_task(index,:);
%             for jk=1:i-1
%                 if (sum(taskRobCheck==taskRobotaux(jk,:))==numTasks/2)
%                     auxAdd=1;
%                     break;
%                 end
%             end
%             if auxAdd==0
%                 plan_event{num_rep}{i}=old_pop{index};
%                 plan_masked{num_rep}{i}=old_mask{index};
%                 cost(num_rep,i)=old_cost(index);
%                 taskRobotaux(i,:)=taskRobCheck;
%                 i=i+1;
%             end
%         end
%         jt=jt+1;
%         
%     end
    
    if i < sizePop
        ju=90
    end
    
    if num_rep==21
        
        ju=2;
        
    end
    best_plan(num_rep)=cost(num_rep,1);
    
    if cost(num_rep,1) < best_plan(num_rep-1)
        aux_same=0;
    else
        aux_same=aux_same+1;
    end    
  
    best_event{num_rep}=plan_event{num_rep,1};
    best_cost=best_plan(num_rep);
plan=best_event{num_rep};
end


