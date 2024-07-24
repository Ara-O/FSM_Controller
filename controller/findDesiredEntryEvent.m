function aux = findDesiredEntryEvent(possible_transitions,robot,desired_region)
aux=0;
num_transitions = size(possible_transitions);
for i=1:num_transitions(1)
    detect_event=possible_transitions{i,1};
    if strcmp(detect_event(1),robot)
        region=str2double(detect_event(2:end-1));
        if region==desired_region
            aux=i;
            break;
        end
    end
    
end
end