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
tasks = { 'tsk1',  18,  2,  'D',  'M';
    'tsk2',  1,  -10,  'D',  'M';
    'tsk3',  0,  5,  'D',  'M';
    'tsk4',  7,  -4,  'D',  'M';
    'tsk5',  -5,  19,  'D',  'M';
    'tsk6',  -18,  15,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  17,  1,  19,  3;
    'regtsk2',  0,  -11,  2,  -9;
    'regtsk3',  -1,  4,  1,  6;
    'regtsk4',  6,  -5,  8,  -3;
    'regtsk5',  -6,  18,  -4,  20;
    'regtsk6',  -19,  14,  -17,  16 };


