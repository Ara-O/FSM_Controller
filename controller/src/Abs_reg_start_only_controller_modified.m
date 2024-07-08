% Author: Jonathon Kreska/Daniel Burke
% Version: 1.9
% Date: September 9, 2016
% Changelog:
%  1.12: Initial release, modified the abstracted controller to only use
%  incremental fsms so that scenarios with full fsms that are too large to
%  create edge lists for can be run.
%

% Current Capability:
%  Only commands a robot to go to a position if it is the next event's event_bot
%  That makes Finish events a detection AND assignment event.
%  Start events are only a task assignment to move through the FSM.
%  Cost Function is integrated with Djikstra's function.
%  Works with Abstracted Path having only Start events
z=0;
z2=0;
num_evalt = 0;
num_evalt2=0;
num_eval2 =0;
num_eval=0;
aux_LD=0;
while runningScenario <= str2double(scenNumFinish)

  run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI
  run(['../FSMs/' ABSfoldName '/fsmdata.m'])       %Import FSM data from FSM GUI

  
  rosinit('localhost')

  for i=1:numRobots                              %Setup Each Robot
    robot{i} = struct;
    robot{i} = setupRobot(robot{i},i);   % i-1 because Stage starts with robot_0
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
    robot{i}.next_reg = []; %fixes: Reference to non-existent field 'next_reg'.
    
    goal{i} = [];                                %Initialize goal to nothing
    robot{i}.cur_task = '';                      %Initialize cur_task to empty
  end

  step_through_final = false;
  step_through_local = false;
  init_cost = zeros(1,numRobots);
  init_place=start_loc;
  clear start_loc;

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


  %% Set current state index based on initial_state name
  cur_state = find(strcmp(initial_state,states(:,1))); 
  % Set end state index based on final_state name
  end_state = find(strcmp(final_state,states(:,1)));

  %% Calculate Edge List
  edge_list = calcSmallEdgeList(states,end_state);
  
  %% Run Dijkstra algorithm to find path through FSM from cur_state to end_state
  
  % Restore menu options to run Abstracted Dijkstra
  abstracted = true;
  start_events_only = true;
  
  tic
  [ABS_totalCost,ABS_state_path] = ...
    robotDijkstra(init_cost,edge_list,cur_state,end_state,numRobots,states,tasks,0,regions,0,start_loc,numTasks,abstracted,start_events_only,0);
  opt_time = toc;

  %% Setup Path Counter (PC)
  ABS_pc = 1;                     %Initialize path counter to be first element of path
  event_bot = 0;

  ABS_event_path = calcEventPath(states,ABS_pc,ABS_state_path);   %Create event path
  
  ABS_next_event=ABS_event_path{ABS_pc};  %Based on chosen path, find the next desired state

  next_event = ABS_next_event;  

  %% get overall FSM data
  run(['../FSMs/' foldName '/userdata' num2str(runningScenario) '.m'])  
  run(['../FSMs/' foldName '/fsmdataIncremental.m'])       %Import FSM data from FSM GUI
  %run(['../FSMs/' foldName '/fsmdata.m']) 
  clear start_loc; % delete cell matrix locations from GUI
  
  % Get locations again
  for i=1:numRobots                              %Update Robot Locations
    robot{i} = updateLocations(robot{i});
    start_loc(i,1) = robot{i}.X;
    start_loc(i,2) = robot{i}.Y;
  end

  % Alter menu options to run local Dijkstra
  abstracted = false;
  start_events_only = false;
  
  %% Calculate EEC (Entry Event Cost)
  %EEC = calcEEC(tasks,numRobots,start_loc,numRegions,numTasks);

  %% Set current state index based on initial_state name
  %cur_state = find(strcmp(initial_state,states(:,1))); 
  % Set end state index based on final_state name
  %end_state = find(strcmp(final_state,states(:,1)));
  
  %% Calculate Edge, and Event Robot Matricies
  %edge_list = calcSmallEdgeList(states,end_state);

  % Prepare for Log
  event_path = [];
  cur_states = initial_state_incr;
  state_path = cur_states;
  
  
  [~,num_fsm] = size(states_incr);
  
  
  event_list = createEventFsmList(events_incr,num_fsm);
  
  % Initializes robot tasks for edge cases
  % Catches bug where a robot is not assigned a task initially
  
  temp_tasks = false(1,numRobots);
  
  for t = 1:numRobots
    if(~temp_tasks(t))
      [~,ABS_size] = size(ABS_event_path);
      for u = 1:ABS_size
        if((ABS_event_path{u}(1)-96) == t)
          temp_tasks(t) = true;
          task_name = ['tsk' ABS_event_path{u}(2:end-1)];
          robot{t}.cur_task = task_name; %Assign task to robot
          break
        end
      end
    end
  end
  
  
  %% MAIN LOOP
  totaltime = tic;
  iju=0;
  while 1  

    %% Check if any events occurred
    detected_events = []; %Clear previous detected events
    for i=1:numRobots  %Concatenate detected events strings into comparable matrix
      detected_events = ...
        [detected_events func_detectRegionEvents(i,robot{i}, regions, event_list)] ;
    end
    
    transition_list = createTransitionList(states_incr,cur_states,num_fsm);
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    
    for d = 1:numel(detected_events)
      
      %if cur_state == end_state %If the current state is the final one
      if detectEndState(cur_states,states_incr,num_fsm)
        break %Exit  LOOP
      end % fixes "Index exceeds matrix dimensions." Bug with final state.
      
        
      next_state_index = strcmp(possible_transitions(:,1),detected_events(d));
      %next_state_index = strcmp(states{cur_state,2}(:,1),detected_events(d));
      if sum(next_state_index) > 0 % if the detected event is a possible transition,

        %occurred_event = states{cur_state,2}{next_state_index,1};
        occurred_event = possible_transitions{next_state_index,1};
        
        if (step_through_final || step_through_local) && strcmp(occurred_event,next_event)
          %transition through the FSM only when stepping through the path.
          % prevents transitioning to a state that doesn't match the path
          % Determine what was detected
          fprintf('Detected Event: %s\n', occurred_event)

          %If the event is a task completion, update cur_task to ''
          if strcmp(occurred_event(end),'f')
            %Convert ascii (str) to robot num (int) and clear task
            robot{occurred_event(1)-96}.cur_task = ''; % 'a'-96 = 1 and so on
            % increment the ABS event path PC
          elseif strcmp(occurred_event(end),'e') 
            % Resets the calculate region variable
            robot{occurred_event(1)-96}.calc_region = true;         
          end
          
          robot{occurred_event(1)-96}.calc_region = true;
          %robot{occurred_event(1)-96}.first_time = true;

          % Concatenate into event_path for output
          event_path = [event_path;occurred_event];
          iju=iju+1;
          path_event{iju}=occurred_event;

          % Transition to the next state based on detection
          %cur_state = str2double(states{cur_state,2}{next_state_index,2});

          
          % increment the pc if the occurred event is designated to occur next
          % fixes the issue where a robot may briefly exit a region to avoid an
          % obstacle
          pc = pc+1; % Increment pc for local path
          
          % Updates the robots next event
          path_size = size(local_event_path);
          
          robot_assigned = false(numRobots,1);  
         
          for tmp_pc = (pc):path_size(2)
            rob_num = (local_event_path{tmp_pc}(1) - 96);
            if(~robot_assigned(rob_num,1))
              if(local_event_path{tmp_pc}(end) == 'e')
                robot{rob_num}.next_event = 'e';
                robot_assigned(rob_num,1) = true;
              elseif(local_event_path{tmp_pc}(end) == 'f')
                robot{rob_num}.next_event = 'f';
                robot_assigned(rob_num,1) = true;
              else 
                robot{rob_num}.next_event = 's';
                robot_assigned(rob_num,1) = true;
              end
            end
            if all(robot_assigned)
              break
            end
          end
          
          
          cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm);
          state_path = [state_path;cur_states];
        end 

      end
    end

    %% Re-Validate next state/event after possible event detection
    if detectEndState(cur_states,states_incr,num_fsm) %If the current state is the final one
      %prevents accessing outside of path length
      break %Exit MAIN LOOP
    end
    
    %% determine event path until each robot is used once
    
    

    %% Track status in Overall FSM    
    
    %next_state_index = strcmp(states{cur_state,2}(:,1),ABS_next_event);
    transition_list = createTransitionList(states_incr,cur_states,num_fsm);
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    next_state_index = strcmp(possible_transitions(:,1),ABS_next_event);
    if sum(next_state_index) > 0 % if the next ABS event is a possible transition,
      
      %event_bot = states{cur_state,2}{next_state_index,1}(1)-96;
      event_bot = possible_transitions{next_state_index,1}(1)-96;


      % assign it to the robot
      task_name = ['tsk' ABS_next_event(2:end-1)];

      robot{event_bot}.cur_task = task_name; %Assign task to robot
      fprintf('Robot %d assigned %s\n', event_bot, task_name)

      % Concatenate into event_path for output
      event_path = [event_path;ABS_next_event];      
      iju=iju+1;
      path_event{iju}=ABS_next_event;
      % increment the ABS event path PC
      ABS_pc = ABS_pc+1; %we must increment the path counter to proceed through the path

      %set it to the next state
      %cur_state = str2double(states{cur_state,2}{next_state_index,2});


      % force the Abstracted event to occur
      next_event = ABS_next_event;

      
      % because we reached the Next Abstracted SState, we need to reset the local
      % search tracking
      pc = 1;
      step_through_local = false;

 
      cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm);
  
      % update path through FSM
      state_path = [state_path;cur_states];
   
    else % We need to control the robots through the regions and to the tasks
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
          
          %init_cost = calcInitCosts(event_path,numRobots,start_loc,tasks,numTasks,EEC,regions,numRegions);
          
          robotLocations = NaN(numRobots,2);
          
          % Stores the robots current tasks to send to localDijkstra
          robot_tasks = num2cell(NaN(1,numRobots));
          
          % Need to send robots current location to Dijkstra
          for kk = 1:numRobots
            robotLocations(kk,1) = robot{kk}.X;
            robotLocations(kk,2) = robot{kk}.Y;
            robot_tasks{kk} = robot{kk}.cur_task(4:end);            
          end
          
          
