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
tasks = { 'tsk1',  -15,  3,  'D',  'M';
    'tsk2',  14,  0,  'D',  'M';
    'tsk3',  3,  -4,  'D',  'M';
    'tsk4',  -26,  -1,  'D',  'M';
    'tsk5',  25,  26,  'D',  'M';
    'tsk6',  -16,  -20,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -16,  2,  -14,  4;
    'regtsk2',  13,  -1,  15,  1;
    'regtsk3',  2,  -5,  4,  -3;
    'regtsk4',  -27,  -2,  -25,  0;
    'regtsk5',  24,  25,  26,  27;
    'regtsk6',  -17,  -21,  -15,  -19 };


