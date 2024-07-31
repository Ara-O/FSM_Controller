numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('18');

% start_loc = {x, y}
start_loc = { '4.4713',  '13.6588';
    '11.6086',  '2.9154';
    '-12.0489',  '-9.8826' };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  8,  15,  'D',  'M';
    'tsk2',  15,  -6,  'D',  'M';
    'tsk3',  8,  -11,  'D',  'M';
    'tsk4',  -18,  9,  'D',  'M';
    'tsk5',  0,  -1,  'D',  'M';
    'tsk6',  15,  4,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  7,  14,  9,  16;
    'regtsk2',  14,  -7,  16,  -5;
    'regtsk3',  7,  -12,  9,  -10;
    'regtsk4',  -19,  8,  -17,  10;
    'regtsk5',  -1,  -2,  1,  0;
    'regtsk6',  14,  3,  16,  5 };

