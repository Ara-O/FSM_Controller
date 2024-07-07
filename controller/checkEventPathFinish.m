function [aux_index,aux_f] = checkEventPathFinish(event_list,path,ind)
aux=0;
aux_f=0;
aux_index=0;
if ind <= length(path{1})
    %for i=1:length(path{1})
    for j=1:length(event_list)
        if strcmp(event_list{j,1},path{1}{ind}{1})
%             if strcmp(event_list{j,1}(end-1),path{1}{ind}{1}(end-1))
%                 if strcmp(event_list{j,1}(end),'s')
                    aux=1;
                    aux_index=j;
                    aux_f=1;
                    break;
                    
%                 end
%             end
        end
    end
    
    if aux==0
        for j=1:length(event_list)
            if strcmp(event_list{j,1}(end),'f')
                aux=1;
                aux_index=j;
                aux_f=0;
                break;
            end
        end
    end
end
%         if aux
%             break;
%         end
    %end
