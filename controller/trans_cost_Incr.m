function [cost_robot,robotLocation] = trans_cost_Incr(init_cost,path_gen,path_events,start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots)

    robotLocation=[];
    cost_robot=[];
    i_n=1;
    cost_robot=zeros(numRobots,1);
    
    cost_robot=init_cost;
    j=length(path_events);
    act_path={path_gen{1,1:j+1}};
    act_state=path_gen{1,j};
    %next_state=path_gen(j+1);
    for i_r = 1:numRobots
        robotLocation{1,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
        %cost_robot(i_r)=0;
    end
    if iscell(path_events{j})
        next_event=cell2mat(path_events{j});
    else
        next_event=path_events{j};
    end
    
    
    event_bot = next_event(1)-96;
    
    
    [transition_cost,~,new_X,new_Y] = ...
        calcTransitionCostGAA(next_event,act_state,path_events,j,path_gen,states,tasks,0,regions,numRegions,start_loc,...
        numTasks,abstracted,start_events_only,robotLocation{1,event_bot},robot_tasks,1);
    
    cost_robot(event_bot)=cost_robot(event_bot)+transition_cost;
    
    currBotLoad = cost_robot(event_bot);
    
    idle_cost = max(0,max(cost_robot(:)) - currBotLoad);
    
    cost_robot(event_bot)=cost_robot(event_bot)+idle_cost;
    
    
    robotLocation{1,event_bot} = [new_X,new_Y];
        
end