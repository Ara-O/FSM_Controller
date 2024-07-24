function [index,num_state] = chooseSameState(path1,path2,num_fsm)
ind=1;
aux_state=[];

for j=2:length(path1)-1
    for i=2:length(path2)-1
        aux_2=0;
        for k=1:num_fsm
            if length(path1{j}{k})==length(path2{i}{k}) %verify if the states have the same length for example 10 and 20
                a=[path1{j}{k}==path2{i}{k}];
                if sum(a)==length(path2{i}{k})
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
            aux_state(ind,2)=i;
            ind=ind+1;
        end                    
    end
end

%after checking all common states, choose a random pair

if isempty(aux_state)
    num_state=0;
    index=[];
else
    num_states=size(aux_state);
    num_state=num_states(1);
    idx_pot=randi([1 num_states(1)]);
    index=[aux_state(idx_pot,1) aux_state(idx_pot,2)];   

end