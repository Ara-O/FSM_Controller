numRobots = str2double('3');
numTasks = str2double('6');
numRegions = str2double('6');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { -12.7179,  -11.5065;
    7.259,  2.8045;
    14.1863,  -9.7039 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk1',  -8,  15,  'D',  'M';
    'tsk2',  15,  16,  'D',  'M';
    'tsk3',  -13,  14,  'D',  'M';
    'tsk4',  5,  -11,  'D',  'M';
    'tsk5',  -6,  -13,  'D',  'M';
    'tsk6',  -2,  -16,  'D',  'M' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'regtsk1',  -9,  14,  -7,  16;
    'regtsk2',  14,  15,  16,  17;
    'regtsk3',  -14,  13,  -12,  15;
    'regtsk4',  4,  -12,  6,  -10;
    'regtsk5',  -7,  -14,  -5,  -12;
    'regtsk6',  -3,  -17,  -1,  -15 };

