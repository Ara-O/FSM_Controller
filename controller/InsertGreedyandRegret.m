function [newSolution,newCost] = InsertGreedyandRegret(type, removedTasks,solutionRobots,solutionRobotCost,numRobots,tasks,start_loc)

newSolution=solutionRobots;
newCost=solutionRobotCost;
%I need to check if there is any pair of tasks inside the desired tasks to
%be inserted


desiredTasks(1)=removedTasks(1);
indi=1;
for i=2:length(removedTasks)
    aux=1;
    %check if the pair of the task was already assigned at the removed
    %tasks array
    for j=1:indi %go over the entire array of the tasks already set to be inserted
        if mod(desiredTasks(j),2) %if it was assigned an odd task, check if the removed task is the even task
            if removedTasks(i) == desiredTasks(j)+mod(desiredTasks(j),2)
                aux=0;%if it is, it doesn't need to add it at the list of tasks to reinsert
                break;
            end
        else
            if removedTasks(i) == desiredTasks(j)+mod(desiredTasks(j),2)-1 % if the removed task is the odd task of an even task already set to be assigned
                aux=0;% it doesn't need to add it to the list to be reinsert
                break;
            end
        end
    end
    if aux % if it doesn't have a pair, just add at the list
        indi=indi+1;
        desiredTasks(indi)=removedTasks(i);
    end
end

%Now I need to create the pair of tasks

