function [ shared_mat ] = calcSharedEvents( events,num_fsms )
%CALCSHAREDEVENTS Summary of this function goes here
%   Coded by Daniel Burke
shared_mat = num2cell(NaN(1,num_fsms));

for i = 1:num_fsms
  for j = 1:num_fsms
    if(i == j)
      continue
    end
    num_events = size(events{i});
    for k = 1:num_events
      event = events{i}(k,1);
      % Need to check first if we already added this event to prevent
      % duplicates
      [~,shared_size] = size(shared_mat{i});
      added_already = false;
      for l = 1:shared_size
        if(strcmp(shared_mat{i}(l),event))
          added_already = true;
        end
      end
      if(hasEvent(event,events{j}) && ~added_already)
        shared_mat{i} = [shared_mat{i} event];
      end
    end    
  end  
end  


end

