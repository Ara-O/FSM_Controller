function  [pop, cost,plans,robots_assigned] = createPopulationRobots(sizePop,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr)

aux_robots=zeros(sizePop,numRobots);
pop=cell(sizePop,1);
cost=zeros(sizePop,1);

pairTasks=numTasks/2;


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

while j<=sizePop
    shareRobots=shareRobots_default;
    index=randperm(pairTasks);
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
                        plans(j,index(i))=task_rob;
                        robots_assigned(j,index(i))=k;
                        aux_robots(j,k)=aux_robots(j,k)+1;
                        if task_rob<10
                            plans_abs{j,index(i)}=strcat(char(k+96),'0',num2str(task_rob),'s');
                        else
                            plans_abs{j,index(i)}=strcat(char(k+96),num2str(task_rob),'s');
                        end
                        break;
                    end
                end
            end
        end
    end
    aux_dup=0;
    for jj=1:j-1
        if (sum(plans(j,:)==plans(jj,:))==pairTasks) && (sum(robots_assigned(j,:)==robots_assigned(jj,:))==pairTasks)
            aux_dup=1;
            break;
        end
    end
    if aux_dup==0
        [pop{j},cost(j)] = testPlan(plans_abs(j,:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);
        j=j+1;
    end
end





end