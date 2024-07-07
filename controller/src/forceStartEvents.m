function [ new_transitions ] = forceStartEvents( path,possible_transitions,trans_mat )
%FORCESTARTEVENTS checks the last transition, if it is a finish event and
%   there are possible start events by the same bot it forces those events,
%   this is to prevent crashing in the controller 
%   Coded by Daniel Burke

[~,path_size] = size(path);

new_transitions = cell.empty;

% If the path has one state there are no transitions yet
if(path_size < 2)
  new_transitions = possible_transitions;
  return
end

% Checks what the transition event is
index = strcmp(trans_mat{path(end-1),2}(:,2),num2str(path(end)));
trans_event = trans_mat{path(end-1),2}{index,1}{1};
trim_events = false;

% Need to check the type of event to see if finish
if(strcmp(trans_event(end),'f'))
  % Force start events if last transition was finish event 
  % BUT - only if there are start events for the same robot
  for j = 1:size(possible_transitions)
    if(strcmp(possible_transitions{j,1}(end),'s') && ...
       strcmp(possible_transitions{j,1}(1),trans_event(1)))
      trim_events = true;
    end
  end
  if(trim_events)
    for i = 1:size(possible_transitions)
      if(strcmp(possible_transitions{i,1}(end),'s'))
        new_transitions(end+1,1) = possible_transitions(i,1);
        new_transitions(end,2) = possible_transitions(i,2);
      end
    end
  else
    new_transitions = possible_transitions;
  end
  
else
  % We do not force start events if last event was not finish
  new_transitions = possible_transitions;
end

end

