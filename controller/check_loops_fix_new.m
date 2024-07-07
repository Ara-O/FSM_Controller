function [new_path_gen,new_path_events]=check_loops_fix_new(path_gen,path_events)
%check if there are loops in the path
n=length(path_gen);
aux_dup=0;
aux_keep=1;

    [~,ind]=unique(path_gen);
    duplicate_ind=setdiff(1:length(path_gen),ind);
    duplicate_value=unique(path_gen(duplicate_ind));
    new_path_gen(1)=path_gen(1);
    %new_path_events(1)=path_events{1:1};
    %while aux_keep
        for j=2:length(path_gen)
            b=length(new_path_gen);
            for i=1:b
                if path_gen(j)==new_path_gen(i)
                    aux_dup=1;
                    if i< b% it means we recorded the loop, so I need to delete everything til i, if equals b we just don't need to record the state
                        old_path=new_path_gen;
                        new_path_gen='';
                        new_path_gen=old_path(1:i);
                        old_event=new_path_events;
                        new_path_events='';
                        new_path_events={old_event{1:i-1}};
                        break;
                    else
                        break;
                    end
                else
                    new_path_gen(b+1)=path_gen(j);
                    new_path_events{b}=path_events{j-1};
                end
            end
        end
        

    %end
 if aux_dup==0
     new_path_gen=[path_gen(1:end)];
     new_path_events=[path_events{1:end}];
%  else
%      if ~isempty(duplicate_value)
%          
%          pause;
%      end
 end
 
end