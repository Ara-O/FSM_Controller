function path_abs = crossOverAbs(parent_1,parent_2,events,num_tasks)
path_1=convertToMask(parent_1);
path_2=convertToMask(parent_2);

for i=1:num_tasks/2
    auxA1(i)=0;
    auxB1(i)=0;   
    auxA2(i)=0;
    auxB2(i)=0;
end
ind=1;
aux=[];
for i=1:length(path_1)
    if strcmp(path_1{i}(1),'a')
        for j=1:length(auxA1)
            if strcmp(path_1{i}(end),num2str(j+(j-1)))
                auxA1(j)=auxA1(j)+1;
            end
        end
    elseif strcmp(path_1{i}(1),'b')
        for j=1:length(auxB1)
            if strcmp(path_1{i}(end),num2str(j+(j-1)))
                auxB1(j)=auxB1(j)+1;
            end
        end
    end
    if strcmp(path_2{i}(1),'a')
        for j=1:length(auxA2)
            if strcmp(path_2{i}(end),num2str(j+(j-1)))
                auxA2(j)=auxA2(j)+1;
            end
        end
    elseif strcmp(path_2{i}(1),'b')
        for j=1:length(auxB2)
            if strcmp(path_2{i}(end),num2str(j+(j-1)))
                auxB2(j)=auxB2(j)+1;
            end
        end
    end
    
        if isequal(auxA1,auxA2) && isequal(auxB1,auxB2)
            aux(ind)=i;
            ind=ind+1;
            
        end 
end

if aux==length(path_1)
    offspring1=path_1;
    offspring2=path_2;
else
    index=randi([1 (length(aux)-1)]);
    offspring1={path_1{1:aux(index)},path_2{aux(index)+1:end}};
    offspring2={path_2{1:aux(index)},path_1{aux(index)+1:end}};
   
    
end
path_abs{1}=offspring1;%convertToEvent(offspring1,events,num_tasks);
path_abs{2}=offspring2;%convertToEvent(offspring2,events,num_tasks);

end