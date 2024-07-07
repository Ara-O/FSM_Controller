function [costs,paths] = ...
  localDijkstra(init_cost,E,cur_state,ABS_event_path,ABS_pc,numRobots,states,tasks,EEC,regions,numRegions,start_loc,numTasks,abstracted,start_events_only,init_loc,robot_tasks)
% Updated by: Jonathon Kreska
% Version: 1.3
% Date: May 3, 2016
% Changelog:
%  1.0: Initial Release
%  1.1: Can use transition or state as the termination
%  1.2: No more massive event_bot Matix
%  Modifications by Daniel Burke
%  1.3: Changed cost calculation to be more accurate and reflect the direct
%       routes done in movement, added variables to track the robots location at
%       each point and each robots current task
%
% Current Capability:
%  This function uses a Dijkstra's Algorithm to determine an optimal path
%  through an FSM. It has been modified to support multiple robots and add an
%  idle cost to an event if the decision will make a robot wait around. 
%  A single-stage Tiebreaker was added to make a decision between two
%  transitions that have the same cost for a robot. The next lowest will be used
%  as a tiebreaker. This will have to be improved when more robots are added.
%  Assumptions: 
%   One Start State, One Finish State.
%   Cost Matrix is nxn.
% Input:
%  E = nx2 Edge List matrix where the first column is the original state and the
%      second column is the state that is being transitioned to
%  cost = nxn Matrix containing the cost of an event for Djikstra's function 
%         where n is the number of states
%  cur_state = The current state of the FSM we are in
%  end_state = The finish state of the FSM
%  event_bots = nxn Matrix for Djikstra's function that says what robot is
%               associated with an event where n is the number of states
%  numRobots = The number of robots in the current FSM
% Output:
%  costs = The cost of the path
%  paths = An array of state numbers that are determined to be the most optimal
%          path
% Acknowledgements:
%  This function was based on the following MATLAB File Exchange function:
%  https://www.mathworks.com/matlabcentral/fileexchange/20025-dijkstra-s-minimum-cost-path-algorithm
%  It was then modified by Kaylah Berndt to calculate costs, idle, and
%  tiebreakers for multiple robots. 
%  After this, it was tailored to the robot scenarios and simplified for speed.

% Process inputs
[n,~] = size(states);
all_ass_event_path = calcPathUntilAllBotAssigned(ABS_event_path,numRobots,ABS_pc);
path_satisfied = false;

% Initialize output variables
costs = zeros(1,1);
paths = num2cell(NaN(1,1));

% Find the minimum costs and paths using Dijkstra's Algorithm
for k = 1:1  
    
  % Initializations
  iTable = NaN(n,1);  % cost table
  minCost = Inf(n,1);
  isSettled = false(n,1);
  path = num2cell(NaN(n,1));
  botTable = NaN(n,numRobots);  % Individual robot costs matrix
  I = cur_state(k);
  %minCost(I) = max(init_cost);  % I'm pretty sure it's max...
  %iTable(I) = max(init_cost);
  %botTable(I,:) = init_cost;
  minCost(I) = 0; 
  iTable(I) = 0;
  botTable(I,:) = 0;
  isSettled(I) = true;
  path(I) = {I};
  next_event = 'init';
  robotLocation = num2cell(NaN(n,numRobots));
  % Sets up the robots initial locations
  for i = 1:numRobots
    robotLocation{cur_state,i} = [init_loc(i,1) init_loc(i,2)];
  end

  % Execute Dijkstra's Algorithm for this vertex
  while ~path_satisfied
        
    % Update the table
    jTable = iTable;  % Jtable is temporary to hold calculations
    iTable(I) = NaN;
    nodeIndex = find(E(:,1) == I); % find the index locations in the Edge Matrix of the transitions from the current state to the next state

    % Calculate the costs to the neighbor nodes and record paths
    for kk = 1:length(nodeIndex) % iterate through the number of transitions
      J = E(nodeIndex(kk),2); % get state number of transition
      if ~isSettled(J) % check if state is settled

        %% Calculate all robot costs for this transition
        J_costs = botTable(J,:); % All robots, next state TOTAL cost

        index = strcmp(states{I,2}(:,2),num2str(J));
        next_event = states{I,2}{index,1};
        event_bot = next_event(1)-96;
        
        % OLD IDLE COST CALCULATION
        % Add in robot idle costs
  %      currBotLoad = botTable(I,event_bot);
  %      for w = 1:numRobots  % Bot next load = current load + idle cost
  %        J_costs(w) = botTable(I,w) + max(0,currBotLoad - botTable(I,w));
  %      end

        for w = 1:numRobots  % Bot next load = current load + idle cost
          J_costs(w) = botTable(I,w);
        end
   
    %    currBotLoad = botTable(I,event_bot);
        % Adds Idle cost only to event owner bot
    %    idle_cost = max(0,max(botTable(I,:)) - currBotLoad);
        % Bot next load = current load + idle cost
    %    J_costs(event_bot) = botTable(I,event_bot) + idle_cost;
             
  
        [transition_cost,~,new_X,new_Y] = ...
          calcTransitionCost(next_event,I,J,path{I},states,tasks,EEC,regions,numRegions,start_loc,...
          numTasks,abstracted,start_events_only,robotLocation{I,event_bot},robot_tasks,0);
