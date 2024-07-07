function [costs,paths,event_path,num_eval] = ...
  robotDijkstraIncrementalNewHash(cur_state,numRobots,states,events,tasks,regions,numRegions,start_loc,numTasks,ABSTRACTED,start_events_only,robot_tasks)
% Updated by: Daniel Burke
% Version: 1.2
% Date: May 3, 2016
% Changelog:
%  1.0: Takes the incremental cur_state, states, and events list, and 
%  eliminates unnecessary input like EEC and init_cost. Builds the full
%  fsm �on-the-fly� in the variable trans_mat to eliminate the need to 
%  store a full fsm for the main controller. 

% Current Capability:
%  This function uses a Dijkstra's Algorithm to determine an optimal path
%  through an FSM. It has been modified to take incremental FSMs as input.
% Acknowledgements:
%  This function was based on the following MATLAB File Exchange function:
%  https://www.mathworks.com/matlabcentral/fileexchange/20025-dijkstra-s-minimum-cost-path-algorithm
%  It was then modified by Kaylah Berndt to calculate costs, idle, and
%  tiebreakers for multiple robots. 
%  After this, it was tailored to the robot scenarios and simplified for speed.
num_eval=0;
a=3
event_path='';
[~,num_fsms] = size(states);
%NEED TO REMOVE THIS LATER
EEC = 0;
for i=1:length(states)
    level(i)=length(states{i});
end

total_states=prod(level);
n = 1;
end_unsettled = true;
end_states = double.empty;
%isDone = false(1,numRobots);


% Initialize output variables
costs = zeros(1,1);
paths = num2cell(NaN(1,1));
robotTask=zeros(1,numRobots);

% Find the minimum costs and paths using Dijkstra's Algorithm
for k = 1:1  
    
  % Initializations
  iTable = NaN(n,1);  % cost table
  minCost = Inf(n,1);
  isSettled = false(n,1);
  path = num2cell(NaN(n,1));
  botTable = NaN(n,numRobots);  % Individual robot costs matrix
  I = 1;
  minCost(I) = 0;
  iTable(I) = 0;
  botTable(I,:) = 0;
  isSettled(I) = true;
  path(I) = {I};
  robotLocation = num2cell(NaN(n,numRobots));
  %robotTask = NaN(n,numRobots);
  % Sets up the robots initial locations
  for i = 1:numRobots
    robotLocation{1,i} = [start_loc(i,1) start_loc(i,2)]; %cur_state vs 1
  end

  trans_mat = cell.empty;
  trans_mat{1,1} = cur_state;
  
  checked_state=cell(total_states,1);
  checked_state{1,1}=cur_state;
  checked_state{1,2}=1;
  
  event_list = createEventFsmList(events,num_fsms);
   

  
  % Execute Dijkstra's Algorithm for this vertex
  while end_unsettled %any(~isSettled(end_state))
        
    % Update the table
    jTable = iTable;  % Jtable is temporary to hold calculations
    iTable(I) = NaN;
    
    cur_state = trans_mat{I,1};
    
    if(detectEndState(cur_state,states,num_fsms))
      end_states(end+1) = I;
    end
    
    %if(any(isSettled(end_states)))
    if(isSettled(end_states))
      end_unsettled = false;
       break;
    end
    
    transition_list = createTransitionList(states,cur_state,num_fsms);
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    [possible_transitions] = forceStartEvents(path{I},possible_transitions,trans_mat);  
   
    num_transitions = size(possible_transitions);
    
    % If there are no transitions out for this bot it is done
    %if(~isnan(bot_done))
      %event_index = strcmp(trans_mat{path{I}(end-1),2}(:,2),num2str(path{I}(end)));
      %trans_event = trans_mat{path{I}(end-1),2}{event_index,1}{1};
      %bot_num = trans_event(1)-96;
      %isDone(bot_done) = true;  
    %end  
     num_eval = num_eval+num_transitions(1); 
    % Calculate the costs to the neighbor nodes and record paths
    for kk = 1:num_transitions(1) % iterate through the number of transitions
      next_state = updateCurEvent(possible_transitions(kk),cur_state,events,states,num_fsms);
      
      [newIndex,index,checked_state] = curStateIndexNew2(checked_state,trans_mat,next_state,num_fsms,level);
      
      event_bot = possible_transitions{kk}(1)-96;

      %if(isDone(evnt_bot))
      %    continue
      %end
      
      if(newIndex == -1)
          
        trans_mat{end+1,1} = next_state;
        
        % Updates all of the variables 
        iTable(end+1,1) = NaN;
        jTable(end+1,1) = NaN;
        minCost(end+1,1) = Inf;
        isSettled(end+1,1) = false;
        path(end+1,1) = num2cell(NaN);
        botTable(end+1,:) = NaN;
        robotLocation(end+1,:) = num2cell(NaN);
    
        trans_mat{I,2}{kk,1} = possible_transitions(kk);
        [trans_ind,~] = size(trans_mat);
        trans_mat{I,2}{kk,2} = num2str(trans_ind);
        
        [index,~] = size(trans_mat);
        
        
      else
        trans_mat{I,2}{kk,1} = possible_transitions(kk);
        trans_mat{I,2}{kk,2} = num2str(index);
      end
