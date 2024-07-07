desired_tasks={[7,9],[1,3,13],[5,11]};
  [~,local_state_path,local_event_path,num_eval2] = ...
        robotDijkstraIncrementalNewHashTasksDesired(desired_tasks,cur_states,numRobots,states_incr,events_incr,tasks,...
        regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robot_tasks); %,robotLocations,robot_tasks
   [pop,cost] = testPlan(local_event_path,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);
   
   plan1={'a07s','b13s','c05s','a09s','c11s','b01s','a03s'};
   plan2={'a09s','c05s','b13s','a03s','b01s','c11s','a07s'};
   plan3={'a09s','c05s','b13s','a07s','c11s','b01s','a03s'};
   plan4={}
   cost_plan = calcCostPlanTasks(local_event_path,numRobots,start_loc, tasks)
   
   [pop,cost] = testPlan(plan1,cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);
   
   [~,local_state_path,local_event_path,num_eval2] = ...
        robotDijkstraIncrementalNewHashTasks(cur_states,numRobots,states_incr,events_incr,tasks,...
        regions,numRegions,start_loc,numTasks,abstracted,start_events_only,robot_tasks); %,robotLocations,robot_tasks