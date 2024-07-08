function updateTablesIncremental(fn, handles)
[states, ~, event_names] = handles.memoized_Read_FSM_Incremental(fn);

if ~isempty(fn)
    %maybe multiply the second argument of events by 1
    events = get(handles.tblEvents,'Data');
    
    if isempty(events)
        % if logic to event names, such as 'a' = bot 1, 's' = task, 'e' = region, enter code here
        %set(handles.txtBot, 'String', num2str(length(events_arr)));
        for i=1:length(event_names)
           events{i,1} = event_names{i};
            
            % Determine which bot for that event
            if strcmp(event_names{i}(1),'a')
                events{i,2} = 1; % bot is 1
            elseif strcmp(event_names{i}(1),'b')
                events{i,2} = 2; % bot is 2
            elseif strcmp(event_names{i}(1),'c')
                events{i,2} = 3; % bot is 3
            elseif strcmp(event_names{i}(1),'d')
                events{i,2} = 4; % bot is 4
            elseif strcmp(event_names{i}(1),'e')
                events{i,2} = 5; % bot is 5
            elseif strcmp(event_names{i}(1),'f')
                events{i,2} = 6; % bot is 6
            elseif strcmp(event_names{i}(1),'g')
                events{i,2} = 7; % bot is 7
            elseif strcmp(event_names{i}(1),'h')
                events{i,2} = 8; % bot is 8
            elseif strcmp(event_names{i}(1),'i')
                events{i,2} = 9; % bot is 9
            elseif strcmp(event_names{i}(1),'j')
                events{i,2} = 10; % bot is 10
            elseif strcmp(event_names{i}(1),'k')
                events{i,2} = 11; % bot is 11
            elseif strcmp(event_names{i}(1),'l')
                events{i,2} = 12; % bot is 12
            elseif strcmp(event_names{i}(1),'m')
                events{i,2} = 13; % bot is 13
            elseif strcmp(event_names{i}(1),'n')
                events{i,2} = 14; % bot is 14
            elseif strcmp(event_names{i}(1),'o')
                events{i,2} = 15; % bot is 15
            elseif strcmp(event_names{i}(1),'p')
                events{i,2} = 16; % bot is 16
            elseif strcmp(event_names{i}(1),'q')
                events{i,2} = 17; % bot is 17
            elseif strcmp(event_names{i}(1),'r')
                events{i,2} = 18; % bot is 18
            elseif strcmp(event_names{i}(1),'s')
                events{i,2} = 19; % bot is 19
            elseif strcmp(event_names{i}(1),'t')
                events{i,2} = 20; % bot is 20
            elseif strcmp(event_names{i}(1),'u')
                events{i,2} = 21; % bot is 21
            elseif strcmp(event_names{i}(1),'v')
                events{i,2} = 22; % bot is 22
            elseif strcmp(event_names{i}(1),'w')
                events{i,2} = 23; % bot is 23
            elseif strcmp(event_names{i}(1),'x')
                events{i,2} = 24; % bot is 24
            elseif strcmp(event_names{i}(1),'y')
                events{i,2} = 25; % bot is 25
            elseif strcmp(event_names{i}(1),'z')
                events{i,2} = 26; % bot is 26
            end
            
            % get robot numbers
            robVal = [];
            for m=1:size((events),1)
                robVal = [robVal events{m,2}];
            end
            
            % find max value
            maxRobVal = max(robVal(:));
            % set as amt of robots
            set(handles.txtBot, 'String', num2str(maxRobVal));
            %Determine region or task based on controllable or uncontrollable event
            %             for n=1:size((states),1)
            %                 for m=1:size((states{n,2}),1)
            %                     if strcmp(states{n,2}{m,1},event_names{i})
            %                         if strcmp(states{n,2}{m,3},'c')
            %                             events{i,3} = 'Task'; % controllable event: Task
            %                             break
            %                         else
            %                             events{i,3} = 'Region'; % uncontrollable event: Region
            %                             break
            %                         end
            %                     end
            %                 end
            %             end
            
            % determine region or task based on last letter of event name
            % all e and f will be regions and s will be task
            if strcmp(event_names{i}(end), 's')
                events{i,3} = 'Task'; % controllable event: Task
            else
                events{i,3} = 'Region'; % uncontrollable event: Region
            end 
        end
    
    % Set events table
    set(handles.tblEvents,'Data',events);
    
    % get task_names
    tasks = get(handles.tblTasks,'Data');
    task_names = tasks(:,1);
    
    % get region_names
    regions = get(handles.tblRegions,'Data');
    region_names = regions(:,1);
    
    % combine task_names and region_names into one list
    type_names = [task_names; region_names]';
    
    % update task_region_names in events table
    set(handles.tblEvents,'ColumnFormat',{'char','numeric',{'Task', 'Region'},type_names})
    
    % update initial state with default first entry of FSM
    initialStates = "";
    for j=1:length(states)
        initialStates = initialStates + states{j}{1,1};
        if(j ~= length(states))
            initialStates = initialStates + " || ";
        end
    end
    set(handles.txtInitialState,'String',initialStates)
    
    
    numTasks = str2double(get(handles.txtTotalNumReg, 'String'));
    numRegions = str2double(get(handles.txtTotalNumTasks, 'String'));
    
    taskRegTotal = numTasks + numRegions;
    
    m=1;
    n=1;
