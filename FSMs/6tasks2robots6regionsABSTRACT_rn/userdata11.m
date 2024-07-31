numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('12');
numEvents = str2double('12');

% start_loc = {x, y}
start_loc = { -2.8538,  1.6582;
    0.82443,  -2.2755 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  2,  4,  'D',  'start';
    'tsk02',  -1,  -2,  'D',  'tsk1';
    'tsk03',  -1,  5,  'D',  'start';
    'tsk04',  1,  1,  'D',  'tsk3';
    'tsk05',  1,  -2,  'D',  'start';
    'tsk06',  -2,  5,  'D',  'tsk5' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -3,  -3,  0,  0;
    'reg08',  -3,  0,  0,  3;
    'reg09',  -3,  3,  0,  6;
    'reg10',  0,  3,  3,  6;
    'reg11',  0,  0,  3,  3;
    'reg12',  0,  -3,  3,  0;
    'regtsk01',  1.75,  3.75,  2.25,  4.25;
    'regtsk02',  -1.25,  -2.25,  -0.75,  -1.75;
    'regtsk03',  -1.25,  4.75,  -0.75,  5.25;
    'regtsk04',  0.75,  0.75,  1.25,  1.25;
    'regtsk05',  0.75,  -2.25,  1.25,  -1.75;
    'regtsk06',  -2.25,  4.75,  -1.75,  5.25 };

