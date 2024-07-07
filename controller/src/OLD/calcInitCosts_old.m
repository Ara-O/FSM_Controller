function init_cost = calcInitCosts_old(state_path,numRobots,init_pos,states,tasks,EEC,regions,numRegions,numTasks)

init_cost = zeros(1,numRobots);
abstracted = false;
start_events_only=false;
regions_exist=true;

for I=1:numel(state_path)-1
  
  cur_state = state_path(I);
  next_state = state_path(I+1);


  [transition_cost,trans_event] ...
    = calcTransitionCost(cur_state,next_state,state_path(1:I+1),states,tasks,EEC,regions,numRegions,init_pos,numTasks,abstracted,start_events_only,regions_exist);

  event_bot = trans_event(1)-96;

  currBotLoad = init_cost(1,event_bot);
  for w = 1:numRobots  % Bot next load = current load + idle cost
    init_cost(1,w) = init_cost(1,w) + max(0,currBotLoad - init_cost(1,w));
  end
                                                                   
  % Except our current robot isn't idle.
  init_cost(1,event_bot) = init_cost(1,event_bot) + transition_cost;
  
end