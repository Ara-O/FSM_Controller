function [ has_event ] = hasEvent( event,event_list )
%HASEVENT Returns true if input event is part of an event list
%   Coded By Daniel Burke

% Initialize variables
has_event = 0;
events_size = size(event_list);

% Loops through events comparing agianst input event and checks for a match
for i = 1:events_size
  if(strcmp(event_list(i,1),event))
    has_event = true;
    break
  end
end

end

