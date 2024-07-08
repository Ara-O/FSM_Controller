function aux_equal = checkStateDF(check_states,cur_states,num_fsm)
aux_equal=false;
for i=1:length(check_states)
    aux_state=0;
    for j=1:num_fsm
        if str2double(cur_states{j})==str2double(check_states{i}{j})
            aux_state=aux_state+1;
        end
    end
    if aux_state==num_fsm
        aux_equal=true;
        break;
    end
end
        