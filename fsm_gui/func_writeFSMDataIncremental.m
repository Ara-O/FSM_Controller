function func_writeFSMDataIncremental(fn, events, eventsArr, states, initial_state, final_state, foldName, handles)

% Get output file name
%fn = get(*handles.txtOutputFn*, 'String');
%foldName = foldName(1:end-4); %Strip off .fsm from file name to make a folder
%foldName = '8tasks2robots9regions_rn';

if ~isempty(fn)
 %   fid = fopen([ '../FSMs/' foldName '/fsmdataIncremental.m'],'w');    % Open output file
   fid = fopen(['../FSMs/' foldName '/fsmdataIncremental.m'],'w');    % Open output file
   if fid == -1
    mkdir(['../FSMs/' foldName])
    fid = fopen(['../FSMs/' foldName '/fsmdataIncremental.m'],'w');
   end
   
   eventsArrFormatted = cell(1, numel(eventsArr));
   statesIncrList = {};
   eventsIncrList = {};

   tasks = get(handles.tblTasks,'Data');
   task_names = tasks(:,1);

   regions = get(handles.tblRegions,'Data');
   region_names = regions(:,1);
    
    m=1;
    n=1;
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

   %Creating table with parsed data for each event rather than for all
   %events
    for i=1:numel(eventsArr)
        statesIncrList = [statesIncrList strcat('states', num2str(i))];
        eventsIncrList = [eventsIncrList strcat('events', num2str(i))];
         events = cell(numel(eventsArr{i}),4);
         for j=1:numel(eventsArr{i})
           events{j,1} = eventsArr{i}{j};
            
            % Determine which bot for that event
            if strcmp(eventsArr{i}{j}(1),'a')
                events{j,2} = 1; % bot is 1
            elseif strcmp(eventsArr{i}{j}(1),'b')
                events{j,2} = 2; % bot is 2
            elseif strcmp(eventsArr{i}{j}(1),'c')
                events{j,2} = 3; % bot is 3
            elseif strcmp(eventsArr{i}{j}(1),'d')
                events{j,2} = 4; % bot is 4
            elseif strcmp(eventsArr{i}{j}(1),'e')
                events{j,2} = 5; % bot is 5
            elseif strcmp(eventsArr{i}{j}(1),'f')
                events{j,2} = 6; % bot is 6
            elseif strcmp(eventsArr{i}{j}(1),'g')
                events{j,2} = 7; % bot is 7
            elseif strcmp(eventsArr{i}{j}(1),'h')
                events{j,2} = 8; % bot is 8
            elseif strcmp(eventsArr{i}{j}(1),'i')
                events{j,2} = 9; % bot is 9
            elseif strcmp(eventsArr{i}{j}(1),'j')
                events{j,2} = 10; % bot is 10
            elseif strcmp(eventsArr{i}{j}(1),'k')
                events{j,2} = 11; % bot is 11
            elseif strcmp(eventsArr{i}{j}(1),'l')
                events{j,2} = 12; % bot is 12
            elseif strcmp(eventsArr{i}{j}(1),'m')
                events{j,2} = 13; % bot is 13
            elseif strcmp(eventsArr{i}{j}(1),'n')
                events{j,2} = 14; % bot is 14
            elseif strcmp(eventsArr{i}{j}(1),'o')
                events{j,2} = 15; % bot is 15
            elseif strcmp(eventsArr{i}{j}(1),'p')
                events{j,2} = 16; % bot is 16
            elseif strcmp(eventsArr{i}{j}(1),'q')
                events{j,2} = 17; % bot is 17
            elseif strcmp(eventsArr{i}{j}(1),'r')
                events{j,2} = 18; % bot is 18
            elseif strcmp(eventsArr{i}{j}(1),'s')
                events{j,2} = 19; % bot is 19
            elseif strcmp(eventsArr{i}{j}(1),'t')
                events{j,2} = 20; % bot is 20
            elseif strcmp(eventsArr{i}{j}(1),'u')
                events{j,2} = 21; % bot is 21
            elseif strcmp(eventsArr{i}{j}(1),'v')
                events{j,2} = 22; % bot is 22
            elseif strcmp(eventsArr{i}{j}(1),'w')
                events{j,2} = 23; % bot is 23
            elseif strcmp(eventsArr{i}{j}(1),'x')
                events{j,2} = 24; % bot is 24
            elseif strcmp(eventsArr{i}{j}(1),'y')
                events{j,2} = 25; % bot is 25
            elseif strcmp(eventsArr{i}{j}(1),'z')
                events{j,2} = 26; % bot is 26
            end
            
 
            if strcmp(eventsArr{i}{j}(end), 's')
                events{j,3} = 'Task'; % controllable event: Task
            else
                events{j,3} = 'Region'; % uncontrollable event: Region
            end 
         end

        %Populate the last column
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
         eventsArrFormatted{1, i} =  events;
    end

    for i=1:numel(eventsArr)
        fprintf(fid, '%% events = {''name'', bot, ''type'', ''type_name''}\n');
        
%       Check for an empty type name column
        isEmpty = any(cellfun(@isempty, eventsArrFormatted{i}(:,4)), 1);
        
        if isEmpty 
           eventsArrFormatted{i}(cellfun(@isempty, eventsArrFormatted{i})) = {' '};
        end
        
        str = func_printTable(strcat('events',  num2str(i)) ,eventsArrFormatted{i});
        fprintf(fid, '%s\n',str);
    
        allFinalStates = strsplit(final_state, " || ");
        finalState = allFinalStates{i};
        if(i == 1)
            initialStateIncr = strsplit(initial_state, " || ");
            parsedIncr = sprintf('''%s'',', initialStateIncr{:});
    
            % Remove the trailing comma 
            parsedIncr = parsedIncr(1:end-1);
    
            fprintf(fid, 'initial_state_incr = {%s};\n', parsedIncr);
            fprintf(fid, '%% final_state = ''%s'';\n\n', finalState);
        else 
            allInitialStates = strsplit(initial_state, " || ");
            initialState = allInitialStates{i};
            fprintf(fid, '%% initial_state = ''%s'';\n', initialState);
            fprintf(fid, '%% final_state = ''%s'';\n\n', finalState);
        end

        %fprintf(fid, 'final_state = ''%s'';\n\n',cell2mat(final_state));
    
        fprintf(fid, '%% states = {''name'', {''event_name'', ''state_name'', ''isControllable: c_uc'', ''cost'';\n');
        fprintf(fid, '%%                    ''event_name'', ''state_name'', ''isControllable: c_uc'', ''cost''}, ''isDone: 0_1''}\n');
        str = func_printTable(strcat('states', num2str(i)),states{i});
        fprintf(fid, '%s',str);
    end

   
    fprintf(fid,'states_incr = {%s}\n\n', strjoin(statesIncrList, ", "));
    fprintf(fid,'events_incr = {%s}\n\n', strjoin(eventsIncrList, ", "));
end
    fclose(fid); %close file
end
