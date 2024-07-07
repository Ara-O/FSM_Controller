function [path_mask,taskRobot] = convertToMask2(path_abs,numTasks)
taskRobot=zeros(numTasks/2,1);
path_mask=cell(numTasks,1);
for i=1:length(path_abs)
    task= str2double(path_abs{i}(end-2:end-1));    
    path_mask{i}=strcat(path_abs{i}(1),num2str(task-(1-mod(task,2))));
    event_robot=path_abs{i}(1)-96;
    ind=ceil(task/2);
    taskRobot(ind)=event_robot;
end
            
%             if strcmp(path_abs{i}(1),'a')
%                 if strcmp(path_abs{i}(end-1),'1') || strcmp(path_abs{i}(end-1),'2')
%                     path_mask{i}=strcat('a',num2str(1));
%                 elseif strcmp(path_abs{i}(end-1),'3') || strcmp(path_abs{i}(end-1),'4')
%                     path_mask{i}=strcat('a',num2str(3));
%                 elseif strcmp(path_abs{i}(end-1),'5') || strcmp(path_abs{i}(end-1),'6')
%                     path_mask{i}=strcat('a',num2str(5));
%                 elseif strcmp(path_abs{i}(end-1),'7') || strcmp(path_abs{i}(end-1),'8')
%                     path_mask{i}=strcat('a',num2str(7));
%                 elseif strcmp(path_abs{i}(end-1),'9') || strcmp(path_abs{i}(end-2:end-1),'10')
%                     path_mask{i}=strcat('a',num2str(9));
%                 elseif strcmp(path_abs{i}(end-2:end-1),'11') || strcmp(path_abs{i}(end-2:end-1),'12')
%                     path_mask{i}=strcat('a',num2str(11));
%                 elseif strcmp(path_abs{i}(end-2:end-1),'13') || strcmp(path_abs{i}(end-2:end-1),'14')
%                     path_mask{i}=strcat('a',num2str(13));
%                 elseif strcmp(path_abs{i}(end-2:end-1),'15') || strcmp(path_abs{i}(end-2:end-1),'16')
%                     path_mask{i}=strcat('a',num2str(15));
%                 else
%                     path_mask{i}=strcat('a',num2str(13));
%                 end
%             elseif strcmp(path_abs{i}(1),'b')
%                 if strcmp(path_abs{i}(end-1),'1') || strcmp(path_abs{i}(end-1),'2')
%                     path_mask{i}=strcat('b',num2str(1));
%                 elseif strcmp(path_abs{i}(end-1),'3') || strcmp(path_abs{i}(end-1),'4')
%                     path_mask{i}=strcat('b',num2str(3));
%                 elseif strcmp(path_abs{i}(end-1),'5') || strcmp(path_abs{i}(end-1),'6')
%                     path_mask{i}=strcat('b',num2str(5));
%                elseif strcmp(path_abs{i}(end-1),'7') || strcmp(path_abs{i}(end-1),'8')
%                     path_mask{i}=strcat('b',num2str(7));
%                 elseif strcmp(path_abs{i}(end-1),'9') || strcmp(path_abs{i}(end-2:end-1),'10')
%                     path_mask{i}=strcat('b',num2str(9));
%                 elseif strcmp(path_abs{i}(end-2:end-1),'11') || strcmp(path_abs{i}(end-2:end-1),'12')
%                     path_mask{i}=strcat('b',num2str(11));
%                 else
%                     path_mask{i}=strcat('b',num2str(13));
%                     
%                 end
%             elseif strcmp(path_abs{i}(1),'c')
%                 if strcmp(path_abs{i}(end-1),'1') || strcmp(path_abs{i}(end-1),'2')
%                     path_mask{i}=strcat('c',num2str(1));
%                 elseif strcmp(path_abs{i}(end-1),'3') || strcmp(path_abs{i}(end-1),'4')
%                     path_mask{i}=strcat('c',num2str(3));
%                 elseif strcmp(path_abs{i}(end-1),'5') || strcmp(path_abs{i}(end-1),'6')
%                     path_mask{i}=strcat('c',num2str(5));
%                 elseif strcmp(path_abs{i}(end-1),'7') || strcmp(path_abs{i}(end-1),'8')
%                     path_mask{i}=strcat('c',num2str(7));
%                 elseif strcmp(path_abs{i}(end-1),'9') || strcmp(path_abs{i}(end-2:end-1),'10')
%                     path_mask{i}=strcat('c',num2str(9));
%                 elseif strcmp(path_abs{i}(end-2:end-1),'11') || strcmp(path_abs{i}(end-2:end-1),'12')
%                     path_mask{i}=strcat('c',num2str(11));
%                 else
%                     path_mask{i}=strcat('c',num2str(13));
%                 end
%             end
%         end

end