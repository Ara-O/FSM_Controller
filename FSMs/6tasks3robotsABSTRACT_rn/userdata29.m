% 0) ********** Number Variables **********

numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');


initial_state = '1';
final_state = '100';

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
% *** be sure to include a task/event for starting location ***
tasks = { 'tsk1',  -12,  13,  'D',  'M';
    'tsk2',  10,  17,  'D',  'M';
    'tsk3',  -15,  -12,  'D',  'M';
    'tsk4',  -15,  0,  'D',  'M';
    'tsk5',  -12,  15,  'D',  'M';
    'tsk6',  -15,  -17,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -13,  12,  -11,  14;
    'regtsk2',  9,  16,  11,  18;
    'regtsk3',  -16,  -13,  -14,  -11;
    'regtsk4',  -16,  -1,  -14,  1;
    'regtsk5',  -13,  14,  -11,  16;
    'regtsk6',  -16,  -18,  -14,  -16 };



