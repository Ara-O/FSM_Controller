numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('12');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { -0.85666,  -13.5251;
    16.0056,  -18.1072 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -4,  -8,  'D',  'start';
    'tsk02',  3,  6,  'D',  'tsk1';
    'tsk03',  -7,  -5,  'D',  'start';
    'tsk04',  -14,  1,  'D',  'tsk3';
    'tsk05',  -1,  20,  'D',  'start';
    'tsk06',  3,  20,  'D',  'tsk5' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -20,  -20,  0,  -6.66;
    'reg08',  -20,  -6.66,  0,  6.66;
    'reg09',  -20,  6.66,  0,  20;
    'reg10',  0,  6.66,  20,  20;
    'reg11',  0,  -6.66,  20,  6.66;
    'reg12',  0,  -20,  20,  -6.66;
    'regtsk01',  -5,  -9,  -3,  -7;
    'regtsk02',  2,  5,  4,  7;
    'regtsk03',  -8,  -6,  -6,  -4;
    'regtsk04',  -15,  0,  -13,  2;
    'regtsk05',  -2,  19,  0,  21;
    'regtsk06',  2,  19,  4,  21 };

