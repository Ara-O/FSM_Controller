numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('12');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { -4.9747,  -16.9389;
    10.1191,  -11.6111 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -6,  -11,  'D',  'start';
    'tsk02',  6,  2,  'D',  'tsk1';
    'tsk03',  -7,  -6,  'D',  'start';
    'tsk04',  -18,  -1,  'D',  'tsk3';
    'tsk05',  -1,  11,  'D',  'start';
    'tsk06',  12,  9,  'D',  'tsk5' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -20,  -20,  0,  -8;
    'reg08',  -20,  -8,  0,  6;
    'reg09',  -20,  6,  0,  20;
    'reg10',  0,  6,  20,  20;
    'reg11',  0,  -8,  20,  6;
    'reg12',  0,  -20,  20,  -8;
    'regtsk01',  -7,  -12,  -5,  -10;
    'regtsk02',  5,  1,  7,  3;
    'regtsk03',  -8,  -7,  -6,  -5;
    'regtsk04',  -19,  -2,  -17,  0;
    'regtsk05',  -2,  10,  0,  12;
    'regtsk06',  11,  8,  13,  10 };

