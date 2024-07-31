numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('10');
numEvents = str2double('12');

% start_loc = {x, y}
start_loc = { -2.4724,  -0.83473;
    1.4205,  0.45816 };

% tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  1,  -2,  'D',  'start';
    'tsk02',  2,  3,  'D',  'tsk1';
    'tsk03',  -2,  2,  'D',  'start';
    'tsk04',  -1,  -3,  'D',  'tsk3';
    'tsk05',  2,  1,  'D',  'start';
    'tsk06',  3,  -3,  'D',  'tsk5' };


% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -3,  -3,  0,  0;
    'reg08',  -3,  0,  0,  3;
    'reg09',  0,  0,  3,  3;
    'reg10',  0,  -3,  3,  0;
    'regtsk01',  0.75,  -2.25,  1.25,  -1.75;
    'regtsk02',  1.75,  2.75,  2.25,  3.25;
    'regtsk03',  -2.25,  1.75,  -1.75,  2.25;
    'regtsk04',  -1.25,  -3.25,  -0.75,  -2.75;
    'regtsk05',  1.75,  0.75,  2.25,  1.25;
    'regtsk06',  2.75,  -3.25,  3.25,  -2.75 };

