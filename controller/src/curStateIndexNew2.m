function [NewIndex, index, checked_state] = curStateIndexNew2( checked_state,trans_mat, cur_state,num_fsm, level)
%CURSTATEINDEX Outputs the index of the input cur_state in the trans_mat or
%   -1 if the input state has not been added yet
%   Coded by Daniel Burke
num_transitions = size(trans_mat);
NewIndex = -1;
aux=0;

for i=1:num_fsm-1
    
    aux=aux+ (str2double(cur_state{i})-1)*prod(level(i:num_fsm-1));
end

aux=aux+str2double(cur_state{num_fsm});
if ~isempty(checked_state{aux,1})
    NewIndex=1;
    index=checked_state{aux,2};
else
    checked_state{aux,1}=cur_state;
    index=num_transitions(1,1)+1;
    checked_state{aux,2}=index;
end
    
    



end


