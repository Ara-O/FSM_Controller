numRobots = str2double('2');
numTasks = str2double('4');
numRegions = str2double('13');
numEvents = str2double('8');

% start_loc = {x, y}
start_loc = { -2.7943,  0.8982;
    1.7748,  -2.3901 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  5,  4,  'D',  'start';
    'tsk02',  1,  2,  'D',  'tsk1';
    'tsk03',  -2,  -1,  'D',  'start';
    'tsk04',  -1,  4,  'D',  'tsk3' };


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
    'regtsk01',  4.75,  3.75,  5.25,  4.25;
    'regtsk02',  0.75,  1.75,  1.25,  2.25;
    'regtsk03',  -2.25,  -1.25,  -1.75,  -0.75;
    'regtsk04',  -1.25,  3.75,  -0.75,  4.25 };

