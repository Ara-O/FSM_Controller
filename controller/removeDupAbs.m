function [path_events] = removeDupAbs(old_event,path)
ind=1;
path_events='';
for i=1:length(old_event)
    aux=0;
    for j=1:length(path)
        if strcmpi(old_event{i}{j},path{j})
            aux=aux+1;
        else
            break;
        end
    end
    if aux<length(path)
        path_events{ind}=old_event{i};
        ind=ind+1;
    end
end
    
if length(path_events)==length(old_event)
    path_events{end+1}=path;
end
end