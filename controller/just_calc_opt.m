% Author: Jonathon Kreska
% Version: 1.5
% Date: May 3, 2016
% Changelog:
%  1.4: Initial Release
%  1.5: Combined with Abstracted offline function and called by Start.m
%
% Current Capability:
%  Finish events are only a detection event.
%  Start events are only a task assignment to move through the FSM.
%  Cost Function is integrated with Djikstra's function.
tic;

if ABSTRACTED
  run(['../FSMs/' ABSfoldName '/fsmdata.m']);  % Get FSM data
else
  run(['../FSMs/' foldName '/fsmdata.m']);  % Get FSM data
end
runningScenario = str2double(scenNumStart);

while runningScenario <= str2double(scenNumFinish)

  %Import userdata from FSM GUI
  if ABSTRACTED
    run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m']);  
  else
    run(['../FSMs/' foldName '/userdata' num2str(runningScenario) '.m']);  
  end
  
  disp(num2str(runningScenario)) 



  %% Setup
  start_loc = cell2mat(start_loc); % strip out start location data creatred by GUI

  %% Calc Entry Event Cost
  if ABSTRACTED
    EEC = 0;
  else
    EEC = calcEEC(tasks,numRobots,start_loc,numRegions,numTasks);
  end
  
  %% Set current state index based on initial_state name
  cur_state = find(strcmp(initial_state,states(:,1))); 
  % Set end state index based on final_state name
  end_state = find(strcmp(final_state,states(:,1)));

  %% Calculate Edge List
  edge_list = calcSmallEdgeList(states,end_state);

  %% Run Dijkstra algorithm to find path through FSM from cur_state to end_state
  init_cost = zeros(numRobots,1);
  robot_tasks = cell(numRobots,1);
  
  
  [costs,state_path] = ...
    robotDijkstra(init_cost,edge_list,cur_state,end_state,numRobots,states,tasks,EEC,regions,numRegions,start_loc,numTasks,ABSTRACTED,START_EVENTS_ONLY,robot_tasks);
  opt_time = toc;
  
  %% Display current state
  disp('Done!')
  
  fprintf(fid,'  Offline Trial %i: \n', runningScenario);
  
  fprintf(fid,'Optimization Time: %f sec\n', opt_time);
  
  fprintf(fid,'Costs:   ');
  for j=1:length(costs)
    fprintf(fid,'%s ',num2str(costs(j)));
  end
  fprintf(fid,'\n');

  if ABSTRACTED
    fprintf(fid,'Abstracted State Path:   ');
  else
    fprintf(fid,'State Path:   ');
  end
  for j=1:length(state_path)
    fprintf(fid,'%s ',num2str(state_path(j)));
  end
  fprintf(fid,'\n');
  
  event_path = calcEventPath(states,1,state_path);
  if ABSTRACTED
    fprintf(fid,'Abstracted Event Path:   ');
  else
    fprintf(fid,'Event Path:   ');
  end
  for j=1:length(event_path)
    fprintf(fid,'%s ',event_path{j});
  end
  
  fprintf(fid,'\n\n');
  
  runningScenario = runningScenario + 1;


end

fclose('all');

disp('All Trials Complete!')