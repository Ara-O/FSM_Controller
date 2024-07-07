% Author: Jonathon Kreska
% Version: 1.3a
% Date: February 29, 2016
% Changelog:
%  1.3a: Initial Release
%
% Current Capability:
%  For use with Abstracted FSMs (no finish events) and no regions.
%  Only commands a robot to go to a position if it is the next event's event_bot
%  Finish events are only a detection event.
%  Robots will wait 1m from the border of their next region found in the 
%   path if they have a task assignment. A robot is onlt allowed to enter a
%   region if its entry event is the next event in the path.
%  Start events are only a task assignment to move through the FSM.
%  Cost Function is integrated with Djikstra's function.

%% Clean-up
clear; close ALL; clc;

%% Initialize
addpath('src') %Add functions to path

disp('Choose Scenario Name:')
disp('1 = 4t0r')
disp('2 = 8t0r')
disp('3 = 16t0r')
disp('4 = 4t4r')
disp('5 = 8t4r')
disp('6 = 8t9r')

choice = input('Choice: ','s'); %Get Scenario name from user

if     choice == '1'
  ABSfoldName = '4tasksNoRegions1robotABSTRACT_rn'
elseif choice == '2'
  ABSfoldName = '8tasksNoRegions1robotABSTRACT_rn'
elseif choice == '3'
  ABSfoldName = '16tasksNoRegions1robotABSTRACT_rn'  
elseif choice == '4'
  ABSfoldName = '4tasks4regions1robotABSTRACT_rn'   
elseif choice == '5'
  ABSfoldName = '8tasks4Regions1robotABSTRACT_rn' 
elseif choice == '6'
  ABSfoldName = '8tasks9Regions1robotABSTRACT_rn' 
% elseif choice == '7'
%   ABSfoldName = '16tasksNoRegions1robot_rn' 
% elseif choice == '8'
%   ABSfoldName = '16tasksNoRegions1robot_rn' 
  


else
  a(0);
  disp('You idiot! Try again!')
end


time = datestr(datetime);
fid = fopen(['../Logs/' ABSfoldName '_results_log_' time(1:11) '_' time(13:14) time(16:17) '.txt'],'w');

menuFlag = false;
while ~menuFlag
  menu = input('1 for single, 2 for batch: ','s');
  if strcmp(menu,'1')
    scenNumStart = input('Input Scenario Number: ','s'); %Get Scenario num from user
    scenNumFinish = scenNumStart;
    menuFlag = true;
  elseif strcmp(menu,'2')
    scenNumStart = input('Input Scenario Start Number: ','s'); %Get Scenario num from user
    scenNumFinish = input('Input Scenario Finish Number: ','s');
    menuFlag = true;
  else 
    menuFlag = false;
  end
end

runningScenario = str2double(scenNumStart);

% wait = input(['Please load up scenario ' num2str(runningScenario) ', then press Enter']);




% Scenario Loop
while runningScenario <= str2double(scenNumFinish)

  run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI

  disp(num2str(runningScenario)) 


  %% Setup


  EEC = 0;
  
  %% Set current state index based on initial_state name
  cur_state = find(strcmp(initial_state,states(:,1))); 
  % Set end state index based on final_state name
  end_state = find(strcmp(final_state,states(:,1)));

  %% Calculate Edge, Cost, and Event Robot Matricies
  [E,event_bots] = calcEdgeAndEventBots(states);

  %% Run Dijkstra algorithm to find path through FSM from cur_state to end_state

  tic
  [totalCost,ABS_state_path] = robotDijkstra(E,cur_state,end_state,event_bots,numRobots,states,tasks,EEC,regions,numRegions,start_loc,numTasks);
  opt_time = toc;

  %% Setup Path Counter (PC)
  pc = 1;                     %Initialize path counter to be first element of path
  
  ABS_event_path = calcEventPath(states,pc,ABS_state_path);   %Create event path
 
  
  %% Display current state
  disp('Done!')
  
  fprintf(fid,'  Trial %i: \n', runningScenario);
  
  fprintf(fid,'Optimization Time: %f sec\n', opt_time);
  
    fprintf(fid,'Costs:   ');
  for j=1:length(totalCost)
    fprintf(fid,'%s ',num2str(totalCost(j)));
  end
  fprintf(fid,'\n');
  
  fprintf(fid,'Abstracted State Path:   ');
  for j=1:length(ABS_state_path)
    fprintf(fid,'%s ',num2str(ABS_state_path(j)));
  end
  fprintf(fid,'\n');
  
  fprintf(fid,'Abstracted Event Path:   ');
  for j=1:length(ABS_event_path)
    fprintf(fid,'%s ',ABS_event_path{j});
  end
%   fprintf(fid,'\n');
  

  fprintf(fid,'\n\n');


  
  runningScenario = runningScenario + 1;

  if runningScenario <= str2double(scenNumFinish)
    
%     waiting = input(['Please load up scenario ' num2str(runningScenario) ', then press Enter']);
  
  end
  
end

fclose('all');

disp('All Trials Complete!')

