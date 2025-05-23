% Author: Jonathon Kreska
% Version: 1.6
% Date: March 28, 2016
% Changelog:
%  1.5: Initial Release
%  1.6: Big Fixes
% DEPRECATED - finish events are hard to work with

% Current Capability:
%  Only commands a robot to go to a position if it is the next event's event_bot
%  That makes Finish events a detection AND assignment event.
%  Start events are only a task assignment to move through the FSM.
%  Cost Function is integrated with Djikstra's function.
%  Works with Abstracted Path having Start and finish events

%% Clean-up
rosshutdown; %Shutdown MATLAB ros node if it exists
clear; close ALL; clc;

%% Initialize
addpath('src') %Add functions to path

ABSfoldName = input('Input Abstracted Scenario Name: ','s'); %Get Scenario name from user
foldName = input('Input Overall Scenario Name: ','s'); 

time = datestr(datetime);
fid = fopen(['../Logs/' ABSfoldName '_results_log_' time(1:11) '_' time(13:14) time(16:17) '.txt'],'w');

menuFlag = false;
while ~menuFlag
  menu = input('1 for single, 2 for batch: ','s');
  if strcmp(menu,'1')
    scenNumStart = input('Input Scenario Number: ','s'); %Get Scenario num from user
    scenNumFinish = scenNumStart;
    menuFlag = true;
  elseif strcmp(menu,'2')
    scenNumStart = input('Input Scenario Start Number: ','s'); %Get Scenario num from user
    scenNumFinish = input('Input Scenario Finish Number: ','s');
    menuFlag = true;
  else 
    menuFlag = false;
  end
end

runningScenario = str2double(scenNumStart);

wait = input(['Please load up scenario ' num2str(runningScenario) ', then press Enter']);




