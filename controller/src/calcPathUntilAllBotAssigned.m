function [all_ass_event_path,num_all_elem] = calcPathUntilAllBotAssigned(ABS_event_path,numRobots,ABS_pc)
% Capability
%  This function takes the input path and returns a shortened path until an event where each
%  robot has an assignment. Works perfectly for Abstracted paths with start
%  events only; its Inteneded use.

robot_assigned = false(numRobots,1);

for i=ABS_pc:numel(ABS_event_path)
  rob_num = ABS_event_path{i}(1)-96;
  robot_assigned(rob_num,1) = true;
  
  if all(robot_assigned)
    break
  end
  
end

all_ass_event_path = ABS_event_path(ABS_pc:i);

num_all_elem=numel(all_ass_event_path);

