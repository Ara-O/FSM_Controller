function edge_list = calcEdgeList(states)
% Author: Jonathon Kreska
% Version: 1.0
% Date: May 3, 2016
% Changelog:
%  1.0: Initial Release
% Current Capability:
%  Generates: 1) a px2 Edge List matrix for Djikstra's function and 2) an nxn
%  matrix similar to an Adjacency matrix but the transitions have the robot
%  number associated with that transition. To save RAM, an Edge Matrix was
%  output as opposed to an Adjacency Matrix.
% Input:
%  states = A cell matrix from userdata of all the states and transitions
% Output:
%  edge_list = px2 Edge List matrix where the first column is the original state and the
%      second column is the state that is being transitioned to; 
%      where p is the number of transitions

n = str2double(states{end,1});  %Get Number of states
if n < 25000 % about 4GB
  A = zeros(n);                   %Initialize Adjacency Matrix
else
  A = sparse(n,n);                   %Initialize Adjacency Matrix
end

for y=1:size(states)
  if ~isempty(states{y,2}) % if not the final state,
    
    cur_state = str2double(states{y,1});      % get current state number
    adjStates = str2double(states{y,2}(:,2)); % get adjacent state numbers
    
    A(cur_state,adjStates)=1; % assign adjacency

  end
end

% Convert adjacency matrix to edge list
A = A - diag(diag(A));
[I,J] = find(A);
edge_list = [I J];
