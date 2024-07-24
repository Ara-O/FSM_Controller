function [ private_mat ] = calcPrivateEvents( shared_mat,events,num_fsms )
%UNTITLED Summary of this function goes here
%   Coded by Daniel Burke

private_mat = num2cell(NaN(1,num_fsms));


for i = 1:num_fsms
  num_events = size(events{i});
  [~,num_shared] = size(shared_mat{i});
  for j = 1:num_events
    shared = false;
    for k = 1:num_shared
      if(strcmp(events{i}(j,1),shared_mat{i}(1,k)))
        shared = true;
      end
    end  
    if(~shared)
      private_mat{i} = [private_mat{i} events{i}(j,1)]; 
    end  
  end    
end    

end

