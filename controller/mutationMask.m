function path_mut = mutationMask(path_abs,num_robots)

step=1/num_robots;
coin=rand;
for k=1:num_robots
    if coin > (k-1)*step && coin < k*step
        rob=k;
        break;
    end
end

index=randi([1 length(path_abs)]);

for i=1:length(path_abs)
    if strcmpi(path_abs{i},path_abs{index})
        path_mut{i}=strcat(char(96+k),path_abs{index}(end));
    else
        path_mut{i}=path_abs{i};
    end
end

end