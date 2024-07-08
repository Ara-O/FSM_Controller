function [plan,cost] = completeTask(plan_tasks,plan_robot,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr)

pairTasks=numTasks/2;
numPlan=size(plan_tasks);

plans_abs=cell(numPlan(1),pairTasks);

plan=cell(numPlan(1),1);
cost=zeros(numPlan(1),1);

for j=1:numPlan(1)
    test=unique(plan_tasks(j,:));
    if length(test)< pairTasks
        plan_tasks(j,:)=checkInf(plan_tasks(j,:),pairTasks);
    end
    for i=1:pairTasks
        task=plan_tasks(j,i);
        robot=plan_robot(j,i);
        if task<10
            plans_abs{j,i}=strcat(char(robot+96),'0',num2str(task),'s');
        else
            plans_abs{j,i}=strcat(char(robot+96),num2str(task),'s');
        end
    end
    [plan{j},cost(j)] = testPlan(plans_abs(j,:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);
end
end