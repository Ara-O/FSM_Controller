function [aux] = checkAbsPath(path,path_set)
    aux=0;
    for i=1:length(path_set)
        aux_set=0;
        for j=1:length(path)
            if strcmp(path{j},path_set{i}{j})
                aux_set=aux_set+1;
            else
                break;
            end
        end
            if aux_set==length(path)
                aux=1;
                break;
            end
    end

end