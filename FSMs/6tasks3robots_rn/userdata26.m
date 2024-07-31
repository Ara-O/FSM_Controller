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
tasks = { 'tsk1',  15,  -16,  'D',  'M';
    'tsk2',  -10,  -17,  'D',  'M';
    'tsk3',  -2,  -18,  'D',  'M';
    'tsk4',  15,  -12,  'D',  'M';
    'tsk5',  -15,  -7,  'D',  'M';
    'tsk6',  -2,  -15,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  14,  -17,  16,  -15;
    'regtsk2',  -11,  -18,  -9,  -16;
    'regtsk3',  -3,  -19,  -1,  -17;
    'regtsk4',  14,  -13,  16,  -11;
    'regtsk5',  -16,  -8,  -14,  -6;
    'regtsk6',  -3,  -16,  -1,  -14 };



