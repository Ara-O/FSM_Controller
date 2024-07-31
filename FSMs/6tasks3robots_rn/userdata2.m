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
tasks = { 'tsk1',  22,  28,  'D',  'M';
    'tsk2',  -26,  29,  'D',  'M';
    'tsk3',  9,  -28,  'D',  'M';
    'tsk4',  -16,  3,  'D',  'M';
    'tsk5',  32,  33,  'D',  'M';
    'tsk6',  -24,  33,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  21,  27,  23,  29;
    'regtsk2',  -27,  28,  -25,  30;
    'regtsk3',  8,  -29,  10,  -27;
    'regtsk4',  -17,  2,  -15,  4;
    'regtsk5',  31,  32,  33,  34;
    'regtsk6',  -25,  32,  -23,  34 };


