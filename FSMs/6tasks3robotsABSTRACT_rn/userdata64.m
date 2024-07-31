numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { '-16.9514',  '-3.0326';
    '6.8046',  '15.9069';
    '-18.9847',  '18.1168' };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  0,  4,  'D',  'M';
    'tsk2',  -18,  4,  'D',  'M';
    'tsk3',  -3,  12,  'D',  'M';
    'tsk4',  -7,  15,  'D',  'M';
    'tsk5',  3,  -12,  'D',  'M';
    'tsk6',  11,  4,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -1,  3,  1,  5;
    'regtsk2',  -19,  3,  -17,  5;
    'regtsk3',  -4,  11,  -2,  13;
    'regtsk4',  -8,  14,  -6,  16;
    'regtsk5',  2,  -13,  4,  -11;
    'regtsk6',  10,  3,  12,  5 };

