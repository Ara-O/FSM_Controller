function edge_list = calcSmallEdgeList(states,end_state)
% Author: Jonathon Kreska
% Version: 1.1
% Date: May 4, 2016
% Changelog:
%  1.0: Initial Release
%  1.1: Added Unique to remove duplicate rows
% Current Capability:
%  Generates: 1) a px2 Edge List matrix for Djikstra's function and 2) an nxn
%  matrix similar to an Adjacency matrix but the transitions have the robot
%  number associated with that transition. To save RAM, an Edge Matrix was
%  output as opposed to an Adjacency Matrix.
%  This function doesn't create a massive nxn array to save more RAM.
%  Also, I found it twice as fast.
% Input:
%  states = A cell matrix from userdata of all the states and transitions
%  end_state = the final state in double
% Output:
%  edge_list = px2 Edge List matrix where the first column is the original state and the
%      second column is the state that is being transitioned to; 
%      where p is the number of transitions


[n, ~] = size(states);
p = 0; % Counter for the number of transitions

for i = 1:n
    [k, ~] = size(states{i, 2});

    if i ~= end_state && k ~= 0
        p = p + numel(states{i, 2}(:, 2));
    end
end

edge_list = zeros(p, 2); % Preallocating the edge_list variable

index = 1; % Index variable to keep track of the current row

% Currently there is a problem with some FSMs having multiple finish states, 
% some of which have no transition states out of them, checking size fixes
% this but this might be an underlying issue with the fsm
for i = 1:n
    [k, ~] = size(states{i, 2});

    if i ~= end_state && k ~= 0
        next_states = states{i, 2}(:, 2);

        for j = 1:numel(next_states)
            edge_list(index, :) = [i, str2double(next_states{j})];
            index = index + 1;
        end
    end
end

edge_list = unique(edge_list, 'rows');


% ORIGINAL 

% [n,~] = size(states);
% edge_list = [];
% for i = 1:n
%  
%   % Currently there is a problem with some FSMs having multiple finish states,
%   % some of which have no transition states out of them, checking size fixes
%   % this but this might be an underlying issue with the fsm
%   [k,~] = size(states{i,2});
%  
%   if i ~= end_state && k ~= 0
%     next_states = states{i,2}(:,2);
% 
%     for j= 1:numel(next_states)
%       edge_list = [edge_list; i str2double(next_states{j})];
%     end
%   end
% 
% end
% 
% edge_list = unique(edge_list,'rows');