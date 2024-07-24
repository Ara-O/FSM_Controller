% Author: Jonathon Kreska
% Version: 1.12
% Date: August 10, 2016
% Changelog:
%  1.0: Initial Release
%  1.1: Finish events are only a detection event.
%       Robots will wait 1m from the b order of their next region found in
%       the path if they have a task assignment.
%  1.2: An Edge Matrix is generated instead of an Adjacency Matrix to save RAM
%  1.3: Cost and Djikstra are combined. Bug Fixes.
%  1.4: Bug Fixes
%  1.5: Bug Fixes and robot will approach finish
%  1.6: Added Flags that define the FSM situation so Dijkstra knows what to do
%  1.7: Moved menu and folder/file initialization to Launch.m
%  1.8: EEC calcualtion is now a function. Removed old code. Updated function
%       calls
%  Modifications by Daniel Burke
%  1.9: Modified movement function to take more direct routes to tasks
%  1.10: Updated movement function to take into account future events past the
%        next event to be more accurate and added calc_region so that these
%        goals are only calculated once
%  1.11: Updated to accomodate changes in robot dijkstra
%  1.12: Special revision used to test tracking through different incremental
%        fsms regardless of the size and number of fsms
%
% Current Capability:
%  Only commands a robot to go to a position if it is the next event's event_bot
%  Finish events are only a detection event.
%  Robots will wait 1m from the border of their next region found in the 
%   path if they have a task assignment. A robot is onlt allowed to enter a
%   region if its entry event is the next event in the path.
%  Start events are only a task assignment to move through the FSM.
%  Cost Function is integrated with Djikstra's function.



