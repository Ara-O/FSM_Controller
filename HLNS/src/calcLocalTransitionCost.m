function [transition_cost,trans_event] ...
                  = calcLocalTransitionCost(cur_state,next_state,~,states,~,EEC,~,~,~,~,ABS_trans_event)
% MODIFIED FOR ABSTRACTED SCENARIOS with start events only
% v1.2a

% v1.2a
% added trans_event

                
% Determine the next event
index = strcmp(states{cur_state,2}(:,2),num2str(next_state));
next_event = states{cur_state,2}{index,1};   

trans_event = next_event;

%% Determine the cost of the transition
if strcmp(next_event(end),'f') % Finish events have no cost
  transition_cost = 0;
  
elseif  strcmp(next_event(end),'e')     % if next event is an entry event,
  transition_cost = EEC; %set cost to EEC ...FOR NOW....

else % else it is a start event
  % for a local OPtimization, any start event that isn't the next Abstracted
  % event should be made super expensive, so that path is not used.

  if strcmp(next_event , ABS_trans_event)
    transition_cost = 0;
  else
    transition_cost = 666;
  end
  
end