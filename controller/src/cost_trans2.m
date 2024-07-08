function [cost,cost_trans,cost_extra,robotLocation] = cost_trans2(path_gen,path_events,start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots)

    robotLocation=[];
    cost_robot=[];
    i_n=1;
    cost_robot=zeros(numRobots,1);
    
    for j=1:length(path_gen)-1
        act_state=path_gen(j);
        next_state=path_gen(j+1);
        if j==1
            for i_r = 1:numRobots
                robotLocation{j,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
            end
        end
        next_event=path_events{j}{1};
        
        
        event_bot = next_event(1)-96;
        currBotLoad = cost_robot(event_bot);
        for w = 1:numRobots  % Bot next load = current load + idle cost
            cost_extra(w,j)=max(0,currBotLoad - cost_robot(w));
            cost_robot(w) = cost_robot(w) + max(0,currBotLoad - cost_robot(w));            
            i_n=i_n+1;
        end
        %path_events{i}{j}{1,1}
        [transition_cost,~,new_X,new_Y] = ...
            calcTransitionCost(next_event,act_state,next_state,path_gen(1:j),states,tasks,0,regions,numRegions,start_loc,...
            numTasks,abstracted,start_events_only,robotLocation{j,event_bot},robot_tasks,0);
        
        cost_robot(event_bot)=cost_robot(event_bot)+transition_cost;
        trans(j)=transition_cost;

        for jj = 1:numRobots
            robotLocation{j+1,jj} = robotLocation{j,jj};
            cost_trans(jj,j)=0;
            %robotTask(J,jj) = robotTask(I,jj);
        end
        cost_trans(event_bot,j)=transition_cost;
        robotLocation{j+1,event_bot} = [new_X,new_Y];
    end
    cost=max(cost_robot);
end