function [ possible_transitions ] = findPossibleTransitions( transition_list,event_list )
%FINDPOSSIBLETRANSITIONS Outputs the transitions that are possible given
%   the input of events that are possible at the current state and the full
%   event list with which fsms need to be available for each event
%   Does the final step of the parallel composition
%   Coded by Daniel Burke

% Initializes size variables
num_transitions = size(transition_list);
num_events = size(event_list);
possible_transitions = cell.empty;

% Loop through each list comparing every element
for i = 1:num_transitions
  for j = 1:num_events
    if(strcmp(transition_list{i,1},event_list{j,1}))
      % First checks that the size of the second column is the same so that 
      % the comparision step after does not crash
      if(size(transition_list{i,2}) == size(event_list{j,2}))
        % Compares the second columns for equality, adding if equal
        if(transition_list{i,2} == event_list{j,2})
          possible_transitions(end+1,1) = transition_list(i,1);
          possible_transitions(end,2) = transition_list(i,2);
          break
        end
      end
    end
  end
end


end

