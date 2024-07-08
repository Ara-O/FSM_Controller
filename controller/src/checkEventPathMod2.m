function aux_index = checkEventPathMod2(event_list,path,ind)
    aux=0;
    aux_index=0;
    if ind <= length(path)
    %for i=1:length(path{1})
        for j=1:length(event_list)
            if strcmp(event_list{j,1},path{ind})
                aux=1;
                aux_index=j;
                break;
            end
        end
    end
%         if aux
%             break;
%         end
    %end
end