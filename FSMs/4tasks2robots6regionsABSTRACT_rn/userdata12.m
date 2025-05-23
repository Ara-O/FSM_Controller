numRobots = str2double('2');
numTasks = str2double('4');
numRegions = str2double('10');
numEvents = str2double('8');

% start_loc = {x, y}
start_loc = { -1.1596,  2.4559;
    1.6587,  -0.20667 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -1,  -1,  'D',  'start';
    'tsk02',  2,  4,  'D',  'tsk1';
    'tsk03',  1,  1,  'D',  'start';
    'tsk04',  -2,  5,  'D',  'tsk3' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg05',  -3,  -3,  0,  0;
    'reg06',  -3,  0,  0,  3;
    'reg07',  -3,  3,  0,  6;
    'reg08',  0,  3,  3,  6;
    'reg09',  0,  0,  3,  3;
    'reg10',  0,  -3,  3,  0;
    'regtsk01',  -1.25,  -1.25,  -0.75,  -0.75;
    'regtsk02',  1.75,  3.75,  2.25,  4.25;
    'regtsk03',  0.75,  0.75,  1.25,  1.25;
    'regtsk04',  -2.25,  4.75,  -1.75,  5.25 };

