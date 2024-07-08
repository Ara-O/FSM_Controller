function path = convertToTasks(pop,num_tasks)
path=cell(num_tasks,1);
aux_tasks=zeros(1,num_tasks);

for i=1:length(pop)
    ele=pop{i};
    if length(ele)==2
        mask_num=str2double(ele(end));
    else
        mask_num=str2double(ele(end-1:end));
    end
    task_num=mask_num+aux_tasks(mask_num);
    if task_num < 10
        task_name=strcat('0',num2str(task_num));
    else
        task_name=num2str(task_num);
    end
    aux_tasks(mask_num)=aux_tasks(mask_num)+1; 
    path{i}=strcat(ele(1),task_name,'s');
end

end