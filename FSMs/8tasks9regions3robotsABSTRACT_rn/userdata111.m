numRobots = str2double('3');
numTasks = str2double('8');
numRegions = str2double('17');
numEvents = str2double('30');

% start_loc = {x, y}
start_loc = { 2.3407,  0.24338;
    -0.21184,  5.3271;
    -1.5396,  -1.6924 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  5,  -2,  'D',  'start';
    'tsk02',  -2,  1,  'D',  'tsk1';
    'tsk03',  2,  5,  'D',  'start';
    'tsk04',  -1,  -2,  'D',  'tsk3';
    'tsk05',  5,  1,  'D',  'start';
    'tsk06',  2,  1,  'D',  'tsk5';
    'tsk07',  5,  4,  'D',  'start';
    'tsk08',  -2,  -1,  'D',  'tsk7' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg09',  -3,  -3,  0,  0;
    'reg10',  -3,  0,  0,  3;
    'reg11',  -3,  3,  0,  6;
    'reg12',  0,  3,  3,  6;
    'reg13',  0,  0,  3,  3;
    'reg14',  0,  -3,  3,  0;
    'reg15',  3,  -3,  6,  0;
    'reg16',  3,  0,  6,  3;
    'reg17',  3,  3,  6,  6;
    'regtsk01',  4.75,  -2.25,  5.25,  -1.75;
    'regtsk02',  -2.25,  0.75,  -1.75,  1.25;
    'regtsk03',  1.75,  4.75,  2.25,  5.25;
    'regtsk04',  -1.25,  -2.25,  -0.75,  -1.75;
    'regtsk05',  4.75,  0.75,  5.25,  1.25;
    'regtsk06',  1.75,  0.75,  2.25,  1.25;
    'regtsk07',  4.75,  3.75,  5.25,  4.25;
    'regtsk08',  -2.25,  -1.25,  -1.75,  -0.75 };

