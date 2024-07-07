function [taskRobot] = checkRobotPos(path_abs,numTasks)
taskRobot=zeros(numTasks,1);
% path_mask=cell(numTasks,1);
for i=1:length(path_abs)
%     task= str2double(path_abs{i}(end-2:end-1));    
%     path_mask{i}=strcat(path_abs{i}(1),num2str(task-(1-mod(task,2))));
    event_robot=path_abs{i}(1)-96;
    taskRobot(i)=event_robot;
%     ind=ceil(task/2);
%     taskRobot(ind)=event_robot;
end
       
end