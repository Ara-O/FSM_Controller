function index_new = createDifAbsPlan(index,index_plan)
aux_1=0;
size_index=size(index);
    for i=1:size_index(1)
        aux=0;
        for j=1:length(index_plan)
            if index(i,j)==index_plan(j)
                aux=aux+1;
            end
        end
        if aux==length(index_plan)
            aux_1=1;
            break;
        end
    end
    
    if aux_1==1
        index_2 = randperm(length(index_plan));
        index_new=createDifAbsPlan(index,index_2);
    else
        index_new=index_plan;
    end
        
end
