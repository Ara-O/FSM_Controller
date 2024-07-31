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
tasks = { 'tsk1',  -20,  -26,  'D',  'M';
    'tsk2',  -13,  16,  'D',  'M';
    'tsk3',  20,  14,  'D',  'M';
    'tsk4',  -34,  24,  'D',  'M';
    'tsk5',  30,  19,  'D',  'M';
    'tsk6',  -32,  -9,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -21,  -27,  -19,  -25;
    'regtsk2',  -14,  15,  -12,  17;
    'regtsk3',  19,  13,  21,  15;
    'regtsk4',  -35,  23,  -33,  25;
    'regtsk5',  29,  18,  31,  20;
    'regtsk6',  -33,  -10,  -31,  -8 };



