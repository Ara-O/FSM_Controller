function [ new_cur_state] = updateCurEvent( cur_event,cur_state,events,states,num_fsms)
%UPDATECUREVENT Returns new states of fsms based on transition happening
%   Coded by Daniel Burke

% Initializes the new current state with empty values
new_cur_state = num2cell(NaN(1,num_fsms));

% Loops through each FSM
for i = 1:num_fsms
  %Checks first if the event exists for this fsm
  if(hasEvent(cur_event,events{i}))
    num_transitions = size(states{i}{str2double(cur_state(i)),2});
    has_transition = false;
    % Checks the possible transistions from the current state in fsm with event
    for j = 1:num_transitions
      if(strcmp(states{i}{str2double(cur_state(i)),2}(j,1),cur_event))
        has_transition = true;
        break;
      end
    end
    
    % If there is a transition from this state it sets current state of the fsm
    % to the state it is transitioning to, otherwise there is an error
    if(has_transition)
      new_cur_state(i) = states{i}{str2double(cur_state(i)),2}(j,2);
    else
      disp('Error: scenario not possible for fsms');
    end
  % If event does not exist for fsm then the state of that fsm remains the same  
  else
    new_cur_state(i) = cur_state(i);
  end
end

end

