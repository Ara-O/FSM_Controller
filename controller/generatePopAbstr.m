function [path_events] = generatePopAbstr(initial_state,states,population_size)
%num_paths=population_size; %number of paths to be generated
act_state=str2double(initial_state);
sz1=size(states{act_state,2}); %number of bifurcation of initial state
num_path=round(population_size/sz1(1,1));
j=1;
for k=1:sz1(1,1)
    for w=1:num_path
        act_state=str2double(initial_state);
        i=1;
        path_gen{j}(i)=act_state; %save at the state being analyzed
        if states{act_state,3} %verify if it is a marked state, if is then stop searching
            aux=0;
            break;
        end
        next_state= states{act_state,2}(k,2); %save the state
        path_events{j}{i}= states{act_state,2}(k,1); %save the tansitions' event
        i=i+1;
        act_state=str2double(next_state);
        aux=1;
        while aux
            path_gen{j}(i)=act_state; %save at the state being analyzed
            if states{act_state,3} %verify if it is a marked state, if is then stop searching
                aux=0;
                break;
            end
            sz=size(states{act_state,2}); %between all the possible transitions from the state
            r = randi([1 sz(1,1)],1,1);%choose a random one
            next_state= states{act_state,2}(r,2); %save the state
            path_events{j}{i}= states{act_state,2}(r,1); %save the tansitions' event
            i=i+1;
            act_state=str2double(next_state);
        end
        j=j+1;
    end
end