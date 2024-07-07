function pos_trans = tasksAllRobots(possible_transitions,aux_robots, numRobots,numTasks)

sumTasks=sum(aux_robots);

desig_tasks= mod(sumTasks,numRobots);
num_transitions = size(possible_transitions);
pos_trans=cell(num_transitions(1),1);
ind=0;
pairTasks=numTasks/2;
share=floor(pairTasks/numRobots);
diff=mod(pairTasks,numRobots);

if desig_tasks ==0
    pos_trans=possible_transitions;
else
    for i=1:num_transitions(1)
        
        event_robot=possible_transitions{i}(1)-96;
        task= str2double(possible_transitions{i}(end-2:end-1));
        
        if mod(task,2)==0
            ind=ind+1;
            pos_trans{ind}=possible_transitions{i};
        elseif aux_robots(event_robot) < share
            ind=ind+1;
            pos_trans{ind}=possible_transitions{i};
        elseif diff > 0
            if share > 1
                if mod(aux_robots(event_robot),share)==0
                    ind=ind+1;
                    pos_trans{ind}=possible_transitions{i};
                end
            else
                if aux_robots(event_robot)==1
                    ind=ind+1;
                    pos_trans{ind}=possible_transitions{i};
                end
            end
        end

    end
    
    if ind < num_transitions(1)
        pos_trans=pos_trans(~cellfun(@isempty,pos_trans'));
    end

end