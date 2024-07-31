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
tasks = { 'tsk1',  30,  -30,  'D',  'M';
    'tsk2',  6,  10,  'D',  'M';
    'tsk3',  11,  26,  'D',  'M';
    'tsk4',  -31,  22,  'D',  'M';
    'tsk5',  2,  14,  'D',  'M';
    'tsk6',  -20,  3,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  29,  -31,  31,  -29;
    'regtsk2',  5,  9,  7,  11;
    'regtsk3',  10,  25,  12,  27;
    'regtsk4',  -32,  21,  -30,  23;
    'regtsk5',  1,  13,  3,  15;
    'regtsk6',  -21,  2,  -19,  4 };



