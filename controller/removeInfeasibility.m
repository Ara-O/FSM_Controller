function [aux,event_a,event_b,i] = removeInfeasibility(aux,event_a,event_b,next_event,i,robot)
old_aux='';
old_aux=aux;
aux='';
if strcmp(robot,'a')
    aux={old_aux{1:event_a{2}}};
    num_add=event_a{3};
    for k=length(aux):-1:1
        if strcmp(aux{k}(1),'b') && strcmp(aux{k}(end),'e') 
            event_b{1}='';
            event_b{1}=aux{k};
            event_b{2}=k;
            break;
        end
    end
else
    aux={old_aux{1:event_b{2}}};
    num_add=event_b{3};
    for k=length(aux):-1:1
        if strcmp(aux{k}(1),'a') && strcmp(aux{k}(end),'e')
            event_a{1}='';
            event_a{1}=aux{k};
            event_a{2}=k;
            break;
        end
    end
end
for j=num_add+1:length(next_event{1})
    if strcmp(next_event{1}{j}(1),robot)
        [aux,event_a,event_b,j]=addEvent(aux,event_a,event_b,next_event,j);
        if strcmp(next_event{1}{j}(end),'e')
            break;
        end
    end
end


for k=num_add+1:j-1
    if ~strcmp(next_event{1}{k}(1),robot)
     [aux,event_a,event_b,k]=addEvent(aux,event_a,event_b,next_event,k);
    end
end

i=j;

end