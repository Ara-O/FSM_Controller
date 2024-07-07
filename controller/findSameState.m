function [index] = findSameState(path1,state,num_fsm)
ind=1;
aux_state=[];
if length(path1) ==1
    aux_state=[];
else

    for j=2:length(path1)
        aux_2=0;
        for k=1:num_fsm
            if length(path1{j}{k})==length(state{k}) %verify if the states have the same length for example 10 and 20
                a=[path1{j}{k}==state{k}];
                if sum(a)==length(state{k})
                    aux_2=aux_2+1;
                else
                    break;
                end
            else
                break;
            end
        end
        if aux_2==num_fsm %if they have a common state
            aux_state(ind,1)=j; %save the indexes
            break;
        end
    end
end

%after checking all common states, choose a random pair

if isempty(aux_state)
    index=[];
else
    index=aux_state;
end