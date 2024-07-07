function [transition_cost,trans_event] ...
          = calcTransitionCost(cur_state,next_state,state_path,states,tasks,EEC,regions,numRegions,start_loc,numTasks,abstracted,start_events_only)
% Author: Jonathon Kreska
% Version: 1.3
% Date: April 4, 2016
% Changelog:
%  1.0: Initial Release
%  1.1: Added functionality for abstracted, start-only, no-region, FSMs
%  1.2: Added flags to determine what transition cost to use and combined 1.1a
%        into this function
%  1.3: Added trans_event
        
% Determine the next event
index = strcmp(states{cur_state,2}(:,2),num2str(next_state));
next_event = states{cur_state,2}{index,1};   

trans_event = next_event;

%% Determine the cost of the transition

%%
if ~abstracted && ~start_events_only % && regions_exist
  
  if strcmp(next_event(end),'f') % Finish events have no cost
    transition_cost = 0;

  elseif  strcmp(next_event(end),'e')     % if next event is an entry event,
    transition_cost = EEC; %set cost to EEC ...FOR NOW....

  else % it is a start event, so the prev location must be determined

    % get the string of events that get to the current state
    if length(state_path)>1
      event_path = calcEventPath(states,1,state_path);
    else
      event_path = []; % if this is the first state, force start_loc to be used
    end

    % Determine what robot will do the transition
    event_bot = next_event(1);
    taskRobot = event_bot-96; % get robot num

    % Determine where the robot was
    index = max(find(strncmp(event_path,event_bot,1)));
    if isempty(index) % if there is not a previous event...
      % it must be the first event for the robot and we can assume the robot 
      % is at the starting position.
      robX = start_loc(taskRobot,1);
      robY = start_loc(taskRobot,2);

    else
      last_event = event_path{index};
      if strcmp(last_event(end),'s') %if the last event for that robot was a 
        % start event, there is not enough info to determine where the robot was
        % so we have to look at the events before it
        index = max(find(strncmp(event_path(1:index-1),event_bot,1)));
      end

      if isempty(index) % if that start event was the first event,
        % the robot is at the starting position.
        robX = start_loc(taskRobot,1);
        robY = start_loc(taskRobot,2);

      else % the robot previously finished a task or entered a region
        last_event = event_path{index};
        last_loc = last_event(2:end-1);

        if strcmp(last_event(end),'e') % if last event was an entry event
          % set the region center to the robot postion ...FOR NOW....
          [robX,robY] = calcRegCenter(last_loc,numRegions,numTasks,regions);
        elseif strcmp(last_event(end),'f') % if last event was a finish event
          [robX,robY,~] = getTaskLocation(last_loc,tasks);
        end
      end
    end


    taskNum = next_event(2:end-1); % get task number

    % Extract the task location
    [taskX,taskY,~] = getTaskLocation(taskNum,tasks);


    if numRegions-numTasks == 0 % if there are no regions   
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

  end
  
%%
elseif abstracted && start_events_only %&& ~regions_exist
  
  % it is a start event, so the prev location must be determined

  % get the string of events that get to the current state
  if length(state_path)>1
    event_path = calcEventPath(states,1,state_path);
  else
    event_path = []; % if this is the first state, force start_loc to be used
  end

  % Determine what robot will do the transition
  event_bot = next_event(1);
  taskRobot = event_bot-96; % get robot num

  % Determine where the robot was
  index = max(find(strncmp(event_path,event_bot,1)));
  if isempty(index) % if there is not a previous event...
    % it must be the first event for the robot and we can assume the robot 
    % is at the starting position.
    robX = start_loc(taskRobot,1);
    robY = start_loc(taskRobot,2);

  else % the robot previously finished a task
      last_event = event_path{index};
      last_loc = last_event(2:end-1);


      [robX,robY,~] = getTaskLocation(last_loc,tasks);
  end


  taskNum = next_event(2:end-1); % get task number

  % Extract the task location
  %disp(taskNum)
  %disp(tasks)
  [taskX,taskY,~] = getTaskLocation(taskNum,tasks);


  %  there are no regions   
  %Assign Cost equal to straight line distance
  transition_cost = sqrt((robX-taskX)^2+(robY-taskY)^2);

end

