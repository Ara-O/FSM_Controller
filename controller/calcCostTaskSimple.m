function [transition_cost,new_X,new_Y] = calcCostTaskSimple(next_task,tasks,bot_location)
 
%         trans_event = next_event;
        
        robX = bot_location(1);
        robY = bot_location(2);
%         robX = start_loc(taskRobot,1);
%         robY = start_loc(taskRobot,2);
        
        taskNum = next_task; % get task number
        
        % Extract the task location
        %disp(taskNum)
        %disp(tasks)
        [taskX,taskY,~] = getTaskLocation(taskNum,tasks);
        
        new_X = taskX;
        new_Y = taskY;
        %  there are no regions
        %Assign Cost equal to straight line distance
        transition_cost = sqrt((robX-taskX)^2+(robY-taskY)^2);
    
    

end