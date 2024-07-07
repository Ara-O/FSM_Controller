function path= popAbsCluster(pop_size,events,num_tasks,num_robots,num_cluster)

total_cluster=num_robots^(num_tasks/num_robots);

for i=1:num_robots
    init(i)=1+num_tasks*(i-1); %pointer to the robot
end

if num_cluster==1
    for i=1:2:num_tasks
        pop{i}=strcat('a',num2str(i));
        pop{i+1}=strcat('a',num2str(i));
    end
else
    if num_cluster==2
        for i=1:2:num_tasks
            pop{i}=strcat('b',num2str(i));
            pop{i+1}=strcat('b',num2str(i));
        end
    else
        if num_cluster==3
            for i=1:2:num_tasks/2
                pop{i}=strcat('a',num2str(i));
                pop{i+1}=strcat('a',num2str(i));
            end
            for i=(num_tasks/2)+2:2:num_tasks
                pop{i}=strcat('b',num2str(i));
                pop{i+1}=strcat('b',num2str(i));
            end
        else
            if num_cluster==4
                for i=1:2:num_tasks/2
                    pop{i}=strcat('b',num2str(i));
                    pop{i+1}=strcat('b',num2str(i));
                end
                for i=(num_tasks/2)+2:2:num_tasks
                    pop{i}=strcat('a',num2str(i));
                    pop{i+1}=strcat('a',num2str(i));
                end
            end
        end
    end
end
index=[];
    
for j=1:pop_size
    index(j,:)=createDifAbsPlan(index,randperm(length(pop)));        
    aux_1=0;
    aux_3=0;
    aux_5=0;
    for i=1:length(index(j,:))
        ele=pop{index(j,i)};
        if strcmp(ele(1),'a')
            if strcmp(ele(end),'1')
                if aux_1==0
                    path{j}{i}={events{1}};
                    aux_1=aux_1+1;
                else
                    path{j}{i}={events{2}};
                end
            else
                if strcmp(ele(end),'3')
                    if aux_3==0
                        path{j}{i}={events{3}};
                        aux_3=aux_3+1;
                    else
                        path{j}{i}={events{4}};
                    end
                else
                    if aux_5==0
                        path{j}{i}={events{5}};
                        aux_5=aux_5+1;
                    else
                        path{j}{i}={events{6}};
                    end
                end
                
            end
        else
            if strcmp(ele(end),'1')
                if aux_1==0
                    path{j}{i}={events{num_tasks+1}};
                    aux_1=aux_1+1;
                else
                    path{j}{i}={events{num_tasks+2}};
                end
            else
                if strcmp(ele(end),'3')
                    if aux_3==0
                        path{j}{i}={events{num_tasks+3}};
                        aux_3=aux_3+1;
                    else
                        path{j}{i}={events{num_tasks+4}};
                    end
                else
                    if aux_5==0
                        path{j}{i}={events{num_tasks+5}};
                        aux_5=aux_5+1;
                    else
                        path{j}{i}={events{num_tasks+6}};
                    end
                end
                
            end
            
        end
        
    end
end


end

