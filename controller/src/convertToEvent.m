function path_abs = convertToEvent(pop,events,num_tasks)

        


aux_1=0;
aux_3=0;
aux_5=0;
aux_7=0;
aux_9=0;
aux_11=0;
aux_13=0;
for i=1:length(pop)
    ele=pop{i};
    if strcmp(ele(1),'a')
        if strcmp(ele(end),'1')
            if aux_1==0
                path{i}={events{1}};
                aux_1=aux_1+1;
            else
                path{i}={events{2}};
            end
        elseif strcmp(ele(end),'3')
                if aux_3==0
                    path{i}={events{3}};
                    aux_3=aux_3+1;
                else
                    path{i}={events{4}};
                end
        elseif strcmp(ele(end),'5')
                    if aux_5==0
                        path{i}={events{5}};
                        aux_5=aux_5+1;
                    else
                        path{i}={events{6}};
                    end
       elseif strcmp(ele(end),'7')
                    if aux_7==0
                        path{i}={events{7}};
                        aux_7=aux_7+1;
                    else
                        path{i}={events{8}};
                    end
       elseif strcmp(ele(end),'9') 
           if aux_9==0
               path{i}={events{9}};
               aux_9=aux_9+1;
           else
               path{i}={events{10}};
           end
        elseif strcmp(ele(end-1:end),'11')
            if aux_11==0
                path{i}={events{11}};
                aux_11=aux_11+1;
            else
                path{i}={events{12}};
            end
        elseif strcmp(ele(end-1:end),'13')
            if aux_13==0
                path{i}={events{13}};
                aux_13=aux_13+1;
            else
                path{i}={events{14}};
            end
        end      

    elseif strcmp(ele(1),'b')
        if strcmp(ele(end),'1')
            if aux_1==0
                path{i}={events{num_tasks+1}};
                aux_1=aux_1+1;
            else
                path{i}={events{num_tasks+2}};
            end
        elseif strcmp(ele(end),'3')
                if aux_3==0
                    path{i}={events{num_tasks+3}};
                    aux_3=aux_3+1;
                else
                    path{i}={events{num_tasks+4}};
                end
        elseif strcmp(ele(end),'5')
                    if aux_5==0
                        path{i}={events{num_tasks+5}};
                        aux_5=aux_5+1;
                    else
                        path{i}={events{num_tasks+6}};
                    end
        elseif strcmp(ele(end),'7')
            if aux_7==0
                path{i}={events{num_tasks+7}};
                aux_7=aux_7+1;
            else
                path{i}={events{num_tasks+8}};
            end
        elseif strcmp(ele(end),'9')
            if aux_9==0
                path{i}={events{num_tasks+9}};
                aux_9=aux_9+1;
            else
                path{i}={events{num_tasks+10}};
            end
        elseif strcmp(ele(end-1:end),'11')
            if aux_11==0
                path{i}={events{num_tasks+11}};
                aux_11=aux_11+1;
            else
                path{i}={events{num_tasks+12}};
            end
        elseif strcmp(ele(end-1:end),'13')
            if aux_13==0
                path{i}={events{num_tasks+13}};
                aux_13=aux_13+1;
            else
                path{i}={events{num_tasks+14}};
            end
            
        end
    else
        if strcmp(ele(end),'1')
            if aux_1==0
                path{i}={events{2*num_tasks+1}};
                aux_1=aux_1+1;
            else
                path{i}={events{2*num_tasks+2}};
            end
        elseif strcmp(ele(end),'3')
                if aux_3==0
                    path{i}={events{2*num_tasks+3}};
                    aux_3=aux_3+1;
                else
                    path{i}={events{2*num_tasks+4}};
                end
        elseif strcmp(ele(end),'5')
                    if aux_5==0
                        path{i}={events{2*num_tasks+5}};
                        aux_5=aux_5+1;
                    else
                        path{i}={events{2*num_tasks+6}};
                    end
        elseif strcmp(ele(end),'7')
            if aux_7==0
                path{i}={events{2*num_tasks+7}};
                aux_7=aux_7+1;
            else
                path{i}={events{2*num_tasks+8}};
            end
        elseif strcmp(ele(end),'9')
            if aux_9==0
                path{i}={events{2*num_tasks+9}};
                aux_9=aux_9+1;
            else
                path{i}={events{2*num_tasks+10}};
            end
        elseif strcmp(ele(end-1:end),'11')
            if aux_11==0
                path{i}={events{2*num_tasks+11}};
                aux_11=aux_11+1;
            else
                path{i}={events{2*num_tasks+12}};
            end
        elseif strcmp(ele(end-1:end),'13')
            if aux_13==0
                path{i}={events{2*num_tasks+13}};
                aux_13=aux_13+1;
            else
                path{i}={events{2*num_tasks+14}};
            end
        end
    end
end
                
path_abs={path};
end