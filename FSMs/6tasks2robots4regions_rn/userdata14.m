numRobots = str2double('2');
numTasks = str2double('6');
numRegions = str2double('10');
numEvents = str2double('12');

%start_loc = {x, y}
start_loc = { -2.539,  -2.157;
   1.3203,  1.5814 };

%tasks = {'name', x1, y1, 'function', 'from_task_name'}
tasks = { 'tsk01',  2,  -1,  'D',  'start';
    'tsk02',  2,  1,  'D',  'tsk1';
   'tsk03',  -2,  1,  'D',  'start';
    'tsk04',  -1,  -1,  'D',  'tsk3';
   'tsk05',  1,  2,  'D',  'start';
   'tsk06',  2,  -2,  'D',  'tsk5' };

% regions = {'name', x1, y1, x2, y2}
regions = { 'reg07',  -3,  -3,  0,  0;
    'reg08',  -3,  0,  0,  3;
    'reg09',  0,  0,  3,  3;
    'reg10',  0,  -3,  3,  0;
    'regtsk01',  1.75,  -1.25,  2.25,  -0.75;
    'regtsk02',  1.75,  0.75,  2.25,  1.25;
    'regtsk03',  -2.25,  0.75,  -1.75,  1.25;
    'regtsk04',  -1.25,  -1.25,  -0.75,  -0.75;
   'regtsk05',  0.75,  1.75,  1.25,  2.25;
    'regtsk06',  1.75,  -2.25,  2.25,  -1.75 };

