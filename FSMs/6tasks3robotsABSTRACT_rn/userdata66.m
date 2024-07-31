numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { '13.6667',  '6.5207';
    '5.072',  '-14.2595';
    '-1.1177',  '18.4898' };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  -3,  0,  'D',  'M';
    'tsk2',  -13,  -6,  'D',  'M';
    'tsk3',  -9,  13,  'D',  'M';
    'tsk4',  11,  -3,  'D',  'M';
    'tsk5',  4,  -13,  'D',  'M';
    'tsk6',  0,  -8,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -4,  -1,  -2,  1;
    'regtsk2',  -14,  -7,  -12,  -5;
    'regtsk3',  -10,  12,  -8,  14;
    'regtsk4',  10,  -4,  12,  -2;
    'regtsk5',  3,  -14,  5,  -12;
    'regtsk6',  -1,  -9,  1,  -7 };

