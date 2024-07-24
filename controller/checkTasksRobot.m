function taskRobot = checkTasksRobot(plan_masked)
numTasks=length(plan_masked);
taskRobot=zeros(1,numTasks/2);
for i=1:length(plan_masked)
    event=plan_masked{i};
    event_robot=event(1)-96;
    if length(event) > 2
        task=str2double(event(end-1:end));
    else
        task=str2double(event(end));
    end
    ind=round(task/2);
    taskRobot(ind)=event_robot;
end
end