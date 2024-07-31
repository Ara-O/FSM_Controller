% 0) ********** Number Variables **********

numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');


initial_state = '1';
final_state = '100';

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
% *** be sure to include a task/event for starting location ***
tasks = { 'tsk1',  17,  -2,  'D',  'M';
    'tsk2',  -17,  14,  'D',  'M';
    'tsk3',  5,  -6,  'D',  'M';
    'tsk4',  19,  -10,  'D',  'M';
    'tsk5',  6,  4,  'D',  'M';
    'tsk6',  -4,  -14,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  16,  -3,  18,  -1;
    'regtsk2',  -18,  13,  -16,  15;
    'regtsk3',  4,  -7,  6,  -5;
    'regtsk4',  18,  -11,  20,  -9;
    'regtsk5',  5,  3,  7,  5;
    'regtsk6',  -5,  -15,  -3,  -13 };



