function [x,y] = calcRegCenter(regNumStr,numRegions,numTasks,regions)
% Author: Jonathon Kreska
% Version: 1.0
% Date: December 16, 2015
% Changelog:
%  1.0: Initial Release
% Current Capability:
%  Returns the (X,Y) point that is the center of the given region number string
% Input:
%  regNumStr = a string that contains the region number
%  numRegions = the number of regions in the current FSM
%  numTasks = the number of tasks in the current FSM
%  regions = a cell matrix from userdata that has the region locations
% Output:
%  [x,y] = the X,Y point that is the center of the given region

for l=1:numRegions-numTasks
  if strcmp(regions{l,1},['reg' regNumStr])
    x = mean([regions{l,2},regions{l,4}]);
    y = mean([regions{l,3},regions{l,5}]);
    break
  end
end