while runningScenario <= str2double(scenNumFinish)

  run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI

  rosinit
  %rosinit('192.168.1.83','NodeHost','192.168.1.105','NodeName','/matlab_node')                                        %Start roscore and Matlab node

  for i=1:numRobots                              %Setup Each Robot
    robot{i} = struct;
    robot{i} = setupRobot(robot{i},i-1);   % i-1 because Stage starts with robot_0
    %Movebase fixes
    robot{i}.old_goal_X = 666;
    robot{i}.old_goal_Y = 666;
    robot_previous_location_x(i)=666;
    robot_previous_location_y(i)=666;
    goal_need_resend(i)=0;
    robot_change_count(i)=0;
    robot{i}.first_time = true; % Quarter goal flow control 
  end

  name = 1; x1 = 2; x2 = 4; y1 = 3; y2 = 5;      %Enumerated helper variables
  r = regions; 
  step_through_final = false;

  pause(1)                                       %Wait for roscore to handshake
  disp('Setup complete!')

  %% Setup

  try                                            %Test to see if Stage is Running
    robot{1} = updateLocations(robot{1});
  catch ME
    disp('Is Stage running?')
    rethrow(ME)
  end

  for i=1:numRobots                              %Update Robot Locations
    robot{i} = updateLocations(robot{i});
    start_loc(i,1) = robot{i}.X;
    start_loc(i,2) = robot{i}.Y;
  end

  for i=1:numRobots                              
    goal{i} = [];                                %Initialize goal to nothing
    robot{i}.cur_task = '';                      %Initialize cur_task to empty
  end

  %% Calculate EEC (Entry Event Cost)
  dists = []; goals = [];

  for l=1:size(tasks) % Extract goals from tasks
    if strncmp(tasks(l,1),'ts',2)
      goals = [goals; cell2mat(tasks(l,2:3))];
    end
  end

  % Determine distance between each robot and the furthest goal and the furthest
  % distance between goals to find the longest a robot could travel
  for l=1:numRobots
    pointsNew = [goals;start_loc(l,:)];
    dists = [dists max(pdist(pointsNew,'euclidean'))];
  end
  maxDist = max(dists);

  EEC = maxDist/(sqrt(numRegions-numTasks)+1); % Calculate Fixed Entry Event Cost

  %% Set current state index based on initial_state name
  cur_state = find(strcmp(initial_state,states(:,1))); 
  % Set end state index based on final_state name
  end_state = find(strcmp(final_state,states(:,1)));

  %% Calculate Edge, Cost, and Event Robot Matricies
  [E,event_bots] = calcEdgeAndEventBots(states);

  %% Run Dijkstra algorithm to find path through FSM from cur_state to end_state

  tic
  [ABS_totalCost,ABS_state_path] = robotDijkstra(E,cur_state,end_state,event_bots,numRobots,states,tasks,EEC,regions,numRegions,start_loc,numTasks);
  opt_time = toc

  %% Setup Path Counter (PC)
  ABS_pc = 1;                     %Initialize path counter to be first element of path
  cur_state = ABS_state_path(ABS_pc);       %Initialize current state to be first state on path
  event_bot = 0;

  ABS_event_path = calcEventPath(states,ABS_pc,ABS_state_path);   %Create event path
  
  ABS_next_event=ABS_event_path{ABS_pc};  %Based on chosen path, find the next desired state

  next_event = ABS_next_event;

  % get overall FSM data
  run(['../FSMs/' foldName '/userdata' num2str(runningScenario) '.m'])   

  %% Set current state index based on initial_state name
  cur_state = find(strcmp(initial_state,states(:,1))); 
  % Set end state index based on final_state name
  end_state = find(strcmp(final_state,states(:,1)));
  
  %% Calculate Edge, and Event Robot Matricies
  [E,event_bots] = calcEdgeAndEventBots(states);

  
  % Prepare for Log
  event_path = [];
  state_path = [num2str(cur_state) ' '];
  
  
  
  
  
  
  
  %% MAIN LOOP
  tic
  while 1  

    %% Check if any events occurred
    detected_events = []; %Clear previous detected events
    for i=1:numRobots  %Concatenate detected events strings into comparable matrix
      detected_events = ...
        [detected_events func_detectRegionEvents(i,robot{i}, regions, events)] ;
    end
    for d = 1:numel(detected_events)
      
      if cur_state == end_state %If the current state is the final one
        break %Exit  LOOP
      end % fixes "Index exceeds matrix dimensions." Bug with final state.
      
      next_state_index = strcmp(states{cur_state,2}(:,1),detected_events(d));
      if sum(next_state_index) > 0 % if the detected event is a possible transition,

        % Determine what was detected
        occurred_event = states{cur_state,2}{next_state_index,1};
        fprintf('Detected Event: %s\n', occurred_event)
        
        % Concatenate into event_path for output
        event_path = [event_path occurred_event ' '];

        
        %If the event is a task completion, update cur_task to ''
        if strcmp(occurred_event(end),'f')
          %Convert ascii (str) to robot num (int) and clear task
          robot{occurred_event(1)-96}.cur_task = ''; % 'a'-96 = 1 and so on
          % increment the ABS event path PC
          ABS_pc = ABS_pc+1; %we must increment the path counter to proceed through the path

          if ABS_pc > numel(ABS_event_path)
            ABS_next_event = 'Waiting for Robots to Finish'
          else
            ABS_next_event = ABS_event_path{ABS_pc};  %Based on chosen path, find the next desired state
          end

        end

        % Transition to the next state based on detection
        cur_state = str2double(states{cur_state,2}{next_state_index,2});
        state_path = [state_path num2str(cur_state) ' '];
        
        pc = pc+1; % Increment pc for local path
        
      end
      
    end

    %% Re-Validate next state/event after possible event detection
    if cur_state == end_state %If the current state is the final one
      %prevents accessing outside of path length
      break %Exit MAIN LOOP
    end

    

    %% Track status in Overall FSM    
    
    next_state_index = strcmp(states{cur_state,2}(:,1),ABS_next_event);
    if sum(next_state_index) > 0 % if the next ABS event is a possible transition,
      
      event_bot = states{cur_state,2}{next_state_index,1}(1)-96;

      if strcmp(ABS_next_event(end),'s')
        
        % assign it to the robot
        task_name = ['tsk' ABS_next_event(2:end-1)];

        robot{event_bot}.cur_task = task_name; %Assign task to robot
        fprintf('Robot %d assigned %s\n', event_bot, task_name)
        
        % Concatenate into event_path for output
        event_path = [event_path ABS_next_event ' '];      
        
        % increment the ABS event path PC
        ABS_pc = ABS_pc+1; %we must increment the path counter to proceed through the path
      
        %set it to the next state
        cur_state = str2double(states{cur_state,2}{next_state_index,2});

        % update path through FSM
        state_path = [state_path num2str(cur_state) ' '];

      end
      
      %elseif strcmp(ABS_next_event(end),'f')
        % force the finish event to occur
        next_event = ABS_next_event;
        
       
        

      % because we reached the Next Abstracted State, we need to reset the local
      % search tracking
      pc = 1;
      step_through_local = false;



      
      
      if ABS_pc > numel(ABS_event_path)
        ABS_next_event = 'Waiting for Robots to Finish'
      else
        ABS_next_event = ABS_event_path{ABS_pc};  %Based on chosen path, find the next desired state
      end
  

      
    else % We need to control the robots through the regions 
     
      if ~step_through_final  
        if step_through_local

          next_event = local_event_path{pc};

        else
        % Run a local search in Djikstra for the ABS_next_event
        % This will return the Optimal Path to the next ABS_next_event
        % We then need to step through the local path

        % Run Dijkstra algorithm to find path through FSM from cur_state to next
        % Abstarcted Event
          pc =1;
          [~,local_state_path] = ...
            localDijkstra(E,cur_state,ABS_next_event,event_bots,numRobots,states,tasks,EEC,regions,numRegions,start_loc,numTasks);

          local_event_path = calcEventPath(states,pc,local_state_path);   %Create event path

          step_through_local = true;

        end
      end
      
    end
    
    if strcmp(ABS_next_event,'Waiting for Robots to Finish')
      % if we have reached the end of the abtracted path, we need to optimze to
      % the finish
      
      if step_through_final %  so it only runs once
        if pc > numel(final_event_path)
          next_event = 'Waiting for Robots to Finish';
        else
          next_event = final_event_path{pc}; %Based on chosen path, find the next desired state
        end
        
      else
        pc =1;
        [totalCost,final_state_path] = localDijkstra(E,cur_state,end_state,event_bots,numRobots,states,tasks,EEC,regions,numRegions,start_loc,numTasks);

