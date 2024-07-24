function [newSolution, removeTasks, newCost] = destroyRandom(solutionRobots,solutionRobotCost,numRemove,numTasks,numRobots,tasks,start_loc)

newSolution=solutionRobots;

newCost=solutionRobotCost;

removeTasks=zeros(numRemove,1);

probTasks= 1/numTasks;
j=1;
while j<=numRemove
    probChoose= rand;
    for i=1:numTasks
        aux_same=0;
        if probChoose <= i*probTasks
            for k=1:j-1
                if removeTasks(k,1)==i
                    aux_same=1;
                    break;
                end
            end
            if ~aux_same
                for l=1:numRobots
                    aux_ind=find(newSolution{l}==i,1);
                    if ~isempty(aux_ind)
                        removeTasks(j,1)=i;
                        j=j+1;
                        if aux_ind<length(newSolution{l})
                            if aux_ind > 1
                            previousTask=newSolution{l}(aux_ind-1);
                            nextTask=newSolution{l}(aux_ind+1);
                            [robotLocation(1,1),robotLocation(1,2),~]=getTaskLocation(previousTask,tasks);
                            [newCost{l}(aux_ind+1),~] = calcCostTaskSimple(nextTask,tasks,robotLocation);
                            else
                                robotLocation=start_loc(l,:);
                                nextTask=newSolution{l}(aux_ind+1);
                                [newCost{l}(aux_ind+1),~] = calcCostTaskSimple(nextTask,tasks,robotLocation);
                            end
                        end
                        newSolution{l}(aux_ind)=[];
                        newCost{l}(aux_ind)=[];
                        %Here I need to update the cost of the task
                        %aux_ind+1, since the robot will be coming from the
                        %position aux_ind-1, instead of aux_ind as
                        %previously
                        
                        break;
                    end
                end
            end
            break;
            
        end
    end
end

%I was thinking that I need to update the cost, since I'm removing one
%task, and the cost of the following transition consider this task
%position, now, it should consider the previous task postion

end