numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { 11.9595,  15.4201;
    -14.1745,  15.7083;
    5.0297,  -15.2935 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  -8,  2,  'D',  'M';
    'tsk2',  17,  18,  'D',  'M';
    'tsk3',  -13,  18,  'D',  'M';
    'tsk4',  17,  -1,  'D',  'M';
    'tsk5',  11,  -14,  'D',  'M';
    'tsk6',  -3,  16,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -9,  1,  -7,  3;
    'regtsk2',  16,  17,  18,  19;
    'regtsk3',  -14,  17,  -12,  19;
    'regtsk4',  16,  -2,  18,  0;
    'regtsk5',  10,  -15,  12,  -13;
    'regtsk6',  -4,  15,  -2,  17 };

