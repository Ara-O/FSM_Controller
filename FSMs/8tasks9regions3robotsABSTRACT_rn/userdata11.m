numRobots = str2double('3');
numTasks = str2double('8');
numRegions = str2double('17');
numEvents = str2double('24');

% start_loc = {x, y}
start_loc = { 0.15149,  -0.42965;
    -9.5607,  9.7069;
    -12.1831,  5.5694 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -18,  2,  'D',  'start';
    'tsk02',  9,  19,  'D',  'tsk1';
    'tsk03',  -4,  -11,  'D',  'start';
    'tsk04',  -18,  10,  'D',  'tsk3';
    'tsk05',  -19,  14,  'D',  'start';
    'tsk06',  16,  -13,  'D',  'tsk5';
    'tsk07',  -15,  1,  'D',  'start';
    'tsk08',  1,  16,  'D',  'tsk7' };


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
    'regtsk01',  -19,  1,  -17,  3;
    'regtsk02',  8,  18,  10,  20;
    'regtsk03',  -5,  -12,  -3,  -10;
    'regtsk04',  -19,  9,  -17,  11;
    'regtsk05',  -20,  13,  -18,  15;
    'regtsk06',  15,  -14,  17,  -12;
    'regtsk07',  -16,  0,  -14,  2;
    'regtsk08',  0,  15,  2,  17 };

