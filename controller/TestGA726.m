clear all;
rosshutdown;
rosinit('localhost');

run(['fsmdata.m']);
%run(['../FSMs/' foldName '/userdata' num2str(runningScenario) '.m']);
run(['userdata14.m']);

  for i=1:numRobots                              %Setup Each Robot
    robot{i} = struct;
    robot{i} = setupRobot(robot{i},i);   % i-1 because Stage starts with robot_0
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
  clear start_loc;

  pause(.5)                                       %Wait for roscore to handshake
  disp('Setup complete!')

  %% Setup

  try                                            %Test to see if Stage is Running
    robot{1} = updateLocations(robot{1});
  catch ME
    disp('Is Stage running?')
    rethrow(ME)
  end

  for i=1:numRobots                              %Update Robot Locations
    robot{i} = updateLocations(robot{i});
    start_loc(i,1) = robot{i}.X;
    start_loc(i,2) = robot{i}.Y;
  end

  
  abstracted = true;
  start_events_only = true;
  abstracted=1;
  start_events_only=1;

cost=[];
num_paths=32; %number of paths to be generated
for j=1:num_paths
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
        if sz>1 % a state with more than one path to choose
            divergent_states{j}(n)=act_state;
            idx_divergent_state{j}(n)=i;
            n=n+1;
        end
        r = randi([1 sz(1,1)],1,1); %choose a random one
        next_state= states{act_state,2}(r,2); %save the state
%         path_events{j}{i}= states{act_state,2}(r,1); %save the tansitions' event
        i=i+1;
        act_state=str2double(next_state);
    end
end
aux_dup=0;
%check if there are loops in the path
for i=1:length(path_gen)
     old_path_gen='';
        old_path_gen=path_gen{i};
        path_gen{i}='';
        path_gen{i}=check_loops_fix(old_path_gen); %remove the loops
end

%now, we have paths without loops

