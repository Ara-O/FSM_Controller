function [ index, checked_state ] = curStateIndexNew( checked_state, trans_mat,cur_state,num_fsm)
%CURSTATEINDEX Outputs the index of the input cur_state in the trans_mat or
%   -1 if the input state has not been added yet
%   Coded by Daniel Burke
num_transitions = size(trans_mat);
index = -1;
aux=0;
for i=1:num_fsm
    aux=aux+str2num(cur_state{i});
end

if num_transitions > 1
    num_t=size(checked_state{aux,1});
    num_el=num_t(1,1);
else
    num_el=0;
end

if num_el > 0
    for i=1:num_el
        if(isequal(checked_state{aux,1}{i,1},cur_state))
            index = checked_state{aux,1}{i,2};
            break
        end
    end
end
if index==-1
    checked_state{aux,1}{num_el+1,1}= cur_state;
    checked_state{aux,1}{num_el+1,2}=num_transitions(1,1)+1;
end

end



