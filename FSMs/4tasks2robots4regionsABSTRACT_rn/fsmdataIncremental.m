% events = {'name', bot, 'type', 'type_name'}
events1 = { 'a01f',  1,  'Region';
    'a02f',  1,  'Region';
    'a03f',  1,  'Region';
    'a04f',  1,  'Region';
    'a05e',  1,  'Region';
    'a06e',  1,  'Region';
    'a07e',  1,  'Region';
    'a08e',  1,  'Region';
    'b01f',  2,  'Region';
    'b02f',  2,  'Region';
    'b03f',  2,  'Region';
    'b04f',  2,  'Region';
    'b05e',  2,  'Region';
    'b06e',  2,  'Region';
    'b07e',  2,  'Region';
    'b08e',  2,  'Region' };

initial_state_incr = {'1','1','1'};

% states = {'name', {'event_name', 'state_name', 'isControllable: c_uc', 'cost';
%                    'event_name', 'state_name', 'isControllable: c_uc', 'cost'}, 'isDone: 0_1'}
states1 = { '1',  { 'a04f',  '1',  'uc',  'o';
    'a06e',  '2',  'c',  'o';
    'a08e',  '3',  'c',  'o';
    'b06e',  '4',  'c',  'o';
    'b08e',  '5',  'c',  'o' },  1;
    '2',  { 'b08e',  '6',  'c',  'o';
    'a02f',  '2',  'uc',  'o';
    'a05e',  '1',  'c',  'o' },  1;
    '3',  { 'b06e',  '10',  'c',  'o';
    'a05e',  '1',  'c',  'o';
    'a01f',  '3',  'uc',  'o';
    'a03f',  '3',  'uc',  'o' },  1;
    '4',  { 'a04f',  '4',  'uc',  'o';
    'a08e',  '10',  'c',  'o';
    'b02f',  '4',  'uc',  'o';
    'b07e',  '1',  'c',  'o' },  1;
    '5',  { 'a04f',  '5',  'uc',  'o';
    'a06e',  '6',  'c',  'o';
    'b01f',  '5',  'uc',  'o';
    'b03f',  '5',  'uc',  'o';
    'b07e',  '1',  'c',  'o' },  1;
    '6',  { 'a02f',  '6',  'uc',  'o';
    'a05e',  '5',  'c',  'o';
    'a07e',  '9',  'c',  'o';
    'b01f',  '6',  'uc',  'o';
    'b03f',  '6',  'uc',  'o';
    'b05e',  '7',  'c',  'o';
    'b07e',  '2',  'c',  'o' },  1;
    '7',  { 'b08e',  '6',  'c',  'o';
    'a02f',  '7',  'uc',  'o';
    'a07e',  '8',  'c',  'o';
    'b04f',  '7',  'uc',  'o' },  1;
    '8',  { 'a06e',  '7',  'c',  'o';
    'a08e',  '11',  'c',  'o';
    'b06e',  '12',  'c',  'o';
    'b08e',  '9',  'c',  'o';
    'b04f',  '8',  'uc',  'o' },  1;
    '9',  { 'a06e',  '6',  'c',  'o';
    'b01f',  '9',  'uc',  'o';
    'b03f',  '9',  'uc',  'o';
    'b05e',  '8',  'c',  'o' },  1;
    '10',  { 'a05e',  '4',  'c',  'o';
    'a07e',  '12',  'c',  'o';
    'b05e',  '11',  'c',  'o';
    'b02f',  '10',  'uc',  'o';
    'b07e',  '3',  'c',  'o';
    'a01f',  '10',  'uc',  'o';
    'a03f',  '10',  'uc',  'o' },  1;
    '11',  { 'b06e',  '10',  'c',  'o';
    'a07e',  '8',  'c',  'o';
    'b04f',  '11',  'uc',  'o';
    'a01f',  '11',  'uc',  'o';
    'a03f',  '11',  'uc',  'o' },  1;
    '12',  { 'a08e',  '10',  'c',  'o';
    'b05e',  '8',  'c',  'o';
    'b02f',  '12',  'uc',  'o' },  1 };

