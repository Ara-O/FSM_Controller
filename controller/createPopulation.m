function [plan_event, plan_masked, cost] = createPopulation(sizePop,cur_state,states,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robotTasks,events )

i=1;
aux=0;
j=1;
taskRobot=zeros(numTasks/2,sizePop);
while i <= sizePop
aux=0;
    [plan_event_aux,plan_state_aux,cost_aux]=createPlan(cur_state,states,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robotTasks,events);
    [plan_masked_aux,taskRobotaux(:,1)]=convertToMask2(plan_event_aux,numTasks);

%     for j=1:i-1
%         if isequal(taskRobotaux(:,1),taskRobot(:,j))
%             aux=1;
%             break;
%         end
%         
%     end
    if aux==0
        plan_event{1,i}=plan_event_aux;
        cost(1,i)=cost_aux;
        plan_masked{1,i}=plan_masked_aux;
        i=i+1;
    end
    j=j+1;
    
    if j>1.5*sizePop
        ju=000
        
    end
    
end

end