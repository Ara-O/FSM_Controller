% 0) ********** Number Variables **********

numRobots = str2double('2');
numTasks = str2double('4');
numRegions = str2double('8');
numEvents = str2double('24');


initial_state = '1';
final_state = '476';

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
% *** be sure to include a task/event for starting location ***
tasks = { 'tsk1',  -25,  -31,  'D',  'start';
    'tsk2',  2,  22,  'D',  'tsk1';
    'tsk3',  -11,  10,  'D',  'start';
    'tsk4',  -20,  13,  'D',  'tsk3' };



% regions = {'name', x1, y1, x2, y2}
regions = { 'reg5',  -35,  -35,  0,  0;
    'reg6',  -35,  0,  0,  35;
    'reg7',  0,  0,  35,  35;
    'reg8',  0,  -35,  35,  0;
    'regtsk1',  -26,  -32,  -24,  -30;
    'regtsk2',  1,  21,  3,  23;
    'regtsk3',  -12,  9,  -10,  11;
    'regtsk4',  -21,  12,  -19,  14 };


