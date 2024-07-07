function aux_trans = checkPosTransEvent(possible_transitions,event)
aux_trans=0;
num_transitions = size(possible_transitions);
for i=1:num_transitions(1)
    if strcmp(possible_transitions{i,1},event)
        aux_trans=i;
        break;
    end
end
end