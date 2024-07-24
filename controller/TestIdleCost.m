% cost_choose=cell(10,numRobots);
% robot=cell(10,numRobots);
% for i=1:10
%     
%     ind=best_index(i);
%     
%     for j=1:numRobots
%         robot{i,j}=perms([all_possible{ind,j}]);
%         num_t=size(robot{i,j});
%         for k=1:num_t(1)
%             robot_location=start_loc(j,:);
%             for kk=1:num_t(2)
%                 taskNum=robot{i,j}(k,kk);
%                 [taskX,taskY,~] = getTaskLocation(taskNum,tasks);
%                 robX=robot_location(1);
%                 robY=robot_location(2);                
%                 cost_choose{i,j}(k,kk)= sqrt((robX-taskX)^2+(robY-taskY)^2);
%                 robot_location(1)=taskX;
%                 robot_location(2)=taskY;
%             end
%         end
%     end
%     
% end
% 
% cost_all=cell(10,24);
% for i=1:10
%     ind=0;
%     for k=1:length(cost_choose{i,1})
%         for j=1:length(cost_choose{i,2})
%             for t=1:length(cost_choose{i,3})
%                 ind=ind+1;
%                 cost_all{i,ind}=[sum(cost_choose{i,1}(k,:)),sum(cost_choose{i,2}(j,:)),sum(cost_choose{i,3}(t,:)) ];
%             end
%         end
%     end
%     
% end
% 
% ind=0;
% 
% for i=1:10
%     for k=1:24
%         ind=ind+1;
%         cost_fin(ind)=max([cost_all{i,k}]);
%     end
% end
% 
% [sort_cost_fin, index_cost_fin] = sort(cost_fin);
% 
% cost_choose_tasks=cell(10,numRobots);
% % jut=cell(10,1);
% for i=1:10
%     
%     ind=best_index(i);
%     
% %     jut{i}=all_possible(ind,:);
%     for j=1:numRobots
%         num_t=size(all_possible{ind,j});
%         robot_location=start_loc(j,:);
%         for kk=1:num_t(2)            
%             taskNum=all_possible{ind,j}(kk);
%             [taskX,taskY,~] = getTaskLocation(taskNum,tasks);
%             robX=robot_location(1);
%             robY=robot_location(2);
%             cost_choose_tasks{i,j}(kk)= sqrt((robX-taskX)^2+(robY-taskY)^2);
% %             robot_location(1)=taskX;
% %             robot_location(2)=taskY;
%         end
%     end
% end
% 
% cost_tasks=zeros(numRobots,pairTasks);
% 
% for j=1:numRobots
%     robot_location=start_loc(j,:);
%     robX=robot_location(1);
%     robY=robot_location(2);
% for i=1:pairTasks
%     taskNum=i+i-1;
%     [taskX,taskY,~] = getTaskLocation(taskNum,tasks);
%     cost_tasks(j,i)=sqrt((robX-taskX)^2+(robY-taskY)^2);
% end
% end
% 
% cost_between=zeros(pairTasks,pairTasks);
% 
% for j=1:pairTasks
%     task1=j+j-1;
%     [taskX1,taskY1,~] = getTaskLocation(task1,tasks);
%     for i=j+1:pairTasks
%         task2=i+i-1;
%         [taskX2,taskY2,~] = getTaskLocation(task2,tasks);
%          cost_between(j,i)=sqrt((taskX1-taskX2)^2+(taskY1-taskY2)^2);
%     end
% end
% 
% savings=cell(numRobots,1);
% 
% for j=1:numRobots
%     savings{j}=nan(pairTasks,pairTasks);
%     for i=1:pairTasks
%         for k=i+1:pairTasks
%             savings{j}(i,k)=cost_tasks(j,i)+cost_tasks(j,k)-cost_between(i,k);
%         end
%     end
% end
robot_saved=zeros(10,numRobots+1);
auxt=zeros(10,6);
autt=zeros(10,2);
for i=1:10
    
    ind=best_index(i);
    
    for j=1:numRobots
        robot_tasks=[all_possible{ind,j}];
        if mod(length(robot_tasks),2)
            auxt(i,1)=cost_tasks(j,round(robot_tasks(1)/2))+cost_between(round(robot_tasks(1)/2),round(robot_tasks(2)/2))+cost_between(round(robot_tasks(2)/2),round(robot_tasks(3)/2));%savings{j}(round(robot_tasks(1)/2),round(robot_tasks(2)/2))+cost_between(round(robot_tasks(2)/2),round(robot_tasks(3)/2));
            auxt(i,2)=cost_tasks(j,round(robot_tasks(1)/2))+cost_between(round(robot_tasks(1)/2),round(robot_tasks(3)/2))+cost_between(round(robot_tasks(2)/2),round(robot_tasks(3)/2));%savings{j}(round(robot_tasks(1)/2),round(robot_tasks(3)/2))+cost_between(round(robot_tasks(2)/2),round(robot_tasks(3)/2));
            auxt(i,3)=cost_tasks(j,round(robot_tasks(2)/2))+cost_between(round(robot_tasks(2)/2),round(robot_tasks(3)/2))+cost_between(round(robot_tasks(1)/2),round(robot_tasks(3)/2));%savings{j}(round(robot_tasks(2)/2),round(robot_tasks(3)/2))+cost_between(round(robot_tasks(1)/2),round(robot_tasks(3)/2));
            auxt(i,4)=cost_tasks(j,round(robot_tasks(2)/2))+cost_between(round(robot_tasks(1)/2),round(robot_tasks(2)/2))+cost_between(round(robot_tasks(1)/2),round(robot_tasks(3)/2));savings{j}(round(robot_tasks(2)/2),round(robot_tasks(3)/2))+cost_between(round(robot_tasks(1)/2),round(robot_tasks(2)/2));
            auxt(i,5)=cost_tasks(j,round(robot_tasks(3)/2))+cost_between(round(robot_tasks(1)/2),round(robot_tasks(3)/2))+cost_between(round(robot_tasks(2)/2),round(robot_tasks(3)/2));
            auxt(i,6)=cost_tasks(j,round(robot_tasks(3)/2))+cost_between(round(robot_tasks(2)/2),round(robot_tasks(3)/2))+cost_between(round(robot_tasks(1)/2),round(robot_tasks(2)/2));
            indexs=find(auxt(i,:)==min(auxt(i,:)));
            if indexs==1
                robot_saved(i,j)=savings{j}(round(robot_tasks(1)/2),round(robot_tasks(2)/2))+savings{j}(round(robot_tasks(2)/2),round(robot_tasks(3)/2));
            elseif indexs==2 || indexs==5
                robot_saved(i,j)=savings{j}(round(robot_tasks(1)/2),round(robot_tasks(3)/2))+savings{j}(round(robot_tasks(2)/2),round(robot_tasks(3)/2));
            elseif indexs==3 
                robot_saved(i,j)=savings{j}(round(robot_tasks(2)/2),round(robot_tasks(3)/2))+savings{j}(round(robot_tasks(1)/2),round(robot_tasks(3)/2));
            elseif indexs==4
                robot_saved(i,j)=savings{j}(round(robot_tasks(1)/2),round(robot_tasks(2)/2))+savings{j}(round(robot_tasks(1)/2),round(robot_tasks(3)/2));
            elseif indexs==6
                robot_saved(i,j)=savings{j}(round(robot_tasks(2)/2),round(robot_tasks(3)/2))+savings{j}(round(robot_tasks(1)/2),round(robot_tasks(2)/2));
                
            end  
        else
            for k=1:length(robot_tasks)-1
                robot_saved(i,j)= robot_saved(i,j)+savings{j}(round(robot_tasks(k)/2),round(robot_tasks(k+1)/2));
            end
        end
        robot_saved(i,numRobots+1)=sum(robot_saved(i,1:3));
    end
