function aux = checkSameState(state1,state2,num_fsm)
aux=0;
aux_fsm=0;
for i=1:num_fsm
    a=str2double(state1{i});
    b=str2double(state2{i});
    if a==b
        aux_fsm=aux_fsm+1;
    else
        break;
    end
end

if aux_fsm==num_fsm
    aux=1;
end


end