
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
  
  
  
  clear start_loc;
  
  for i=1:numRobots                              %Update Robot Locations
      robot{i} = updateLocations(robot{i});
      start_loc(i,1) = robot{i}.X;
      start_loc(i,2) = robot{i}.Y;
  end
  
abstracted = true;
start_events_only = true;  
 
  
    aux=1;
    act_state=1;% always start from the initial state
    i=1;
    n=1;
    j=1;
    num_path=16;

for j=1:num_path
    aux=1;
    act_state=1;% always start from the initial state
    i=1;
    n=1;
    while aux
        path_gen{j}(i)=act_state; %save at the state being analyzed
        if states{act_state,3} %verify if it is a marked state, if is then stop searching
            aux=0;
            break;
        end
        sz=size(states{act_state,2}); %between all the possible transitions from the state
        rng('shuffle');
        r = randi([1 sz(1,1)],1,1); %choose a random one
        next_state= states{act_state,2}(r,2); %save the state
        path_events{j}{i}= states{act_state,2}(r,1); %save the tansitions' event
        i=i+1;
        act_state=str2double(next_state);
    end
end

for i=1:length(path_gen)
    old_path_gen='';
    old_path_gen=path_gen{i};
    old_event_gen='';
    old_event_gen=path_events{i};
    path_gen{i}='';
    path_events{i}='';
    [path_gen{i},path_events{i}]=check_loops_fix_new(old_path_gen,old_event_gen); %remove the loops
    cost(1,i)=0;
    [cost(1,i),cost_trans{1}{i}]= path_cost(path_gen{i},path_events{i},start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);
    
end



num_rep=1;
num_spoint(num_rep)=0;
num_spoint(num_rep+1)=0;

rng('shuffle');
order=randperm(num_path);
for i=1:length(order)/2
    if cost(1,order(2*i-1))<cost(1,order(2*i))
        parents(i)=order(2*i-1);
    else
        parents(i)=order(2*i);
    end
end


%
tic
offspring='';
i_off=1;
ix=1;
realized_crossover=zeros(1,length(parents));
for i=1:length(parents)
    if ~realized_crossover(1,i)
        aux_2=9;
        parent_1='';
        parent_1=path_gen{parents(i)};
        kk=1;
        for x=i+1:length(parents)
            parent_2='';
            parent_2=path_gen{parents(x)};
            k=1;
            cross_point='';
            a=8;
            b=8;
            for j=2:length(parent_1)-1%looking for same point,that can't be start or finish node
                for m=j:length(parent_2)-1
                    aux_off=ismember({num2str(parent_2(m))},[states{parent_1(j),2}(:,2)]);
                    if aux_off %
                        aux_off_2= ismember({num2str(parent_1(j+1))},[states{parent_2(m-1),2}(:,2)]);
                        if aux_off_2
                            a=9;
                            break;
                        end
                    end
                    if a==9
                        break;
                    end
                end
                if a==9
                    break;
                end
            end
            if a==9%~isempty(cross_point)
                same_point(i,x)=1;
                same_point(x,i)=1;
                %cross{i}{kk}=cross_point;
                kk=kk+1;
                num_spoint(num_rep)=num_spoint(num_rep)+1;
                aux_2=8;
            else
                same_point(i,x)=0;
                same_point(x,i)=0;
            end
            
        end
        
        pos_partner='';
        pos_partner=find(same_point(i,:)==1);
        if ~isempty(pos_partner) %find chromosomes that has a crossover point
            rng('shuffle');
            idx_partner=randi([1 length(pos_partner)],1,1); %choose between the options a random one
            parent_2='';
            parent_2=path_gen{parents(pos_partner(idx_partner))};
            k=1;
            cross_point='';
            for j=2:length(parent_1)-1%looking for same point,that can't be start or finish node
                for m=j:length(parent_2)-1
                    aux_off=ismember({num2str(parent_2(m))},[states{parent_1(j),2}(:,2)]);
                    if aux_off %
                        aux_off_2= ismember({num2str(parent_1(j+1))},[states{parent_2(m-1),2}(:,2)]);
                        if aux_off_2
                            cross_point{k}{1}=j;
                            cross_point{k}{2}=m-1;
                            for t=1:length(states{parent_1(j),2}(:,2))
                                if parent_2(m)==str2num(states{parent_1(j),2}{t,2})
                                    cross_point{k}{3}= states{parent_1(j),2}{t,1};
                                end
                            end
                            for t=1:length(states{parent_2(m-1),2}(:,2))
                                if parent_1(j+1)==str2num(states{parent_2(m-1),2}{t,2})
                                    cross_point{k}{4}= states{parent_2(m-1),2}{t,1};
                                end
                            end
                            k=k+1;
                        end
                    end
                end
            end
            %now I have all crossover points between the selected chromosomes
            rng('shuffle') %I choose a random crossover point
            idx=randi([1 length(cross_point)]);
            offspring{i_off}=[parent_1(1:cross_point{idx}{1}),parent_2(cross_point{idx}{2}+1:end)];
            offspring_event{i_off}={path_events{parents(i)}{1:cross_point{idx}{1}-1},{cross_point{idx}{3}},path_events{parents(pos_partner(idx_partner))}{cross_point{idx}{2}+1:end}};
            offspring{i_off+1}=[parent_2(1:cross_point{idx}{2}),parent_1(cross_point{idx}{1}+1 :end)];
            offspring_event{i_off+1}={path_events{parents(pos_partner(idx_partner))}{1:cross_point{idx}{2}-1},{cross_point{idx}{4}},path_events{parents(i)}{cross_point{idx}{1}+1:end}};
            i_off=i_off+1;
            realized_crossover(1,i)=1; %mark as the chromosome has already be matched
            ix=ix+1;
            realized_crossover(1,parents(pos_partner(idx_partner)))=1;
            ix=ix+1;
        else % chromosome hasn't any match
            offspring{i_off}=parent_1; % I create a copy of it
            offspring_event{i_off}=path_events{parents(i)};
            i_off=i_off+1;
            realized_crossover(1,i)=1;
            ix=ix+1;
        end
    end
      
end
    
