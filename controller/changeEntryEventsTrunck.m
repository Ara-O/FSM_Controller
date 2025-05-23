function [new_plan, new_events] = changeEntryEventsTrunck(plan,plan_event,states_incr,num_fsm,initial_state_incr,event_list,events_incr)
index=randperm(length(plan_event)-1);
for i=1:length(plan_event)   
    if strcmp(plan_event{index(i)}(end),'f')
        robot=plan_event{index(i)}(1);
        break;
    end
end
final_entry=plan_event{index(i)};
goal=plan{index(i)+1};
region1=0;
% for j=index(i):-1:1
%     if strcmp(plan_event{j}(1),robot)
%         if strcmp(plan_event{j}(end),'e')
%             final_entry=plan_event{j};
%             break;
%         end
%     end
% end
index1=0;
for j=index(i)-1:-1:1
    %if strcmp(plan_event{j}(1),robot)
        if strcmp(plan_event{j}(end),'s') || strcmp(plan_event{j}(end),'f')
            index1=j;
            break;
        end
    %end
end
if index1==0
    ju=34;
end
root=plan{index1+1};

[part_plan,part_events,aux_event,aux_level] = breathFirstStateTrunck(root,goal,states_incr,num_fsm,event_list,events_incr);

indPlan=randi([1 length(part_events)]);

if aux_event==1
    new_events={plan_event{1:index1},part_events{indPlan}{:},plan_event{index(i)+1:end}};
    new_plan={plan{1:index1},part_plan{indPlan}{:},plan{index(i)+2:end}};
else
    if aux_level==1
        new_events={plan_event{1:end}};
        new_plan={plan{1:end}};
    end
end

end