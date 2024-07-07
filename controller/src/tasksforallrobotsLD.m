function [result,aux_a,aux_b,aux_c] = tasksforallrobotsLD(all_ass_event_path,numRobots)
aux_a=0;
aux_b=0;
aux_c=0;
result=1;

%if numel(all_ass_event_path)<numRobots
 %result=0;
%end
%else
  
  %verify if the LocalDijkstra run at least one time and the entry events
  %resulting from the LD occured and then one final event happened, so another
  %event from the Global plan is going to be addressed
  
  %if (aux_LD>0) && strcmp(event_path(end-1,4),'f') 
  %if numel(all_ass_event_path)==num_robots
    for i=1:numel(all_ass_event_path)
      typerobot = all_ass_event_path{i}(1);
      if strcmp(typerobot,'a')
        aux_a=1;
      else
        if strcmp(typerobot,'b')
          aux_b=1;
        else
          if strcmp(typerobot,'c')
            aux_c=1;
          end
        end
      end
    end
  
  if (aux_a+aux_b+aux_c)<numRobots
    result=0;
  end
  end
%end
%end