function [states, eventNames] = func_Read_FSM(fn)
% This function uses the filename in the GUI textbox to open and read in
% the values in the fsm. It separates and stores each chunk of text in the
% fsm into the states variable. The event names are also exttacted and put
% into eventNames, but before being passed back, duplicates are removed. 
%%

% open file, fid is a file identifier
% fid < 0 --> invalid
% fid = 0 --> Standard input
% fid = 1 --> Standard output
% fid = 2 --> Error output
% fid >= 3 --> Used for files opened by user (this case)
% fid will signify if it was successfully opened
fid = fopen(fn);

% read data from the file
% if you make is %s, it will return everything in the file in a one column
% cell with 1,1 being the first chunk of text, 2,1 being the second, 3,1
% being the third. looks like the whole file
%
% if it's %u, it only gets the num of states, a 1x1 cell array
% [num_blocks, pos] = textscan(fid,'%u');

% function y = litcount(filename, literal)
% % Search for number of string matches per line.
%
% fid = fopen(filename);
% y = 0;

% this gets the whole first line (num of states) as a string
tline = fgetl(fid);

%these are counters for the loops
x=1;
j=1;

% create a cell array that is whatever the number in the 1,1 cell of
% num_blocks is (num of states) by 3... numOfStates x 3
states = cell(str2double(tline),3);  % Access first element which has num states
% initialize so you can stack onto it
eventList = {};

% this gets the second line (first line after num of states) as a string
% It is ''
tline = fgetl(fid);

%as long as there is letters in tline
while ~feof(fid)
    % if tline isn't empty
    if ~isempty(tline)
        % if it's not just a space
        if ~strcmp(tline,' ')
            %states(j) = regexp(tline, '(\w*),(\w*)\s\d\s*(\d)','tokens');
            
            % breaks up whats in tline so that it is a 1x3 with each column
            % holding what is in each column of the fsm line (removes the
            % tabs)
            c = textscan(tline, '%s %s %s');
            
            % assign it what's in the first column (state name)
            states{j,1} = c{1,1}{1,1}; % state name
            
            % check if its the end state... read what is in the second
            % column. needs to be number format not cells
            states{j,3} = str2double(c{1,2}); % is endState?
            
            % make a cell array for events that is the size of the 3rd
            % column of c (last column of state in fsm) by 4. the 4 is for
            % the 4 columns in the fsm that are under the state name, the
            % 3rd column holds how many lines there are
            events=cell(str2double(c{1,3}),4);  % needs to be numbers
            
            % loop through for each row under state name in fsm
            for i = 1:str2double(c{1,3})
                % make sure you're not at the end of the file
                if ~feof(fid)
                    % gets the next line as a string
                    tline = fgetl(fid);
                    % separate data by tab (4 things in the line, %s puts
                    % each one in its own cell) d=1x4 cell array with each
                    % element being a cell
                    d = textscan(tline, '%s %s %s %s');
                    
                    % sets the 4 columns of events in whatever row you're
                    % in. 
                    events{x,1} = d{1,1}{1,1}; % event name...ie a1s
                    events{x,2} = d{1,2}{1,1}; % next state number
                    events{x,3} = d{1,3}{1,1}; % is controllable? (letter)
                    events{x,4} = d{1,4}{1,1}; % is observable? (letter)
                    
                    % list of the event names. ie a1s
                    eventList = [eventList events{x,1}];
                    
                    %fprintf('%s:\t%s,%s -> %s,%s\n',char(events{x,1}),char(states{j,1}),char(states{j,2}),char(events{x,2}),char(events{x,3}));
                    
                    % increment for next loop
                     x=x+1;
                end % end if end of file
            end % end looping through the events
            x = 1; % reset x for next state's loop
            
            % fill the jth row, 2nd column of the states variable
            states{j,2} = events;
            
            % increment j for next states loop
            j=j+1;
        end % end if not just a space
    end % end if tline is empty
    
    % get next line
    tline = fgetl(fid);
end % end while tline is a-
char

% close file
fclose(fid);

% trim so the event names only appear once
eventNames = unique(eventList);

%clear ans c d fid i j num_blocks pos tline x eventList events