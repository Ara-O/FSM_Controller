function [newSolution,newCost] = InsertRegret(removedTasks,solutionRobots,solutionRobotCost,numRobots,tasks,start_loc)

newSolution=solutionRobots;
newCost=solutionRobotCost;
%I need to check if there is any pair of tasks inside the desired tasks to
%be inserted
desiredTasks(1)=removedTasks(1);
indi=1;
for i=2:length(removedTasks)
    aux=1;
    for j=1:indi
        if mod(desiredTasks(j),2)
            if removedTasks(i) == desiredTasks(j)+mod(desiredTasks(j),2)
                aux=0;
                break;
            end
        else
            if removedTasks(i) == desiredTasks(j)+mod(desiredTasks(j),2)-1
                aux=0;
                break;
            end
        end
    end
    if aux
        indi=indi+1;
        desiredTasks(indi)=removedTasks(i);
    end
end

for i=1:length(desiredTasks)
    desiredTask=desiredTasks(i);
    
    pairTasks(1,1)=desiredTask+mod(desiredTask,2)-1;
    pairTasks(2,1)=desiredTask+mod(desiredTask,2);
    
    for indexRobot=1:numRobots
        robotLocation=start_loc(indexRobot,:);
        check=mod(desiredTask,2)+1;
        test=find(newSolution{indexRobot}==pairTasks(check),1);
        actualTasks=length(newSolution{indexRobot});
    end
end
end