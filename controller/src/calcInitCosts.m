function init_cost = calcInitCosts(event_path,numRobots,start_loc,tasks,numTasks,EEC,regions,numRegions)

init_cost = zeros(1,numRobots);

for i=1:size(event_path)
  
  event = event_path(i,:);
  
  if strcmp(event(end),'s')
    
    event_bot = event(1)-96;
    robX = start_loc(event_bot,1);
    robY = start_loc(event_bot,2);

    
    [taskX,taskY,~] = getTaskLocation(event(2:end-1),tasks);
    
    if (numRegions-numTasks) == 0 % if there are no regions   
      %Assign Cost equal to straight line distance
      transition_cost = sqrt((robX-taskX)^2+(robY-taskY)^2);

    else % 4 or 9 regions ...FOR NOW...
    %elseif numRegions-numTasks == 4 % if 4 regions,

      % determine what region the task is in
      taskRegion = whichRegion(taskX,taskY,numRegions,regions);

      % determine what region the robot is or will be in
      robotRegion = whichRegion(robX,robY,numRegions,regions);

      % Check if the robot is in the task region
      if strcmp(robotRegion,taskRegion)
        transition_cost = sqrt((robX-taskX)^2+(robY-taskY)^2);
      % ...and set it's cost to the straightline dist


      % else the robot and task are not in the same region
      % therefore the robot must be in an adjacent or kiddy-corner region
      % for now, set cost to this formula, 
      else

        transition_cost = max(sqrt((robX-taskX)^2+(robY-taskY)^2),sqrt((robX-taskX)^2+(robY-taskY)^2) - EEC);
        % This equation satisfies both Adjacent and kiddy-corner regions
        % max was added to prevent negative transition costs.
        % sometimes tasks are right nex to each other, but are in different
        % regions. ex: 2 - 5 = -3

      end

    end
    
    init_cost(event_bot) = transition_cost;
    
  end
  
end