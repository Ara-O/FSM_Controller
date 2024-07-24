function [path_gen,path_events] = removeDup(old_gen,old_event)

path_gen{1}=old_gen{1};
path_events{1}=old_event{1};

for i=2:length(old_gen)
    aux=1;
    b=length(path_gen);
    for j=1:b
        if length(path_events{j})==length(old_event{i})
            aux_i=0;
            for k=1:length(old_event{i})
                if strcmp(old_event{i}{k},path_events{j}{k})
                    aux_i=aux_i+1;
                else
                    break;
                end
            end
            if k>=length(old_event{i})
                aux=0;
            end
        end
    end
    if aux==1
        path_gen{b+1}=old_gen{i};
        path_events{b+1}=old_event{i};
    end
end
    
end