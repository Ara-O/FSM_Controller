numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { '1.0042',  '-13.8537';
    '-5.4832',  '-18.0037';
    '-12.905',  '9.3342' };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  11,  -2,  'D',  'M';
    'tsk2',  11,  19,  'D',  'M';
    'tsk3',  -8,  -14,  'D',  'M';
    'tsk4',  15,  2,  'D',  'M';
    'tsk5',  18,  5,  'D',  'M';
    'tsk6',  19,  2,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  10,  -3,  12,  -1;
    'regtsk2',  10,  18,  12,  20;
    'regtsk3',  -9,  -15,  -7,  -13;
    'regtsk4',  14,  1,  16,  3;
    'regtsk5',  17,  4,  19,  6;
    'regtsk6',  18,  1,  20,  3 };

