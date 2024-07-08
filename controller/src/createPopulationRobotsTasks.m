function  [pop, cost,desired_tasks] = createPopulationRobotsTasks(sizePop,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr)

aux_robots=zeros(sizePop,numRobots);
pop=cell(sizePop,1);
cost=zeros(sizePop,1);

pairTasks=numTasks/2;

num_dup=0;

probRobot=zeros(numRobots,1);

share=floor(pairTasks/numRobots);
diff=mod(pairTasks,numRobots);
shareRobots_default=zeros(numRobots,1);
for i=1:numRobots
    probRobot(i)=i*(1/numRobots);
    shareRobots_default(i)=share;
    
end

plans=zeros(sizePop,pairTasks);
robots_assigned=zeros(sizePop,pairTasks);
plans_abs=cell(sizePop,pairTasks);

j=1;

shareRobots=zeros(numRobots,1);
desired_tasks=cell(sizePop,numRobots);
while j<=sizePop
    shareRobots=shareRobots_default;
    ind_extra=randi(numRobots);
    shareRobots(ind_extra,1)=share+diff;
    for i=1:pairTasks        
        aux_rob=0;
        while aux_rob==0
            coin=rand;
            for k=1:numRobots
                if coin <= probRobot(k)
                    if aux_robots(j,k) < shareRobots(k,1)
                        aux_rob=1;
                        task_rob=i+(i-1);
                        desired_tasks{j,k}(end+1)=task_rob;
                        aux_robots(j,k)=aux_robots(j,k)+1;
                        plans(j,i)=k;
                        break;
                    else
                        break;
                    end
                end
            end
        end
    end
    aux_dup=0;
    for jj=1:j-1
        if (sum(plans(j,:)==plans(jj,:))==pairTasks)
            aux_dup=1;
            num_dup=num_dup+1;
            for ll=1:numRobots
                desired_tasks{j,ll}=[];
            end
            aux_robots(j,:)=0;
            break;
        end
    end
    if aux_dup==0
        [pop{j},cost(j)] = testPlanTasks(desired_tasks(j,:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);
        j=j+1;
    end
end





end