end

% % desired_savings={[],[1,7],[3,5,9,11,13]};
% % numRobTasksSavings(1)=length(desired_savings{1});
% % for i=2:numRobots
% %     numRobTasksSavings(i)=numRobTasksSavings(i-1)+length(desired_savings{i});
% % end
% % 
% % index_tasks=(1:pairTasks);
% % 
% %     order=perms(index_tasks);
% %     for j=1:length(order)
% %         for kk=1:pairTasks
% %             for i=1:numRobots
% %                 if order(j,kk)<=numRobTasksSavings(i)
% %                     numTasksRobb=length(desired_savings{i});
% %                     indexTask=order(j,kk)-numRobTasksSavings(i)+numTasksRobb;
% %                     task_rob=desired_savings{i}(indexTask);
% %                     robot=i;
% %                     
% %                     if task_rob<10
% %                         plans_savings{j}{kk}=strcat(char(robot+96),'0',num2str(task_rob),'s');
% %                     else
% %                         plans_savings{j}{kk}=strcat(char(robot+96),num2str(task_rob),'s');
% %                     end
% %                     break;
% %                 end
% %             end
% %         end
% %          [pop_savings{j},costs_savings(j)] = testPlan(plans_savings{j}(:),cur_states,states_incr,event_list,num_fsms,numRobots,start_loc,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,events_incr);
% %     
% %     end


