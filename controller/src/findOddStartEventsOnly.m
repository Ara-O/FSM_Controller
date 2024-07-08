function possible_trans = findOddStartEventsOnly(possible_transitions)
    %possible_trans=possible_transitions;
    ind=1;
    ind_1=1;
    aux=0;
    num_transitions=size(possible_transitions);
    for i=1:num_transitions(1)
        task=str2double(possible_transitions{i,1}(end-2:end-1));
       if mod(task,2)~=0
               possible_trans{ind_1,1}=possible_transitions{i,1};
               possible_trans{ind_1,2}=possible_transitions{i,2};
               ind_1=ind_1+1;
       

       end
    end

    
    
end