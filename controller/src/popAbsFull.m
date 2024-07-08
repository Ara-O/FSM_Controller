function path= popAbsFull(pop_size,num_tasks,num_robots)
ind=1;
path='';
for i=1:num_tasks
    if i<10
        task{ind}=strcat('0',num2str(i));
    else
        task{ind}=num2str(i);
    end
    ind=ind+1;
end

for j=1:num_robots
    robot{j}=char(96+j);
end

step=1/num_robots;

for i=1:2:num_tasks-1
    mask(i)=i;
    mask(i+1)=i;
end
i=1;
while i<=pop_size
    index=1;
    ind=randperm(num_tasks);
    aux=zeros(1,num_tasks/2);
    task_rob=zeros(1,num_tasks/2);
    for j=1:length(ind)
        
        
        if aux(mask(ind(j))-floor(mask(ind(j))/2))==0
            coin=rand;
            for k=1:num_robots
                if coin > (k-1)*step && coin < k*step
                    rob=k;
                    break;
                end
            end
            task_rob(mask(ind(j))-floor(mask(ind(j))/2))=k;
            path_aux{index}={strcat(robot{k},task{mask(ind(j))},'s')};
            index=index+1;
            aux(mask(ind(j))-floor(mask(ind(j))/2))=1;
        else
            path_aux{index}={strcat(robot{task_rob(mask(ind(j))-floor(mask(ind(j))/2))},task{mask(ind(j))+1},'s')};
            index=index+1;
        end
        
    end
     path{i}=path_aux;
    i=i+1;
end
end
