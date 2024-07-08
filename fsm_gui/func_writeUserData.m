function func_writeUserData(fn, bot, tasks, regions, events, states, initial_state, final_state, numTasks, numRegions, numEvents, foldName,start_loc)

% Get output file name
%fn = get(*handles.txtOutputFn*, 'String');
if contains(foldName, ".fsm")
    foldName = foldName(1:end-4); %Strip off .fsm from file name to make a folder
end

%foldName = 'JustTasks';
if ~isempty(fn)
  
%fid = fopen([ '../FSMs/' foldName '/userdata35.m'],'w');    % Open output file
fid = fopen([ '../FSMs/' foldName '/' fn],'w');  % Open output file

if fid == -1
   mkdir(['../FSMs/' foldName])
   fid = fopen(['../FSMs/' foldName '/' fn],'w');
end


    fprintf(fid, 'numRobots = str2double(''%d'');\n',bot);
    fprintf(fid, 'numTasks = str2double(''%d'');\n',numTasks);
    fprintf(fid, 'numRegions = str2double(''%d'');\n',numRegions);
    fprintf(fid, 'numEvents = str2double(''%d'');\n\n',numEvents);
       
    fprintf(fid, '%% start_loc = {x, y}\n');
    str=func_printTable('start_loc', start_loc);
    fprintf(fid, '%s',str);
    
    
%     fprintf(fid, 'start_loc(1,1) = 00000;\n');
%     fprintf(fid, 'start_loc(1,2) = 00000;\n\n');
    
%     fprintf(fid, 'initial_state = ''%s'';\n',initial_state);
%     fprintf(fid, 'final_state = ''%s'';\n\n',final_state);
%     
    fprintf(fid, '%% tasks = {''name'', x1, y1, ''function'', ''from_task_name''}\n');
    str = func_printTable('tasks',tasks);
    fprintf(fid, '%s\n',str);
    
    fprintf(fid, '%% regions = {''name'', x1, y1, x2, y2}\n');
    str = func_printTable('regions',regions);
    fprintf(fid, '%s',str);
    
%     fprintf(fid, '%% events = {''name'', bot, ''type'', ''type_name''}\n');
%     str = func_printTable('events',events);
%     fprintf(fid, '%s\n\n',str);
%     
%     fprintf(fid, '%% states = {''name'', {''event_name'', ''state_name'', ''isControllable: c_uc'', ''cost'';\n');
%     fprintf(fid, '%%                    ''event_name'', ''state_name'', ''isControllable: c_uc'', ''cost''}, ''isDone: 0_1''}\n');
%     str = func_printTable('states',states);
%     fprintf(fid, '%s\n\n',str);
    
    fclose(fid); %close file
end