%          [~,local_state_path] = ...
 %           localDijkstra(init_cost,edge_list,cur_state,ABS_event_path,ABS_pc,numRobots,states,...
  %          tasks,EEC,regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robotLocations,robot_tasks);
        a=1   
        ldtime = tic;
          
          [cost_ld,local_state_path,local_event_path,num_eval,total_cost_time,total_trans_list_time,total_pos_trans_time,total_force_start_events_time,total_update_event_time,total_create_event_path_time,total_satisf_path_time] = ...
            localDijkstraIncremental(cur_states,ABS_event_path,ABS_pc,numRobots,states_incr,events_incr,...
            tasks,regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robotLocations,robot_tasks);  
          aux_LD=1;
          a=2
          
          z=z+1;
          localtime(z) = toc(ldtime);
          

          num_evalt(z)=num_eval;
          total_cost_time_t(z)=total_cost_time;
          total_trans_list_time_t(z) = total_trans_list_time;
          total_pos_trans_time_t(z)= total_pos_trans_time;
          
          total_force_start_events_time_t(z)=total_force_start_events_time;
          total_update_event_time_t(z)=total_update_event_time;
          total_create_event_path_time_t(z)=total_create_event_path_time;
          total_satisf_path_time_t(z)=total_satisf_path_time;
         
          %local_event_path = calcEventPath(states,pc,local_state_path);   %Create event path
          next_event = local_event_path{pc};  %Based on chosen path, find the next desired state

          step_through_local = true;
          
          % Updates the robots next event
          path_size = size(local_event_path);
          
          robot_assigned = false(numRobots,1);  
         
          for tmp_pc = (pc):path_size(2)
            rob_num = (local_event_path{tmp_pc}(1) - 96);
            if(~robot_assigned(rob_num,1))
              if(local_event_path{tmp_pc}(end) == 'e')
                robot{rob_num}.next_event = 'e';
                robot_assigned(rob_num,1) = true;
              elseif(local_event_path{tmp_pc}(end) == 'f')
                robot{rob_num}.next_event = 'f';
                robot_assigned(rob_num,1) = true;
              else 
                robot{rob_num}.next_event = 's';
                robot_assigned(rob_num,1) = true;
              end
            end
            if all(robot_assigned)
              break
            end
          end
          
          %cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm)

        end
      end    
    end
    
    %Determine Flag for transition to final path
    all_ass_event_path = calcPathUntilAllBotAssigned(ABS_event_path,numRobots,ABS_pc);
    optest = tasksforallrobots(all_ass_event_path,numRobots,aux_LD,event_path);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Modified Juliana
    %if ~optest
    %if numel(all_ass_event_path)<numRobots
    if numel(all_ass_event_path)==0
      ABS_pc = 666; % force to final path
    end %init_cost = calcInitCosts
   
    %update next Abstracted event
  if ABS_pc > numel(ABS_event_path)