for i=1:length(path_gen)

    cost(1,i)=0;
    robotLocation=[];
    cost_robot=[];
    cost_robot=zeros(numRobots,1);
    for j=1:length(path_gen{i})-1
        act_state=path_gen{i}(j);

        
        if j==1
            for i_r = 1:numRobots
                robotLocation{act_state,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
            end
        end
        sz=size(states{act_state,2}); %between all the possible transitions from the state
        for m=1:sz(1,1)
            aux_1=string(path_gen{i}(j+1));
            aux_2=states{act_state,2}{m,2};
            if aux_1==aux_2
                path_events{i}{j}=states{act_state,2}(m,1);
                event_bot = path_events{i}{j}{1,1}(1)-96;
                [transition_cost,~,new_X,new_Y] = ...
                calcTransitionCost(path_events{i}{j}{1,1},act_state,str2double(aux_2),path_gen{i},states,tasks,0,regions,numRegions,start_loc,...
                    numTasks,abstracted,start_events_only,robotLocation{act_state,event_bot},robot_tasks,0);
                for i_rob=1:numRobots
                    if event_bot==i_rob
                        cost_robot(i_rob)=cost_robot(i_rob)+transition_cost;
                    end
                end
                robotLocation{str2double(aux_2),event_bot} = [new_X,new_Y];
                break;
            end
        end
    end
    cost(1,i)=max(cost_robot);
end
%find the events
% for i=1:num_paths
%     %         fit_values(i)=path_total_cost(path_events{1,i});
%     [cost(1,i),fit_values_A(i),fit_values_B(i),fit_values_C(i)]=path_total_cost(path_events{1,i});
% end

[fit_values_rn{1}, idx_fit_aux{1}]=sort(cost(1,:));

best_plan(1)=fit_values_rn{1}(1);
aux_same_result=0;
num_rep=2;

while num_rep<=100 && aux_same_result<=15

    num_spoint(num_rep)=0;
    num_sparent(num_rep)=0;
    %parents selection through tournament 2X2
    order=randperm(num_paths);
    for i=1:length(order)/2
        if cost(1,order(2*i-1))<cost(1,order(2*i))
            parents(i)=order(2*i-1);
        else
            parents(i)=order(2*i);
        end
    end
    
    %crossover
    offspring='';
    
    for i=1:length(parents)/2
        parent_1=path_gen{parents(2*i-1)};
        parent_2=path_gen{parents(2*i)};
        k=1;
        cross_point='';
        
        for j=2:length(parent_1)-1%looking for same point,that can't be start or finish node
            for m=2:length(parent_2)-1
                if parent_1(j)==parent_2(m)
                    cross_point{k}(1)=j;
                    cross_point{k}(2)=m;
                    k=k+1;
                end
            end
        end
        if ~isempty(cross_point)
            idx=randi([1 length(cross_point)]);
            offspring{2*i-1}=[parent_1(1:cross_point{idx}(1)),parent_2(cross_point{idx}(2)+1:end)];
            offspring{2*i}=[parent_2(1:cross_point{idx}(2)),parent_1(cross_point{idx}(1)+1:end)];
            num_spoint(num_rep)=num_spoint(num_rep)+1;
        else
            offspring{2*i-1}=parent_1;
            offspring{2*i}= parent_2;
            num_sparent(num_rep)=num_sparent(num_rep)+1;
        end
    end
    
    %mutation
    mutation_rate=0.4;
    mutation_idx_max=ceil(length(offspring)*mutation_rate);
    mutation_idx_total=randperm(length(offspring));
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
    
    for i=1:length(mutation_idx)
        mut_off='';
        mut_off=offspring{mutation_idx(i)};
        idx_mut=randi([1 length(mut_off)]);
        node_mut=mut_off(idx_mut);
        offspring{mutation_idx(i)}='';
        offspring{mutation_idx(i)}=mut_off(1:idx_mut-1);
        aux=1;
        act_state=node_mut;% always start from the initial state
        ind=idx_mut;
        while aux
            offspring{mutation_idx(i)}(ind)=act_state; %save at the state being analyzed
            if states{act_state,3} %verify if it is a marked state, if is then stop searching
                aux=0;
                break;
            end
            sz=size(states{act_state,2}); %between all the possible transitions from the state
            %           if sz>1 % a state with more than one path to choose
            %               divergent_states{j}(n)=act_state;
            %               idx_divergent_state{j}(n)=i;
            %               n=n+1;
            %           end
            r = randi([1 sz(1,1)],1,1); %choose a random one
            next_state= states{act_state,2}(r,2); %save the state
            %path_events{j}{i}= states{act_state,2}(r,1); %save the tansitions' event
            ind=ind+1;
            act_state=str2double(next_state);
        end
        
    end

    for i=1:length(offspring)
        old_offspring='';
        old_offspring=offspring{i};
        offspring{i}='';
        offspring{i}=check_loops_fix(old_offspring);
    end
    
    
    
    
    path_gen_old='';
    path_gen_old=path_gen;
    path_gen='';
    path_events_old='';
    path_events_old=path_events;
    path_events='';
%     for i=1:length(parents)
%         path_gen{i}=path_gen_old{parents(i)}; %copy parents to the new population
%         path_events{i}=path_events_old{parents(i)};
%     end
    max_path=length(path_gen_old);
     for i=1:length(offspring)
         path_gen_old{max_path+i}=offspring{i};
    end
    %check the path of events for offsprings
    
    for i=1:length(offspring)
        cost_off(1,i)=0;
        robotLocation=[];
        cost_robot=[];
        cost_robot=zeros(numRobots,1);
        for j=1:length(offspring{i})-1
            act_state=offspring{i}(j);
            sz=size(states{act_state,2}); %between all the possible transitions from the state
            if j==1
                for i_r = 1:numRobots
                    robotLocation{act_state,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
                end
            end
            for m=1:sz(1,1)
                aux_1=string(offspring{i}(j+1));
                aux_2=states{act_state,2}{m,2};
                if aux_1==aux_2
                    path_events_old{max_path+i}{j}=states{act_state,2}(m,1);
                    event_bot = path_events_old{max_path+i}{j}{1,1}(1)-96;
                    [transition_cost,~,new_X,new_Y] = ...
                        calcTransitionCost(path_events_old{max_path+i}{j}{1,1},act_state,str2double(aux_2),path_gen_old{max_path+i},states,tasks,0,regions,numRegions,start_loc,...
                        numTasks,abstracted,start_events_only,robotLocation{act_state,event_bot},robot_tasks,0);
                    for i_rob=1:numRobots
                        if event_bot==i_rob
                            cost_robot(i_rob)=cost_robot(i_rob)+transition_cost;
                        end
                    end
                    robotLocation{str2double(aux_2),event_bot} = [new_X,new_Y];
                    break;
                end
            end
        end
        cost_off(1,i)=max(cost_robot);
    end
    
    cost_aux=[cost cost_off];
        
    
%     for i=1:length(path_events_old)
%                 fit_values(i)=path_total_cost(path_events{1,i});
%         [cost_aux(num_rep,i),fit_aux_values_A(i),fit_aux_values_B(i),fit_aux_values_C(i)]=path_total_cost(path_events_old{1,i});
%     end
    
    [fit_values_rn_aux{num_rep}, idx_fit_aux_2{num_rep}]=sort(cost_aux);
    cost=[];
    for i=1:num_paths
        path_gen{i}=path_gen_old{idx_fit_aux_2{num_rep}(i)};
        path_events{i}=path_events_old{idx_fit_aux_2{num_rep}(i)};
        cost(1,i)=cost_aux(idx_fit_aux_2{num_rep}(i));
    end
    
    

    
    [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(cost);
    
    if fit_values_rn{num_rep}(1)==best_plan(num_rep-1)
        aux_same_result=aux_same_result+1;
        best_plan(num_rep)=best_plan(num_rep-1);
    else
        aux_same_result=0;
        if fit_values_rn{num_rep}(1)< best_plan
            best_plan(num_rep)=fit_values_rn{num_rep}(1);
        end
    end
    
    num_rep=num_rep+1;
end

plan=path_events{idx_fit_aux{num_rep-1}(1)};
plan_state=path_gen{idx_fit_aux{num_rep-1}(1)};