% events = {'name', bot, 'type', 'type_name'}
events2 = { 'a01f',  1,  'Region';
    'a01s',  1,  'Task';
    'a02f',  1,  'Region';
    'a02s',  1,  'Task';
    'a03f',  1,  'Region';
    'a03s',  1,  'Task';
    'a04f',  1,  'Region';
    'a04s',  1,  'Task';
    'b01f',  2,  'Region';
    'b01s',  2,  'Task';
    'b02f',  2,  'Region';
    'b02s',  2,  'Task';
    'b03f',  2,  'Region';
    'b03s',  2,  'Task';
    'b04f',  2,  'Region';
    'b04s',  2,  'Task' };



% states = {'name', {'event_name', 'state_name', 'isControllable: c_uc', 'cost';
%                    'event_name', 'state_name', 'isControllable: c_uc', 'cost'}, 'isDone: 0_1'}
states2 = { '1',  { 'a01s',  '2',  'c',  'o';
    'a03s',  '3',  'c',  'o';
    'a04s',  '4',  'c',  'o';
    'b01s',  '5',  'c',  'o';
    'b03s',  '6',  'c',  'o';
    'b04s',  '7',  'c',  'o' },  0;
    '2',  { 'b03s',  '9',  'c',  'o';
    'b04s',  '10',  'c',  'o';
    'a01f',  '8',  'uc',  'o' },  0;
    '3',  { 'b01s',  '44',  'c',  'o';
    'b03s',  '45',  'c',  'o';
    'b04s',  '46',  'c',  'o';
    'a03f',  '1',  'uc',  'o' },  0;
    '4',  { 'b01s',  '43',  'c',  'o';
    'b03s',  '47',  'c',  'o';
    'b04s',  '48',  'c',  'o';
    'a04f',  '1',  'uc',  'o' },  0;
    '5',  { 'a03s',  '44',  'c',  'o';
    'a04s',  '43',  'c',  'o';
    'b01f',  '25',  'uc',  'o' },  0;
    '6',  { 'a01s',  '9',  'c',  'o';
    'a03s',  '45',  'c',  'o';
    'a04s',  '47',  'c',  'o';
    'b03f',  '1',  'uc',  'o' },  0;
    '7',  { 'a01s',  '10',  'c',  'o';
    'a03s',  '46',  'c',  'o';
    'a04s',  '48',  'c',  'o';
    'b04f',  '1',  'uc',  'o' },  0;
    '8',  { 'a03s',  '20',  'c',  'o';
    'a04s',  '17',  'c',  'o';
    'b03s',  '19',  'c',  'o';
    'b04s',  '16',  'c',  'o';
    'a02s',  '11',  'c',  'o' },  0;
    '9',  { 'a01f',  '19',  'uc',  'o';
    'b03f',  '2',  'uc',  'o' },  0;
    '10',  { 'a01f',  '16',  'uc',  'o';
    'b04f',  '2',  'uc',  'o' },  0;
    '11',  { 'b03s',  '13',  'c',  'o';
    'b04s',  '14',  'c',  'o';
    'a02f',  '12',  'uc',  'o' },  0;
    '12',  { 'a03s',  '37',  'c',  'o';
    'a04s',  '35',  'c',  'o';
    'b03s',  '23',  'c',  'o';
    'b04s',  '21',  'c',  'o' },  1;
    '13',  { 'a02f',  '23',  'uc',  'o';
    'b03f',  '11',  'uc',  'o' },  0;
    '14',  { 'a02f',  '21',  'uc',  'o';
    'b04f',  '11',  'uc',  'o' },  0;
    '15',  { 'a04f',  '16',  'uc',  'o';
    'b04f',  '17',  'uc',  'o' },  0;
    '16',  { 'a03s',  '22',  'c',  'o';
    'a04s',  '15',  'c',  'o';
    'b04f',  '8',  'uc',  'o';
    'a02s',  '14',  'c',  'o' },  0;
    '17',  { 'b03s',  '24',  'c',  'o';
    'b04s',  '15',  'c',  'o';
    'a04f',  '8',  'uc',  'o' },  0;
    '18',  { 'a03f',  '19',  'uc',  'o';
    'b03f',  '20',  'uc',  'o' },  0;
    '19',  { 'a03s',  '18',  'c',  'o';
    'a04s',  '24',  'c',  'o';
    'b03f',  '8',  'uc',  'o';
    'a02s',  '13',  'c',  'o' },  0;
    '20',  { 'b03s',  '18',  'c',  'o';
    'b04s',  '22',  'c',  'o';
    'a03f',  '8',  'uc',  'o' },  0;
    '21',  { 'a03s',  '40',  'c',  'o';
    'a04s',  '42',  'c',  'o';
    'b04f',  '12',  'uc',  'o' },  1;
    '22',  { 'b04f',  '20',  'uc',  'o';
    'a03f',  '16',  'uc',  'o' },  0;
    '23',  { 'a03s',  '39',  'c',  'o';
    'a04s',  '41',  'c',  'o';
    'b03f',  '12',  'uc',  'o' },  1;
    '24',  { 'a04f',  '19',  'uc',  'o';
    'b03f',  '17',  'uc',  'o' },  0;
    '25',  { 'a03s',  '26',  'c',  'o';
    'a04s',  '27',  'c',  'o';
    'b03s',  '29',  'c',  'o';
    'b04s',  '30',  'c',  'o';
    'b02s',  '28',  'c',  'o' },  0;
    '26',  { 'b03s',  '32',  'c',  'o';
    'b04s',  '33',  'c',  'o';
    'a03f',  '25',  'uc',  'o';
    'b02s',  '31',  'c',  'o' },  0;
    '27',  { 'b03s',  '36',  'c',  'o';
    'b04s',  '38',  'c',  'o';
    'a04f',  '25',  'uc',  'o';
    'b02s',  '34',  'c',  'o' },  0;
    '28',  { 'a03s',  '31',  'c',  'o';
    'a04s',  '34',  'c',  'o';
    'b02f',  '12',  'uc',  'o' },  0;
    '29',  { 'a03s',  '32',  'c',  'o';
    'a04s',  '36',  'c',  'o';
    'b03f',  '25',  'uc',  'o' },  0;
    '30',  { 'a03s',  '33',  'c',  'o';
    'a04s',  '38',  'c',  'o';
    'b04f',  '25',  'uc',  'o' },  0;
    '31',  { 'a03f',  '28',  'uc',  'o';
    'b02f',  '37',  'uc',  'o' },  0;
    '32',  { 'a03f',  '29',  'uc',  'o';
    'b03f',  '26',  'uc',  'o' },  0;
    '33',  { 'b04f',  '26',  'uc',  'o';
    'a03f',  '30',  'uc',  'o' },  0;
    '34',  { 'a04f',  '28',  'uc',  'o';
    'b02f',  '35',  'uc',  'o' },  0;
    '35',  { 'b03s',  '41',  'c',  'o';
    'b04s',  '42',  'c',  'o';
    'a04f',  '12',  'uc',  'o' },  1;
    '36',  { 'a04f',  '29',  'uc',  'o';
    'b03f',  '27',  'uc',  'o' },  0;
    '37',  { 'b03s',  '39',  'c',  'o';
    'b04s',  '40',  'c',  'o';
    'a03f',  '12',  'uc',  'o' },  1;
    '38',  { 'a04f',  '30',  'uc',  'o';
    'b04f',  '27',  'uc',  'o' },  0;
    '39',  { 'a03f',  '23',  'uc',  'o';
    'b03f',  '37',  'uc',  'o' },  1;
    '40',  { 'b04f',  '37',  'uc',  'o';
    'a03f',  '21',  'uc',  'o' },  1;
    '41',  { 'a04f',  '23',  'uc',  'o';
    'b03f',  '35',  'uc',  'o' },  1;
    '42',  { 'a04f',  '21',  'uc',  'o';
    'b04f',  '35',  'uc',  'o' },  1;
    '43',  { 'a04f',  '5',  'uc',  'o';
    'b01f',  '27',  'uc',  'o' },  0;
    '44',  { 'a03f',  '5',  'uc',  'o';
    'b01f',  '26',  'uc',  'o' },  0;
    '45',  { 'a03f',  '6',  'uc',  'o';
    'b03f',  '3',  'uc',  'o' },  0;
    '46',  { 'b04f',  '3',  'uc',  'o';
    'a03f',  '7',  'uc',  'o' },  0;
    '47',  { 'a04f',  '6',  'uc',  'o';
    'b03f',  '4',  'uc',  'o' },  0;
    '48',  { 'a04f',  '7',  'uc',  'o';
    'b04f',  '4',  'uc',  'o' },  0 };