%     if ABS_pc ==666
      ABS_next_event = 'Waiting for Robots to Finish';
    else
      ABS_next_event = ABS_event_path{ABS_pc};  %Based on chosen path, find the next desired state
  end
    
    if strcmp(ABS_next_event,'Waiting for Robots to Finish')
      testj=79;
      % if we have reached the end of the abtracted path, we need to optimze to
      % the finish

      if step_through_final %  so it only runs once
        if pc > numel(local_event_path)
          next_event = 'Waiting for Robots to Finish';
        else
          if strcmp(next_event(end),'s')
            testj=87;
            pc = pc+1; % since there can be start events in the final path, 
                       %  we need to increment to the next start event
                       
            %next_state_index = strcmp(states{cur_state,2}(:,1),next_event);
            %event_bot = states{cur_state,2}{next_state_index,1}(1)-96;
            event_bot = next_event(1)-96;


            % assign it to the robot
            task_name = ['tsk' next_event(2:end-1)];

            robot{event_bot}.cur_task = task_name; %Assign task to robot
            fprintf('Robot %d assigned %s\n', event_bot, task_name)

            % Concatenate into event_path for output
            event_path = [event_path;next_event];      
            iju=iju+1;
            path_event{iju}=next_event;
            %set it to the next state
            %cur_state = str2double(states{cur_state,2}{next_state_index,2});
            
            % Updates the robots next event
            path_size = size(local_event_path);
           
            robot_assigned = false(numRobots,1);  
         
            for tmp_pc = (pc):path_size(2)
              rob_num = (local_event_path{tmp_pc}(1) - 96);
              if(~robot_assigned(rob_num,1))
                if(local_event_path{tmp_pc}(end) == 'e')
                  robot{rob_num}.next_event = 'e';
                  robot_assigned(rob_num,1) = true;
                elseif(local_event_path{tmp_pc}(end) == 'f')
                  robot{rob_num}.next_event = 'f';
                  robot_assigned(rob_num,1) = true;
                else 
                  robot{rob_num}.next_event = 's';
                  robot_assigned(rob_num,1) = true;
                end
              end
              if all(robot_assigned)
                break
              end
            end
            
            cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm);
           
            % update path through FSM
            state_path = [state_path;cur_states];
                    
          end
          
          next_event = local_event_path{pc}; %Based on chosen path, find the next desired state

        end
        
      else
        % Were are in the final stretch to the end, run Djikstra again to the
        % finish state
        pc =1;
        
        %init_cost = calcInitCosts(event_path,numRobots,start_loc,tasks,numTasks,EEC,regions,numRegions);
        
        robotLocations = NaN(numRobots,2);
        
        % Stores the robots current tasks to send to localDijkstra
        robot_tasks = num2cell(NaN(1,numRobots));
        
        % Need to send robots current location to Dijkstra
        for kk = 1:numRobots
          robotLocations(kk,1) = robot{kk}.X;
          robotLocations(kk,2) = robot{kk}.Y; 
          robot_tasks{kk} = robot{kk}.cur_task(4:end);   
        end
          a=3
        rdtime =tic;
        [cost_di,local_state_path,local_event_path,num_eval2] = ...
          robotDijkstraIncremental(cur_states,numRobots,states_incr,events_incr,tasks,...
          regions,numRegions,robotLocations,numTasks,abstracted,start_events_only,robot_tasks); %,robotLocations,robot_tasks
        a=4
        
       z2=z2+1; 
       
       localtime2(z2)=toc(rdtime);
       
       local_event_path;
       
       sum(localtime)+localtime2
       
       num_evalt2(z2)=num_eval2;

        %local_event_path = calcEventPathIncr(states_incr,pc,local_state_path);   %Create event path

        next_event = local_event_path{pc};  %Based on chosen path, find the next desired state

        step_through_final = true;
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Juliana
        robot_assigned = false(numRobots,1);
        
        for tmp_pc = (pc):path_size(2)
          rob_num = (local_event_path{tmp_pc}(1) - 96);
          if(~robot_assigned(rob_num,1))
            if(local_event_path{tmp_pc}(end) == 'e')
              robot{rob_num}.next_event = 'e';
              robot_assigned(rob_num,1) = true;
            elseif(local_event_path{tmp_pc}(end) == 'f')
              robot{rob_num}.next_event = 'f';
              robot_assigned(rob_num,1) = true;
            else
              robot{rob_num}.next_event = 's';
              robot_assigned(rob_num,1) = true;
            end
          end
          if all(robot_assigned)
            break
          end
        end
          
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm)

      end 
    end
   
    %% Determine the next region of each robot
    if step_through_final || step_through_local
      for k=1:numRobots
        for l=pc:numel(local_event_path)
          if strcmp(local_event_path{l}(1),char(k+96)) && strcmp(local_event_path{l}(end),'e')
            robot{k}.next_reg = local_event_path{l}(2:end-1);         %Extract region
            break
          else
            robot{k}.next_reg = [];
          end
        end
      end
    end
    
    %% Assign goal when appropriate 
        
    event_bot = next_event(1) - 96;   %Determine which bot will do this event

    % Determine and set a preliminary goal
    for i=1:numRobots
      if ~isempty(robot{i}.cur_task) % if task has been assigned

        tsk_x = tasks{strcmp(robot{i}.cur_task,tasks(:,1)),2}; % get location
        tsk_y = tasks{strcmp(robot{i}.cur_task,tasks(:,1)),3};


        if numRegions-numTasks==0          %If no regions,
          goal{i} = [tsk_x tsk_y];         %go directly to the task
          %fprintf('Robot %d going to %s (%3.1f,%3.1f)\n',...
            %i, robot{i}.cur_task,tsk_x,tsk_y)
          
        else
          % Determine the Region of each robot and task
          robot{i}.region = whichRegion(robot{i}.X,robot{i}.Y,numRegions,regions);
          robot{i}.tsk_region =  whichRegion(tsk_x,tsk_y,numRegions,regions);
          
          % if the next event is a finish event and the next event matches
          % the task assigned to the robot
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Modified Juliana
          if (strcmp(robot{i}.cur_task(4:end),next_event(2:end-1)) ...
              || strcmp(robot{i}.region,robot{i}.tsk_region)) && strcmp(robot{i}.next_event,'f')
           % if (strcmp(robot{i}.region,robot{i}.tsk_region)) %&& strcmp(robot{i}.next_event,'f')
            % Go directly to the task
            goal{i} = [tsk_x tsk_y];
            %fprintf('Robot %d going to %s (%3.1f,%3.1f)\n',...
              %i, robot{i}.cur_task,tsk_x,tsk_y)
            
            robot{i}.first_time = true; % reset quarter goal
            
          elseif ~strcmp(next_event(end),'s') % if start event, skip until next loop
            if  (strcmp(robot{i}.region,robot{i}.tsk_region) && robot{i}.first_time)
