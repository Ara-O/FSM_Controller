function [newSolution,newCost] = InsertGreedy(removedTasks,solutionRobots,solutionRobotCost,numRobots,tasks,start_loc)

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

%Now I need to create the pair of tasks

for i=1:length(desiredTasks)
    desiredTask=desiredTasks(i);
    
    pairTasks(1,1)=desiredTask+mod(desiredTask,2)-1;
    pairTasks(2,1)=desiredTask+mod(desiredTask,2);
    
    %I need to calculate the cost of inserting this task at each route in its
    %best position at that route. However, I need to remember that if the route
    %does not have the task or its pair, I need to calculate the cost of adding
    %both. Actually, I just need to find the greedy position of "odd" task and
    %then find the greedy position of "even" task.
    
    for indexRobot=1:numRobots
        robotLocation=start_loc(indexRobot,:);
        check=mod(desiredTask,2)+1;
        test=find(newSolution{indexRobot}==pairTasks(check),1);
        actualTasks=length(newSolution{indexRobot});
        if isempty(test) %it means the route doesn't have the pair of the desired task
            middle{indexRobot}=zeros(1,actualTasks+2);
            middleCost{indexRobot}=zeros(1,actualTasks+2);
            j=1;
            indi=0;
            testTask=pairTasks(1,1);
            auxTask1=1;
            auxTask2=1;
            while j<=length(newSolution{indexRobot}) 
                [aux1,auxX1,auxY1]=calcCostTaskSimple(newSolution{indexRobot}(j),tasks,robotLocation);
                if auxTask1 || auxTask2
                    [aux2,auxX2,auxY2]=calcCostTaskSimple(testTask,tasks,robotLocation);
                else
                    aux2=Inf;
                end
                indi=indi+1;
                if aux1 <= aux2
                   middle{indexRobot}(indi)=newSolution{indexRobot}(j);
                   middleCost{indexRobot}(indi)=aux1;
                   robotLocation=[auxX1,auxY1];
                   j=j+1;
                else
                    middle{indexRobot}(indi)=testTask;
                    middleCost{indexRobot}(indi)=aux2;
                    robotLocation=[auxX2,auxY2];
                    if auxTask1
                        auxTask1=0;
                        testTask=pairTasks(2,1);
                    else
                        auxTask2=0;
                    end
                    
                end               
            end
            %what if I didn't add the desired tasks
            if auxTask1
                middle{indexRobot}(end-1)=pairTasks(1,1);
                [middleCost{indexRobot}(end-1),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(1,1),tasks,robotLocation);
                middle{indexRobot}(end)=pairTasks(2,1);
                [middleCost{indexRobot}(end),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
            elseif auxTask2
                middle{indexRobot}(end)=pairTasks(2,1);
                [middleCost{indexRobot}(end),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
            end
                
        else %it means the rout already has the pair of the desired task
            if mod(desiredTask,2) %id the desired task is an "odd" task
                middle{indexRobot}=zeros(1,actualTasks+1);
                middleCost{indexRobot}=zeros(1,actualTasks+1);
                j=1;
                indi=0;
                testTask=pairTasks(1,1);
                while j<=test-1 % I search to put the task before its "even" task
                    [aux1,auxX1,auxY1]=calcCostTaskSimple(newSolution{indexRobot}(j),tasks,robotLocation);
                    [aux2,auxX2,auxY2]=calcCostTaskSimple(testTask,tasks,robotLocation);
                    indi=indi+1;
                    if aux1 <= aux2
                        middle{indexRobot}(indi)=newSolution{indexRobot}(j);
                        middleCost{indexRobot}(indi)=aux1;
                        robotLocation=[auxX1,auxY1];
                        j=j+1;
                    else
                        middle{indexRobot}(indi)=testTask;
                        middleCost{indexRobot}(indi)=aux2;
                        robotLocation=[auxX2,auxY2];
                        auxTask1=0;
                        break;
                    end
                end
                if auxTask1
                    indi=indi+1;
                    middle{indexRobot}(indi)=pairTasks(1,1);
                    [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(1,1),tasks,robotLocation);
                    indi=indi+1;
                    middle{indexRobot}(indi)=pairTasks(2,1);
                    [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
                    indi=indi+1;
                    middle{indexRobot}(indi:end,1)= newSolution{indexRobot}(test+1:end);
                    middleCost{indexRobot}(indi:end,1)=newCost{indexRobot}(test+1:end);
                else
                    indi=indi+1;
                    middle{indexRobot}(indi)=newSolution{indexRobot}(j);
                    [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(newSolution{indexRobot}(j),tasks,robotLocation);
                    indi=indi+1;
                    middle{indexRobot}(indi:end,1)= newSolution{indexRobot}(j+1:end);
                    middleCost{indexRobot}(indi:end,1)=newCost{indexRobot}(j+1:end);  
                end
            else %it means I want to add the "even" task after the position of the "odd" task
                middle{indexRobot}=zeros(1,actualTasks+1);
                middleCost{indexRobot}=zeros(1,actualTasks+1);
                middle{indexRobot}(1:test,1)=newSolution{indexRobot}(1:test);
                middleCost{indexRobot}(1:test,1)=newCost{indexRobot}(1:test);
                [robotLocation(1,1),robotLocation(1,2),~]=getTaskLocation(newSolution{indexRobot}(test),tasks);
                j=test+1;
                indi=0;
                testTask=pairTasks(2,1);
                while j<=actualTasks % I search to put the task before its "even" task
                    [aux1,auxX1,auxY1]=calcCostTaskSimple(newSolution{indexRobot}(j),tasks,robotLocation);
                    [aux2,auxX2,auxY2]=calcCostTaskSimple(testTask,tasks,robotLocation);
                    indi=indi+1;
                    if aux1 <= aux2
                        middle{indexRobot}(indi)=newSolution{indexRobot}(j);
                        middleCost{indexRobot}(indi)=aux1;
                        robotLocation=[auxX1,auxY1];
                        j=j+1;
                    else
                        middle{indexRobot}(indi)=testTask;
                        middleCost{indexRobot}(indi)=aux2;
                        robotLocation=[auxX2,auxY2];
                        auxTask2=0;
                        break;
                    end
                end
                if auxTask2
                    indi=indi+1;
                    middle{indexRobot}(indi)=pairTasks(2,1);
                    [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
                else
                    indi=indi+1;
                    middle{indexRobot}(indi)=newSolution{indexRobot}(j);
                    [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(newSolution{indexRobot}(j),tasks,robotLocation);
                    indi=indi+1;
                    middle{indexRobot}(indi:end,1)= newSolution{indexRobot}(j+1:end);
                    middleCost{indexRobot}(indi:end,1)=newCost{indexRobot}(j+1:end);  
                end
            end

        end
    end
    
    %I check which gives me the smallest cost
    costRobot=zeros(numRobots,1);
    for ll=1:numRobots
        costRobot(ll)=sum(middleCost{indexRobot});        
    end
    [~,indexMin]=sort(costRobot);
    
    desiredRobot=indexMin(1);
    newSolution{desiredRobot}=[];
    newSolution{desiredRobot}=middle{desiredRobot};
    newCost{desiredRobot}=[];
    newCost{desiredRobot}=middleCost{desiredRobot};
    
end
end