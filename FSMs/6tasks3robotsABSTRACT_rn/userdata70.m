numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { '-.29089',  '7.4002';
    '17.9639',  '-6.5453';
    '12.8365',  '9.0847' };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  -15,  0,  'D',  'M';
    'tsk2',  -12,  15,  'D',  'M';
    'tsk3',  -15,  -17,  'D',  'M';
    'tsk4',  2,  10,  'D',  'M';
    'tsk5',  -7,  -12,  'D',  'M';
    'tsk6',  -6,  -11,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -16,  -1,  -14,  1;
    'regtsk2',  -13,  14,  -11,  16;
    'regtsk3',  -16,  -18,  -14,  -16;
    'regtsk4',  1,  9,  3,  11;
    'regtsk5',  -8,  -13,  -6,  -11;
    'regtsk6',  -7,  -12,  -5,  -10 };

