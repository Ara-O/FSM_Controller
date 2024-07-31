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
tasks = { 'tsk1',  -5,  17,  'D',  'M';
    'tsk2',  -32,  31,  'D',  'M';
    'tsk3',  18,  4,  'D',  'M';
    'tsk4',  -22,  0,  'D',  'M';
    'tsk5',  1,  35,  'D',  'M';
    'tsk6',  25,  32,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -6,  16,  -4,  18;
    'regtsk2',  -33,  30,  -31,  32;
    'regtsk3',  17,  3,  19,  5;
    'regtsk4',  -23,  -1,  -21,  1;
    'regtsk5',  0,  34,  2,  36;
    'regtsk6',  24,  31,  26,  33 };



