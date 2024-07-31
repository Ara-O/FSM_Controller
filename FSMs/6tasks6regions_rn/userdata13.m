numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('12');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { -0.85666,  -14.1755;
    16.0056,  -18.2974 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -11,  -15,  'D',  'start';
    'tsk02',  15,  3,  'D',  'tsk1';
    'tsk03',  -16,  -1,  'D',  'start';
    'tsk04',  -11,  1,  'D',  'tsk3';
    'tsk05',  -6,  17,  'D',  'start';
    'tsk06',  6,  16,  'D',  'tsk5' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -20,  -20,  0,  -8;
    'reg08',  -20,  -8,  0,  6;
    'reg09',  -20,  6,  0,  20;
    'reg10',  0,  6,  20,  20;
    'reg11',  0,  -8,  20,  6;
    'reg12',  0,  -20,  20,  -8;
    'regtsk01',  -12,  -16,  -10,  -14;
    'regtsk02',  14,  2,  16,  4;
    'regtsk03',  -17,  -2,  -15,  0;
    'regtsk04',  -12,  0,  -10,  2;
    'regtsk05',  -7,  16,  -5,  18;
    'regtsk06',  5,  15,  7,  17 };

