numRobots = str2double('2');
numTasks = str2double('4');
numRegions = str2double('13');
numEvents = str2double('8');

% start_loc = {x, y}
start_loc = { -0.61123,  1.3248;
    1.3386,  -1.603 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  4,  4,  'D',  'start';
    'tsk02',  2,  2,  'D',  'tsk1';
    'tsk03',  -1,  -1,  'D',  'start';
    'tsk04',  -2,  5,  'D',  'tsk3' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg05',  -3,  -3,  0,  0;
    'reg06',  -3,  0,  0,  3;
    'reg07',  -3,  3,  0,  6;
    'reg08',  0,  3,  3,  6;
    'reg09',  0,  0,  3,  3;
    'reg10',  0,  -3,  3,  0;
    'reg11',  3,  -3,  6,  0;
    'reg12',  3,  0,  6,  3;
    'reg13',  3,  3,  6,  6;
    'regtsk01',  3.75,  3.75,  4.25,  4.25;
    'regtsk02',  1.75,  1.75,  2.25,  2.25;
    'regtsk03',  -1.25,  -1.25,  -0.75,  -0.75;
    'regtsk04',  -2.25,  4.75,  -1.75,  5.25 };

