clear all;
rosshutdown;
rosinit('localhost');

run("fsmdataIncremental.m");
run("fsmdata.m");
run(['userdata14.m']);


  % Alter menu options to run local Dijkstra
  abstracted = false;
  start_events_only = false;
total_cost_time=0;
total_trans_list_time=0;
total_pos_trans_time=0;
total_force_start_events_time=0;
total_update_event_time = 0;
total_create_event_path_time = 0;
total_satisf_path_time = 0;
num_eval=0;
[~,num_fsms] = size(states);
%NEED TO REMOVE THIS LATER
EEC = 0;



t_total=tic;
t_pop=tic;
event_path = [];
cur_states = initial_state_incr;
state_path = cur_states;

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

%global_state_path

abstracted = true;
start_events_only = true;
abstracted=1;
start_events_only=1;
tic
[ABS_event_path_1,ABS_state_path,ABS_plan_cost] = GA_abstract(states,abstracted,start_events_only,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks);
t=toc;

 clear start_loc; % delete cell matrix locations from GUI
  
  % Get locations again
  for i=1:numRobots                              %Update Robot Locations
      robot{i} = updateLocations(robot{i});
      start_loc(i,1) = robot{i}.X;
      start_loc(i,2) = robot{i}.Y;
  end
  
  % Alter menu options to run local Dijkstra
  abstracted = false;
  start_events_only = false;
  
  [~,num_fsm] = size(states_incr);
  
  a=0;
  event_list = createEventFsmList(events_incr,num_fsm);
  
  num_paths=64; %number of paths to be generated
  n=1;
  event_path = [];
  cur_state = initial_state_incr;
  state_path = cur_state;
  
  
  [~,num_fsm] = size(states_incr);
  
  
  event_list = createEventFsmList(events_incr,num_fsm);
  
  % Initializes robot tasks for edge cases
  % Catches bug where a robot is not assigned a task initially
  
  temp_tasks = false(1,numRobots);
  
  
  ABS_pc = 1;                     %Initialize path counter to be first element of path
  event_bot = 0;

  ABS_event_path = calcEventPath(states,ABS_pc,ABS_state_path);   %Create event path
   

for j=1:num_paths
    iTable = NaN(n,1);  % cost table
    minCost = Inf(n,1);
    isSettled = false(n,1);
    path = num2cell(NaN(n,1));
    botTable = NaN(n,numRobots);  % Individual robot costs matrix
    %I = cur_state(k);
    I = 1;
    %minCost(I) = max(init_cost);  % I'm pretty sure it's max...
    %iTable(I) = max(init_cost);
    %botTable(I,:) = init_cost;
    minCost(I) = 0;
    iTable(I) = 0;
    botTable(I,:) = 0;
    isSettled(I) = true;
    path(I) = {I};
    next_event = 'init';
    robotLocation = num2cell(NaN(n,numRobots));
    cost(1,j)=0;

    cost_robot=[];
    cost_robot=zeros(numRobots,1);
    event_path{j}=[];
 
  % Sets up the robots initial locations
  for i = 1:numRobots
      robotLocation{1,i} = [start_loc(i,1) start_loc(i,2)];
  end
  
  trans_mat = cell.empty;
  trans_mat{1} = cur_state;
  
  i=1;
  event_list = createEventFsmList(events_incr,num_fsms);
    while a==0
        if i==1
            for i_r = 1:numRobots
                robotLocation{i,i_r} = [start_loc(i_r,1) start_loc(i_r,2)]; %cur_state vs 1
            end
            path(i)={i};
            state_path{j}=initial_state_incr;
        end
        
    jTable = iTable;  % Jtable is temporary to hold calculations
    iTable(I) = NaN;
    
    %cur_state = trans_mat{I,1};
    
    if(I == 126)
      disp('1')
    end

    transition_list = createTransitionList(states_incr,cur_state,num_fsms);
    

    possible_transitions = findPossibleTransitions(transition_list,event_list);
    

