% events = {'name', bot, 'type', 'type_name'}
events = { 'a01f',  1,  'Region',  'regtsk01';
    'a02f',  1,  'Region',  'regtsk02';
    'a03f',  1,  'Region',  'regtsk03';
    'a04f',  1,  'Region',  'regtsk04';
    'a05e',  1,  'Region',  'reg05';
    'a06e',  1,  'Region',  'reg06';
    'a07e',  1,  'Region',  'reg07';
    'a08e',  1,  'Region',  'reg08';
    'a09e',  1,  'Region',  'reg09';
    'a10e',  1,  'Region',  'reg10';
    'b01f',  2,  'Region',  'regtsk01';
    'b02f',  2,  'Region',  'regtsk02';
    'b03f',  2,  'Region',  'regtsk03';
    'b04f',  2,  'Region',  'regtsk04';
    'b05e',  2,  'Region',  'reg05';
    'b06e',  2,  'Region',  'reg06';
    'b07e',  2,  'Region',  'reg07';
    'b08e',  2,  'Region',  'reg08';
    'b09e',  2,  'Region',  'reg09';
    'b10e',  2,  'Region',  'reg10' };


initial_state = '1';
final_state = '1';

% states = {'name', {'event_name', 'state_name', 'isControllable: c_uc', 'cost';
%                    'event_name', 'state_name', 'isControllable: c_uc', 'cost'}, 'isDone: 0_1'}
states = { '1',  { 'a05e',  '2',  'c',  'o';
    'a07e',  '3',  'c',  'o';
    'a09e',  '4',  'c',  'o';
    'b05e',  '5',  'c',  'o';
    'b09e',  '6',  'c',  'o' },  1;
    '2',  { 'b09e',  '10',  'c',  'o';
    'a01f',  '2',  'uc',  'o';
    'a06e',  '1',  'c',  'o' },  1;
    '3',  { 'b05e',  '24',  'c',  'o';
    'b09e',  '27',  'c',  'o';
    'a06e',  '1',  'c',  'o';
    'a08e',  '16',  'c',  'o';
    'a04f',  '3',  'uc',  'o' },  1;
    '4',  { 'b05e',  '17',  'c',  'o';
    'a03f',  '4',  'uc',  'o';
    'a06e',  '1',  'c',  'o';
    'a08e',  '16',  'c',  'o' },  1;
    '5',  { 'a07e',  '24',  'c',  'o';
    'a09e',  '17',  'c',  'o';
    'b01f',  '5',  'uc',  'o';
    'b10e',  '1',  'c',  'o' },  1;
    '6',  { 'a05e',  '10',  'c',  'o';
    'a07e',  '27',  'c',  'o';
    'b03f',  '6',  'uc',  'o';
    'b08e',  '29',  'c',  'o';
    'b10e',  '1',  'c',  'o' },  1;
    '7',  { 'b09e',  '10',  'c',  'o';
    'a01f',  '7',  'uc',  'o';
    'a10e',  '8',  'c',  'o';
    'b07e',  '9',  'c',  'o' },  1;
    '8',  { 'a05e',  '7',  'c',  'o';
    'a09e',  '20',  'c',  'o';
    'b05e',  '19',  'c',  'o';
    'b09e',  '15',  'c',  'o';
    'b07e',  '14',  'c',  'o' },  1;
    '9',  { 'a01f',  '9',  'uc',  'o';
    'a10e',  '14',  'c',  'o';
    'b06e',  '7',  'c',  'o';
    'b08e',  '12',  'c',  'o';
    'a06e',  '25',  'c',  'o';
    'b04f',  '9',  'uc',  'o' },  1;
    '10',  { 'a01f',  '10',  'uc',  'o';
    'a10e',  '15',  'c',  'o';
    'b03f',  '10',  'uc',  'o';
    'b06e',  '7',  'c',  'o';
    'b08e',  '12',  'c',  'o';
    'a06e',  '6',  'c',  'o';
    'b10e',  '2',  'c',  'o' },  1;
    '11',  { 'a05e',  '12',  'c',  'o';
    'a09e',  '13',  'c',  'o';
    'b09e',  '15',  'c',  'o';
    'b07e',  '14',  'c',  'o';
    'b02f',  '11',  'uc',  'o' },  1;
    '12',  { 'b09e',  '10',  'c',  'o';
    'a01f',  '12',  'uc',  'o';
    'a10e',  '11',  'c',  'o';
    'b07e',  '9',  'c',  'o';
    'b02f',  '12',  'uc',  'o';
    'a06e',  '29',  'c',  'o' },  1;
    '13',  { 'a10e',  '11',  'c',  'o';
    'b07e',  '23',  'c',  'o';
    'b02f',  '13',  'uc',  'o';
    'a03f',  '13',  'uc',  'o';
    'a06e',  '29',  'c',  'o' },  1;
    '14',  { 'a05e',  '9',  'c',  'o';
    'a09e',  '23',  'c',  'o';
    'b06e',  '8',  'c',  'o';
    'b08e',  '11',  'c',  'o';
    'b04f',  '14',  'uc',  'o' },  1;
    '15',  { 'a05e',  '10',  'c',  'o';
    'b03f',  '15',  'uc',  'o';
    'b06e',  '8',  'c',  'o';
    'b08e',  '11',  'c',  'o' },  1;
    '16',  { 'a07e',  '3',  'c',  'o';
    'a09e',  '4',  'c',  'o';
    'b05e',  '18',  'c',  'o';
    'b09e',  '21',  'c',  'o';
    'a02f',  '16',  'uc',  'o' },  1;
    '17',  { 'a10e',  '19',  'c',  'o';
    'b06e',  '20',  'c',  'o';
    'a03f',  '17',  'uc',  'o';
    'a06e',  '5',  'c',  'o';
    'a08e',  '18',  'c',  'o';
    'b01f',  '17',  'uc',  'o';
    'b10e',  '4',  'c',  'o' },  1;
    '18',  { 'a07e',  '24',  'c',  'o';
    'a09e',  '17',  'c',  'o';
    'b06e',  '22',  'c',  'o';
    'b01f',  '18',  'uc',  'o';
    'b10e',  '16',  'c',  'o';
    'a02f',  '18',  'uc',  'o' },  1;
    '19',  { 'a09e',  '17',  'c',  'o';
    'b06e',  '8',  'c',  'o';
    'b01f',  '19',  'uc',  'o' },  1;
    '20',  { 'b05e',  '17',  'c',  'o';
    'a10e',  '8',  'c',  'o';
    'b07e',  '23',  'c',  'o';
    'a03f',  '20',  'uc',  'o';
    'a08e',  '22',  'c',  'o' },  1;
    '21',  { 'a07e',  '27',  'c',  'o';
    'b03f',  '21',  'uc',  'o';
    'b06e',  '22',  'c',  'o';
    'b10e',  '16',  'c',  'o';
    'a02f',  '21',  'uc',  'o' },  1;
    '22',  { 'a07e',  '28',  'c',  'o';
    'a09e',  '20',  'c',  'o';
    'b05e',  '18',  'c',  'o';
    'b09e',  '21',  'c',  'o';
    'b07e',  '26',  'c',  'o';
    'a02f',  '22',  'uc',  'o' },  1;
    '23',  { 'a10e',  '14',  'c',  'o';
    'b06e',  '20',  'c',  'o';
    'b08e',  '13',  'c',  'o';
    'a03f',  '23',  'uc',  'o';
    'a06e',  '25',  'c',  'o';
    'a08e',  '26',  'c',  'o';
    'b04f',  '23',  'uc',  'o' },  1;
    '24',  { 'b06e',  '28',  'c',  'o';
    'a06e',  '5',  'c',  'o';
    'a08e',  '18',  'c',  'o';
    'b01f',  '24',  'uc',  'o';
    'b10e',  '3',  'c',  'o';
    'a04f',  '24',  'uc',  'o' },  1;
    '25',  { 'a05e',  '9',  'c',  'o';
    'a09e',  '23',  'c',  'o';
    'b08e',  '29',  'c',  'o';
    'b04f',  '25',  'uc',  'o' },  1;
    '26',  { 'a09e',  '23',  'c',  'o';
    'b06e',  '22',  'c',  'o';
    'a02f',  '26',  'uc',  'o';
    'b04f',  '26',  'uc',  'o' },  1;
    '27',  { 'b03f',  '27',  'uc',  'o';
    'b06e',  '28',  'c',  'o';
    'b08e',  '30',  'c',  'o';
    'a06e',  '6',  'c',  'o';
    'a08e',  '21',  'c',  'o';
    'b10e',  '3',  'c',  'o';
    'a04f',  '27',  'uc',  'o' },  1;
    '28',  { 'b05e',  '24',  'c',  'o';
    'b09e',  '27',  'c',  'o';
    'a08e',  '22',  'c',  'o';
    'a04f',  '28',  'uc',  'o' },  1;
    '29',  { 'a05e',  '12',  'c',  'o';
    'a07e',  '30',  'c',  'o';
    'a09e',  '13',  'c',  'o';
    'b09e',  '6',  'c',  'o';
    'b07e',  '25',  'c',  'o';
    'b02f',  '29',  'uc',  'o' },  1;
    '30',  { 'b09e',  '27',  'c',  'o';
    'b02f',  '30',  'uc',  'o';
    'a06e',  '29',  'c',  'o';
    'a04f',  '30',  'uc',  'o' },  1 };
