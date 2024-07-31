numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('12');
numEvents = str2double('12');

% start_loc = {x, y}
start_loc = { -1.9582,  0.27644;
    0.44355,  -2.4055 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  2,  5,  'D',  'start';
    'tsk02',  -2,  -2,  'D',  'tsk1';
    'tsk03',  -1,  5,  'D',  'start';
    'tsk04',  2,  2,  'D',  'tsk3';
    'tsk05',  2,  -1,  'D',  'start';
    'tsk06',  -2,  5,  'D',  'tsk5' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -3,  -3,  0,  0;
    'reg08',  -3,  0,  0,  3;
    'reg09',  -3,  3,  0,  6;
    'reg10',  0,  3,  3,  6;
    'reg11',  0,  0,  3,  3;
    'reg12',  0,  -3,  3,  0;
    'regtsk01',  1.75,  4.75,  2.25,  5.25;
    'regtsk02',  -2.25,  -2.25,  -1.75,  -1.75;
    'regtsk03',  -1.25,  4.75,  -0.75,  5.25;
    'regtsk04',  1.75,  1.75,  2.25,  2.25;
    'regtsk05',  1.75,  -1.25,  2.25,  -0.75;
    'regtsk06',  -2.25,  4.75,  -1.75,  5.25 };

