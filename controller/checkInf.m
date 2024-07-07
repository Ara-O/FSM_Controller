function fixedPlan = checkInf(plan,numPairs)

fixedPlan=zeros(1,numPairs);
auxTasks=zeros(1,numPairs);
missing=[];
for i=1:numPairs
    auxTasks(i)=i+i-1;
end

tasks=unique(plan);

if length(tasks)==numPairs
    fixedPlan=plan;
else
    tasks=sort(tasks);
    indt=0;
    j=1;
    i=1;
    while i<=length(tasks)
        if tasks(i)~=auxTasks(j)
            indt=indt+1;
            missing(indt)=auxTasks(j);
        else
            i=i+1;
        end
        j=j+1;
    end
    if indt<(numPairs-length(tasks))
        for k=length(tasks)+1:numPairs
            missing(end+1)=auxTasks(k);
        end
    end
    rep=hist(plan,tasks);
    rep_tasks=tasks(rep>1);
    rep_track=zeros(length(rep_tasks),1);
    j=1;
    for i=1:length(plan)
        event=plan(i);
        aux_ev=0;
        for k=1:length(rep_tasks)
            if event==rep_tasks(k)
                aux_ev=1;
                if rep_track(k)
                    if j > length(missing)
                        ju=000
                    end
                    fixedPlan(i)=missing(j);
                    j=j+1;
                else
                    fixedPlan(i)=event;
                    rep_track(k)=1;
                end
                break;
            end
        end
        if aux_ev==0
            fixedPlan(i)=event;
        end
    end
end
end
