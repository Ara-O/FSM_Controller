clear all;
rosshutdown;
rosinit('localhost');

addpath('src') %


foldName = '10tasks9regions3robots_rn';
ABSfoldName='10tasks9regions3robotsABSTRACT_rn';
runningScenario=12;
  % Alter menu options to run local Dijkstra
  
  run(['../FSMs/' ABSfoldName '/userdata' num2str(runningScenario) '.m'])       %Import userdata from FSM GUI
  run(['../FSMs/' ABSfoldName '/fsmdata.m'])       %Import FSM data from FSM GUI
  run(['../FSMs/' foldName '/fsmdataIncremental.m'])

[~,num_fsms] = size(states);
%NEED TO REMOVE THIS LATER
EEC = 0;

  for i=1:numRobots                              %Setup Each Robot
    robot{i} = struct;
    robot{i} = setupRobot(robot{i},i-1);   % i-1 because Stage starts with robot_0
    %Movebase fixes
    robot{i}.old_goal_X = 666;
    robot{i}.old_goal_Y = 666;
    robot_previous_location_x(i)=666;
    robot_previous_location_y(i)=666;
    goal_need_resend(i)=0;
    robot_change_count(i)=0;
    robot{i}.first_time = true; % Quarter goal flow control 
    robot{i}.calc_region = true;
    robot{i}.next_event = 's';
    robot{i}.next_reg = []; %fixes: Reference to non-existent field 'next_reg'.
    
    goal{i} = [];                                %Initialize goal to nothing
    robot{i}.cur_task = '';                      %Initialize cur_task to empty
  end
  
  robot_tasks=0;
  step_through_final = false;
  step_through_local = false;
  init_cost = zeros(1,numRobots);
  


  pause(.5)                                       %Wait for roscore to handshake
  disp('Setup complete!')

  %% Setup

  try                                            %Test to see if Stage is Running
    robot{1} = updateLocations(robot{1});
  catch ME
    disp('Is Stage running?')
    rethrow(ME)
  end

pop_size=[4;8;16;32;48;64];
mut_rate=[0.1;0.2;0.4;0.6];
stop_cond=[5;10;15;20;25;30];

i_t=1;

% i_pop=4;
% i_rate=1;
% i_stop=1;

for i_pop=1:length(pop_size)
    for i_rate=1:length(mut_rate)
        for i_stop=1:length(stop_cond)

            t_total=tic;
            t_pop=tic;
            event_path = [];
            cur_states = initial_state_incr;
            state_path = cur_states;
            
            
            population_size_1=pop_size(i_pop);
            max_rep_1=100;
            mutation_rate_1=mut_rate(i_rate);
            stop_cond_1=stop_cond(i_stop);
            
            num_rep=10;
            
            time = datestr(datetime);
            
            table(i_t,1)=population_size_1;
            table(i_t,2)=mutation_rate_1;
            table(i_t,3)=stop_cond_1;
            
            for i_rep=0:2:2
               
            
                for i_num=1:num_rep
                    
                    
                    
                    clear start_loc;
                    
                    for i=1:numRobots                              %Update Robot Locations
                        robot{i} = updateLocations(robot{i});
                        start_loc(i,1) = robot{i}.X;
                        start_loc(i,2) = robot{i}.Y;
                    end
                    
                    %global_state_path
                    
                    
                    
                    
                    tic
                    [ABS_event_path_1{i_num},ABS_state_path{i_num},ABS_plan_cost(i_num)] = GA_abstract(population_size_1,max_rep_1,mutation_rate_1,stop_cond_1,states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks);
                    t_abs(i_num)=toc;
                    
                end
                table(i_t,4+i_rep)= mean(t_abs);
                table(i_t,5+i_rep)=mean(ABS_plan_cost);
                
%                      clear start_loc; % delete cell matrix locations from GUI
%                 
%                      Get locations again
%                      for i=1:numRobots                              %Update Robot Locations
%                          robot{i} = updateLocations(robot{i});
%                          start_loc(i,1) = robot{i}.X;
%                          start_loc(i,2) = robot{i}.Y;
%                      end
%                 
%                      population_size_2=16;
%                      max_rep_2=150;
%                      mutation_rate_2=0.1;
%                      stop_cond_2=10;
%                 
%                      tic
%                      [INCR_event_path{i_num},INCR_state_path{i_num},INCR_plan_cost(i_num)] = GA_incremental(population_size_2,max_rep_2,mutation_rate_2,stop_cond_2,robot_tasks,initial_state_incr,states_incr,events_incr,start_loc,regions,numRegions,tasks,numTasks,numRobots);
%                      t_incr(i_num)=toc;

                %
            end
