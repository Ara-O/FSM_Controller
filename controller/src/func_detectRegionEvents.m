function event_names = func_detectRegionEvents(bot, pos2d, regions, events)
% Updated by: Jonathon Kreska
% Version: 1.1
% Date: December 16, 2015
% Changelog:
%  1.0: Initial Release by Jill
%  1.1: Updated header and added comments
% Current Capability:
%  Returns event name(s) from the events array based on the position of a robot 
%  in user-defined regions.
% Input:
%   bot = the robot to detect the event for. Since different events correspond 
%         to each robot, bot is used to pick one event from multiple_events
%   pos2d = the position data that is provided by odometry. It is a struct with 
%           at least two fields: px and py which provide the x and y location of 
%           the robot. 
%   regions = a cell array with five columns and any number of rows. The first 
%             column contains the name of the state, the second through fifth 
%             columns contain the upper and lower bounds of x-values and 
%             y-values in that region. Example:
%              regions = { 'name',   x1,   y1,  x2,  y2}
%   events = a cell array with four columns. Example:
%             events = { 'name',  bot,  'event_type',  'type_name';
% Output: 
%  event_names = an array of strings that list all events that have been
%                detected

% These variables indicate which column of the cell array contains x values
% and which columns contain y values.
name = 1; x1 = 2; x2 = 4; y1 = 3; y2 = 5;
region_names = {};
event_names = {};

% Shorten regions, x and y vaues of current position
r = regions;
px = pos2d.X; py = pos2d.Y;

j=1;
% Loop through regions
for i=1:size(regions,1)
  % Detect if robot position is within region boundaries
  if px < max(r{i,x1},r{i,x2}) && px > min(r{i,x1},r{i,x2}) ...
      && py < max(r{i,y1},r{i,y2}) && py > min(r{i,y1},r{i,y2})
    region_name = regions{i,name};
    % Store all regions in a list of region_names
    region_names{j} = region_name;
    j=j+1;
  end
end

k=1;
% Loop through region_names
for i=1:size(region_names,2)
  % Get region_name matches in events
  multiple_events = events(strcmp(region_names(i),events(:,4)),1:2);

  % Loop through multiple_events
  for j = 1:size(multiple_events,1)
    % Match event_bot with bot
    if bot == (multiple_events{j,1}(1)-96) % Modified from multiple_events{j,2}
      event_name=multiple_events{j,1};

      % Add event_name to list of event_names
      event_names{k} = event_name;
      k=k+1;
      break
    end
  end
end