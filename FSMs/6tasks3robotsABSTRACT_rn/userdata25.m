% 0) ********** Number Variables **********

numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');


initial_state = '1';
final_state = '100';

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
% *** be sure to include a task/event for starting location ***
tasks = { 'tsk1',  3,  13,  'D',  'M';
    'tsk2',  9,  3,  'D',  'M';
    'tsk3',  -10,  6,  'D',  'M';
    'tsk4',  -16,  5,  'D',  'M';
    'tsk5',  6,  9,  'D',  'M';
    'tsk6',  15,  18,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  2,  12,  4,  14;
    'regtsk2',  8,  2,  10,  4;
    'regtsk3',  -11,  5,  -9,  7;
    'regtsk4',  -17,  4,  -15,  6;
    'regtsk5',  5,  8,  7,  10;
    'regtsk6',  14,  17,  16,  19 };



