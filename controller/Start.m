% Start Script

% Author: Jonathon Kreska
% Version: 1.1
% Date: May 3, 2016
% Changelog:
%  1.0: Initial Release
%  1.1: Cleaned up code and Simplified

% Running this and selecting options will get the controllers ready for you

%% Clean-up
clear; close ALL; clc;

addpath('src') %Add functions to path

%% menu
disp('Menu 1=yes 0=no')
OFFLINE = logical(input('Running Offline? '));
ABSTRACTED = logical(input('Abstracted Scenario? '));
if ABSTRACTED
  START_EVENTS_ONLY = logical(input('Start Events Only? '));
else
  START_EVENTS_ONLY = false;
end
REGIONS_EXIST = logical(input('Are there regions? '));

%% Initialize

disp('Choose Scenario Name:')

if ~REGIONS_EXIST
  
  disp('1 = 4tasks2robots')
  disp('2 = 6tasks3robots')
  disp('3 = 10tasks3robots')
  disp('4 = 4tasksNoRegions1robot')
  disp('5 = 8tasksNoRegions1robot_rn')
  disp('6 = 16tasksNoRegions1robot_rn')

else
  
  disp('1 = 4tasks4regions')
  disp('2 = 4tasks9regions')
  disp('3 = 4tasks4regions1robot')
  disp('4 = 8tasks4Regions1robot')
  disp('5 = 8tasks9Regions1robot')
  disp('6 = 6tasks9regions')
  disp('7 = 6tasks9regions3robots')
  disp('8 = 10tasks9regions')
  disp('9 = 10tasks9regionsModular')
  disp('10 = 10tasks9regions3robots')
  disp('25 = 6tasks6regions')
  disp('32 = 6tasks9regions3')
  disp('24 = 12tasks9regions3robots')
  disp('78 = 14tasks9regions3robots')
  disp('0 = 8tasks9regions3robots')
  disp('56 = 6tasks9regions2robots')
  disp('40 = 4tasks2robots4regions')
  disp('41 = 4tasks2robots6regions')
  disp('42 = 4tasks2robots9regions')
  disp('50 = 6tasks2robots4regions')
  disp('51 = 6tasks2robots6regions')
  disp('52 = 6tasks2robots9regions')
  disp('60 = 8tasks2robots4regions')
  disp('61 = 8tasks2robots6regions')
  disp('62 = 8tasks2robots9regions')
end


choice = input('Choice: ','s'); %Get Scenario name from user

if ~REGIONS_EXIST
  if     choice == '1'
    foldName    = '4tasks2robots_rn';
    ABSfoldName = '4tasks2robotsABSTRACT_rn';
  elseif choice == '2'
    foldName    = '6tasks3robots_rn';
    ABSfoldName = '6tasks3robotsABSTRACT_rn';
  elseif choice == '3'
    foldName    = '10tasks3robots_rn';
    ABSfoldName = '10tasks3robotsABSTRACT_rn';
  elseif choice == '4'
    foldName    = '4tasksNoRegions1robot_rn';
    ABSfoldName = '4tasksNoRegions1robotABSTRACT_rn';
  elseif choice == '5'
    foldName    = '8tasksNoRegions1robot_rn';
    ABSfoldName = '8tasksNoRegions1robotABSTRACT_rn';
  elseif choice == '6'
    foldName    = '16tasksNoRegions1robot_rn';
    ABSfoldName = '16tasksNoRegions1robotABSTRACT_rn';
  else
    disp('You idiot! Try again!')
    a(0);
  end
  
INCREMENTAL = false;
  
elseif REGIONS_EXIST
  if     choice == '1'
    foldName    = '4tasks4regions_rn';
    ABSfoldName = '4tasks4regionsABSTRACT_rn';
  elseif choice == '2'
    foldName    = '4tasks9regions_rn';
    ABSfoldName = '4tasks9regionsABSTRACT_rn';
  elseif choice == '3'
    foldName = '4tasks4regions1robot_rn';
    ABSfoldName = '4tasks4regions1robotABSTRACT_rn';
  elseif choice == '4'
    foldName = '8tasks4Regions1robot_rn';
    ABSfoldName = '8tasks4Regions1robotABSTRACT_rn' ;
  elseif choice == '5'
    foldName = '8tasks9Regions1robot_rn';
    ABSfoldName = '8tasks9Regions1robotABSTRACT_rn' ;
  elseif choice == '6'
    foldName = '6tasks9regions_rn';
    ABSfoldName = '6tasks9regionsABSTRACT_rn' ;
  elseif choice == '7'
    foldName = '6tasks9regions3robots_rn';
    ABSfoldName = '6tasks9regions3robotsABSTRACT_rn'; 
    %INCREMENTAL = true;
  elseif choice == '8'
    foldName = '10tasks9regions_rn';
    ABSfoldName = '10tasks9regionsABSTRACT_rn'; 
    %INCREMENTAL = true;
  elseif choice == '9'
    foldName = '10tasks9regionsModular_rn';
    ABSfoldName = '10tasks9regionsABSTRACT_rn'; 
    %INCREMENTAL = true;    
  elseif choice == '10'
    foldName = '10tasks9regions3robots_rn';
    ABSfoldName = '10tasks9regions3robotsABSTRACT_rn';
  elseif choice == '25'
    foldName = '6tasks6regions_rn';
    ABSfoldName = '6tasks6regionsABSTRACT_rn';
  elseif choice == '32'
    foldName = '6tasks9regions3_rn';
    ABSfoldName = '6tasks9regions3ABSTRACT_rn';
  elseif choice == '0'
    foldName = '8tasks9regions3robots_rn';
    ABSfoldName = '8tasks9regions3robotsABSTRACT_rn';
   elseif choice == '24'
    foldName = '12tasks9regions3robots_rn';
    ABSfoldName = '12tasks9regions3robotsABSTRACT_rn';
  elseif choice == '78'
    foldName = '14tasks9regions3robots_rn';
    ABSfoldName = '14tasks9regions3robotsABSTRACT_rn';
   elseif choice == '56'
    foldName = '6tasks9regions2robots_rn';
    ABSfoldName = '6tasks9regions2robotsABSTRACT_rn';
    elseif choice == '40'
      foldName = '4tasks2robots4regions_rn';
      ABSfoldName = '4tasks2robots4regionsABSTRACT_rn';
  elseif choice == '41'
      foldName = '4tasks2robots6regions_rn';
      ABSfoldName = '4tasks2robots6regionsABSTRACT_rn';
  elseif choice == '42'
      foldName = '4tasks2robots9regions_rn';
      ABSfoldName = '4tasks2robots9regionsABSTRACT_rn';
  elseif choice == '50'
      foldName = '6tasks2robots4regions_rn';
      ABSfoldName = '6tasks2robots4regionsABSTRACT_rn';
  elseif choice == '51'
      foldName = '6tasks2robots6regions_rn';
      ABSfoldName = '6tasks2robots6regionsABSTRACT_rn';
  elseif choice == '52'
      foldName = '6tasks2robots9regions_rn';
      ABSfoldName = '6tasks2robots9regionsABSTRACT_rn';
  elseif choice == '60'
      foldName = '8tasks2robots4regions_rn';
      ABSfoldName = '8tasks2robots4regionsABSTRACT_rn';
  elseif choice == '61'
      foldName = '8tasks2robots6regions_rn';
      ABSfoldName = '8tasks2robots6regionsABSTRACT_rn';
  elseif choice == '62'
      foldName = '8tasks2robots9regions_rn';
      ABSfoldName = '8tasks2robots9regionsABSTRACT_rn';
  else
    disp('You idiot! Try again!')
    a(0);
  end
  

