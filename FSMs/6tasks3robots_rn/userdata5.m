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
tasks = { 'tsk1',  -5,  11,  'D',  'M';
    'tsk2',  16,  2,  'D',  'M';
    'tsk3',  -27,  9,  'D',  'M';
    'tsk4',  -26,  -26,  'D',  'M';
    'tsk5',  -28,  -25,  'D',  'M';
    'tsk6',  -23,  -21,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -6,  10,  -4,  12;
    'regtsk2',  15,  1,  17,  3;
    'regtsk3',  -28,  8,  -26,  10;
    'regtsk4',  -27,  -27,  -25,  -25;
    'regtsk5',  -29,  -26,  -27,  -24;
    'regtsk6',  -24,  -22,  -22,  -20 };



