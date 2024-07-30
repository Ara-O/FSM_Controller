numRobots = str2double('3');
numTasks = str2double('8');
numRegions = str2double('17');
numEvents = str2double('24');

% start_loc = {x, y}
start_loc = { -3.3966,  1.1534;
    -11.0104,  14.1646;
    -11.1196,  -17.1821 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -19,  1,  'D',  'start';
    'tsk02',  14,  13,  'D',  'tsk1';
    'tsk03',  2,  -12,  'D',  'start';
    'tsk04',  -11,  10,  'D',  'tsk3';
    'tsk05',  -12,  14,  'D',  'start';
    'tsk06',  12,  -19,  'D',  'tsk5';
    'tsk07',  -11,  -3,  'D',  'start';
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
    'regtsk01',  -20,  0,  -18,  2;
    'regtsk02',  13,  12,  15,  14;
    'regtsk03',  1,  -13,  3,  -11;
    'regtsk04',  -12,  9,  -10,  11;
    'regtsk05',  -13,  13,  -11,  15;
    'regtsk06',  11,  -20,  13,  -18;
    'regtsk07',  -12,  -4,  -10,  -2;
    'regtsk08',  0,  15,  2,  17 };

