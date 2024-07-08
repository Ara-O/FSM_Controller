function [newSolution, removeTasks, newCost] = destroyWorstRobot(solutionRobots,solutionRobotCost,numRobots)

newSolution=solutionRobots;

newCost=solutionRobotCost;

costRobot=zeros(numRobots,1);

for i=1:numRobots
    costRobot(i,1)=sum(newCost{i});
end


[~, orderIndex]=sort(costRobot);

worstRobot= orderIndex(end);

removeTasks=newSolution{worstRobot};

newSolution{worstRobot}=[];

newCost{worstRobot}=[];


end