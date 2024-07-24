function [newSolution, removeTasks, newCost] = destroyWorstTask(solutionRobots,solutionRobotCost,numRemove,numTasks,numRobots,tasks, start_loc)

newSolution=solutionRobots;

newCost=solutionRobotCost;

removeTasks=zeros(numRemove,1);

robotTask=zeros(numTasks,1);
costTaskRemove=zeros(numTasks,1);
costRobot=zeros(numRobots,1);

for i=1:numRobots
    costRobot(i,1)=sum(newCost{i});
end

for i=1:numRobots    
    for j=1:length(newSolution{i})
        costRobotNew=costRobot;
        costRobotNew(i,1)=costRobotNew(i,1)-newCost{i}(j);
        ind=newSolution{i}(j);
        robotTask(ind,1)=i;
        costTaskRemove(ind,1)=max(costRobotNew);       
    end
end

[~, orderedIndex]=sort(costTaskRemove);

for i=1:numRemove
    ind=orderedIndex(i);
    removeTasks(i)=ind;
    index=find(newSolution{robotTask(ind)}==ind);
    if index < length(newSolution{robotTask(ind)})
        if index > 1
            previousTask=newSolution{robotTask(ind)}(index-1);
            afterTask=newSolution{robotTask(ind)}(index+1);
            [robotLocation(1,1),robotLocation(1,2),~]=getTaskLocation(previousTask,tasks);
            [newCost{robotTask(ind)}(index+1),auxX1,auxY1]=calcCostTaskSimple(afterTask,tasks,robotLocation); % I check how much cost to add the cur
        else
            robotLocation=start_loc(robotTask(ind),:);
            nextTask=newSolution{robotTask(ind)}(index+1);
            [newCost{robotTask(ind)}(index+1),~] = calcCostTaskSimple(nextTask,tasks,robotLocation);
        end
    end
            newSolution{robotTask(ind)}(index)=[];
    newCost{robotTask(ind)}(index)=[];
end


end