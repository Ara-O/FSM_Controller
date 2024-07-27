numRobots = str2double('2');
numTasks = str2double('4');
numRegions = str2double('10');
numEvents = str2double('8');

% start_loc = {x, y}
start_loc = { -1.0743,  2.5788;
    1.5741,  -2.8729 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -1,  -2,  'D',  'start';
    'tsk02',  1,  4,  'D',  'tsk1';
    'tsk03',  2,  2,  'D',  'start';
    'tsk04',  -1,  4,  'D',  'tsk3' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg05',  -3,  -3,  0,  0;
    'reg06',  -3,  0,  0,  3;
    'reg07',  -3,  3,  0,  6;
    'reg08',  0,  3,  3,  6;
    'reg09',  0,  0,  3,  3;
    'reg10',  0,  -3,  3,  0;
    'regtsk01',  -2.25,  -1.25,  -1.75,  -0.75;
    'regtsk02',  1.75,  4.75,  2.25,  5.25;
    'regtsk03',  1.75,  0.75,  2.25,  1.25;
    'regtsk04',  -2.25,  4.75,  -1.75,  5.25 };

