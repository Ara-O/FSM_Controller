% 0) ********** Number Variables **********

numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');


initial_state = '1';
final_state = '100';

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
% *** be sure to include a task/event for starting location ***
tasks = { 'tsk1',  2,  7,  'D',  'M';
    'tsk2',  15,  -17,  'D',  'M';
    'tsk3',  -7,  -17,  'D',  'M';
    'tsk4',  -12,  8,  'D',  'M';
    'tsk5',  8,  14,  'D',  'M';
    'tsk6',  3,  -16,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  1,  6,  3,  8;
    'regtsk2',  14,  -18,  16,  -16;
    'regtsk3',  -8,  -18,  -6,  -16;
    'regtsk4',  -13,  7,  -11,  9;
    'regtsk5',  7,  13,  9,  15;
    'regtsk6',  2,  -17,  4,  -15 };


