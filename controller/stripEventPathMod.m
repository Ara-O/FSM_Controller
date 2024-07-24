function event_path = stripEventPathMod(event_path)
% path stripper
% This function takes the input path and strips out all the entry and finish
% events and returns a modified path with only start events.
% Intended use is for comparing the stripped path with an abstracted path for
% comparison.

for i= numel(event_path):-1:1
  if ~strcmp(event_path{i}(end),'s')
    %%%%%modified Juliana
     aux=0;
     if aux==0
      event_path(i)=[];
     end
  end
end
end