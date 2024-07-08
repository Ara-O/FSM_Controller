function thisRegion = whichRegion(X,Y,numRegions,regions)
% Author: Jonathon Kreska
% Version: 1.1
% Date: January 10, 2015
% Changelog:
%  1.0: Initial Release
%  1.1: Supports 2 digit regions
% Current Capability:
%  Determines what region number the point (X,Y) is in
% Input:
%  [X,Y] = a point in the scenario
%  numRegions = the number of regions in the current FSM
%  regions = a cell matrix from userdata that has the region locations
% Output:
%  thisRegion = The region number the provided (X,Y) point is in

% These variables indicate which column of the cell array contains x values
% and which columns contain y values. They also clean up the code.
name = 1; x1 = 2; x2 = 4; y1 = 3; y2 = 5; r = regions; 

for j=1:numRegions    % Loop through regions
  % Detect if goal is within region boundaries
  if X < max(r{j,x1},r{j,x2}) && X > min(r{j,x1},r{j,x2})...
      && Y < max(r{j,y1},r{j,y2}) && Y > min(r{j,y1},r{j,y2})
    thisRegion = regions{j,name}(4:end); % extract region number
    break % Break before it gets to the task regions
  end
end