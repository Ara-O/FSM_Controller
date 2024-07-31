numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { 17.5974,  1.7786;
    0.80316,  -10.1994;
    -0.42189,  4.7143};

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  -3,  0,  'D',  'M';
    'tsk2',  -16,  -9,  'D',  'M';
    'tsk3',  11,  -18,  'D',  'M';
    'tsk4',  16,  9,  'D',  'M';
    'tsk5',  0,  3,  'D',  'M';
    'tsk6',  -10,  -2,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -4,  -1,  -2,  1;
    'regtsk2',  -17,  -10,  -15,  -8;
    'regtsk3',  10,  -19,  12,  -17;
    'regtsk4',  15,  8,  17,  10;
    'regtsk5',  -1,  2,  1,  4;
    'regtsk6',  -11,  -3,  -9,  -1 };

