function [ index ] = curStateIndex( trans_mat,cur_state )
%CURSTATEINDEX Outputs the index of the input cur_state in the trans_mat or
%   -1 if the input state has not been added yet
%   Coded by Daniel Burke
num_transitions = size(trans_mat);
index = -1;

% Simply loops through trans_mat and compares, breaking if match
for i = 1:num_transitions
  if(isequal(trans_mat{i,1},cur_state))
    index = i;
    break
  end
end


end