%         transition_cost = cost(I,J);
        % Except our current robot isn't idle.        
   %     J_costs(event_bot) = botTable(I,event_bot) ...
   %                                + transition_cost;
        J_costs(event_bot) = J_costs(event_bot) ...
                                   + transition_cost; 
     
        currBotLoad = J_costs(event_bot);
        % Adds Idle cost only to event owner bot
        idle_cost = max(0,max(J_costs(:)) - currBotLoad);
        % Bot next load = current load + idle cost
        J_costs(event_bot) = J_costs(event_bot) + idle_cost;                         
                                 
                                 
        %% Tie-Breaker - minimize the maximum
        temp_botTable = botTable(J,:);
        temp_Jcosts = J_costs;

        % if the maximums are equal, we will need the next one
        % BUT, we don't want to mess with the values in the actual
        % tables, so make some temporary ones for comparison only.
        if (max(botTable(J,:)) == max(J_costs))
          [~,index] = max(temp_botTable);
          temp_botTable(index) = 0;
          [~,index2] = max(J_costs);
          temp_Jcosts(index2) = 0;
        end

        empty = isnan(jTable(J));
        % This is the section to select event costs
        % if empty || (jTable(J) > (jTable(I) + c))
        if empty || (max(temp_botTable) > max(temp_Jcosts)) % If no cost to this event YET, or if new cost is LESS than old cost
          iTable(J) = max(J_costs);    % Hold the maximum accumulated cost as our total costs.
          % Add in robot costs
          botTable(J,:) = J_costs;    % Costs previously calculated.              

          path{J} = [path{I} J];
          
          % Update all bot locations and tasks
          for jj = 1:numRobots
            robotLocation{J,jj} = robotLocation{I,jj};
            %robotTask(J,jj) = robotTask(I,jj);
          end
          % Updates location of bot
          robotLocation{J,event_bot} = [new_X,new_Y];   
          
          

        else
          iTable(J) = jTable(J);
        end
      end
       
      % check if path was satisfied and exit loop
      if numel(path{J}) > 1 % prevent calculating a path for the start state
        cur_event_path = calcEventPath(states,1,path{J});
        cur_event_path = stripEventPath(cur_event_path,all_ass_event_path);
        matches = false(numel(cur_event_path),1);


        for i=1:numel(cur_event_path)
          if strcmp(all_ass_event_path{i},cur_event_path{i})
            matches(i,1)=true;
          end
        end

        if all(matches) && numel(cur_event_path)==numel(all_ass_event_path)
          %this is the correct path
          path_satisfied = true;
        elseif ~all(matches) %if any are out of order or doesn't exactly follow,
          %make it expensive
          iTable(J,:)=iTable(J,:)*666;
        end
      end
      
    end
    % Find values in the table
    K = find(~isnan(iTable));   % K is 1 where values not NaN
    if isempty(K)
      break
    else
      % Settle the minimum value in the table
      [~,N] = min(iTable(K)); % Find index of minimum of all costs
      I = K(N);
      minCost(I) = iTable(I);
      isSettled(I) = true;
    end
  end
    
  % Store costs and paths

  paths(k,:) = path(J);

  paths = paths{1}; % extract the path
  costs = botTable(J,:);


end