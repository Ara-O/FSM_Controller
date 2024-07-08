function [cost,cost_trans,cost_extra] = path_cost_IncrNew(path_events,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots)

    robotLocation=[];
    cost_robot=[];
    i_n=1;
    cost_robot=zeros(numRobots,1);
    for j=1:length(path_events)
%         act_path={path_gen{1,1:j}};
%         act_state=path_gen{1,j};
        %next_state=path_gen(j+1);
        if j==1
            for i_r = 1:numRobots
                robotLocation{j,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
                cost_robot(i_r)=0;
            end
        end
        if iscell(path_events{j})
            next_event=cell2mat(path_events{j});
        else
            next_event=path_events{j};
        end
        
        
        event_bot = next_event(1)-96;

        %path_events{i}{j}{1,1}
        [transition_cost,~,new_X,new_Y] = ...
            calcTransitionCostGAAIncr(next_event,path_events,j,tasks,0,regions,numRegions,start_loc,...
            numTasks,abstracted,start_events_only,robotLocation{j,event_bot},robot_tasks,1);
        
        currBotLoad = cost_robot(event_bot);
        
        idle_cost = max(0,max(cost_robot(:)) - currBotLoad);
        
        
        cost_robot(event_bot)=cost_robot(event_bot)+transition_cost;
        
       
        %cost_robot(event_bot) = cost_robot(event_bot) + idle_cost;
        
        for w = 1:numRobots  % Bot next load = current load + idle cost
            cost_extra(w,j)=idle_cost;%max(0,cost_robot(w)-currBotLoad);
            cost_robot(w) = cost_robot(w) + idle_cost;%max(0,currBotLoad - cost_robot(w));            
            i_n=i_n+1;
        end
        trans(j)=transition_cost;

        for jj = 1:numRobots
            robotLocation{j+1,jj} = robotLocation{j,jj};
            cost_trans(jj,j)=0;
            %robot_tasks{jj} = robotTask(I,jj) ;
            %robotTask(J,jj) = robotTask(I,jj);
        end
        cost_trans(event_bot,j)=transition_cost;
        robotLocation{j+1,event_bot} = [new_X,new_Y];
    end
    cost=max(cost_robot);
end