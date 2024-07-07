function EEC = calcEEC(tasks,numRobots,start_loc,numRegions,numTasks)
% Author: Jonathon Kreska
% Version: 1.1
% Date: May 2, 2016
% Changelog:
%  1.0: Initial Release
%  1.1: Updated to not use pdaist so you don't need the Statistics Toolbox

dists = []; goals = [];

for l=1:size(tasks) % Extract goals from tasks
  if strncmp(tasks(l,1),'ts',2)
    goals = [goals; cell2mat(tasks(l,2:3))];
  end
end

% Determine distance between each robot and the furthest goal and the furthest
% distance between goals to find the longest a robot could travel
for l=1:numRobots
  X = [goals;start_loc(l,:)]; % concatenate current robot

  [n,p] = size(X);

  outClass = class(X);
  Y = zeros(1,n*(n-1)./2, outClass);
  k = 1;
  for i = 1:n-1

    dsq = zeros(n-i,1,outClass);
    for q = 1:p
      dsq = dsq + (X(i,q) - X((i+1):n,q)).^2;
    end
    Y(k:(k+n-i-1)) = sqrt(dsq);

    k = k + (n-i);
  end
  dists = [dists max(Y)]; % only store the max of the distances
  
end
maxDist = max(dists); % Then take the max of all the robots

EEC = maxDist/(sqrt(numRegions-numTasks)+1); % Calculate Fixed Entry Event Cost