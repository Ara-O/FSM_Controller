numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('15');
numEvents = str2double('12');

% start_loc = {x, y}
start_loc = { -0.43268,  2.0124;
    1.5708,  -2.1036 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  5,  -2,  'D',  'start';
    'tsk02',  2,  2,  'D',  'tsk1';
    'tsk03',  -2,  4,  'D',  'start';
    'tsk04',  2,  1,  'D',  'tsk3';
    'tsk05',  4,  4,  'D',  'start';
    'tsk06',  5,  -1,  'D',  'tsk5' };


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
    'regtsk01',  4.75,  -2.25,  5.25,  -1.75;
    'regtsk02',  1.75,  1.75,  2.25,  2.25;
    'regtsk03',  -2.25,  3.75,  -1.75,  4.25;
    'regtsk04',  1.75,  0.75,  2.25,  1.25;
    'regtsk05',  3.75,  3.75,  4.25,  4.25;
    'regtsk06',  4.75,  -1.25,  5.25,  -0.75 };

