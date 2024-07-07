function [best_cost,plan,cost] = ...
    robotGATasksNew2(cur_states,numRobots,states_incr,event_incr,tasks,regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robot_tasks, sizePop, mutRate, stopCond, maxRep, num_fsms)

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

[plan_event(1,:), cost(1,:),plan_tasks{1}] = createPopulationRobotsTasks(sizePop,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,event_incr);


%we sort out the paths based on their cost value,from smaller to biggest cost
% [fit_values_rn{1}, idx_fit_aux{1}]=sort(cost(1,:));

[cost(1,:), idx_fit_aux{1}]=sort(cost(1,:));
%save the plan with smallest cost as the best plan

best_plan(1)=cost(1,1);

initial_plan=best_plan(1);

best_event{1}=plan_event{idx_fit_aux{1}(1)};
numSelected=sizePop/2;
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
while aux_same < stopCond && num_rep < maxRep

%     [proCost, indexProb]=sort(cost(num_rep,:));
    proCost=cost(num_rep,:);
    indexProb=idx_fit_aux{num_rep};
    
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
    
    indc=1;
    for i=1:length(selected)
        
        index_rob=randperm(numRobots);
        
        for il=1:numRobots            
            desired_selected{indc,il}=plan_tasks{num_rep}{selected(i),index_rob(il)};            
        end
        
        desired_selected(indc+1,:)=plan_tasks{num_rep}(selected(i),:);   
        aux_ch=1;
        
        while aux_ch
            coin_rob=rand;
            
            for il=1:numRobots
                if coin_rob<=prob_rob(il)
                    num_trans=length(desired_selected{indc+1,il});
                    if num_trans>0
                        aux_ch=0;
                        index_change=randperm(num_trans,1);
                        num_rob=randperm(numRobots,1);
                        while num_rob==il
                            num_rob=randperm(numRobots,1);
                        end
                        desired_selected{indc+1,num_rob}(end+1)=desired_selected{indc+1,il}(index_change);
                        desired_selected{indc+1,il}(index_change)=[];
                    end
                    
                end
            end
        end
        
        [offspring{indc},cost_off(indc)] = testPlanTasks(desired_selected(indc,:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,event_incr);
        [offspring{indc+1},cost_off(indc+1)] = testPlanTasks(desired_selected(indc+1,:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,event_incr);
        
%         if cost_off1 > cost(num_rep,end)
%             offspring{indc}=plan_event{num_rep,indexProb(end)};
%             desired_selected(indc,:)= plan_tasks{num_rep}(indexProb(end),:);  
%             cost_off(indc)=cost(num_rep,end);
%         else
%             offspring{indc}=offspring1;
%             cost_off(indc)=cost_off1;
%         end
%         
%         if cost_off2 > cost(num_rep,end)
%             offspring{indc+1}=plan_event{num_rep,indexProb(end)};
%             desired_selected(indc+1,:)= plan_tasks{num_rep}(indexProb(end),:);
%             cost_off(indc+1)=cost(num_rep,end);
%         else
%             offspring{indc+1}=offspring2;
%             cost_off(indc+1)=cost_off2;
%         end
        indc=indc+2;       
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
% %     old_robots_assigned=robots_assigned{num_rep};
%     old_tasks=plan_tasks{num_rep};
%     old_cost=cost(num_rep,:);
%     full_cost=[cost(num_rep,:),cost_off];
%     old_task=taskRobot{num_rep};
    
    num_rep=num_rep+1;
    
    [cost(num_rep,:), idx_fit_aux{num_rep}]=sort(cost_off);
    
     i=0;
    if cost(num_rep,1) > cost(num_rep-1,1)
        i=i+1;
        index=idx_fit_aux{num_rep-1}(1);
        plan_event{num_rep,i}=plan_event{num_rep-1,index};
        plan_tasks{num_rep}(i,:)=plan_tasks{num_rep-1}(index,:);
%         robots_assigned{num_rep}(i,:)=robots_assigned{num_rep-1}(index,:);
        cost(num_rep,i)=cost(num_rep-1,i);
    end
    
    while i<sizePop
        i=i+1;
        index=idx_fit_aux{num_rep}(i);
        plan_event{num_rep,i}=offspring{index};
        plan_tasks{num_rep}(i,:)=desired_selected(index,:);
%         robots_assigned{num_rep}(i,:)=offspringRobots(index,:);
         cost(num_rep,i)=cost_off(index);
    end
%     for i=1:sizePop
%         if idx_fit_aux{num_rep}(i)>sizePop
%             index=idx_fit_aux{num_rep}(i)-sizePop;
%             plan_event{num_rep,i}=offspring{index};
%             plan_tasks{num_rep}(i,:)=desired_selected(index,:);%offspringTasks(index,:);
% %             robots_assigned{num_rep}(i,:)=offspringRobots(index,:);
%             cost(num_rep,i)=cost_off(index);
%         else
%             index=idx_fit_aux{num_rep}(i);
%             plan_event{num_rep,i}=old_pop{index};
%             plan_tasks{num_rep}(i,:)=old_tasks(index,:);
% %             robots_assigned{num_rep}(i,:)=old_robots_assigned(index,:);
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

best_cost=best_plan(num_rep);
plan=best_event{num_rep};
end
