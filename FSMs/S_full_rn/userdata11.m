numRobots = str2double('2');
numTasks = str2double('4');
numRegions = str2double('8');
numEvents = str2double('24');

% start_loc = {x, y}
start_loc = { -0.12748,  -0.10533;
    0.47284,  -0.088222 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -1,  0,  'D',  'start';
    'tsk02',  -3,  3,  'D',  'tsk1';
    'tsk03',  2,  0,  'D',  'start';
    'tsk04',  1,  -1,  'D',  'tsk3' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg05',  -3,  -3,  0,  0;
    'reg06',  -3,  0,  0,  3;
    'reg07',  0,  0,  3,  3;
    'reg08',  0,  -3,  3,  0;
    'regtsk01',  -2,  -1,  0,  1;
    'regtsk02',  -4,  2,  -2,  4;
    'regtsk03',  1,  -1,  3,  1;
    'regtsk04',  0,  -2,  2,  0 };

