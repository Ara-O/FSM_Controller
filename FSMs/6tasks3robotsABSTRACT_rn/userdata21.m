% 0) ********** Number Variables **********

numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');


initial_state = '1';
final_state = '100';

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
% *** be sure to include a task/event for starting location ***
tasks = { 'tsk1',  14,  3,  'D',  'M';
    'tsk2',  2,  -13,  'D',  'M';
    'tsk3',  13,  5,  'D',  'M';
    'tsk4',  -6,  1,  'D',  'M';
    'tsk5',  -4,  -16,  'D',  'M';
    'tsk6',  -10,  -14,  'D',  'M' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  13,  2,  15,  4;
    'regtsk2',  1,  -14,  3,  -12;
    'regtsk3',  12,  4,  14,  6;
    'regtsk4',  -7,  0,  -5,  2;
    'regtsk5',  -5,  -17,  -3,  -15;
    'regtsk6',  -11,  -15,  -9,  -13 };