while runningScenario <= str2double(scenNumFinish)

  run(['../FSMs/' foldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI
  run(['../FSMs/' foldName '/fsmdata.m'])       %Import FSM data from FSM GUI
  run(['../FSMs/' foldName '/fsmdataIncremental.m'])

  rosinit

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
    robot{i}.calc_region = true;
    robot{i}.next_event = 's';
    
    goal{i} = [];                                %Initialize goal to nothing
    robot{i}.cur_task = '';                      %Initialize cur_task to empty
  end
  
  init_cost = zeros(1,numRobots);
  clear start_loc


  pause(.5)                                       %Wait for roscore to handshake
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

  %% Calculate EEC (Entry Event Cost)
  EEC = calcEEC(tasks,numRobots,start_loc,numRegions,numTasks);

  %% Set current state index based on initial_state name
  cur_state = find(strcmp(initial_state,states(:,1))); 
  % Set end state index based on final_state name
  end_state = find(strcmp(final_state,states(:,1)));

  %% Calculate Edge List
  edge_list = calcSmallEdgeList(states,end_state);
  
  %% Run Dijkstra algorithm to find path through FSM from cur_state to end_state
  abstracted = false;
  start_events_only = false;
  
  tic
  [totalCost,state_path] = ...
    robotDijkstra(init_cost,edge_list,cur_state,end_state,numRobots,states,tasks,EEC,regions,numRegions,start_loc,numTasks,abstracted,start_events_only,0);
  opt_time = toc;

  %% Setup Path Counter (PC)
  pc = 1;                     %Initialize path counter to be first element of path
  cur_state = state_path(pc);       %Initialize current state to be first state on path
  event_bot = 0;

  fprintf('Current State %u\n',cur_state) %Display current state
  tic

  event_path = calcEventPath(states,1,state_path); 
  
  [~,num_fsm] = size(states_incr);
  
  cur_states = initial_state_incr;
  
  
  
  %% MAIN LOOP
  while 1  

    %% Check if any events occurred
    
    detected_events = []; %Clear previous detected events
    for i=1:numRobots  %Concatenate detected events strings into comparable matrix
      detected_events = ...
        [detected_events func_detectRegionEvents(i,robot{i}, regions, events)] ;
    end

    %event_path = calcEventPath(states,pc,state_path);   %Create event path
    next_event=event_path{pc};  %Based on chosen path, find the next desired state

    %If a detected event is the next event, then it has occured
    if sum(strcmp(next_event, detected_events(:)))>0
      fprintf('Detected Event!: %s \n',next_event)
      pc = pc+1; %So we increment the path counter to the next state
      
      
      %Updates current event for the incremental fsms
      cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm)
      
      if(detectEndState(cur_states,states_incr,num_fsm))
        disp('End State Reached on Incremental')
      end

      %If the event is a task completion, update cur_task to ''
      if strcmp(next_event(end),'f')
        %Convert ascii (str) to robot num (int) and clear task
        robot{next_event(1)-96}.cur_task = ''; % 'a'-96 = 1 and so on
      elseif strcmp(next_event(end),'e') 
        % Resets the calculate region variable
        robot{next_event(1)-96}.calc_region = true;         
      end
          
      robot{next_event(1)-96}.calc_region = true;
      %robot{occurred_event(1)-96}.first_time = true;
      
      % Updates the robots next event
      path_size = size(event_path);
        
      for tmp_pc = (pc):path_size(2)
        if((event_path{tmp_pc}(1) - 96) == (next_event(1)-96))
          if(event_path{tmp_pc}(end) == 'e')
            robot{next_event(1)-96}.next_event = 'e';
            break
          elseif(event_path{tmp_pc}(end) == 'f')
            robot{next_event(1)-96}.next_event = 'f';
            break
          else 
            robot{next_event(1)-96}.next_event = 's';
            break
          end
        end
      end
      
    end

    %% Re-Validate next state/event after possible event detection
    cur_state = state_path(pc);
    if cur_state == end_state %If the current state is the final one
      break %Exit MAIN LOOP
    end

    %% Re-Create path of events
    %event_path = calcEventPath(states,pc,state_path);
    next_event = event_path{pc};

    event_bot = next_event(1) - 96;   %Determine which bot will do this event

    %% Determine the next region of each robot
    for k=1:numRobots
      for l=pc:numel(event_path)
        if strcmp(event_path{l}(1),char(k+96)) && strcmp(event_path{l}(end),'e')
          robot{k}.next_reg = event_path{l}(2:end-1);         %Extract region
          break
        else
          robot{k}.next_reg = [];
        end
      end
    end

    %% Set goal if chosen
    if strcmp(next_event(end),'s')     %If the next event is a start event, 
      pc = pc+1; %we must increment the path counter to proceed through the path
      task_name = ['tsk' next_event(2:end-1)];
      robot{event_bot}.cur_task = task_name; %Assign task to robot
      fprintf('Robot %d assigned %s\n', event_bot, task_name)
      
      
      % Updates Incremental states
      cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm)
      
      if(detectEndState(cur_states,states_incr,num_fsm))
        disp('End State Reached on Incremental')
      end
      
      % Updates the robots next event
      path_size = size(event_path);
        
      for tmp_pc = (pc):path_size(2)
        if((event_path{tmp_pc}(1) - 96) == (next_event(1)-96))
          if(event_path{tmp_pc}(end) == 'e')
            robot{next_event(1)-96}.next_event = 'e';
            break
          elseif(event_path{tmp_pc}(end) == 'f')
            robot{next_event(1)-96}.next_event = 'f';
            break
          else 
            robot{next_event(1)-96}.next_event = 's';
            break
          end
        end
      end
    end 

    %% Assign goal when appropriate 

    for i=1:numRobots
      if ~isempty(robot{i}.cur_task) % if task has been assigned

        tsk_x = tasks{strcmp(robot{i}.cur_task,tasks(:,1)),2}; % get location
        tsk_y = tasks{strcmp(robot{i}.cur_task,tasks(:,1)),3};

        if numRegions-numTasks==0          %If no regions,
          goal{i} = [tsk_x tsk_y];         %go directly to the task
          fprintf('Robot %d going to %s (%3.1f,%3.1f)\n',...
            i, robot{i}.cur_task,tsk_x,tsk_y)
        else

          % Determine the Region of each robot and task
          robot{i}.region = whichRegion(robot{i}.X,robot{i}.Y,numRegions,regions);
          robot{i}.tsk_region =  whichRegion(tsk_x,tsk_y,numRegions,regions);

          % if the next event is a finish event and the next event matches
          % the task assigned to the robot
          % Added strcmp to ensure it is a finish event
          if (strcmp(robot{i}.cur_task(4:end),next_event(2:end-1))...
              || strcmp(robot{i}.region,robot{i}.tsk_region)) && strcmp(robot{i}.next_event,'f')
            % Go directly to the task
            % This fixes the problem of breaking the FSM where robots drift into 
            % another region
            % because they have to avoid an obstacle or they swing wide on a
            % turn
            goal{i} = [tsk_x tsk_y];
            
            
            % Need to reset calc region here to deal with "Trail 60" error in
            % the 6tasks9regions where the robot (for some reason) avoids the
            % task and enters a new region to wait for other bot to move through
            %if strcmp(next_event(end),'e')
            %  robot{i}.calc_region = true;
            %end
            
    %        fprintf('Robot %d going to %s (%3.1f,%3.1f)\n',...
    %          i, robot{i}.cur_task,tsk_x,tsk_y)
            
