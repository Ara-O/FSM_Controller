% 0) ********** Number Variables **********

numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('36');

% 1) ********** User Input **********

% botNames = {'Cer', 'Cer1'};
% botIP = {'6665', '6666');
% botIndex = [0, 2];
% bots = {'name', 'IP', Index}
% bots = {'Cer', '6665', 0;
%        'Cer1', '6666', 2};

initial_state = '1';
final_state = '983';

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
% *** be sure to include a task/event for starting location ***
tasks = { 'tsk1',  32,  18,  'D',  'M';
    'tsk2',  -34,  13,  'D',  'M';
    'tsk3',  14,  10,  'D',  'M';
    'tsk4',  4,  -20,  'D',  'M';
    'tsk5',  19,  -19,  'D',  'M';
    'tsk6',  -9,  27,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  31,  17,  33,  19;
    'regtsk2',  -35,  12,  -33,  14;
    'regtsk3',  13,  9,  15,  11;
    'regtsk4',  3,  -21,  5,  -19;
    'regtsk5',  18,  -20,  20,  -18;
    'regtsk6',  -10,  26,  -8,  28 };


