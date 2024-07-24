function pos_trans = findEntryFinishEvents(possible_transitions)
ind=1;
pos_trans='';
num_transitions = size(possible_transitions);
for i=1:num_transitions(1)
    if ~strcmp(possible_transitions{i,1}(end),'s')
        pos_trans{ind,1}=possible_transitions{i,1};
        ind=ind+1;
        
    end
    
end
end