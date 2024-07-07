function aux = checkRepEntry(path_events,event)
aux=0;
if strcmp(event(1),'a')
    robot='a';
else
    robot='b';
end
    for i=length(path_events):-1:1
        if strcmp(path_events{i}(end),'s')
            index=i;
            for j=i:-1:1
                if strcmp(path_events{j}(end),'e') || strcmp(path_events{j}(1),robot)
                    index=j;
                    break;
                end
            end
            break;
        end
    end
    
    for i=length(path_events):-1:index
        if strcmp(path_events{i},event)
            aux=1;
            break;
        end
    end
end