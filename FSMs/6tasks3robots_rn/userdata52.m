numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { 17.3723,  -0.55573;
    11.4107,  -13.6083;
    -2.9731,  15.7979 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  12,  15,  'D',  'M';
    'tsk2',  -14,  16,  'D',  'M';
    'tsk3',  5,  -15,  'D',  'M';
    'tsk4',  -8,  2,  'D',  'M';
    'tsk5',  17,  18,  'D',  'M';
    'tsk6',  -13,  18,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  11,  14,  13,  16;
    'regtsk2',  -15,  15,  -13,  17;
    'regtsk3',  4,  -16,  6,  -14;
    'regtsk4',  -9,  1,  -7,  3;
    'regtsk5',  16,  17,  18,  19;
    'regtsk6',  -14,  17,  -12,  19 };

