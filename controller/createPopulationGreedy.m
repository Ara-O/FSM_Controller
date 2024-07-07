function [plan_event, plan_masked, cost, taskRobot] = createPopulationGreedy(cost_ini,path_ini,sizePop,cur_state,states,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robotTasks,events )


aux=0;
taskRobot=zeros(sizePop,numTasks/2);
sizeInit=length(cost_ini);
plan_event=cell(1,sizePop);
plan_masked=cell(1,sizePop);
cost=zeros(1,sizePop);
% i=1;
for i=1:sizeInit
    plan_event{1,i}=path_ini(i,:)';
    [plan_masked_aux,taskRobot(i,:)]=convertToMask2(plan_event{1,i},numTasks);
    plan_masked{1,i}=plan_masked_aux;
    cost(1,i)=cost_ini(i);
end
% i=i+1;
% for j=2:sizeInit
%     aux=0;
%     
%     [plan_masked_aux,taskRobotaux]=convertToMask2(path_ini(j,:)',numTasks);
%     for ik=1:i-1
%         if (sum(taskRobotaux==taskRobot(ik,:))==numTasks/2)
%             aux=1;
%             break;
%         end
%     end
%   
%     if aux==0
%         plan_event{1,i}=path_ini(j,:)';
%         plan_masked{1,i}=plan_masked_aux;
%         cost(1,i)=cost_ini(j);
%         taskRobot(i,:)=taskRobotaux;
%         i=i+1;
%     end
% 
% end
% j=1;
 i=sizeInit+1;
 j=1;
while i <= sizePop
% aux=0;
    [plan_event_aux,plan_state_aux,cost_aux]=createPlan(cur_state,states,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robotTasks,events);
    [plan_masked_aux,taskRobotaux]=convertToMask2(plan_event_aux,numTasks);

    plan_event{1,i}=plan_event_aux;
    cost(1,i)=cost_aux;
    plan_masked{1,i}=plan_masked_aux;
    taskRobot(i,:)=taskRobotaux;
    i=i+1;
    
    
%     for ik=1:i-1
%         if (sum(taskRobotaux==taskRobot(ik,:))==numTasks/2)
%             aux=1;
%             break;
%         end
%     end
%     if aux==0
%         plan_event{1,i}=plan_event_aux;
%         cost(1,i)=cost_aux;
%         plan_masked{1,i}=plan_masked_aux;
%         taskRobot(i,:)=taskRobotaux;
%         i=i+1;
%     end
    j=j+1;
    
    if j>1.5*sizePop
        ju=000
        
    end
    
end

end