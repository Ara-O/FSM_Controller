numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('12');
numEvents = str2double('36');

% start_loc = {x, y}
start_loc = { -5.8127,  -9.9325;
    5.5205,  -1.8791 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -6,  -16,  'D',  'start';
    'tsk02',  19,  -6,  'D',  'tsk1';
    'tsk03',  -11,  -2,  'D',  'start';
    'tsk04',  -5,  4,  'D',  'tsk3';
    'tsk05',  -16,  13,  'D',  'start';
    'tsk06',  9,  15,  'D',  'tsk5' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -20,  -20,  0,  -6.66;
    'reg08',  -20,  -6.66,  0,  6.66;
    'reg09',  -20,  6.66,  0,  20;
    'reg10',  0,  6.66,  20,  20;
    'reg11',  0,  -6.66,  20,  6.66;
    'reg12',  0,  -20,  20,  6.66;
    'regtsk01',  -7,  -17,  -5,  -15;
    'regtsk02',  18,  -7,  20,  -5;
    'regtsk03',  -12,  -3,  -10,  -1;
    'regtsk04',  -6,  3,  -4,  5;
    'regtsk05',  -17,  12,  -15,  14;
    'regtsk06',  8,  14,  10,  16 };