%       
      J = index; % get state number of transition
      if ~isSettled(J) % check if state is settled

        %% Calculate all robot costs for this transition
        J_costs = botTable(J,:); % All robots, next state TOTAL cost % WHY DOES THIS LINE EXIST?
        
        %index = strcmp(states{I,2}(:,2),num2str(J));
        %index = find(index,1); %only take the first transition
        %next_event = states{I,2}{index,1};
        %event_bot = next_event(1)-96;
        
        temp_index = strcmp(trans_mat{I,2}(:,2),num2str(J));
        %temp_index = isequal(trans_mat{I,2}{:,2},J);
        next_event = trans_mat{I,2}{temp_index,1}{1};
        event_bot = next_event(1)-96;    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        
%         if(~ABSTRACTED)
%           % OLD IDLE COSTS CALCULATION - use for abstracted for now
%           % Add in robot idle costs
%           currBotLoad = botTable(I,event_bot);       
%           for w = 1:numRobots  % Bot next load = current load + idle cost
%             J_costs(w) = botTable(I,w) + max(0,currBotLoad - botTable(I,w));
%           end
%         
%         else 
          for w = 1:numRobots  % Bot next load = current load + idle cost
            J_costs(w) = botTable(I,w);
          end
   
          %currBotLoad = botTable(I,event_bot);
          % Adds Idle cost only to event owner bot
          %idle_cost = max(0,max(botTable(I,:)) - currBotLoad);
          % Bot next load = current load + idle cost
          %J_costs(event_bot) = botTable(I,event_bot) + idle_cost;
%        end
        
        
        [transition_cost,~,new_X,new_Y] = ...
          calcTransitionCostDijkstra(next_event,I,path{I},trans_mat,tasks,EEC,regions,numRegions,start_loc,...
          numTasks,ABSTRACTED,start_events_only,robotLocation{I,event_bot},robotTask,1); %,robotTask(I,event_bot)
        % Except our current robot isn't idle.
     %   J_costs(event_bot) = botTable(I,event_bot) ...
     %                              + transition_cost;
                                 
        J_costs(event_bot) = J_costs(event_bot) ...
                                   + transition_cost;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                               
%        if(~ABSTRACTED)
          currBotLoad = J_costs(event_bot);
          % Adds Idle cost only to event owner bot
          idle_cost = max(0,max(J_costs(:)) - currBotLoad);
          % Bot next load = current load + idle cost
          J_costs(event_bot) = J_costs(event_bot) + idle_cost;
%        end
                                 
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
%             robotTask(J,jj) = robotTask(I,jj);
          end
          % Updates location of bot
          robotLocation{J,event_bot} = [new_X,new_Y];                   
          
          % Updates task if transition is a start event
%          if(strcmp(next_event(end),'s'))
%            robotTask(J,event_bot) = str2double(next_event(2:end-1));
%           end

        else
          iTable(J) = jTable(J);
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
  %paths(k,:) = path(end_state);
  paths(k,:) = path(end_states(isSettled(end_states)));
  paths = paths{1}; % extract the path
  %costs = botTable(end_state,:);
  costs = botTable(end_states(isSettled(end_states)),:);

%   [~,b] = size(paths);
%   for i = 1:b
%     a = sprintf('State: %d', paths(i));
%     disp(a)
%     disp(botTable(paths(i),:))
%   end

  event_path = calcEventPathIncr(trans_mat,1,paths);
  
  bot_used = false(1,numRobots);
  % Removes the extra events after calculating the path
  [~,path_size] = size(event_path);
  for i = path_size:-1:1
    if(strcmp(event_path{i}(end),'f'))
      bot_num = event_path{i}(1)-96;
      bot_used(bot_num) = true;
    else
      bot_num = event_path{i}(1)-96;
      % We delete entry events that happen after finish
      %if(~bot_used(bot_num))
        %event_path(i) = [];
      %end
    end
    % Exits 
    if(bot_used)
      break
    end
  end  
end
