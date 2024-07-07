function [pos_trans, aux] = justStartTasks(possible_transitions)
num_transitions = size(possible_transitions);
pos_trans=cell(num_transitions(1),1);
ind=0;
aux=0;
for i=1:num_transitions(1)
    
    task= str2double(possible_transitions{i}(end-2:end-1));
    
    if mod(task,2)==1
        ind=ind+1;
        pos_trans{ind}=possible_transitions{i};
    end
end

    if ind < num_transitions(1)
        pos_trans=pos_trans(~cellfun(@isempty,pos_trans'));
        if ind==0
            aux=1;
        end
    end

end