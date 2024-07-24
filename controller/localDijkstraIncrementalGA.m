function [costs,paths,event_path,num_eval,total_cost_time,total_trans_list_time,total_pos_trans_time,total_force_start_events_time,total_update_event_time,total_create_event_path_time,total_satisf_path_time ] = ...
  localDijkstraIncrementalGA(cur_state,numRobots,states,events,tasks,regions,numRegions,start_loc,numTasks,abstracted,start_events_only,init_loc,robot_tasks)
% Modified by Daniel Burke
% Functions like localDijkstra with same modifications made as with
% robotDijkstraIncremental in order to handle only the incremental FSMs as
% input and build the trans_mat on the fly so a full fsm is never stored in
% the controller. 
total_cost_time=0;
total_trans_list_time=0;
total_pos_trans_time=0;
total_force_start_events_time=0;
total_update_event_time = 0;
total_create_event_path_time = 0;
total_satisf_path_time = 0;
num_eval=0;
[~,num_fsms] = size(states);
%NEED TO REMOVE THIS LATER
EEC = 0;

% Process inputs
n = 1;
[~,num_fsms] = size(states);
% all_ass_event_path = calcPathUntilAllBotAssignedLD(ABS_event_path,numRobots,ABS_pc);
path_satisfied = false;

% Initialize output variables
costs = zeros(1,1);
paths = num2cell(NaN(1,1));
robotTask=zeros(1,2);
% Catches bug where a robot is not assigned a task initially
%for t = 1:numRobots
%  if(isempty(robot_tasks{t}))
%    [~,aaep] = size(all_ass_event_path);
%    for u = 1:aaep
%      if((all_ass_event_path{u}(1)-96) == t)
%        robot_tasks{t} = all_ass_event_path{u}(2:end-1);
%     end
%    end
%  end
%end

% Find the minimum costs and paths using Dijkstra's Algorithm
for k = 1:1  
    
  % Initializations
  iTable = NaN(n,1);  % cost table
  minCost = Inf(n,1);
  isSettled = false(n,1);
  path = num2cell(NaN(n,1));
  botTable = NaN(n,numRobots);  % Individual robot costs matrix
  %I = cur_state(k);
  I = 1;
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
    robotLocation{1,i} = [init_loc(i,1) init_loc(i,2)];
  end
  
  trans_mat = cell.empty;
  trans_mat{1} = cur_state;
  
  
  event_list = createEventFsmList(events,num_fsms);
   

  % Execute Dijkstra's Algorithm for this vertex
  while ~path_satisfied
       
    % Update the table
    jTable = iTable;  % Jtable is temporary to hold calculations
    iTable(I) = NaN;
    
    cur_state = trans_mat{I,1};
    
    if(I == 126)
      disp('1')
    end
    time_trans_list_ini = tic;
    transition_list = createTransitionList(states,cur_state,num_fsms);
    time_trans_list_final = toc(time_trans_list_ini);
    total_trans_list_time=total_trans_list_time+time_trans_list_final;
    
    time_pos_trans_ini=tic;
    possible_transitions = findPossibleTransitions(transition_list,event_list);
    time_pos_trans_final=toc(time_pos_trans_ini);
    total_pos_trans_time=total_pos_trans_time+time_pos_trans_final;
    
    time_force_start_events_ini=tic;
    [possible_transitions] = forceStartEvents(path{I},possible_transitions,trans_mat);
    time_force_start_events_final=toc(time_force_start_events_ini);
    total_force_start_events_time=total_force_start_events_time+time_force_start_events_final;
    
    num_transitions = size(possible_transitions);
    
     num_eval=num_eval+num_transitions(1);

    % Calculate the costs to the neighbor nodes and record paths
    for kk = 1:num_transitions % iterate through the number of transitions
      
      time_update_event_ini = tic; 
      next_state = updateCurEvent(possible_transitions(kk),cur_state,events,states,num_fsms);
      time_update_event_final = toc(time_update_event_ini);
      total_update_event_time= total_update_event_time+ time_update_event_final;
      
      index = curStateIndex(trans_mat,next_state);
      if(index == -1)
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
      
      J = index; % get state number of transition
      if ~isSettled(J) % check if state is settled

        %% Calculate all robot costs for this transition
        J_costs = botTable(J,:); % All robots, next state TOTAL cost

        temp_index = strcmp(trans_mat{I,2}(:,2),num2str(J));
        %temp_index = isequal(trans_mat{I,2}{:,2},J);
        next_event = trans_mat{I,2}{temp_index,1}{1};
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
             
         tcost = tic;
         
        [transition_cost,~,new_X,new_Y] = ...
          calcTransitionCostDijkstra(next_event,I,path{I},trans_mat,tasks,EEC,regions,numRegions,start_loc,...
          numTasks,abstracted,start_events_only,robotLocation{I,event_bot},robotTask,1);
        
        tfinalcost = toc(tcost);
        total_cost_time=total_cost_time+tfinalcost;
        
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
            robotTask(J,jj) = robotTask(I,jj);
          end
          % Updates location of bot
          robotLocation{J,event_bot} = [new_X,new_Y];  
          
          if(strcmp(next_event(end),'s'))
           robotTask(J,event_bot) = str2double(next_event(2:end-1));
          end
          

        else
          iTable(J) = jTable(J);
        end
      end
       
      % check if path was satisfied and exit loop
      if numel(path{J}) > 1 % prevent calculating a path for the start state
        
        time_satisf_path_ini=tic;
        cur_event_path = calcEventPathIncr(trans_mat,1,path{J});
        cur_event_path = stripEventPath(cur_event_path,all_ass_event_path);
        time_satisf_path_final =toc(time_satisf_path_ini);
        total_satisf_path_time=total_satisf_path_time+time_satisf_path_final;
        
        if numel(cur_event_path)==6
            path_satisfied=true;
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

  time_create_event_path_ini=tic;
  event_path = calcEventPathIncr(trans_mat,1,paths);
  time_create_event_path_final=toc(time_create_event_path_ini);
  total_create_event_path_time = total_create_event_path_time+time_create_event_path_final;
end


%}
