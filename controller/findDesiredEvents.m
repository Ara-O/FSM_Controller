%remove any start event that is available to happen
%it avoids to create a chromossome which is not in allignment with the
%desired abstract plan
function possible_trans = findDesiredEvents(possible_transitions,desired_tasks)
%possible_trans=possible_transitions;
ind=1;
ind_1=1;
aux=0;
num_transitions=size(possible_transitions);
for i=1:num_transitions(1)
    task=str2double(possible_transitions{i,1}(end-2:end-1));
    robot=possible_transitions{i,1}(1)-96;
    for j=1:length(desired_tasks{robot})
        if task==desired_tasks{robot}(j)
            possible_trans{ind_1,1}=possible_transitions{i,1};
            possible_trans{ind_1,2}=possible_transitions{i,2};
            ind_1=ind_1+1;
        end
        
    end
    
    
end



end