%     assignin('base', 'regions', regions);
    regName = {};
    % separate the regtsk options and the reg options
    for p=1:size(regions,1)
        % if the size of the reg name is 4 (reg4 or reg04 vs regtsk4)
        if size(regions{p,1},2) == 4 || size(regions{p,1},2) == 5
            % add to name array in cell format (or it will concatenate)
            regName(m)=regions(p,1);
            % increment
            m=m+1;
        else
            % it's a regtsk, add to this list
            regTskNames(n) = regions(p,1);
            % increment it's index
            n=n+1;
        end
    end
%     
%     assignin('base', 'events', events);
%     assignin('base', 'regTskNames', regTskNames);
%     assignin('base', 'task_names', task_names);

% go through each row in events to update the last column
    for k = 1:size(events,1)
        % get the event name
        eventname = events{k,1};
        % get the last letter
        lastLetter = eventname(end);
        
%         if taskRegTotal < 10
            % if it's the old format 'a1s'
            if length(eventname) == 3
                % the number is one digit located one back from the end
                eventNum = eventname(end-1);
                if taskRegTotal > 9
                    eventNum = ['0' eventNum];
                end
            else % it's the new method or double digits
                % the number is in the 2 and 3 spot
                eventNum = eventname(2:3);
                % make sure you remove the '01' to '1' (make a num then a str
                % again)
%                 eventNum = num2str(str2double(eventNum));
            end
%         else % theyre in the format a01s and you want the middle two and keep the 0
%             eventNum = eventname(2:3);
%         end
            
            
        % find the letter match
        switch lastLetter
            case {'f'} % these are regtsk type name events
                % go through the names of regtsk's options
                for r=1:length(regTskNames)
                    % get the nth name
                    n = regTskNames{r};
                    
                    % if its in format regtsk#
                    if length(n) == 7
                        % just get the last number
                        n2 = n(end);
                    else % it's in format regtsk##
                        n2=n(7:end); % get the 7th to end value
                    end
                    
                    % compare the regtsk's number to the event name's
                    % number
                    if strcmp(n2,eventNum)
                        % they match, set that column to that regtsk name
                        events{k,4} = n;
                        % stop looping
                        break;
                    end
                end
                
            case {'e'} % these are 'reg' type name events
                % go through the reg name options
                for r=1:length(regName)
                    % get the nth name
                    n = regName{r};
                    
                    % if it's in format reg#
                    if length(n) == 4
                        % get the end
                        n2 = n(end);
                    else % it's format reg##
                        % get the 4th to end number
                        n2=n(4:end);
                    end
                    
                    % compare the reg number to the event name number
                    if strcmp(n2,eventNum)
                        % match, set the event column to that
                        events{k,4} = n;
                        break; % stop looping
                    end
                end
                
            case {'s'} % these are tsk type name events
                % already found these names above but are in column vector,
                % transpose to row vector
                task_names = task_names';
                
                % go through the task name options
                for r=1:length(task_names)
                    % get the name
                    n = task_names{r};
                    % if it's format tsk#
                    if length(n) == 4
                        % get the end
                        n2 = n(end);
                    else % it's format tsk##
                        n2=n(4:end); % get the last 2 (or 3 or 4..)
                    end
                    
                    % compare the tsk name number with the event's number
                    if strcmp(n2,eventNum)
                        events{k,4} = n; % match, set event column
                        break; % stop looping
                    end
                end % end for case s
                
        end % end switch
                
    end % end main for 
    
    % update data table
    set(handles.tblEvents, 'Data', events);
    
    finalStates = {};
    
    % update marked state with first marked state in FSM
    for j=1:length(states)
        for n=1:length(states{j})
            if states{j}{n,3}
                finalStates{end + 1} = states{j}{n,1};
                break
            end
        end
    end

    %set(handles.txtFinalState,'String',strjoin(unique(finalStates), " || "))

    % Find the unique values while preserving the order of appearance
    %[~, uniqueIndices, ~] = unique(finalStates, 'stable');
    
    % Create a cell array with the unique values in the original order
    %uniqueFinalStates = finalStates(uniqueIndices);
    
    % Convert the cell array to a string with " || " as the delimiter
    finalStatesStr = strjoin(cellfun(@num2str, finalStates, 'UniformOutput', false), " || ");

    set(handles.txtFinalState,'String', finalStatesStr)
    
    % Get the data from the robot start table (so it can be set)
    robotStart = get(handles.tblRobotStart, 'Data');
       
    % Set Robot Start Location Table
    if isempty(robotStart)
        % get how many robots
        maxRobVal = str2double(get(handles.txtBot, 'String'));
        
        % empty x and y
        for num=1:maxRobVal
            robotStart{num,2} = '';
            robotStart{num,3} = '';
        end
        
        
        %         i=1;
        %         % weed out the regtsk options
        %         for p=1:size(regions,1)
        %             % if the size of the reg name is 4 (reg4 vs regtsk4)
        %             if size(regions{p,1},2) == 4
        %                 % add to temp array in cell format (or it will concatenate)
        %                 regNames(i)=regions(p,1);
        %                 % increment
        %                 i=i+1;
        %             end
        %         end
        
        if ~isempty(regName)
            % Make a dropdown of the 'reg#' options
            set(handles.tblRobotStart,'ColumnFormat',{regName});
        else
            noReg = {'noReg'};
            set(handles.tblRobotStart,'ColumnFormat',{noReg});
        end
        % update robot start table
        set(handles.tblRobotStart,'Data',robotStart);
    end
   end
end
