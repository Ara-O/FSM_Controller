function [offspring_new,offspring_event_new,aux_dup] = remove_cycles(offspring,offspring_event,num_fsm)
aux_dup=0;
    for i=1:ceil((length(offspring)-1)/2)
        for j=length(offspring):-1:ceil((length(offspring)-1)/2)+1
            a=offspring(i,:);
            b=offspring(j,:);
            loop=cellfun(@isequal,a,b);
            if sum(loop)==num_fsm %equal state
                offspring_new=[offspring(1:i,:);offspring(j+1:end,:)];
                offspring_event_new=[offspring_event(1:i-1,:),offspring_event(j:end,:)];
                aux_dup=1;
                break;
            end
        end
        if aux_dup
            break;
        end
    end
    if aux_dup==0
        offspring_new=offspring;
        offspring_event_new=offspring_event;
    end
end