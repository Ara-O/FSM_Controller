function [taskX,taskY,taskOrigin] = getTaskLocation(taskNum,tasks)
% Author: Jonathon Kreska
% Version: 1.0
% Date: December 16, 2015
% Changelog:
%  1.0: Initial Release
% Current Capability:
%  Returns the (X,Y) point that is the location of the given task number string.
%  This can also provide the location where the robot should be before starting
%  the current task.
% Input:
%  taskNum = a string that contains the task number
%  tasks = a cell matrix from userdata that has the task locations ans origins
% Output:
%  [taskX,taskY] = the X,Y point that is the task location
%  taskOrigin = where the task originated from

% {
% disp(taskNum)
% disp(isnumeric(taskNum))
% Converts taskNum to a string to check 
if(isnumeric(taskNum))
  taskNum = num2str(taskNum);
end
% }

%disp(size(tasks))
for k=1:size(tasks)
  %another error here with the task numberings?
  
  if strcmp(tasks(k,1),['tsk' taskNum]) || strcmp(tasks(k,1),['tsk0' taskNum])  % find the task in the list
    taskX = tasks{k,2}; % Extract the task location
    taskY = tasks{k,3}; 
    taskOrigin = tasks{k,5}; % get origin of task
    %disp('assigned')
    %disp(taskX)
    %disp(taskY)
    %disp(taskOrigin)
    break
  end
  %disp(k)
end