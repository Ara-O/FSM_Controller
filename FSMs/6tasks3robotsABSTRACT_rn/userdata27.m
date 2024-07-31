% 0) ********** Number Variables **********

numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');


initial_state = '1';
final_state = '100';

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
% *** be sure to include a task/event for starting location ***
tasks = { 'tsk1',  -15,  -19,  'D',  'M';
    'tsk2',  -3,  6,  'D',  'M';
    'tsk3',  8,  1,  'D',  'M';
    'tsk4',  -15,  5,  'D',  'M';
    'tsk5',  -14,  -14,  'D',  'M';
    'tsk6',  -15,  -14,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -16,  -20,  -14,  -18;
    'regtsk2',  -4,  5,  -2,  7;
    'regtsk3',  7,  0,  9,  2;
    'regtsk4',  -16,  4,  -14,  6;
    'regtsk5',  -15,  -15,  -13,  -13;
    'regtsk6',  -16,  -15,  -14,  -13 };


