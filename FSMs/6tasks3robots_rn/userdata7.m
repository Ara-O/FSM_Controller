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
tasks = { 'tsk1',  4,  7,  'D',  'M';
    'tsk2',  -25,  28,  'D',  'M';
    'tsk3',  -3,  -21,  'D',  'M';
    'tsk4',  28,  18,  'D',  'M';
    'tsk5',  27,  -15,  'D',  'M';
    'tsk6',  12,  11,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  3,  6,  5,  8;
    'regtsk2',  -26,  27,  -24,  29;
    'regtsk3',  -4,  -22,  -2,  -20;
    'regtsk4',  27,  17,  29,  19;
    'regtsk5',  26,  -16,  28,  -14;
    'regtsk6',  11,  10,  13,  12 };