% Dr. Hill made me comment this out. 
% The PC will only increment if the occured task is next in the path.              
%           elseif (strcmp(robot{i}.region,robot{i}.tsk_region) && robot{i}.first_time)
%             % if the robot and task are in the same region, but the robot
%             % shouldn't finish the task yet, then we should have it start
%             % heading to the task
%             
%             mid_x = (robot{i}.X + tsk_x)/2;
%             mid_y = (robot{i}.Y + tsk_y)/2;
%             
%             close_x = (mid_x + tsk_x)/2;
%             close_y = (mid_y + tsk_y)/2;
%             
%             goal{i} = [close_x close_y];
%             robot{i}.first_time = false; %once the quarter goal has been made, stop sending it

          % else the robot and task are not in the same region  
          elseif ~strcmp(next_event(end),'s')
            %So we have to direct it to the edge of its next region in the path
            %We can only direct a robot to the edge of a region if it has been
            % assigned a task. Otherwise, I will detect a future task's entry
            % events
         
            if (~isempty(robot{i}.next_reg)&& robot{i}.first_time)% if there is a next region in the path
              % have the robot wait at the border between the two regions
              % until the next event in the path says that robot can enter the
              % region
              
              %{
              
              %OLD CODE
              % Calculate both region centers
              [robReg_x,robReg_y] = ...
                calcRegCenter(robot{i}.region,numRegions,numTasks,regions);
              [nxtReg_x,nxtReg_y] = ...
                calcRegCenter(robot{i}.next_reg,numRegions,numTasks,regions);

              % Calculate the Center point of the two regions,
              % which should be the middle of the border
              border_x = (robReg_x + nxtReg_x)/2;
              border_y = (robReg_y + nxtReg_y)/2;

              % To get the robot close to the border without going into the
              % region, we need to find the middle point between the current
              % robot position and the border. I can't set the the goal as the
              % border because the navigation will overshoot.
              mid_x = (robot{i}.X + border_x)/2;
              mid_y = (robot{i}.Y + border_y)/2;

              % get even closer, I will take the middle point of the middle and
              % the middle of the border which will make the robot end up 3/4
              % of the way to the middle of the border.
              close_x = (mid_x + border_x)/2;
              close_y = (mid_y + border_y)/2;

%               % if the middle of the border is futher than 4m from the robot
%               if pdist([robot{i}.X,robot{i}.Y;border_x,border_y],'euclidean') > 4
%                 % assign the waiting point to the robot's goal 1m from the
%                 % border
                goal{i} = [close_x close_y];
                robot{i}.first_time = false;
                
                
              
              %}
              
              % Calculate both region centers
              [robReg_x,robReg_y] = ...
                calcRegCenter(robot{i}.region,numRegions,numTasks,regions);
              [nxtReg_x,nxtReg_y] = ...
                calcRegCenter(robot{i}.next_reg,numRegions,numTasks,regions);

              % Gets the coordinates for the line bordering each region
              [x1,y1,x2,y2] = returnBorderlineCoords(robot{i}.region,robot{i}.next_reg,numRegions,numTasks,regions, ...
                                        robReg_x,robReg_y,nxtReg_x,nxtReg_y);
               
              % Stores coordinates of each line to calculate intersection                        
              x_coordsA = [x1 x2];
              x_coordsB = [tsk_x robot{i}.X];
              y_coordsA = [y1 y2];
              y_coordsB = [tsk_y robot{i}.Y];
              
              % Calculates intersection
              [inter_x,inter_y] = polyxpoly(x_coordsA,y_coordsA,x_coordsB,y_coordsB);
              
              % If there is no intersection it finds the corner closest to task
              if(isempty(inter_x) && isempty(inter_y))
                              
                % Had to modify this, pdist2 uses different coordinate structure
                corner1coords = [x1 y1];
                corner2coords = [x2 y2];
                
                tsk_coords = [tsk_x tsk_y];
                
                dist1 = pdist2(corner1coords,tsk_coords);
                dist2 = pdist2(corner2coords,tsk_coords);
                
                % Sets intersection to the closest corner
                if(dist1 > dist2)
                  inter_x = x2;
                  inter_y = y2;
                else
                  inter_x = x1;
                  inter_y = y1;
                end
                
                % Depending on the location of the robot it sends it to just
                % inside of the corner to avoid some issues with region crossing
                if(robot{i}.X > inter_x)
                  inter_x = inter_x + 3;
                else
                  inter_x = inter_x - 3;
                end
                
                if(robot{i}.Y > inter_y)
                  inter_y = inter_y + 3;
                else
                  inter_y = inter_y - 3;
                end              
              
                
              else                        
                
                % Otherwise it just sets goal to be 3/4s of the way to the
                % border as with the earlier code
                mid_x = (robot{i}.X + inter_x)/2;
                mid_y = (robot{i}.Y + inter_y)/2;

                % get even closer
                inter_x = (mid_x + inter_x)/2;
                inter_y = (mid_y + inter_y)/2;
                
              end
              
              inter_x = round(inter_x, 2);
              inter_y = round(inter_y, 2);
              
              goal{i} = [inter_x inter_y];
              robot{i}.first_time = false; %once the quarter goal has been made, stop sending it
              robot{i}.calc_region = true;

                 
                
                
