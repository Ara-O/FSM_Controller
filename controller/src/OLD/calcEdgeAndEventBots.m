function [E,event_bots] = calcEdgeAndEventBots(states)
% Author: Jonathon Kreska
% Version: 1.1
% Date: February 29, 2016
% Changelog:
%  1.0: Initial Release
%  1.1: Uses sparse matrix to save RAM
% Current Capability:
%  Generates: 1) a px2 Edge List matrix for Djikstra's function and 2) an nxn
%  matrix similar to an Adjacency matrix but the transitions have the robot
%  number associated with that transition. To save RAM, an Edge Matrix was
%  output as opposed to an Adjacency Matrix.
% Input:
%  states = A cell matrix from userdata of all the states and transitions
% Output:
%  E = px2 Edge List matrix where the first column is the original state and the
%      second column is the state that is being transitioned to; 
%      where p is the number of transitions
%  event_bots = nxn Matrix for Djikstra's function that says what robot is
%               associated with an event where n is the number of states

n = str2double(states{end,1});  %Get Number of states
if n < 25000
  A = zeros(n);                   %Initialize Adjacency Matrix
  event_bots = zeros(n);          %Initialize Event Bot Matrix
else
  A = sparse(n,n);                   %Initialize Adjacency Matrix
  event_bots = sparse(n,n);          %Initialize Event Bot Matrix
end

for y=1:size(states)
  if ~isempty(states{y,2}) % if not the final state,
    
    cur_state = str2double(states{y,1});      % get current state number
    adjStates = str2double(states{y,2}(:,2)); % get adjacent state numbers
    
    A(cur_state,adjStates)=1; % assign adjacency

    % Determine Robot for each event
    for l = 1:numel(adjStates)
      event_bots(cur_state,adjStates(l)) = states{y,2}{l,1}(1) - 96;
    end

  end
end

% Convert adjacency matrix to edge list
A = A - diag(diag(A));
[I,J] = find(A);
E = [I J];
