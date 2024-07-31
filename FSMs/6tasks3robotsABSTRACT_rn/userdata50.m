numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { -15.7914,  -3.8083;
    -9.1249,  11.4026;
    -2.6063,  15.6046 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  -13,  12,  'D',  'M';
    'tsk2',  1,  19,  'D',  'M';
    'tsk3',  -16,  -2,  'D',  'M';
    'tsk4',  -15,  18,  'D',  'M';
    'tsk5',  -19,  10,  'D',  'M';
    'tsk6',  12,  14,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -14,  11,  -12,  13;
    'regtsk2',  0,  18,  2,  20;
    'regtsk3',  -17,  -3,  -15,  -1;
    'regtsk4',  -16,  17,  -14,  19;
    'regtsk5',  -20,  9,  -18,  11;
    'regtsk6',  11,  13,  13,  15 };

