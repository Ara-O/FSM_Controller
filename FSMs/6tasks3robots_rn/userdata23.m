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
tasks = { 'tsk1',  -13,  14,  'D',  'M';
    'tsk2',  6,  -5,  'D',  'M';
    'tsk3',  -12,  -3,  'D',  'M';
    'tsk4',  -1,  -14,  'D',  'M';
    'tsk5',  3,  -10,  'D',  'M';
    'tsk6',  -4,  3,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -14,  13,  -12,  15;
    'regtsk2',  5,  -6,  7,  -4;
    'regtsk3',  -13,  -4,  -11,  -2;
    'regtsk4',  -2,  -15,  0,  -13;
    'regtsk5',  2,  -11,  4,  -9;
    'regtsk6',  -5,  2,  -3,  4 };


