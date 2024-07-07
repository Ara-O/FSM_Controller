function [finalPlan, cost] = twoOpt(plan_abs,cost_abs,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr)

% aux_better=1;
% test_plan=plan_abs;
% cost_test=cost_abs;
% max_rep1 =100;%factorial(numTasks/2);
% num_rep=0;
% rep_better=2;
% better_num=0;

finalPlan=plan_abs;
cost=cost_abs;

for i=1:length(plan_abs)-1
    for k=i+1:length(plan_abs)
    
%     indexes=randi(numTasks/2,1,2);
%     
%     if ~isempty(find(indexes==1))
%         indexes(indexes==1)=indexes(indexes==1)+1;
%     end
%     
%     
%     if indexes(1) > indexes(2)
%         k=indexes(1);
%         i=indexes(2);
%     elseif indexes(1)==indexes(2)
%         if indexes(1)==numTasks/2
%             k=indexes(2);
%             i=indexes(1)-1;
%         else
%             k=indexes(2)+1;
%             i=indexes(1);
%         end
%     else
%         k=indexes(2);
%         i=indexes(1);
%     end
    
    new_abs=[plan_abs(1:i-1),flip(plan_abs(i:k)),plan_abs(k+1:end)];
    
     [planAux,costAux] = testPlan(new_abs,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);

     if costAux < cost
         cost=costAux;
         finalPlan=planAux;
         break;
     end
    end
end

end