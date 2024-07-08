function [aux_index,pos_trans] = findDesiredTaskEvents(possible_transitions,event)
aux_index=0;
num_transitions = size(possible_transitions);
pos_trans=cell(num_transitions(1),1);
ind=0;
for i=1:num_transitions(1)
    task=str2double(possible_transitions{i,1}(end-2:end-1));
    
    if mod(task,2)==0
        ind=ind+1;
        pos_trans{ind,1}=possible_transitions{i,1};
    
    elseif strcmp(possible_transitions{i,1},event)
        ind=ind+1;
       pos_trans{ind,1}=possible_transitions{i,1};
        
    end
    
end
 if ind<num_transitions(1)
      pos_trans=pos_trans(~cellfun('isempty',pos_trans));
 end

end