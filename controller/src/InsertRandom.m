function [newSolution,newCost] = InsertRandom(removedTasks,solutionRobots,solutionRobotCost,numRobots,tasks,start_loc)

probRobots=1/numRobots;
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
    
    previousRobot=0; %to record the robot that had the task assigned previously
    posTask=0; % to save the position of the pair task already assigned
    
    desiredTask=desiredTasks(i);
    
    pairTasks(1,1)=desiredTask+mod(desiredTask,2)-1;
    pairTasks(2,1)=desiredTask+mod(desiredTask,2);
    
    chooseRobot=rand;
    for j=1:numRobots
        if chooseRobot<=j*probRobots
            indexRobot=j;
            break;
        end
    end
    
    check=mod(desiredTask,2)+1;
    test=find(newSolution{indexRobot}==pairTasks(check),1);
    actualTasks=length(newSolution{indexRobot});
    if isempty(test)
        %this means the task pair was not assigned to this robot previous,
        %so now I need to decide where to insert these two new tasks
        middle=zeros(1,actualTasks+2);
        middleCost=zeros(1,actualTasks+2);
        newPos=randi(actualTasks+1); %find a place to the "odd" task first
        
        if newPos==actualTasks+1 %if the index is at the end of the task vector
            if actualTasks==0% if the robot didn't have any assigned task prior
                robotLocation=start_loc(indexRobot,:);
            else
                [robotLocation(1,1),robotLocation(1,2),~]=getTaskLocation(newSolution{indexRobot}(end),tasks);
            end
            
            middle(1:newPos-1)=newSolution{indexRobot}(1:end);
            middle(newPos)=pairTasks(1,1);
            middle(newPos+1)=pairTasks(2,1);
            
            middleCost(1:newPos-1)=newCost{indexRobot}(1:end);
            
            [middleCost(newPos),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(pairTasks(1,1),tasks,robotLocation);
                        
            [middleCost(newPos+1),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
            newSolution{indexRobot}=[];
            
            newSolution{indexRobot}=middle;
            
            testzero=find(middleCost==0, 1);
            
            if ~isempty(testzero)
                ju=1
            end
            newCost{indexRobot}=[];
            newCost{indexRobot}=middleCost;

            
            
        else % the new position is at the middle of the task vector
            middle=zeros(1,actualTasks+1); %create a new vector with 2 extra positions
            %find the index for the "even" task
            secPos=randi([newPos+1 actualTasks+2]); % this position should be after the first position
            
            %now re-arrange
            
            middle(1:newPos-1)=newSolution{indexRobot}(1:newPos-1);
            middle(newPos)=pairTasks(1,1);
            middle(newPos+1:end)=newSolution{indexRobot}(newPos:end);
            

            
            %now add the new costs
            middleCost=zeros(1,actualTasks+1);
            if newPos==1
                robotLocation=start_loc(indexRobot,:);
            else
                [robotLocation(1,1),robotLocation(1,2),~]=getTaskLocation(newSolution{indexRobot}(newPos-1),tasks);
            end
            
            middleCost(1:newPos-1)= newCost{indexRobot}(1:newPos-1);
            
            [middleCost(newPos),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(pairTasks(1,1),tasks,robotLocation);
            
            [middleCost(newPos+1),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(newSolution{indexRobot}(newPos),tasks,robotLocation);
            
            middleCost(newPos+2:end)=newCost{indexRobot}(newPos+1:end);
            
            newSolution{indexRobot}=[];
            newSolution{indexRobot}=middle;
            
            testzero=find(middleCost==0, 1);
            
            if ~isempty(testzero)
                ju=1
            end
            
            newCost{indexRobot}=[];
            
            newCost{indexRobot}=middleCost;
            

            
            middle=[];
            middleCost=[];
            
            actualTasks=length(newSolution{indexRobot});
            
            middle=zeros(1,actualTasks+1);
            middleCost=zeros(1,actualTasks+1);
            
            
           
            middle=[newSolution{indexRobot}(1:secPos-1),pairTasks(2,1),newSolution{indexRobot}(secPos:end)];
            newSolution{indexRobot}=[];
            newSolution{indexRobot}=middle;
            
            %             else
            [robotLocation(1,1),robotLocation(1,2),~]=getTaskLocation(newSolution{indexRobot}(secPos-1),tasks);
            %             end
            middleCost(1:secPos-1)= newCost{indexRobot}(1:secPos-1);
            
            [middleCost(secPos),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
            
            if secPos < actualTasks+1
                [middleCost(secPos+1),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(newSolution{indexRobot}(secPos+1),tasks,robotLocation);
                
                middleCost(secPos+2:end)=newCost{indexRobot}(secPos+1:end);
            end
            
            newCost{indexRobot}=[];
            
            newCost{indexRobot}=middleCost;
            testzero=find(newCost{indexRobot}==0, 1);
            
            if ~isempty(testzero)
                ju=1
            end
                                
            end
          
        
        %Now we need to find to which robot one of the task was previously
        %assigned
        
        for j=1:numRobots
            if j ~= indexRobot
                test=find(newSolution{j}==pairTasks(check),1);
                if ~isempty(test)
                    previousSize=length(newSolution{j});
                    newSolution{j}(test)=[];
                    newCost{j}(test)=[];
                    if ~isempty(newCost{j}) %if there is still tasks at the robot route
                        if test==1 %if the removed task was the first task
                            nextTask=newSolution{j}(1);% I grab the new first task
                            robotLocation=start_loc(j,:);% I update the robot location to its start position
                            [newCost{j}(1),auxX2,auxY2]=calcCostTaskSimple(nextTask,tasks,robotLocation); % I update the cost for this task
                        elseif test ~= previousSize %if the removed task is not the first task and not the last task, because if it is the last task, I don't need to do anything
                            nextTask=newSolution{j}(test); %Now that I remove the pairTask, the task after it is at the posTask position
                            previousTask=newSolution{j}(test-1);
                            [robotLocation(1,1),robotLocation(1,2),~] = getTaskLocation(previousTask,tasks);
                            [newCost{j}(test),auxX2,auxY2]=calcCostTaskSimple(nextTask,tasks,robotLocation);
                        end
                        testzero=find(newCost{indexRobot}==0, 1);
                        
                        if ~isempty(testzero)
                            ju=1
                        end
                        break;
                    end
                end
            end
        end
        
        
        
    else %now we need to handle when the pair Task is designed to the choosen robot
        %in this case we need to check if we are handle with an "odd" or
        %"even" task
        type=mod(desiredTask,2);
        middle=zeros(1,actualTasks+1);
                
        if type %means that I want to add the "odd" task
            if length(test)>1 || test<=0
                ju=1
            end
            if test > 1
                newPos=randi([1 test-1]); % I need to add the task at any place before the position of "even" task
            else
                newPos=1;
            end
            middle=[newSolution{indexRobot}(1:newPos-1),pairTasks(1,1),newSolution{indexRobot}(newPos:end)];
            newSolution{indexRobot}=[];
            newSolution{indexRobot}=middle;
            
            %now add the new costs
            middleCost=zeros(1,actualTasks+1);
            if newPos==1
                robotLocation=start_loc(indexRobot,:);
            else
                [robotLocation(1,1),robotLocation(1,2),~]=getTaskLocation(newSolution{indexRobot}(newPos-1),tasks);
            end
            middleCost(1:newPos-1)= newCost{indexRobot}(1:newPos-1);
            
            [middleCost(newPos),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(pairTasks(1,1),tasks,robotLocation);
            
            [middleCost(newPos+1),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(newSolution{indexRobot}(newPos+1),tasks,robotLocation);
            
            middleCost(newPos+2:end)=newCost{indexRobot}(newPos+1:end);           
            
            newCost{indexRobot}=[];
            
            newCost{indexRobot}=middleCost;
            
            testzero=find(newCost{indexRobot}==0, 1);
            
            if ~isempty(testzero)
                ju=1
            end
            
        else %it means I wanna add the "even" task
            
            newPos=randi([test+1 actualTasks+1]); % I need to add the task at any place before the position of "even" task
            middle=[newSolution{indexRobot}(1:newPos-1),pairTasks(2,1),newSolution{indexRobot}(newPos:end)];
            newSolution{indexRobot}=[];
            newSolution{indexRobot}=middle;
            
            %now add the new costs
            middleCost=zeros(1,actualTasks+1);
%             if newPos==1
%                 robotLocation=start_loc(indexRobot,:);
%             else
                [robotLocation(1,1),robotLocation(1,2),~]=getTaskLocation(newSolution{indexRobot}(newPos-1),tasks);
%             end
            middleCost(1:newPos-1)= newCost{indexRobot}(1:newPos-1);
            
            [middleCost(newPos),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
            
            
            if newPos < actualTasks
                
                [middleCost(newPos+1),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(newSolution{indexRobot}(newPos+1),tasks,robotLocation);
                middleCost(newPos+2:end)=newCost{indexRobot}(newPos+1:end);
                
            elseif newPos == actualTasks
                
                [middleCost(newPos+1),robotLocation(1,1),robotLocation(1,2)] = calcCostTaskSimple(newSolution{indexRobot}(newPos+1),tasks,robotLocation);
                middleCost(newPos+2:end)=newCost{indexRobot}(newPos+1:end);
                
            end
            
            newCost{indexRobot}=[];
            
            newCost{indexRobot}=middleCost;
            
            testzero=find(newCost{indexRobot}==0, 1);
            
            if ~isempty(testzero)
                ju=1
            end
        end
            
    end
end

end