function plan_abs = extractPlanOdd(plan,numTasks)
plan_abs=cell(1,numTasks/2);
ind=0;
for i=1:length(plan)
    task=str2double(plan{i}(end-2:end-1));
    if mod(task,2)
        ind=ind+1;
        plan_abs{ind}=plan{i};
    end
end
end