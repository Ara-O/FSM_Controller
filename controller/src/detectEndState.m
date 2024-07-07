function [ at_end ] = detectEndState( cur_states,states,num_fsms )
%DETECTENDSTATE Returns true if at an end state in every fsm
%   Coded by Daniel Burke

% Initialize as true
at_end = 1;

for i = 1:num_fsms
  % Checks to see if the state is marked, breaks if not
  if(cell2mat(states{i}(str2double(cur_states(i)),3)) == 0)
    at_end = 0;
    break
  end
end  

end