% Dr. Hill made me comment this out. 
% The PC will only increment if the occured task is next in the path.              
%               % if the robot and task are in the same region, but the robot
%               % shouldn't finish the task yet, then we should have it start
%               % heading to the task
% 
%               mid_x = (robot{i}.X + tsk_x)/2;
%               mid_y = (robot{i}.Y + tsk_y)/2;
% 
%               close_x = (mid_x + tsk_x)/2;
%               close_y = (mid_y + tsk_y)/2;
% 
%               goal{i} = [close_x close_y];
%               robot{i}.first_time = false; %once the quarter goal has been made, stop sending it
% 
%             % the robot and task are not in the same region  
%             %So we have to direct it to the edge of its next region in the path
%             %We can only direct a robot to the edge of a region if it has been
%             % assigned a task. Otherwise, it will detect a future task's entry
%             % events
            elseif (~isempty(robot{i}.next_reg) && robot{i}.first_time)
              % if there is a next region in the path, have the robot wait at 
              % the border between the two regions until the next event in the 
              % path says that robot can enter the region

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
                  inter_x = inter_x + 0.25;
                else
                  inter_x = inter_x - 0.25;
                end
                
                if(robot{i}.Y > inter_y)
                  inter_y = inter_y + 0.25;
                else
                  inter_y = inter_y - 0.25;
                end
                
                %{
                % Sets goal to be 3/4s of the way to the
                % corner as with the earlier code
                mid_x = (robot{i}.X + inter_x)/2;
                mid_y = (robot{i}.Y + inter_y)/2;

                % get even closer
                inter_x = (mid_x + inter_x)/2;
                inter_y = (mid_y + inter_y)/2;
                %}
              
              else
                % Otherwise it just sets goal to be 3/4s of the way to the
                % border as with the earlier code
                mid_x = (robot{i}.X + inter_x)/2;
                mid_y = (robot{i}.Y + inter_y)/2;

                % get even closer
                inter_x = (mid_x + inter_x)/2;
                inter_y = (mid_y + inter_y)/2;
                
              end
              
              % Calculate the Center point of the two regions,
              % which should be the middle of the border
     %         border_x = (robReg_x + nxtReg_x)/2;
     %         border_y = (robReg_y + nxtReg_y)/2;

              % To get the robot close to the border without going into the
              % region, we need to find the middle point between the current
              % robot position and the border. I can't set the the goal as the
              % border because the navigation will overshoot.
     %         mid_x = (robot{i}.X + border_x)/2;
     %         mid_y = (robot{i}.Y + border_y)/2;

              % get even closer, I will take the middle point of the middle and
              % the middle of the border which will make the robot end up 3/4
              % of the way to the middle of the border.
     %         close_x = (mid_x + border_x)/2;
     %         close_y = (mid_y + border_y)/2;

              % if the middle of the border is futher than 4m from the robot
              % assign the waiting point to the robot's goal 1m from the
              % border
     %         goal{i} = [close_x close_y];
              goal{i} = [inter_x inter_y];
              robot{i}.first_time = false; %once the quarter goal has been made, stop sending it
              robot{i}.calc_region = true;
              % if this is not included, the code will constantly move the
              % goal and confuse D* and eventually cross the border
            end
          end 
        end
      end
    end

    % Move robot to next region if it is the next event in path
    % if the next event is an entry event, and has not been been calculated yet
    if (strcmp(next_event(end),'e') && robot{event_bot}.calc_region)
      %{
      % override the border goal and direct it to the center of the next region 
      % in the path
      [x,y] = calcRegCenter(next_event(2:end-1),numRegions,numTasks,regions);

      goal{event_bot} = [x y];
      fprintf('Robot %d GoToReg %s (%3.1f,%3.1f)\n',...
        event_bot,next_event(2:end-1),x,y)
      
      robot{event_bot}.first_time = true; % reset quarter goal output control
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
      if strcmp(robot{event_bot}.cur_task,'')
               %a=9; 
      else
        tsk_x = tasks{strcmp(robot{event_bot}.cur_task,tasks(:,1)),2}; % get location
        tsk_y = tasks{strcmp(robot{event_bot}.cur_task,tasks(:,1)),3};
      end
      % Stores coordinates of each line to calculate intersection                        
      x_coordsA = [x1 x2];
      x_coordsB = [tsk_x robot{event_bot}.X];
      y_coordsA = [y1 y2];
      y_coordsB = [tsk_y robot{event_bot}.Y];
              
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
                
        % Has to run calculations to determine if it needs to add or subtract to
        % reach the inside corner, otherwise it could place it in wrong region
        % If x's are equal border is vertical
        if(x1 == x2)
          % Then it checks which corner it is in
          if(inter_y == y1)
            % Then checks if the corner is the top or bottom
            if(y1 > y2)
              inter_y = inter_y - 0.25;
            else
              inter_y = inter_y + 0.25;
            end
          else
            if(y2 > y1)
              inter_y = inter_y - 0.25;
            else
              inter_y = inter_y + 0.25;
            end
          end
          
          %Adjusts the x values
          if(robot{event_bot}.X > inter_x)
            inter_x = inter_x - 0.25;
          else
            inter_x = inter_x + 0.25;
          end
          
        % Otherwise the y's are equal and the border is horizontal
        else
                    % Then it checks which corner it is in
          if(inter_x == x1)
            % Then checks if the corner is the top or bottom
            if(x1 > x2)
              inter_x = inter_x - 0.25;
            else
              inter_x = inter_x + 0.25;
            end
          else
            if(x2 > x1)
              inter_x = inter_x - 0.25;
            else
              inter_x = inter_x + 0.25;
            end
          end
          
          % Adjusts the y values
          if(robot{event_bot}.Y > inter_y)
            inter_y = inter_y - 0.25;
          else
            inter_y = inter_y + 0.25;
          end   
        end
             
              
      else
        % Otherwise it just sets goal to be past the border
        % Checks the orientation of the border
        if(y1 == y2)
          if(robot{event_bot}.Y > y1)
            inter_y = inter_y - 0.25;
          else
            inter_y = inter_y + 0.25;
          end      
          
          % We need a buffer if the robot is too close to the region border
          if(abs(inter_x - x1) < 0.25)
            if(inter_x > x1)
              inter_x = inter_x + 0.25;
            else
              inter_x = inter_x - 0.25;
            end
          elseif(abs(inter_x - x2) < 0.25)
            if(inter_x > x2)
              inter_x = inter_x + 0.25;
            else
              inter_x = inter_x - 0.25;
            end
          end
      else
        if(robot{event_bot}.X > x1)
          inter_x = inter_x - 0.25;
        else
          inter_x = inter_x + 0.25;
        end   
        
        % We need a buffer if the robot is too close to the region border
        if(abs(inter_y - y1) < 0.25)
          if(inter_y > y1)
            inter_y = inter_y + 0.25;
          else
            inter_y = inter_y - 0.25;
          end
        elseif(abs(inter_y - y2) < 0.25)
          if(inter_y > y2)
            inter_y = inter_y + 0.25;
          else
            inter_y = inter_y - 0.25;
          end
        end
        
      end
          
      end
      
      goal{event_bot} = [inter_x inter_y];
      fprintf('Robot %d GoToReg %s (%3.1f,%3.1f)\n',...
        event_bot,next_event(2:end-1),inter_x,inter_y)
      
      %robot{event_bot}.first_time = true; % reset quarter goal output control
      robot{event_bot}.calc_region = false; % makes sure this is calculated once  
      
    end

    %fprintf('\n\n') % Clean up Command Window

    
     %% Send Goals to MoveBase
    for i=1:numRobots
      if ~isempty(goal{i})     % if goal was assigned,
        robot{i}.goal_msg.Header.FrameId=['/robot' char(i+48) '_tf/odom'];
        %after possible goal conditioning, extract the Goal
        robot{i}.goal_msg.Pose.Position.X = goal{i}(1);%goal{i}(2)-init_place{i,2}; % extract X of goal
        robot{i}.goal_msg.Pose.Position.Y = goal{i}(2);%-goal{i}(1)+init_place{i,1}; % extract Y
%         %after possible goal conditioning, extract the Goal
%         robot{i}.goal_msg.X = goal{i}(1); % extract X of goal
%         robot{i}.goal_msg.Y = goal{i}(2); % extract Y
% check if goal is changed so MoveBase doesn't get overloaded
        if (robot{i}.goal_msg.Pose.Position.X ~= robot{i}.old_goal_X)...
            || (robot{i}.goal_msg.Pose.Position.Y ~= robot{i}.old_goal_Y)...
            || (goal_need_resend(i)==1)
          robot{i}.goal_msg.Pose.Orientation.W = 1.0; % set direction
          goal_need_resend(i) = 0; % Goal has changed, so we may need to replan
          send(robot{i}.goal_pub,robot{i}.goal_msg) % Publish Goals
          robot{i}.old_goal_X = robot{i}.goal_msg.Pose.Position.X;
          robot{i}.old_goal_Y = robot{i}.goal_msg.Pose.Position.Y;
%         % check if goal is changed so MoveBase doesn't get overloaded
%         if (robot{i}.goal_msg.X ~= robot{i}.old_goal_X)...
%             || (robot{i}.goal_msg.Y ~= robot{i}.old_goal_Y)...
%             || (goal_need_resend(i)==1)
%           robot{i}.goal_msg.Z = 1.0; % set direction
%           goal_need_resend(i) = 0; % Goal has changed, so we may need to replan
%           send(robot{i}.goal_pub,robot{i}.goal_msg) % Publish Goals
%           robot{i}.old_goal_X = robot{i}.goal_msg.X;
%           robot{i}.old_goal_Y = robot{i}.goal_msg.Y;
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
          %robot{i}.calc_region = true;
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
  
  time = toc(totaltime);
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
  
  
  fprintf(fid,'Overall State Path:   ');
  for j=1:length(state_path)
    fprintf(fid,'[ ');
    for k = 1:num_fsm
      fprintf(fid,'%s ',state_path{j,k});
    end
    fprintf(fid,']  ');
  end
  fprintf(fid,'\n');
  
  fprintf(fid,'Overall Event Path:   ');
  for j=1:size(event_path)
    fprintf(fid,'%s ',num2str(event_path(j,:)));
  end
  fprintf(fid,'\n');
  
  fprintf(fid,'\n');


%   rosshutdown;
  
  runningScenario = runningScenario + 1;

  if runningScenario <= str2double(scenNumFinish)
    waiting = input(['Please load up scenario ' num2str(runningScenario) ', then press Enter']);
  end
  
end

fclose('all');
disp('All Trials Complete!')