for i=1:length(desiredTasks)
    previousRobot=0; %to record the robot that had the task assigned previously
    posTask=0; % to save the position of the pair task already assigned
    desiredTask=desiredTasks(i);
    %create the pair of tasks to be reinsert
    %first is the odd task and second is the even task
    pairTasks(1,1)=desiredTask+mod(desiredTask,2)-1;
    pairTasks(2,1)=desiredTask+mod(desiredTask,2);
    
    %I need to calculate the cost of inserting this task at each route in its
    %best position at that route. However, I need to remember that if the route
    %does not have the task or its pair, I need to calculate the cost of adding
    %both. Actually, I just need to find the greedy position of "odd" task and
    %then find the greedy position of "even" task after that.
    
    %I will calculate it for each robot and then I will choose based on the
    %best cost if greedy or best regret
    for indexRobot=1:numRobots
        robotLocation=start_loc(indexRobot,:);
        check=mod(desiredTask,2)+1; %check if the pair task is already at the route
        %if the desiredTask is "even", check = 1, so I will see if the
        %"odd" task is already assigned for that robot. And if the
        %desiredTask is "odd", check=2, so I will check if the "even" task
        %is already assigned for that robot
        test=find(newSolution{indexRobot}==pairTasks(check),1); %check if the robot has the pair task
        actualTasks=length(newSolution{indexRobot});
        if isempty(test) %it means the route doesn't have the pair of the desired task
            middle{indexRobot}=[];
            middleCost{indexRobot}=[];
            middle{indexRobot}=zeros(1,actualTasks+2);
            middleCost{indexRobot}=zeros(1,actualTasks+2);
            j=1;
            indi=0;
            testTask=pairTasks(1,1);
            auxTask1=1;
            auxTask2=1;
            while j<=length(newSolution{indexRobot}) 
                [aux1,auxX1,auxY1]=calcCostTaskSimple(newSolution{indexRobot}(j),tasks,robotLocation); % I check how much cost to add the current task at the robot
                if auxTask1 || auxTask2
                    [aux2,auxX2,auxY2]=calcCostTaskSimple(testTask,tasks,robotLocation); % I check how much cost to add the desiredTask
                else % If I already inserted both tasks, I set the cost to assign it as Inf, so I keep just adding the tasks already assigned to the robot
                    aux2=Inf;
                end
                indi=indi+1;
                if aux1 <= aux2 % If it is cheaper to add the task already assigned to the robot, I keep this task
                   middle{indexRobot}(indi)=newSolution{indexRobot}(j);
                   middleCost{indexRobot}(indi)=aux1;
                   robotLocation=[auxX1,auxY1];
                   j=j+1;
                else %If it is cheaper to assign the desiredTask
                    middle{indexRobot}(indi)=testTask;
                    middleCost{indexRobot}(indi)=aux2;
                    robotLocation=[auxX2,auxY2];
                    if auxTask1 % if I still haven't assigned the "odd" task, this was the task just assigned
                        auxTask1=0; %I set up that I already assigned it and go to check the following "even" task
                        testTask=pairTasks(2,1);
                    else
                        auxTask2=0;
                    end
                    
                end               
            end
            %what if I wnet to all the already assigned tasks and I didn't add the desired tasks
            if auxTask1 %if I didn't assign the "odd" task, I need to assign both tasks
                indi=indi+1;
                middle{indexRobot}(indi)=pairTasks(1,1);
                [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(1,1),tasks,robotLocation);
                indi=indi+1;
                middle{indexRobot}(indi)=pairTasks(2,1);
                [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
            elseif auxTask2
                indi=indi+1;
                middle{indexRobot}(indi)=pairTasks(2,1);
                [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
            end
                
        else %it means the route already has the pair of the desired task
            previousRobot=indexRobot; % I save the robot that had the pair of the desiredTask
            posTask=test;% I also save the position of the pair task 
            if mod(desiredTask,2) %if the desired task is an "odd" task, so I need to add the task before the position of the "even" task
                middle{indexRobot}=[];
                middleCost{indexRobot}=[];
                middle{indexRobot}=zeros(1,actualTasks+1);
                middleCost{indexRobot}=zeros(1,actualTasks+1);
                j=1;
                indi=0;
                testTask=pairTasks(1,1); % I want to add the "odd" task
                auxTask1=1;
                while j<=test-1 % I search to put the task before its "even" task. what if the even task is at the first position?
                    [aux1,auxX1,auxY1]=calcCostTaskSimple(newSolution{indexRobot}(j),tasks,robotLocation);
                    if auxTask1
                        [aux2,auxX2,auxY2]=calcCostTaskSimple(testTask,tasks,robotLocation);
                    else
                        aux2=Inf;
                    end
                    indi=indi+1;
                    if aux1 <= aux2 %if the task from the robot has smaller cost, so I keep the task from the robot
                        middle{indexRobot}(indi)=newSolution{indexRobot}(j);
                        middleCost{indexRobot}(indi)=aux1;
                        robotLocation=[auxX1,auxY1];
                        j=j+1;
                    else % If the cost of the desiredTask is smaller
                        middle{indexRobot}(indi)=testTask;
                        middleCost{indexRobot}(indi)=aux2;
                        robotLocation=[auxX2,auxY2];
                        auxTask1=0; 
                    end
                end
                
                if test==1 %the even task is at the first position
                    [aux2,auxX2,auxY2]=calcCostTaskSimple(testTask,tasks,robotLocation);
                    indi=indi+1;
                    middle{indexRobot}(indi)=testTask;
                    middleCost{indexRobot}(indi)=aux2;
                    robotLocation=[auxX2,auxY2];
                    auxTask1=0;
                    indi=indi+1;
                    %I update the transition cost to the "even" task
                    [aux2,auxX2,auxY2]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
                    robotLocation=[auxX2,auxY2];
                    middle{indexRobot}(1,indi)= pairTasks(2,1);
                    middleCost{indexRobot}(1,indi)=aux2;
                    indi=indi+1;
                    %I assign the remaining tasks
                    middle{indexRobot}(1,indi:end)= newSolution{indexRobot}(test+1:end);
                    middleCost{indexRobot}(1,indi:end)=newCost{indexRobot}(test+1:end);
                
                %If I went over all the tasks and didn't add the
                %desiredTask
                elseif auxTask1 % I didn't add the desired task
                    indi=indi+1;
                    middle{indexRobot}(indi)=pairTasks(1,1);
                    [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(1,1),tasks,robotLocation);
                    indi=indi+1;
                    middle{indexRobot}(indi)=pairTasks(2,1);
                    [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
                    indi=indi+1;
                    middle{indexRobot}(1,indi:end)= newSolution{indexRobot}(test+1:end);
                    middleCost{indexRobot}(1,indi:end)=newCost{indexRobot}(test+1:end);
                else % I did assign the desiredTask and all the tasks up to the position prior the "even" task
                    indi=indi+1;
                    middle{indexRobot}(indi)=pairTasks(2,1);
                    [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
                    indi=indi+1;
                    middle{indexRobot}(1,indi:end)= newSolution{indexRobot}(test+1:end);
                    middleCost{indexRobot}(1,indi:end)=newCost{indexRobot}(test+1:end);

                end
            else %it means I want to add the "even" task after the position of the "odd" task
                %I increase just one position to the array of tasks
                middle{indexRobot}=[];
                middleCost{indexRobot}=[];
                middle{indexRobot}=zeros(1,actualTasks+1);
                middleCost{indexRobot}=zeros(1,actualTasks+1);
                %I copy all the tasks up to the "odd" task
                middle{indexRobot}(1,1:test)=newSolution{indexRobot}(1:test);
                middleCost{indexRobot}(1,1:test)=newCost{indexRobot}(1:test);
                %I update the robot's location to the "odd" task position
                [robotLocation(1,1),robotLocation(1,2),~]=getTaskLocation(newSolution{indexRobot}(test),tasks);
                j=test+1; %Now, I start my search from the next task position just after the "odd" task
                indi=test;
                testTask=pairTasks(2,1); %this is the task I want to add
                auxTask2=1;
                while j<=actualTasks % I search to put the task after its "odd" task
                    [aux1,auxX1,auxY1]=calcCostTaskSimple(newSolution{indexRobot}(j),tasks,robotLocation);
                    if auxTask2
                        [aux2,auxX2,auxY2]=calcCostTaskSimple(testTask,tasks,robotLocation);
                    else
                        aux2=Inf;
                    end
                    indi=indi+1;
                    if aux1 <= aux2 %If the tasl already assigned to the robot has smaller cost
                        middle{indexRobot}(indi)=newSolution{indexRobot}(j);
                        middleCost{indexRobot}(indi)=aux1;
                        robotLocation=[auxX1,auxY1];
                        j=j+1;
                    else
                        middle{indexRobot}(indi)=testTask;
                        middleCost{indexRobot}(indi)=aux2;
                        robotLocation=[auxX2,auxY2];
                        auxTask2=0;
                    end
                end
                %I assigned all the tasks 
                if auxTask2 %If I didn't assign the "even" task
                    auxTask2=0;
                    indi=indi+1;
                    middle{indexRobot}(indi)=pairTasks(2,1);
                    [middleCost{indexRobot}(indi),robotLocation(1,1),robotLocation(1,2)]=calcCostTaskSimple(pairTasks(2,1),tasks,robotLocation);
                end
            end

        end
    end
    
    %After check how to add the desired task for each one of the robots
    costRobot=zeros(numRobots,1);
    for ll=1:numRobots
        costRobot(ll)=sum(middleCost{ll});        
    end
    [~,indexMin]=sort(costRobot); %I order the cost of the robots 
    
    if type %if it is selected to be a Greedy Insertion
        desiredRobot=indexMin(1); %I choose the robot with the smallest cost
        newSolution{desiredRobot}=[];
        newSolution{desiredRobot}=middle{desiredRobot};
        newCost{desiredRobot}=[];
        newCost{desiredRobot}=middleCost{desiredRobot};

    else %if it is selected to be a Regret Insertion
        for ll=1:numRobots %I calculate the regret for each robot
            regret(ll)=costRobot(ll)-costRobot(indexMin(1));
        end
        [~,indexRegret]=sort(regret);
        desiredRobot=indexRegret(end); %I choose the roboy with biggest regret value
        newSolution{desiredRobot}=[];
        newSolution{desiredRobot}=middle{desiredRobot};
        newCost{desiredRobot}=[];
        newCost{desiredRobot}=middleCost{desiredRobot};
        
    end
    if previousRobot ~=0
        if desiredRobot ~= previousRobot % I added the task pair to a robot that didn't have the desiredTask pair
            %I remove the task from the previous robot
            previousSize=length(newSolution{previousRobot});
            newSolution{previousRobot}(posTask)=[]; %I remove the task from the solution
            newCost{previousRobot}(posTask)=[];% I remove the cost from the solution
            %now needs to update the cost of the following task
            if ~isempty(newCost{previousRobot}) %if there is still tasks at the robot route
                if posTask==1 %if the removed task was the first task
                    nextTask=newSolution{previousRobot}(1);% I grab the new first task
                    robotLocation=start_loc(previousRobot,:);% I update the robot location to its start position
                    [newCost{previousRobot}(1),auxX2,auxY2]=calcCostTaskSimple(nextTask,tasks,robotLocation); % I update the cost for this task
                elseif posTask ~= previousSize %if the removed task is not the first task and not the last task, because if it is the last task, I don't need to do anything
                    nextTask=newSolution{previousRobot}(posTask); %Now that I remove the pairTask, the task after it is at the posTask position
                    previousTask=newSolution{previousRobot}(posTask-1);
                    [robotLocation(1,1),robotLocation(1,2),~] = getTaskLocation(previousTask,tasks);
                    [newCost{previousRobot}(posTask),auxX2,auxY2]=calcCostTaskSimple(nextTask,tasks,robotLocation);
                end
            end
            
        end
    end
    
end
end