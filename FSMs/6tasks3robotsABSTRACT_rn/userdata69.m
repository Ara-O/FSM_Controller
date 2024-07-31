numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { '2.5898',  '6.3151';
    '-14.9031',  '-15.7972';
    '4.7546',  '-3.4302' };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  -8,  -12,  'D',  'M';
    'tsk2',  18,  9,  'D',  'M';
    'tsk3',  -9,  3,  'D',  'M';
    'tsk4',  17,  -16,  'D',  'M';
    'tsk5',  -16,  5,  'D',  'M';
    'tsk6',  -10,  10,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -9,  -13,  -7,  -11;
    'regtsk2',  17,  8,  19,  10;
    'regtsk3',  -10,  2,  -8,  4;
    'regtsk4',  16,  -17,  18,  -15;
    'regtsk5',  -17,  4,  -15,  6;
    'regtsk6',  -11,  9,  -9,  11 };