else
  disp('INVALID OPTIONS! Try again!')
  a(0);
  
end

time = datestr(datetime);
if ABSTRACTED
  fid = fopen(['../Logs/' ABSfoldName '_results_log_' time(1:11) '_' time(13:14) time(16:17) '.txt'],'w');
else
  fid = fopen(['../Logs/' foldName '_results_log_' time(1:11) '_' time(13:14) time(16:17) '.txt'],'w');
end

menuFlag = false;
while ~menuFlag
  menu = input('1 for single, 2 for batch: ','s');
  if strcmp(menu,'1')
    scenNumStart = input('Input Scenario Number: ','s'); %Get Scenario num from user
    scenNumFinish = scenNumStart;
    menuFlag = true;
  elseif strcmp(menu,'2')
    scenNumStart = input('Input Scenario Start Number: ','s'); %Get Scenario num from user
    scenNumFinish = input('Input Scenario Finish Number: ','s');
    menuFlag = true;
  else 
    menuFlag = false;
  end
end

runningScenario = str2double(scenNumStart);


% Algorithm choice section
algorithmFlag = false;
disp("What algorithm would you like to run this scenario with?")
disp("1 = Djikstra's algorithm")
disp('2 = Genetic algorithm')
disp('3 = Greedy algorithm')
disp('4 = ALNS (Adaptive Large Neighborhood Search)')

while ~algorithmFlag
    chosenAlgorithm = input('Choice: ','s');
    
    % Djikstra
    if strcmp(chosenAlgorithm, '1')
        algorithmFlag = true;
    % GA
    elseif strcmp(chosenAlgorithm, '2')
        algorithmFlag = true;
        population_size_1 = input('Enter population size: ');
        stop_cond_1 = input('Enter stop condition: ');
        max_rep_1 = input('Enter max repetitions: ');
        mutation_rate_1 = input('Enter mutation rate: ');
        num_repet = input('Enter number of repetitions: ');
    % Greedy
    elseif strcmp(chosenAlgorithm, '3')
        algorithmFlag = true;
    % ALNS
    elseif strcmp(chosenAlgorithm, '4')
        algorithmFlag = true;
    else
        disp('Please enter a valid algorithm choice')
    end  
end

% TODO: Handle batch for GA mono
if OFFLINE
        % Offline, djikstra 
    if strcmp(chosenAlgorithm, "1")
        run('just_calc_opt.m')
        % Offline, genetic algorithm, and single
    elseif strcmp(chosenAlgorithm, "2") && strcmp(menu, "1")
        run('monolithicGA.m')
        % Offline, genetic algorithm, and batch
    elseif strcmp(chosenAlgorithm, "2") && strcmp(menu, "2")
        run('TestGAMono.m')
        % Offline, monolithic
    elseif strcmp(chosenAlgorithm, "3")
        run('monolithicGreedy.m')
        % Offline, HLNS/ALNS
    elseif strcmp(chosenAlgorithm, "4")
        %Not sure?
        run('')
    end
end

if ~OFFLINE
    rosshutdown; %Shutdown MATLAB ros node if it exists
    
    wait = input(['Please load up scenario ' num2str(runningScenario) ', then press Enter']);
    
    if ABSTRACTED
        INCREMENTAL = logical(input('Incremental FSM? '));
    end
    
    % Online, dijkstra
    if strcmp(chosenAlgorithm, "1")
        if ABSTRACTED
            if INCREMENTAL
                run('Abs_reg_start_only_controller_modified_New.m')
            else
                run('Abs_reg_start_only_controller.m')
            end
        else       
            run('controller.m')
        end
    % Online, genetic algorithm
    elseif strcmp(chosenAlgorithm, "2")
        run('onlineGATasks.m')
    end
end