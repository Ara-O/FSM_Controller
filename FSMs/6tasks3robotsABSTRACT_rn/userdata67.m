numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { '1.4435',  '-6.1102';
    '2.1242',  '1.3972';
    '-4.1568',  '7.4583' };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  14,  -13,  'D',  'M';
    'tsk2',  -9,  -16,  'D',  'M';
    'tsk3',  18,  -10,  'D',  'M';
    'tsk4',  6,  -16,  'D',  'M';
    'tsk5',  -11,  0,  'D',  'M';
    'tsk6',  -15,  -4,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  13,  -14,  15,  -12;
    'regtsk2',  -10,  -17,  -8,  -15;
    'regtsk3',  17,  -11,  19,  -9;
    'regtsk4',  5,  -17,  7,  -15;
    'regtsk5',  -12,  -1,  -10,  1;
    'regtsk6',  -16,  -5,  -14,  -3 };

