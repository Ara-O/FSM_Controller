numRobots = str2double('3');
numTasks = str2double('8');
numRegions = str2double('17');
numEvents = str2double('24');

% start_loc = {x, y}
start_loc = { -1.0267,  4.6119;
    -13.1041,  17.8325;
    -11.1363,  -12.9682 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -17,  0,  'D',  'start';
    'tsk02',  16,  13,  'D',  'tsk1';
    'tsk03',  0,  -15,  'D',  'start';
    'tsk04',  -19,  13,  'D',  'tsk3';
    'tsk05',  -10,  18,  'D',  'start';
    'tsk06',  10,  -17,  'D',  'tsk5';
    'tsk07',  -13,  1,  'D',  'start';
    'tsk08',  -2,  9,  'D',  'tsk7' };


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
    'regtsk01',  -18,  -1,  -16,  1;
    'regtsk02',  15,  12,  17,  14;
    'regtsk03',  -1,  -16,  1,  -14;
    'regtsk04',  -20,  12,  -18,  14;
    'regtsk05',  -11,  17,  -9,  19;
    'regtsk06',  9,  -18,  11,  -16;
    'regtsk07',  -14,  0,  -12,  2;
    'regtsk08',  -3,  8,  -1,  10 };

