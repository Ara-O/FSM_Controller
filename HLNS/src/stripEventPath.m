function event_path = stripEventPath(event_path, all_ass_event_path)
% path stripper
% This function takes the input path and strips out all the entry and finish
% events and returns a modified path with only start events.
% Intended use is for comparing the stripped path with an abstracted path for
% comparison.

for i= numel(event_path):-1:1
  if ~strcmp(event_path{i}(end),'s')
    %%%%%modified Juliana
    aux=0;
     if strcmp(event_path{i}(end),'f') 
         for k=1:numel(all_ass_event_path)
          if strcmp(event_path{i},all_ass_event_path{k})
                   aux=1;
          end
         end
     end
     if aux==0
      event_path(i)=[];
     end
  end
end
end
