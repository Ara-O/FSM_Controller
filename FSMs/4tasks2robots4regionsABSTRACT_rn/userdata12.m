numRobots = str2double('2');
numTasks = str2double('4');
numRegions = str2double('8');
numEvents = str2double('8');

% start_loc = {x, y}
start_loc = { -0.29185,  -0.16564;
    1.4726,  1.4678 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  2,  -1,  'D',  'start';
    'tsk02',  -2,  2,  'D',  'tsk1';
    'tsk03',  1,  -2,  'D',  'start';
    'tsk04',  -2,  -2,  'D',  'tsk3' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg05',  -3,  -3,  0,  0;
    'reg06',  -3,  0,  0,  3;
    'reg07',  0,  0,  3,  3;
    'reg08',  0,  -3,  3,  0;
    'regtsk01',  1.75,  -1.25,  2.25,  -0.75;
    'regtsk02',  -2.25,  1.75,  -1.75,  2.25;
    'regtsk03',  0.75,  -2.25,  1.25,  -1.75;
    'regtsk04',  -2.25,  -2.25,  -1.75,  -1.75 };
