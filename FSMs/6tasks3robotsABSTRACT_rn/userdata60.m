numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { '7.528',  '6.3281';
    '-12.231',  '-14.1355';
    '18.9651',  '-12.4974' };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  -17,  9,  'D',  'M';
    'tsk2',  -9,  -3,  'D',  'M';
    'tsk3',  2,  17,  'D',  'M';
    'tsk4',  -3,  18,  'D',  'M';
    'tsk5',  -8,  8,  'D',  'M';
    'tsk6',  6,  1,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -18,  8,  -16,  10;
    'regtsk2',  -10,  -4,  -8,  -2;
    'regtsk3',  1,  16,  3,  18;
    'regtsk4',  -4,  17,  -2,  19;
    'regtsk5',  -9,  7,  -7,  9;
    'regtsk6',  5,  0,  7,  2 };

