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
tasks = { 'tsk1',  12,  15,  'D',  'M';
    'tsk2',  -14,  16,  'D',  'M';
    'tsk3',  5,  -15,  'D',  'M';
    'tsk4',  -8,  2,  'D',  'M';
    'tsk5',  17,  18,  'D',  'M';
    'tsk6',  -13,  18,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  11,  14,  13,  16;
    'regtsk2',  -15,  15,  -13,  17;
    'regtsk3',  4,  -16,  6,  -14;
    'regtsk4',  -9,  1,  -7,  3;
    'regtsk5',  16,  17,  18,  19;
    'regtsk6',  -14,  17,  -12,  19 };