%         end
%             
%             
% 
%             table_aux(1,1)=population_size_1;
%             table_aux(1,2)=mutation_rate_1;
%             table_aux(1,3)=stop_cond_1;
%             table_aux_2=[table_aux ABS_plan_cost];
%             table_aux=[table_aux t_abs];
%             table_2(i_t,:)=table_aux;
%             table_2(i_t+1,:)=table_aux_2;
            
            i_t=i_t+1;
            
            
%             fid = fopen(['../LogsGA/' ABSfoldName '/' ABSfoldName '_results_log_' time(1:11) '_' time(13:20) '_PS' num2str(population_size_1) '_MR' num2str(mutation_rate_1) '_SC' num2str(stop_cond_1)  '.txt'],'w');
%             
%             fprintf(fid,'Abstract Genetic Algorithm \n');
%             fprintf(fid,' \n');
%             fprintf(fid,'Variable Values: \n');
%             fprintf(fid,'Population size: %f \n', population_size_1);
%             fprintf(fid,'Mutation Rate: %f \n', mutation_rate_1);
%             fprintf(fid,'Max Repetition: %f \n', max_rep_1);
%             fprintf(fid,'Stop Condition (# same result): %f \n', stop_cond_1);
%             fprintf(fid,' \n');
%             fprintf(fid,'Optimization time: \n ');
%             for i=1:num_rep
%                 fprintf(fid,'%f ', t_abs(i));
%             end
%             fprintf(fid,' \n');
%             
%             fprintf(fid,'Optimization values: \n');
%             for i=1:num_rep
%                 fprintf(fid,'%f ', ABS_plan_cost(i));
%             end
%             fprintf(fid,' \n');
%             fprintf(fid,'Optimization plan events: \n');
%             for i=1:num_rep
%                 fprintf(fid,'Plan %s :',num2str(i));
%                 for j=1:length(ABS_event_path_1{i})
%                     fprintf(fid,'%s ', ABS_event_path_1{i}{j}{1});
%                 end
%                 fprintf(fid,' \n');
%             end
%             fprintf(fid,' \n');
%             
%             fprintf(fid,'Optimization plan states: \n');
%             for i=1:num_rep
%                 fprintf(fid,'Plan State %s : \n',num2str(i));
%                 for j=1:length(ABS_state_path{i})
%                     fprintf(fid,'%s ', num2str(ABS_state_path{i}(j)));
%                 end
%                 fprintf(fid,'\n');
%             end
%             fprintf(fid,'\n');
%             fprintf(fid,'\n');
            
            %  fprintf(fid,'Incremental Genetic Algorithm \n');
            %  fprintf(fid,'Variable Values: \n');
            %  fprintf(fid,'Population size: %f \n', population_size_2);
            %  fprintf(fid,'Mutation Rate: %f \n', mutation_rate_2);
            %  fprintf(fid,'Max Repetition: %f \n', max_rep_2);
            %  fprintf(fid,'Stop Condition (# same result): %f \n', stop_cond_2);
            %  fprintf(fid,' \n');
            %
            %  fprintf(fid,'Optimization time: \n ');
            %  for i=1:num_rep
            %      fprintf(fid,'%f ', t_incr(i));
            %  end
            %
            %  fprintf(fid,' \n');
            %
            %  fprintf(fid,'Optimization values: \n');
            %  for i=1:num_rep
            %      fprintf(fid,'%f ', INCR_plan_cost(i));
            %  end
            %
            %  fprintf(fid,' \n');
            %  fprintf(fid,'Optimization plan events: \n');
            %  for i=1:num_rep
            %      fprintf(fid,'Plan %s :',num2str(i));
            %      for j=1:length(INCR_event_path{i})
            %          fprintf(fid,'%s ', INCR_event_path{i}(j,:));
            %      end
            %      fprintf(fid,' \n');
            %  end
            %
            %  fprintf(fid,' \n');
            %  fprintf(fid,'Optimization plan states: \n');
            %  for i=1:num_rep
            %      fprintf(fid,'Plan State %s : \n',num2str(i));
            %      for j=1:length(INCR_state_path{i})
            %          for k=1:length(INCR_state_path{i}(j,:))
            %              fprintf(fid,'%s ,', num2str(INCR_state_path{i}{j,k}));
            %          end
            %          fprintf(fid,'\n');
            %      end
            %      fprintf(fid,'\n');
            %  end
%             fprintf(fid,'\n');
%             fclose(fid);
        
        end
    
    end
    
end

csvwrite(['../LogsGA/' ABSfoldName 'scenario_' num2str(runningScenario) '_rep_' num2str(num_rep) '_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '.csv'],table);
csvwrite(['../LogsGA/' ABSfoldName 'scenario_' num2str(runningScenario) '_rep_' num2str(num_rep) '_results_log_' time(1:11) '_' time(13:14) '_' time(16:17) '_full' '.csv'],table_2);       