%     [possible_transitions] = forceStartEvents(path{I},possible_transitions,trans_mat);
    
    num_transitions = size(possible_transitions);
    
     num_eval=num_eval+num_transitions(1);
       
        
     if detectEndState(cur_state,states_incr,num_fsm)
         a=1;
         break; %Exit  LOOP
     end %
     num_events=length(possible_transitions);
     next_event_idx=randi([1 num_events]);
     
     next_event=possible_transitions{next_event_idx,1};
     pos_cur_states = updateCurEvent(next_event,cur_state,events_incr,states_incr,num_fsm);
        aux=0;
        for k=1:i
            loop=strcmp(state_path{j}(k,:),pos_cur_states);
            if sum(loop)==num_fsm %equal state
                aux=1;
                u=k;
                break;
            end  
        end
        if aux==1%remove loop 
            if u<i-1
                %ju=state_path{j};
                state_path{j}(u+1:i,:)=[];
                i=u;
                %pause;
            end
        end
        if aux==0
            trans_mat{end+1,1} = pos_cur_states;
            trans_mat{end,2} = next_event;
            [index,~] = size(trans_mat);
            J=index;
            path{end+1}=i+1;
            event_bot = next_event(1)-96;
%             [transition_cost,~,new_X,new_Y] = ...
%                 calcTransitionCostGA(next_event,I,J,path{I},trans_mat,tasks,EEC,regions,numRegions,start_loc,...
%                 numTasks,abstracted,start_events_only,robotLocation{I,event_bot},robot_tasks,1);
%                 for i_rob=1:numRobots
%                     if event_bot==i_rob
%                         cost_robot(i_rob)=cost_robot(i_rob)+transition_cost;
%                     end
%                 end
                i=i+1;
%                 robotLocation{i,event_bot} = [new_X,new_Y];
            cur_state=pos_cur_states;
            state_path{j} = [state_path{j};cur_state];
            event_path{j} = [event_path{j};next_event];

            
        end
    end
    cost(1,j)=max(cost_robot);
end

% for i=1:num_paths
%     %         fit_values(i)=path_total_cost(path_events{1,i});
%     [cost(1,i),fit_values_A(i),fit_values_B(i),fit_values_C(i)]=path_total_cost__21_07(event_path{i});
% end

[fit_values_rn{1}, idx_fit_aux{1}]=sort(cost(1,:));
best_plan(1)=fit_values_rn{1}(1);
aux_same_result=0;
num_rep=2;

t_end_pop=toc(t_pop);
t_evol=tic;
while num_rep<=100 && aux_same_result<=20

    num_spoint(num_rep)=0;
    num_sparent(num_rep)=0;
    %parents selection through tournament 2X2
    order=randperm(num_paths);
    for i=1:length(order)/2
        if cost(num_rep-1,order(2*i-1))<cost(num_rep-1,order(2*i))
            parents(i)=order(2*i-1);
        else
            parents(i)=order(2*i);
        end
    end
    
    %crossover
    offspring='';
    
    for i=1:length(parents)/2
        parent_1=state_path{parents(2*i-1)};
        parent_1_event=event_path{parents(2*i-1)};
        parent_2=state_path{parents(2*i)};
        parent_2_event=event_path{parents(2*i)};
        k=1;
        cross_point='';
        
        for j=2:length(parent_1)-1%looking for same point,that can't be start or finish node
            for m=2:length(parent_2)-1
                crossp=strcmp(parent_1(j,:),parent_2(m,:));
                if sum(crossp)==num_fsm %equal state
                    cross_point{k}(1)=j;
                    cross_point{k}(2)=m;
                    k=k+1;
                end
            end
        end
        if ~isempty(cross_point)
            idx=randi([1 length(cross_point)]);
            offspring{2*i-1}=[parent_1(1:cross_point{idx}(1),:);parent_2(cross_point{idx}(2)+1:end,:)];
            offspring_event{2*i-1}=[parent_1_event(1:cross_point{idx}(1),:);parent_2_event(cross_point{idx}(2)+1:end,:)];
            offspring{2*i}=[parent_2(1:cross_point{idx}(2),:);parent_1(cross_point{idx}(1)+1:end,:)];
            offspring_event{2*i}=[parent_2_event(1:cross_point{idx}(2),:);parent_1_event(cross_point{idx}(1)+1:end,:)];
            num_spoint(num_rep)=num_spoint(num_rep)+1;
        else
            offspring{2*i-1}=parent_1;
            offspring_event{2*i-1}=parent_1_event;
            offspring{2*i}= parent_2;
            offspring_event{2*i}= parent_2_event;
            num_sparent(num_rep)=num_sparent(num_rep)+1;
        end
    end
    
    %mutation
    mutation_rate=0.1;
    mutation_idx_max=ceil(length(offspring)*mutation_rate);
    mutation_idx_total=randperm(length(offspring));
    mutation_idx=mutation_idx_total(1:mutation_idx_max);