% events = {'name', bot, 'type', 'type_name'}
events3 = { 'a01s',  1,  'Task';
    'a02s',  1,  'Task';
    'a03f',  1,  'Region';
    'a03s',  1,  'Task';
    'a04f',  1,  'Region';
    'a04s',  1,  'Task';
    'b01s',  2,  'Task';
    'b02s',  2,  'Task';
    'b03f',  2,  'Region';
    'b03s',  2,  'Task';
    'b04f',  2,  'Region';
    'b04s',  2,  'Task' };


% states = {'name', {'event_name', 'state_name', 'isControllable: c_uc', 'cost';
%                    'event_name', 'state_name', 'isControllable: c_uc', 'cost'}, 'isDone: 0_1'}
states3 = { '1',  { 'a01s',  '2',  'c',  'o';
    'a03s',  '3',  'c',  'o';
    'b01s',  '4',  'c',  'o';
    'b03s',  '5',  'c',  'o' },  0;
    '2',  { 'a03s',  '28',  'c',  'o';
    'b03s',  '29',  'c',  'o';
    'a02s',  '27',  'c',  'o' },  0;
    '3',  { 'b01s',  '6',  'c',  'o';
    'a03f',  '30',  'uc',  'o' },  0;
    '4',  { 'a03s',  '6',  'c',  'o';
    'b03s',  '32',  'c',  'o';
    'b02s',  '27',  'c',  'o' },  0;
    '5',  { 'a01s',  '29',  'c',  'o';
    'b03f',  '19',  'uc',  'o' },  0;
    '6',  { 'a03f',  '7',  'uc',  'o';
    'b02s',  '8',  'c',  'o' },  0;
    '7',  { 'b02s',  '10',  'c',  'o';
    'a04s',  '14',  'c',  'o' },  0;
    '8',  { 'a03f',  '10',  'uc',  'o' },  0;
    '9',  { 'a02s',  '10',  'c',  'o';
    'a04s',  '11',  'c',  'o' },  0;
    '10',  { 'a04s',  '12',  'c',  'o' },  0;
    '11',  { 'a04f',  '13',  'uc',  'o' },  0;
    '12',  { 'a04f',  '15',  'uc',  'o' },  0;
    '13',  { 'a02s',  '15',  'c',  'o' },  0;
    '14',  { 'b02s',  '12',  'c',  'o';
    'a04f',  '16',  'uc',  'o' },  0;
    '15',  {},  1;
    '16',  { 'b02s',  '15',  'c',  'o' },  0;
    '17',  { 'b01s',  '14',  'c',  'o';
    'a04f',  '18',  'uc',  'o' },  0;
    '18',  { 'a01s',  '13',  'c',  'o';
    'b01s',  '16',  'c',  'o' },  0;
    '19',  { 'a01s',  '20',  'c',  'o';
    'b01s',  '21',  'c',  'o';
    'b04s',  '22',  'c',  'o' },  0;
    '20',  { 'a02s',  '23',  'c',  'o';
    'b04s',  '24',  'c',  'o' },  0;
    '21',  { 'b02s',  '23',  'c',  'o';
    'b04s',  '26',  'c',  'o' },  0;
    '22',  { 'a01s',  '24',  'c',  'o';
    'b04f',  '18',  'uc',  'o' },  0;
    '23',  { 'b04s',  '25',  'c',  'o' },  0;
    '24',  { 'a02s',  '25',  'c',  'o';
    'b04f',  '13',  'uc',  'o' },  0;
    '25',  { 'b04f',  '15',  'uc',  'o' },  0;
    '26',  { 'b04f',  '16',  'uc',  'o' },  0;
    '27',  { 'a03s',  '8',  'c',  'o';
    'b03s',  '31',  'c',  'o' },  0;
    '28',  { 'a03f',  '9',  'uc',  'o' },  0;
    '29',  { 'a02s',  '31',  'c',  'o';
    'b03f',  '20',  'uc',  'o' },  0;
    '30',  { 'a01s',  '9',  'c',  'o';
    'b01s',  '7',  'c',  'o';
    'a04s',  '17',  'c',  'o' },  0;
    '31',  { 'b03f',  '23',  'uc',  'o' },  0;
    '32',  { 'b03f',  '21',  'uc',  'o' },  0 };

events_incr = {events1,events2,events3};

states_incr = {states1,states2,states3};
