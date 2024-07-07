%remove any start event that is available to happen
%it avoids to create a chromossome which is not in allignment with the
%desired abstract plan
function possible_trans = findEntryEventsMod(possible_transitions)
    %possible_trans=possible_transitions;
    ind=1;
    ind_1=1;
    aux=0;
    for i=1:length(possible_transitions)
       if ~strcmp(possible_transitions{i,1}(end),'s')
               possible_trans{ind_1,1}=possible_transitions{i,1};
               possible_trans{ind_1,2}=possible_transitions{i,2};
               ind_1=ind_1+1;

       end
    end

    
    
end