%     
    for i=1:length(mutation_idx)
        mut_off='';
        mut_off=offspring{mutation_idx(i)};
        mut_off_event= offspring_event{mutation_idx(i)};
        idx_mut=randi([1 length(mut_off)]);
        node_mut=mut_off(idx_mut,:);
        offspring{mutation_idx(i)}='';
        offspring_event{mutation_idx(i)}='';
        if idx_mut==1
            offspring{mutation_idx(i)}=mut_off(1:idx_mut,:);
            offspring_event{mutation_idx(i)}=mut_off_event(1:idx_mut,:);
            cur_states=mut_off(idx_mut,:);
        else
            offspring{mutation_idx(i)}=mut_off(1:idx_mut-1,:);
            offspring_event{mutation_idx(i)}=mut_off_event(1:idx_mut-1,:);
                    cur_states=mut_off(idx_mut-1,:);
        end
        a=0;

        while a==0
            transition_list = createTransitionList(states_incr,cur_states,num_fsm);
            possible_transitions = findPossibleTransitions(transition_list,event_list);
            
            
            if detectEndState(cur_states,states_incr,num_fsm)
                a=1;
                break; %Exit  LOOP
            end %
            num_events=length(possible_transitions);
            next_event_idx=randi([1 num_events]);
            
            next_event=possible_transitions{next_event_idx,1};
            pos_cur_states = updateCurEvent(next_event,cur_states,events_incr,states_incr,num_fsm);
            aux=0;
            m=size(offspring{mutation_idx(i)});
            for k=1:m(1)
                loop=strcmp(offspring{mutation_idx(i)}(k,:),pos_cur_states);
                if sum(loop)==num_fsm %equal state
                    aux=1;
                    u=k;
                    break;
                end
            end
            if aux==1%remove loop
                if u<m(1)-1
                    %ju=state_path{j};
                    offspring{mutation_idx(i)}(u+1:m(1),:)=[];
                    offspring_event{mutation_idx(i)}(u+1:m(1),:)=[];
                    m=u;
                    %pause;
                end
            end
            if aux==0
                cur_states=pos_cur_states;
                offspring{mutation_idx(i)} = [offspring{mutation_idx(i)};cur_states];
                offspring_event{mutation_idx(i)} = [offspring_event{mutation_idx(i)};next_event];
                m(1)=m(1)+1;
            end
        end
    end
%     
%     
%      path_gen_old='';
%      path_gen_old=state_path;
%      state_path='';
%      path_events_old='';
%      path_events_old=event_path;
%      event_path='';
path_gen='';
path_gen_event='';
    path_gen=[state_path,offspring];
    path_gen_event=[event_path,offspring_event];
    state_path='';
    offspring='';
    event_path='';
    offspring_event='';
     for i=1:length(path_gen)
        %         fit_values(i)=path_total_cost(path_events{1,i});
        [cost_aux(num_rep,i),fit_aux_values_A(i),fit_aux_values_B(i),fit_aux_values_C(i)]=path_total_cost__21_07(path_gen_event{i});
    end
    
    [fit_values_rn_aux{num_rep}, idx_fit_aux_2{num_rep}]=sort(cost_aux(num_rep,:));
    
    for i=1:num_paths
        state_path{i}=path_gen{idx_fit_aux_2{num_rep}(i)};
        event_path{i}=path_gen_event{idx_fit_aux_2{num_rep}(i)};
    end
     
     
%      for i=1:length(parents)
%         state_path{i}=path_gen_old{parents(i)}; %copy parents to the new population
%         event_path{i}=path_events_old{parents(i)};
%     end
%     max=length(state_path);
%     for i=1:length(offspring)
%         state_path{max+i}=offspring{i};
%         event_path{max+i}=offspring_event{i};
%     end
    for i=1:num_paths
        %         fit_values(i)=path_total_cost(path_events{1,i});
        [cost(num_rep,i),fit_values_A(i),fit_values_B(i),fit_values_C(i)]=path_total_cost__21_07(event_path{i});
    end
    
    [fit_values_rn{num_rep}, idx_fit_aux{num_rep}]=sort(cost(num_rep,:));

%     
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
t_end_evol=toc(t_evol);
t_end_total=toc(t_total);
plan=event_path{idx_fit_aux{num_rep-1}(1)};
plan_state=state_path{idx_fit_aux{num_rep-1}(1)};