numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('10');
numEvents = str2double('12');

% start_loc = {x, y}
start_loc = { -0.21344,  -0.80901;
    1.4658,  1.7356 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  1,  -2,  'D',  'start';
    'tsk02',  2,  1,  'D',  'tsk1';
    'tsk03',  -1,  2,  'D',  'start';
    'tsk04',  -2,  -2,  'D',  'tsk3';
    'tsk05',  1,  1,  'D',  'start';
    'tsk06',  1,  -1,  'D',  'tsk5' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -3,  -3,  0,  0;
    'reg08',  -3,  0,  0,  3;
    'reg09',  0,  0,  3,  3;
    'reg10',  0,  -3,  3,  0;
    'regtsk01',  0.75,  -2.25,  1.25,  -1.75;
    'regtsk02',  1.75,  0.75,  2.25,  1.25;
    'regtsk03',  -1.25,  1.75,  -0.75,  2.25;
    'regtsk04',  -2.25,  -2.25,  -1.75,  -1.75;
    'regtsk05',  0.75,  0.75,  1.25,  1.25;
    'regtsk06',  0.75,  -1.25,  1.25,  -0.75 };

