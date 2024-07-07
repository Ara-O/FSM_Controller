function cost_plan = calcCostPlanTasks(plan_event,numRobots,start_loc, tasks)

robotLocation= cell(numRobots,1);
cost_robot= zeros(numRobots,1);
trans_cost=zeros(length(plan_event),1);
costIdle=zeros(length(plan_event),1);
for i_r = 1:numRobots
    robotLocation{i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
    cost_robot(i_r)=0;
end
for i=1:length(plan_event)
    
    next_event=plan_event{i};
    
    event_bot = next_event(1)-96;
    
    [transition_cost, new_X, new_Y]= calcCostTask(next_event, tasks, robotLocation{event_bot},start_loc);
    trans_cost(i)=transition_cost;
    cost_robot(event_bot)=cost_robot(event_bot)+transition_cost;
    
    currBotLoad = cost_robot(event_bot);
    
    idle_cost = max(0,max(cost_robot(:)) - currBotLoad);
    costIdle(i)=idle_cost;
    cost_robot(event_bot)=cost_robot(event_bot)+idle_cost;
    
    for jj = 1:numRobots
        robotLocation{jj} = robotLocation{jj};
    end
    
    robotLocation{event_bot} = [new_X,new_Y];
    
end

cost_plan=max(cost_robot);

end