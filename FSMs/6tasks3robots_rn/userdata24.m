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
tasks = { 'tsk1',  -2,  6,  'D',  'M';
    'tsk2',  10,  -6,  'D',  'M';
    'tsk3',  6,  -3,  'D',  'M';
    'tsk4',  13,  13,  'D',  'M';
    'tsk5',  -9,  4,  'D',  'M';
    'tsk6',  3,  2,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -3,  5,  -1,  7;
    'regtsk2',  9,  -7,  11,  -5;
    'regtsk3',  5,  -4,  7,  -2;
    'regtsk4',  12,  12,  14,  14;
    'regtsk5',  -10,  3,  -8,  5;
    'regtsk6',  2,  1,  4,  3 };