%               % if this is not included, the code will constantly move the
%               % goal and confuse D* and eventually cross the border
%               end
            end
          end 
        end
      end
    end

    

    %% Move robot to next region is path if chosen
    if (strcmp(next_event(end),'e') && robot{event_bot}.calc_region) % if the next event is an entry event,
      
      %{
      
      %OLD CODE
      [x,y] = calcRegCenter(next_event(2:end-1),numRegions,numTasks,regions);

      goal{event_bot} = [x y];
    %  fprintf('Robot %d GoToReg %s (%3.1f,%3.1f)\n',...
    %    event_bot,next_event(2:end-1),x,y)
      
      robot{event_bot}.first_time = true; % reset
      
      %}
      
      % Uses the same method as start event above
      % Calculate both region centers
      [robReg_x,robReg_y] = ...
         calcRegCenter(robot{event_bot}.region,numRegions,numTasks,regions);
      [nxtReg_x,nxtReg_y] = ...
         calcRegCenter(robot{event_bot}.next_reg,numRegions,numTasks,regions);

      % Gets the coordinates for the line bordering each region
      [x1,y1,x2,y2] = returnBorderlineCoords(robot{event_bot}.region,robot{event_bot}.next_reg,numRegions,numTasks,regions, ...
                                        robReg_x,robReg_y,nxtReg_x,nxtReg_y);
               
      % Gets appropriate task location                                
      tsk_x = tasks{strcmp(robot{event_bot}.cur_task,tasks(:,1)),2}; % get location
      tsk_y = tasks{strcmp(robot{event_bot}.cur_task,tasks(:,1)),3};                                
                                      
      % Stores coordinates of each line to calculate intersection                        
      x_coordsA = [x1 x2];
      x_coordsB = [tsk_x robot{event_bot}.X];
      y_coordsA = [y1 y2];
      y_coordsB = [tsk_y robot{event_bot}.Y];
              
      % Calculates intersection
      [inter_x,inter_y] = polyxpoly(x_coordsA,y_coordsA,x_coordsB,y_coordsB);
              
      % If there is no intersection it finds the corner closest to task
      if(isempty(inter_x) && isempty(inter_y)) 
        
        % Finds the next region after next region
        path_size = size(event_path);
        nextReg2 = 0;
        
        for tmp_pc = (pc + 1):path_size(2)
          if((event_path{tmp_pc}(1) - 96) == event_bot)
            if(event_path{tmp_pc}(end) == 'e')
              nextReg2 = event_path{tmp_pc}(2:end-1);
              break
            else
              disp('Error: Impossible region scenario')
            end
          end
        end
        
        [nxtReg2_x,nxtReg2_y] = ...
          calcRegCenter(nextReg2,numRegions,numTasks,regions);
       
        [x1,y1,x2,y2] = returnBorderlineCoords(robot{event_bot}.next_reg,nextReg2,numRegions,numTasks,regions, ...
                                        nxtReg_x,nxtReg_y,nxtReg2_x,nxtReg2_y);
                                            
        % Had to modify this, pdist2 uses different coordinate structure
        corner1coords = [x1 y1];
        corner2coords = [x2 y2];
                
        tsk_coords = [tsk_x tsk_y];
                
        dist1 = pdist2(corner1coords,tsk_coords);
        dist2 = pdist2(corner2coords,tsk_coords);
        
        %STOPPING POINT
                
        % Sets intersection to the closest corner
        if(dist1 > dist2)
          inter_x = x2;
          inter_y = y2;
        else
          inter_x = x1;
          inter_y = y1;
        end
                
        % Has to run calculations to determine if it needs to add or subtract to
        % reach the inside corner, otherwise it could place it in wrong region
        % If x's are equal border is vertical
        if(x1 == x2)
          % Then it checks which corner it is in
          if(inter_y == y1)
            % Then checks if the corner is the top or bottom
            if(y1 > y2)
              inter_y = inter_y - 3;
            else
              inter_y = inter_y + 3;
            end
          else
            if(y2 > y1)
              inter_y = inter_y - 3;
            else
              inter_y = inter_y + 3;
            end
          end
          
          %Adjusts the x values
          if(robot{event_bot}.X > inter_x)
            % Has to handle the special case where next next region is same
            % as the current region, otherwise could put on wrong side of border
            if(nextReg2 == robot{event_bot}.region)
              inter_x = inter_x - 3;
            else
              inter_x = inter_x + 3;    %switched these
            end
          else
            if(nextReg2 == robot{event_bot}.region)
              inter_x = inter_x + 3;
            else
              inter_x = inter_x - 3;    %switched these
            end
          end
          
        % Otherwise the y's are equal and the border is horizontal
        else
          % Then it checks which corner it is in
          if(inter_x == x1)
            % Then checks if the corner is the top or bottom
            if(x1 > x2)
              inter_x = inter_x - 3;
            else
              inter_x = inter_x + 3;
            end
          else
            if(x2 > x1)
              inter_x = inter_x - 3;
            else
              inter_x = inter_x + 3;
            end
          end
          
          % Adjusts the y values
          if(robot{event_bot}.Y > inter_y)
            % Has to handle the special case where next next region is same
            if(nextReg2 == robot{event_bot}.region)
              inter_y = inter_y - 3;
            else
              inter_y = inter_y + 3;    %switched these
            end
          else
            if(nextReg2 == robot{event_bot}.region)
              inter_y = inter_y + 3;
            else
              inter_y = inter_y - 3;    %switched these
            end
          end   
        end                    
              
      else
        % Checks if the next event is a entry or finish event to determine a
        % if there is a more accurate positioning
        path_size = size(event_path);
        nextReg2 = -1;
        
        for tmp_pc = (pc + 1):path_size(2)
          if((event_path{tmp_pc}(1) - 96) == event_bot)
            if(event_path{tmp_pc}(end) == 'e')
              nextReg2 = event_path{tmp_pc}(2:end-1);
              break
            elseif(event_path{tmp_pc}(end) == 'f')
              break
            else
              disp('Error: Impossible region scenario')
            end
          end
        end
        
        % If the next event is a finish event we leave the intersection as it is
        % and set the goal to be just past the border
        if(nextReg2 == -1)
          % Checks the orientation of the border
          if(y1 == y2)
            if(robot{event_bot}.Y > y1)
              inter_y = inter_y - 3;
            else
              inter_y = inter_y + 3;
            end  
            
            % We need a buffer if the robot is too close to the region border
            if(abs(inter_x - x1) < 1)
              if(inter_x > x1)
                inter_x = inter_x + 1;
              else
                inter_x = inter_x - 1;
              end
            elseif(abs(inter_x - x2) < 1)
              if(inter_x > x2)
                inter_x = inter_x + 1;
              else
                inter_x = inter_x - 1;
              end
            end
              
          else
            if(robot{event_bot}.X > x1)
              inter_x = inter_x - 3;
            else
              inter_x = inter_x + 3;
            end   
            
            % We need a buffer if the robot is too close to the region border
            if(abs(inter_y - y1) < 1)
              if(inter_y > y1)
                inter_y = inter_y + 1;
              else
                inter_y = inter_y - 1;
              end
            elseif(abs(inter_y - y2) < 1)
              if(inter_y > y2)
                inter_y = inter_y + 1;
              else
                inter_y = inter_y - 1;
              end
            end
          end
        % If the next event is an entry event it needs to set a more accurate goal   
        else
          [nxtReg2_x,nxtReg2_y] = ...
            calcRegCenter(nextReg2,numRegions,numTasks,regions);
       
          [x1,y1,x2,y2] = returnBorderlineCoords(robot{event_bot}.next_reg,...
            nextReg2,numRegions,numTasks,regions,nxtReg_x,nxtReg_y,nxtReg2_x,nxtReg2_y);
          
          % Stores coordinates of each line to calculate intersection                        
          x_coordsA = [x1 x2];
          y_coordsA = [y1 y2];
              
          % Calculates intersection
          [inter_x,inter_y] = polyxpoly(x_coordsA,y_coordsA,x_coordsB,y_coordsB);
              
          % If there is no intersection it finds the corner closest to task
          if(isempty(inter_x) && isempty(inter_y)) 
            % Had to modify this, pdist2 uses different coordinate structure
            corner1coords = [x1 y1];
            corner2coords = [x2 y2];     
            tsk_coords = [tsk_x tsk_y];
                
            dist1 = pdist2(corner1coords,tsk_coords);
            dist2 = pdist2(corner2coords,tsk_coords);
        
            % Sets intersection to the closest corner
            if(dist1 > dist2)
              inter_x = x2;
              inter_y = y2;
            else
              inter_x = x1;
              inter_y = y1;
            end
                
            if(x1 == x2)
              % Then it checks which corner it is in
              if(inter_y == y1)
                % Then checks if the corner is the top or bottom
                if(y1 > y2)
                  inter_y = inter_y - 3;
                else
                  inter_y = inter_y + 3;
                end
              else
                if(y2 > y1)
                  inter_y = inter_y - 3;
                else
                  inter_y = inter_y + 3;
                end
              end
          
              %Adjusts the x values
              if(robot{event_bot}.X > inter_x)
                % Has to handle the special case where next next region is same
                % as the current region, otherwise could put on wrong side of border
                if(nextReg2 == robot{event_bot}.region)
                  inter_x = inter_x - 3;
                else
                  inter_x = inter_x + 3;    %switched these earlier - kept same
                end
              else
                if(nextReg2 == robot{event_bot}.region)
                  inter_x = inter_x + 3;
                else
                  inter_x = inter_x - 3;    %switched these earlier ^
                end
              end
          
            % Otherwise the y's are equal and the border is horizontal
            else
               % Then it checks which corner it is in
              if(inter_x == x1)
                % Then checks if the corner is the top or bottom
                if(x1 > x2)
                  inter_x = inter_x - 3;
                else
                  inter_x = inter_x + 3;
                end
              else
                if(x2 > x1)
                  inter_x = inter_x - 3;
                else
                  inter_x = inter_x + 3;
                end
              end
          
              % Adjusts the y values
              if(robot{event_bot}.Y > inter_y)
                % Has to handle the special case where next next region is same
                if(nextReg2 == robot{event_bot}.region)
                  inter_y = inter_y - 3;
                else
                  inter_y = inter_y + 3;    %switched these
                end
              else
                if(nextReg2 == robot{event_bot}.region)
                  inter_y = inter_y + 3;
                else
                  inter_y = inter_y - 3;    %switched these
                end
              end   
            end  
          % If there is a second intersection we set it to just inside the intersect
          else
            % Checks the orientation of the border
            if(y1 == y2)
              if(robot{event_bot}.Y > y1)
                inter_y = inter_y + 3;
              else
                inter_y = inter_y - 3; %Switched these
              end     
              
              % We need a buffer if the robot is too close to the region border
              if(abs(inter_x - x1) < 1)
                if(inter_x > x1)
                  inter_x = inter_x + 1;
                else
                  inter_x = inter_x - 1;
                end
              elseif(abs(inter_x - x2) < 1)
                if(inter_x > x2)
                  inter_x = inter_x + 1;
                else
                  inter_x = inter_x - 1;
                end
              end
              
            else
              if(robot{event_bot}.X > x1)
                inter_x = inter_x + 3;
              else
                inter_x = inter_x - 3; %Switched these
              end   
              
              % We need a buffer if the robot is too close to the region border
              if(abs(inter_y - y1) < 1)
                if(inter_y > y1)
                  inter_y = inter_y + 1;
                else
                  inter_y = inter_y - 1;
                end
              elseif(abs(inter_y - y2) < 1)
                if(inter_y > y2)
                  inter_y = inter_y + 1;
                else
                  inter_y = inter_y - 1;
                end
              end
            end
          end %if isempty for second intersect test      
          
         
        end
          
      end
      
      inter_x = round(inter_x, 2);
      inter_y = round(inter_y, 2);
      
      %TEMPORARY CHANGE
      %[inter_x, inter_y] = calcRegCenter(next_event(2:end-1),numRegions,numTasks,regions);
      
      goal{event_bot} = [inter_x inter_y];
      fprintf('Robot %d GoToReg %s (%3.1f,%3.1f)\n',...
        event_bot,next_event(2:end-1),inter_x,inter_y)
      
      %robot{event_bot}.first_time = true; % reset quarter goal output control
      robot{event_bot}.calc_region = false; % makes sure this is calculated once 

      %}
      
    end

    %fprintf('\n\n') % Clean up Command Window

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
        if robot_change_count(i) > 100 % wait until new goal is sent or sent again
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
  
  fprintf(fid,'Optimization Time: %f\n', opt_time);
  
  time = toc;
  fprintf(fid,'Elapsed Time: %f\n', time);
  
  fprintf(fid,'Costs:   ');
  for j=1:length(totalCost)
    fprintf(fid,'%s ',num2str(totalCost(j)));
  end
  fprintf(fid,'\n');

  fprintf(fid,'State Path:   ');
  for j=1:length(state_path)
    fprintf(fid,'%s ',num2str(state_path(j)));
  end
  fprintf(fid,'\n');
  
  event_path = calcEventPath(states,1,state_path);
  fprintf(fid,'Event Path:   ');
  for j=1:length(event_path)
    fprintf(fid,'%s ',event_path{j});
  end
  
  fprintf(fid,'\n\n');


  rosshutdown;
  
  runningScenario = runningScenario + 1;

  if runningScenario <= str2double(scenNumFinish)
    
    waiting = input(['Please load up scenario ' num2str(runningScenario) ', then press Enter']);
  
  end
  
end

fclose('all');

disp('All Trials Complete!')

