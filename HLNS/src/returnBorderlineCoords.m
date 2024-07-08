function [x1,y1,x2,y2] = returnBorderlineCoords(robRegNum,nxtRegNum,numRegions,numTasks,regions, ...
                                        robReg_x,robReg_y,nxtReg_x,nxtReg_y,trans_event,event_path)
% Author: Daniel Burke
% Version: 1.0
% Date: July 13, 2016
% Changelog:
%  1.0: Initial Release
% Current Capability:
%  Returns the (X,Y) coordinates of the borderline between two given regions
% Input:
%  regNumStr1 = a string that contains the first region number
%  regNumStr2 = a string that contains the second region number
%  numRegions = the number of regions in the current FSM
%  numTasks = the number of tasks in the current FSM
%  regions = a cell matrix from userdata that has the region locations
% Output:
%  [x,y] = the X,Y coordinates of the borderline between two given regions

% First the program checks where the adjacent regions are relative to each other
% x's equal means that one region is above or below the other
if(robReg_x == nxtReg_x)
   % Checks which y is bigger, takes the bottom left coords of 
   % the one with bigger y and takes top right coords from smaller y
   if(robReg_y > nxtReg_y)
     [x1, y1] = getBottomLeftCoords(robRegNum,numRegions,numTasks,regions);
     [x2, y2] = getTopRightCoords(nxtRegNum,numRegions,numTasks,regions);
   else
     [x1, y1] = getBottomLeftCoords(nxtRegNum,numRegions,numTasks,regions);
     [x2, y2] = getTopRightCoords(robRegNum,numRegions,numTasks,regions);
   end

% y's equal mean that regions are to the left/right of each other
elseif(robReg_y == nxtReg_y)
   % Checks which x is bigger, takes the bottom left coords of 
   % the one with bigger x and takes top right coords from smaller x
   if(robReg_x > nxtReg_x)
     [x1, y1] = getBottomLeftCoords(robRegNum,numRegions,numTasks,regions);
     [x2, y2] = getTopRightCoords(nxtRegNum,numRegions,numTasks,regions);
   else
     [x1, y1] = getBottomLeftCoords(nxtRegNum,numRegions,numTasks,regions);
     [x2, y2] = getTopRightCoords(robRegNum,numRegions,numTasks,regions);
   end
   
else
  % This case should not ever occur if code works correctly
  disp('Error: Regions not adjacent');
end

function [a,b] = getBottomLeftCoords(regNum,numRegions,numTasks,regions)

for l=1:numRegions-numTasks
  if strcmp(regions{l,1},['reg' regNum])
    a = regions{l,2};
    b = regions{l,3};
    break
  end
end

function [c,d] = getTopRightCoords(regNum,numRegions,numTasks,regions)

for l=1:numRegions-numTasks
  if strcmp(regions{l,1},['reg' regNum])
    c = regions{l,4};
    d = regions{l,5};
    break
  end
end