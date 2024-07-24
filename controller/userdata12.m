numRobots = str2double('3');
numTasks = str2double('10');
numRegions = str2double('19');
numEvents = str2double('30');

% start_loc = {x, y}
start_loc = { -4.5464,  2.9819;
    -9.4059,  18.792;
    -13.3006,  -12.8136 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -13,  -2,  'D',  'start';
    'tsk02',  19,  15,  'D',  'tsk1';
    'tsk03',  -2,  -10,  'D',  'start';
    'tsk04',  -14,  14,  'D',  'tsk3';
    'tsk05',  -12,  11,  'D',  'start';
    'tsk06',  9,  -13,  'D',  'tsk5';
    'tsk07',  -10,  -2,  'D',  'start';
    'tsk08',  -6,  12,  'D',  'tsk7';
    'tsk09',  -16,  -15,  'D',  'start';
    'tsk10',  18,  -2,  'D',  'tsk9' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg11',  -20,  -20,  -8,  -8;
    'reg12',  -20,  -8,  -8,  6;
    'reg13',  -20,  6,  -8,  20;
    'reg14',  -8,  6,  6,  20;
    'reg15',  -8,  -8,  6,  6;
    'reg16',  -8,  -20,  6,  -8;
    'reg17',  6,  -20,  20,  -8;
    'reg18',  6,  -8,  20,  6;
    'reg19',  6,  6,  20,  20;
    'regtsk01',  -14,  -3,  -12,  -1;
    'regtsk02',  18,  14,  20,  16;
    'regtsk03',  -3,  -11,  -1,  -9;
    'regtsk04',  -15,  13,  -13,  15;
    'regtsk05',  -13,  10,  -11,  12;
    'regtsk06',  8,  -14,  10,  -12;
    'regtsk07',  -11,  -3,  -9,  -1;
    'regtsk08',  -7,  11,  -5,  13;
    'regtsk09',  -17,  -16,  -15,  -14;
    'regtsk10',  17,  -3,  19,  -1 };

