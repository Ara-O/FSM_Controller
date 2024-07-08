function [ transition_list ] = createTransitionList( states,cur_state,num_fsms )
%CREATETRANSITIONLIST creates a list of all the events in the first column
%   and which fsm(s) those events belong to in the second column
%   Coded by Daniel Burke

% Initializes using the first fsm
transition_list=cell.empty;
for i_k=1:1
    if ~isempty(states{1}{str2double(cur_state(i_k)),2})
        transition_list = states{1}{str2double(cur_state(i_k)),2}(:,1);
        transition_list(:,2) = num2cell(1);
        break;
    end
end
i_k=1;
for i = i_k+1:num_fsms
  state_ind = str2double(cur_state(i));
  if(isempty(states{i}{state_ind,2}))
    continue
  end
  transitions_away = states{i}{state_ind,2}(:,1);
  % Compares against all of the currently added values
  if ~isempty(transition_list)
      states_size = size(transition_list);
  else
      states_size=0;
  end
  fsm_events = size(transitions_away);
  for j = 1:fsm_events
    %Compares to each value in next fsm
    added_yet = false;
    for k = 1:states_size
      if(strcmp(transition_list(k,1),transitions_away(j,1)))
        %Adds the fsm num to list
        added_yet = true;
        transition_list{k,2}(end+1) = i;
        break
      end
    end
    % If not added yet we add to bottom of list
    if(~added_yet)
      transition_list(end+1,1) = transitions_away(j,1);
      transition_list(end,2) = num2cell(i);
    end
  end  
  
  
end

end

