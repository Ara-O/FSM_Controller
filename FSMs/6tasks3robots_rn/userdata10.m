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
tasks = { 'tsk1',  -20,  -12,  'D',  'M';
    'tsk2',  -28,  17,  'D',  'M';
    'tsk3',  17,  3,  'D',  'M';
    'tsk4',  -11,  23,  'D',  'M';
    'tsk5',  4,  32,  'D',  'M';
    'tsk6',  27,  -10,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -21,  -13,  -19,  -11;
    'regtsk2',  -29,  16,  -27,  18;
    'regtsk3',  16,  2,  18,  4;
    'regtsk4',  -12,  22,  -10,  24;
    'regtsk5',  3,  31,  5,  33;
    'regtsk6',  26,  -11,  28,  -9 };



