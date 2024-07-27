numRobots = str2double('2');
numTasks = str2double('4');
numRegions = str2double('10');
numEvents = str2double('8');

% start_loc = {x, y}
start_loc = { -2.6622,  1.3315;
    0.90055,  -1.7958 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  -2,  -1,  'D',  'start';
    'tsk02',  -2,  5,  'D',  'tsk1';
    'tsk03',  2,  2,  'D',  'start';
    'tsk04',  2,  5,  'D',  'tsk3' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg05',  -3,  -3,  0,  0;
    'reg06',  -3,  0,  0,  3;
    'reg07',  -3,  3,  0,  6;
    'reg08',  0,  3,  3,  6;
    'reg09',  0,  0,  3,  3;
    'reg10',  0,  -3,  3,  0;
    'regtsk01',  -2.25,  -1.25,  -1.75,  -0.75;
    'regtsk02',  -2.25,  4.75,  -1.75,  5.25;
    'regtsk03',  1.75,  1.75,  2.25,  2.25;
    'regtsk04',  1.75,  4.75,  2.25,  5.25 };

