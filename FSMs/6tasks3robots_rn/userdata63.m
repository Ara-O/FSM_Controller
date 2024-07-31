numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { -18.2446,  -18.004;
    -17.9244,  -9.644;
    13.6811,  1.4756 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  7,  19,  'D',  'M';
    'tsk2',  -12,  -14,  'D',  'M';
    'tsk3',  16,  7,  'D',  'M';
    'tsk4',  -16,  10,  'D',  'M';
    'tsk5',  10,  16,  'D',  'M';
    'tsk6',  8,  -14,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  6,  18,  8,  20;
    'regtsk2',  -13,  -15,  -11,  -13;
    'regtsk3',  15,  6,  17,  8;
    'regtsk4',  -17,  9,  -15,  11;
    'regtsk5',  9,  15,  11,  17;
    'regtsk6',  7,  -15,  9,  -13 };

