numRobots = str2double('3');
numTasks = str2double('8');
numRegions = str2double('17');
numEvents = str2double('24');

% start_loc = {x, y}
start_loc = { 2.9235,  -2.5437;
    -17.0997,  11.6548;
    -18.8425,  -18.4163 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -15,  -7,  'D',  'start';
    'tsk02',  9,  8,  'D',  'tsk1';
    'tsk03',  -5,  -17,  'D',  'start';
    'tsk04',  -15,  7,  'D',  'tsk3';
    'tsk05',  -9,  19,  'D',  'start';
    'tsk06',  13,  -14,  'D',  'tsk5';
    'tsk07',  -16,  5,  'D',  'start';
    'tsk08',  -3,  8,  'D',  'tsk7' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg09',  -20,  -20,  -8,  -8;
    'reg10',  -20,  -8,  -8,  6;
    'reg11',  -20,  6,  -8,  20;
    'reg12',  -8,  6,  6,  20;
    'reg13',  -8,  -8,  6,  6;
    'reg14',  -8,  -20,  6,  -8;
    'reg15',  6,  -20,  20,  -8;
    'reg16',  6,  -8,  20,  6;
    'reg17',  6,  6,  20,  20;
    'regtsk01',  -16,  -8,  -14,  -6;
    'regtsk02',  8,  7,  10,  9;
    'regtsk03',  -6,  -18,  -4,  -16;
    'regtsk04',  -16,  6,  -14,  8;
    'regtsk05',  -10,  18,  -8,  20;
    'regtsk06',  12,  -15,  14,  -13;
    'regtsk07',  -17,  4,  -15,  6;
    'regtsk08',  -4,  7,  -2,  9 };

