function [newSolution, removeTasks, newCost] = destroyLastTask(solutionRobots,solutionRobotCost,numRobots)

newSolution=solutionRobots;

newCost=solutionRobotCost;


ind=1;
for i=1:numRobots
    if ~isempty(newSolution{i})
        if newSolution{i}(end)==0
            ju=2
        end
        removeTasks(ind,1)=newSolution{i}(end);
        newSolution{i}(end)=[];
        newCost{i}(end)=[];
        ind=ind+1;
    end
    
    

end



end