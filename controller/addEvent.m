function [aux,event_a,event_b,i] = addEvent(aux,event_a,event_b,next_event,i)

if strcmp(next_event{1}{i}(1),'a')
        if ~strcmp(event_b{1}(2:end),next_event{1}{i}(2:end))
            aux{length(aux)+1}=next_event{1}{i};
            if strcmp(next_event{1}{i}(end),'e')
                event_a{1}='';
                event_a{1}=next_event{1}{i};
                event_a{2}=length(aux);
                event_a{3}=i;
            end
        else
            [aux,event_a,event_b,i] = removeInfeasibility(aux,event_a,event_b,next_event,i,'b');          
        end
    else
        if ~strcmp(event_a{1}(2:end),next_event{1}{i}(2:end))
            aux{length(aux)+1}=next_event{1}{i};
            if strcmp(next_event{1}{i}(end),'e')
                event_b{1}='';
                event_b{1}=next_event{1}{i};
                event_b{2}=length(aux);
                 event_b{3}=i;
            end
        else
            [aux,event_a,event_b,i] = removeInfeasibility(aux,event_a,event_b,next_event,i,'a'); 
        end
end
end