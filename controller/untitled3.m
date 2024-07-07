
tCost=zeros(numRobots,1);

for i=1:numRobots
    
    bot_location=start_loc(i,:);
    for j=1:length(bestSolution{i})
        next_task=bestSolution{i}(j)
        [transition_cost,new_X,new_Y] = calcCostTaskSimple(next_task,tasks,bot_location);
        bot_location(1,1)=new_X;
        bot_location(2,1)=new_Y;
        tCost(i)=tCost(i)+transition_cost;
        tall{i}(j)=transition_cost;
    end
    over(i)=sum(tall{i});
end