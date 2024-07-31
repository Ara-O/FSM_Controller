numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('15');
numEvents = str2double('12');

% start_loc = {x, y}
start_loc = { -2.8513,  0.8496;
    1.9604,  -1.531 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  4,  -1,  'D',  'start';
    'tsk02',  2,  2,  'D',  'tsk1';
    'tsk03',  -1,  4,  'D',  'start';
    'tsk04',  1,  2,  'D',  'tsk3';
    'tsk05',  4,  5,  'D',  'start';
    'tsk06',  4,  -2,  'D',  'tsk5' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -3,  -3,  0,  0;
    'reg08',  -3,  0,  0,  3;
    'reg09',  -3,  3,  0,  6;
    'reg10',  0,  3,  3,  6;
    'reg11',  0,  0,  3,  3;
    'reg12',  0,  -3,  3,  0;
    'reg13',  3,  -3,  6,  0;
    'reg14',  3,  0,  6,  3;
    'reg15',  3,  3,  6,  6;
    'regtsk01',  3.75,  -1.25,  4.25,  -0.75;
    'regtsk02',  1.75,  1.75,  2.25,  2.25;
    'regtsk03',  -1.25,  3.75,  -0.75,  4.25;
    'regtsk04',  0.75,  1.75,  1.25,  2.25;
    'regtsk05',  3.75,  4.75,  4.25,  5.25;
    'regtsk06',  3.75,  -2.25,  4.25,  -1.75 };

