numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { -4.8521,  16.6111;
    12.5222,  13.2652;
    -4.8437,  3.541 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  11,  15,  'D',  'M';
    'tsk2',  4,  15,  'D',  'M';
    'tsk3',  17,  2,  'D',  'M';
    'tsk4',  9,  3,  'D',  'M';
    'tsk5',  -18,  -2,  'D',  'M';
    'tsk6',  6,  1,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  10,  14,  12,  16;
    'regtsk2',  3,  14,  5,  16;
    'regtsk3',  16,  1,  18,  3;
    'regtsk4',  8,  2,  10,  4;
    'regtsk5',  -19,  -3,  -17,  -1;
    'regtsk6',  5,  0,  7,  2 };

