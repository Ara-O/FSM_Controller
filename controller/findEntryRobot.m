function pos_trans = findEntryRobot(possible_transitions,robot)
ind=1;
pos_trans='';
num_transitions = size(possible_transitions);
for i=1:num_transitions(1)
    detect_event=possible_transitions{i,1};
    if strcmp(detect_event(1),robot)
        if strcmp(detect_event(end),'e')
            pos_trans{ind}=detect_event;
            ind=ind+1;
        end
    end
    
end