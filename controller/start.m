% Start Script

% Author: Eyiara Oladipo
% Version: 1.1
% Date: July 4, 2024

% Changelog:
%  1.0: Initial Release
%  1.1: Cleaned up code and Simplified
%  1.2: Updated the codebase

% Running this and selecting options will get the controllers ready for you

%% Clean-up
clear; close ALL; clc;

addpath('src') %Add functions to path

%% menu
disp('Menu 1=yes 0=no')
OFFLINE = ~logical(input('Running with simulation? '));
ABSTRACTED = logical(input('Abstracted Scenario? '));
if ABSTRACTED
    START_EVENTS_ONLY = logical(input('Start Events Only? '));
else
    START_EVENTS_ONLY = false;
end
REGIONS_EXIST = logical(input('Are there regions? '));

%% Initialize


default_scenario = logical(input('Would you like to select a default scenario: '));

if default_scenario
    
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
        disp('11 = 6tasks6regions')
        disp('12 = 6tasks9regions3')
        disp('13 = 12tasks9regions3robots')
        disp('14 = 14tasks9regions3robots')
        disp('15 = 8tasks9regions3robots')
        disp('16 = 6tasks9regions2robots')
        disp('17 = 4tasks2robots4regions')
        disp('18 = 4tasks2robots6regions')
        disp('19 = 4tasks2robots9regions')
        disp('20 = 6tasks2robots4regions')
        disp('21 = 6tasks2robots6regions')
        disp('22 = 6tasks2robots9regions')
        disp('23 = 8tasks2robots4regions')
        disp('24 = 8tasks2robots6regions')
        disp('25 = 8tasks2robots9regions')
        disp('0 = test')
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
            disp('Try again!')
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
        elseif choice == '11'
            foldName = '6tasks6regions_rn';
            ABSfoldName = '6tasks6regionsABSTRACT_rn';
        elseif choice == '12'
            foldName = '6tasks9regions3_rn';
            ABSfoldName = '6tasks9regions3ABSTRACT_rn';
        elseif choice == '13'
            foldName = '8tasks9regions3robots_rn';
            ABSfoldName = '8tasks9regions3robotsABSTRACT_rn';
        elseif choice == '14'
            foldName = '12tasks9regions3robots_rn';
            ABSfoldName = '12tasks9regions3robotsABSTRACT_rn';
        elseif choice == '15'
            foldName = '14tasks9regions3robots_rn';
            ABSfoldName = '14tasks9regions3robotsABSTRACT_rn';
        elseif choice == '16'
            foldName = '6tasks9regions2robots_rn';
            ABSfoldName = '6tasks9regions2robotsABSTRACT_rn';
        elseif choice == '17'
            foldName = '4tasks2robots4regions_rn';
            ABSfoldName = '4tasks2robots4regionsABSTRACT_rn';
        elseif choice == '18'
            foldName = '4tasks2robots6regions_rn';
            ABSfoldName = '4tasks2robots6regionsABSTRACT_rn';
        elseif choice == '19'
            foldName = '4tasks2robots9regions_rn';
            ABSfoldName = '4tasks2robots9regionsABSTRACT_rn';
        elseif choice == '20'
            foldName = '6tasks2robots4regions_rn';
            ABSfoldName = '6tasks2robots4regionsABSTRACT_rn';
        elseif choice == '21'
            foldName = '6tasks2robots6regions_rn';
            ABSfoldName = '6tasks2robots6regionsABSTRACT_rn';
        elseif choice == '22'
            foldName = '6tasks2robots9regions_rn';
            ABSfoldName = '6tasks2robots9regionsABSTRACT_rn';
        elseif choice == '23'
            foldName = '8tasks2robots4regions_rn';
            ABSfoldName = '8tasks2robots4regionsABSTRACT_rn';
        elseif choice == '24'
            foldName = '8tasks2robots6regions_rn';
            ABSfoldName = '8tasks2robots6regionsABSTRACT_rn';
        elseif choice == '25'
            foldName = '8tasks2robots9regions_rn';
            ABSfoldName = '8tasks2robots9regionsABSTRACT_rn';
        elseif choice == '0'
            foldName = 'test';
            ABSfoldName = 'test';
        else
            disp('Invalid Option! Try again!')
            a(0);
        end
        
        
    else
        disp('INVALID OPTIONS! Try again!')
        a(0);
        
    end
else
    validFoldName = false;
    while ~validFoldName
        num_tasks = input('Number of tasks? ', 's');
        num_robots = input('Number of robots? ', 's');
        num_regions = input('Number of regions? ', 's');
        
        foldName = [num_tasks 'tasks' num_robots 'robots' num_regions 'regions_rn'];
        ABSfoldName =  [num_tasks 'tasks' num_robots 'robots' num_regions 'regionsABSTRACT_rn'];
        
        if ~exist(foldName, 'dir')
            disp(['The folder ' foldName ' does not exist, please try again']);
        elseif ~exist(ABSfoldName, 'dir')
            disp(['The folder ' ABSfoldName ' does not exist, please try again']);
        else
            validFoldName = true;
        end
    end
end

INCREMENTAL = false;

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
        rateW = input('Enter reaction factor: ');
        segment = input('Enter segment size: ');
        stopCond = input('Enter stop condition: ');
    else
        disp('Please enter a valid algorithm choice')
    end
end

% TODO: Handle batch for GA mono
if OFFLINE
    % Offline, djikstra
    if strcmp(chosenAlgorithm, "1")
        run('offline_djikstra.m')
        % Offline, genetic algorithm, and single
    elseif strcmp(chosenAlgorithm, "2") && strcmp(menu, "1")
        run('offline_ga.m')
        % Offline, genetic algorithm, and batch
    elseif strcmp(chosenAlgorithm, "2") && strcmp(menu, "2")
        run('offline_ga_batch.m')
        % Offline, greedy
    elseif strcmp(chosenAlgorithm, "3")
        run('offline_greedy.m')
        % Offline, HLNS/ALNS
    elseif strcmp(chosenAlgorithm, "4")
        %Not sure
        run('offline_hlns.m')
    end
end

if ~OFFLINE
    %rosshutdown; %Shutdown MATLAB ros node if it exists
    
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
        % Online, greedy
    elseif strcmp(chosenAlgorithm, "3")
        run('TestGATasks.m')
    end
end