%         cur_state = final_state_path(pc);       %Initialize current state to be first state on path

        final_event_path = calcEventPath(states,pc,final_state_path);   %Create event path

        next_event=final_event_path{pc};  %Based on chosen path, find the next desired state

        step_through_final = true;

      end
      
    end
   
    
    
    %% Send event bot to its respective goal
    
    event_bot = next_event(1)-96;
    
    if strcmp(next_event(end),'f') % If finish event is next,
      % go directly to the task
      tsk_x = tasks{strcmp(robot{event_bot}.cur_task,tasks(:,1)),2}; % get location
      tsk_y = tasks{strcmp(robot{event_bot}.cur_task,tasks(:,1)),3};

      goal{event_bot} = [tsk_x tsk_y];         
      fprintf('Robot %d going to %s (%3.1f,%3.1f)\n',...
        event_bot, robot{event_bot}.cur_task,tsk_x,tsk_y)

    elseif strcmp(next_event(end),'e') % elseif, send to next region's center
      regNumStr = next_event(2:end-1);
      [tsk_x,tsk_y] = calcRegCenter(regNumStr,numRegions,numTasks,regions);

      goal{event_bot} = [tsk_x tsk_y];         
      fprintf('Robot %d going to reg %s (%3.1f,%3.1f)\n',...
        event_bot, next_event(2:end-1),tsk_x,tsk_y)

    end    

      


    
    %% Send Goals to MoveBase
    for i=1:numRobots
      if ~isempty(goal{i})     % if goal was assigned,

        %after possible goal conditioning, extract the Goal
        robot{i}.goal_msg.X = goal{i}(1); % extract X of goal
        robot{i}.goal_msg.Y = goal{i}(2); % extract Y

        % check if goal is changed so MoveBase doesn't get overloaded
        if (robot{i}.goal_msg.X ~= robot{i}.old_goal_X)...
            || (robot{i}.goal_msg.Y ~= robot{i}.old_goal_Y)...
            || (goal_need_resend(i)==1)
          robot{i}.goal_msg.Z = 1.0; % set direction
          goal_need_resend(i) = 0; % Goal has changed, so we may need to replan
          send(robot{i}.goal_pub,robot{i}.goal_msg) % Publish Goals
          robot{i}.old_goal_X = robot{i}.goal_msg.X;
          robot{i}.old_goal_Y = robot{i}.goal_msg.Y;
        end
      end
    end

    %% Update locations each loop
    for i=1:numRobots
      robot{i} = updateLocations(robot{i});
      robot_current_location_x(i) = robot{i}.X;
      robot_current_location_y(i) = robot{i}.Y;

      % Since Move Base needs time to register that the robot has reached the
      % goal, we need to add a delay to the goal sending so Movebase has time
      % to replan. 
      if(robot_previous_location_x(i) == robot_current_location_x(i))...
          && (robot_previous_location_y(i) == robot_current_location_y(i))
        robot_change_count(i) = robot_change_count(i) +1;
        if robot_change_count(i) > 1000 % wait until new goal is sent or sent again
          % Should be made a timer...
          goal_need_resend(i) = 1;
          robot_change_count(i) = 0;
        end
      else
        robot_change_count(i) = 0;
      end

      robot_previous_location_x(i) = robot{i}.X; %Save location for next loop
      robot_previous_location_y(i) = robot{i}.Y;
      start_loc(i,1) = robot{i}.X;
      start_loc(i,2) = robot{i}.Y;
    end 

  end
  %% Display current state
  disp('Done!')
  
  fprintf(fid,'  Trial %i: \n', runningScenario);
  
  fprintf(fid,'Optimization Time: %f sec\n', opt_time);
  
  time = toc
  fprintf(fid,'Elapsed Time: %f sec\n', time);

    fprintf(fid,'Abstracted Costs:   ');
  for j=1:length(ABS_totalCost)
    fprintf(fid,'%s ',num2str(ABS_totalCost(j)));
  end
  fprintf(fid,'\n');
  
  fprintf(fid,'Abstracted State Path:   ');
  for j=1:length(ABS_state_path)
    fprintf(fid,'%s ',num2str(ABS_state_path(j)));
  end
  fprintf(fid,'\n');
  
  fprintf(fid,'Abstracted Event Path:   ');
  for j=1:length(ABS_event_path)
    fprintf(fid,'%s ',ABS_event_path{j});
  end
  fprintf(fid,'\n');
  
  
  fprintf(fid,'Overall State Path: %s\n',state_path);

  fprintf(fid,'Overall Event Path: %s\n',event_path);
  
  fprintf(fid,'\n\n');


  rosshutdown;
  
  runningScenario = runningScenario + 1;

  if runningScenario <= str2double(scenNumFinish)
    
    waiting = input(['Please load up scenario ' num2str(runningScenario) ', then press Enter']);
  
  end
  
end

fclose('all');

disp('All Trials Complete!')
    