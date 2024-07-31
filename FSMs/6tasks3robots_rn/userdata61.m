numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { -2.0222,  -7.3587;
    0.32333,  0.40932;
    12.0699,  11.2036 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  9,  -12,  'D',  'M';
    'tsk2',  7,  -12,  'D',  'M';
    'tsk3',  -5,  5,  'D',  'M';
    'tsk4',  11,  -16,  'D',  'M';
    'tsk5',  16,  10,  'D',  'M';
    'tsk6',  -1,  -2,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  8,  -13,  10,  -11;
    'regtsk2',  6,  -13,  8,  -11;
    'regtsk3',  -6,  4,  -4,  6;
    'regtsk4',  10,  -17,  12,  -15;
    'regtsk5',  15,  9,  17,  11;
    'regtsk6',  -2,  -3,  0,  -1 };

