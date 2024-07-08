function [cost,cost_trans,cost_extra] = greedy_algorithm(start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots)

    robotLocation=[];
    cost_robot=[];
    i_n=1;
    cost_robot=zeros(numRobots,1);    
    act_state=1;
    sz1=size(states{act_state,2});
    num_path=sz1(1,1);
    j=1;
    for k=1:num_path
        act_state=1;
        i=1;
        aux=1;
        path_gen{j}(i)=act_state; %save at the state being analyzed
        if states{act_state,3} %verify if it is a marked state, if is then stop searching
            aux=0;
            break;
        end
        next_state= states{act_state,2}(k,2); %save the state
        path_events{j}{i}= states{act_state,2}(k,1); %save the tansitions' event
        i=i+1;
        act_state=str2double(next_state);
        sz2=size(states{act_state,2});
        path_gen{j}(i)=act_state; %save at the state being analyzed
        if states{act_state,3} %verify if it is a marked state, if is then stop searching
            aux=0;
            break;
        end
        aux2=1;
        while aux2

            for t=1:sz2(1,1)
                path_aux=path_gen{j};
                path_aux_events=path_events{j};
                next_state=states{act_state,2}(t,2);
                path_aux_events(length(path_aux_events)+1)=states{act_state,2}(t,1);
                act_state=str2double(next_state);
                path_aux(length(apth_aux)+1)= act_state
                
                
            end
        end
        
    end

    

end