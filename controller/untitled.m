ind=1;
for i=1:length(cost_init)
    
    [task_robot]=checkRobotPos(path_init(i,:),numTasks);
    if (sum(task_robot==taskju)==numTasks)
        index(ind)=i;
        ind=ind+1;
    end
end

ju={'b09s'
'a11s'
'b07s'
'c03s'
'c05s'
'b08s'
'a12s'
'b01s'
'c06s'
'a13s'
'b10s'
'c04s'
'a14s'
'b02s'
};

taskju=checkRobotPos(ju,numTasks);

indd=find(cost_init==min(cost_init));

for i=1:length(indd)
    [task_mask,taskRobot(:,i)]=convertToMask2(path_init(indd(i),:),numTasks);
    plan_cost=calcCostPlanTasks(path_init(indd(i),:),numRobots,start_loc, tasks);
end


for i=1:numRobots
    ind=1;
    for j=1:2:numTasks-1
        distance(i,ind)=sqrt(((start_loc(i,1)-tasks{j,2})^2)+((start_loc(i,2)-tasks{j,3})^2))+sqrt(((tasks{j,2}-tasks{j+1,2})^2)+((tasks{j,3}-tasks{j+1,3})^2));
        ind=ind+1;
    end
end
