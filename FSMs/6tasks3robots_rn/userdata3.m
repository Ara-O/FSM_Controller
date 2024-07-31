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
tasks = { 'tsk1',  -18,  12,  'D',  'M';
    'tsk2',  -15,  12,  'D',  'M';
    'tsk3',  14,  -30,  'D',  'M';
    'tsk4',  -17,  -19,  'D',  'M';
    'tsk5',  12,  24,  'D',  'M';
    'tsk6',  -11,  20,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -19,  11,  -17,  13;
    'regtsk2',  -16,  11,  -14,  13;
    'regtsk3',  13,  -31,  15,  -29;
    'regtsk4',  -18,  -20,  -16,  -18;
    'regtsk5',  11,  23,  13,  25;
    'regtsk6',  -12,  19,  -10,  21 };



