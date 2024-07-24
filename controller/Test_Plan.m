 function [plan_cost,cost_trans,cost_extra] = Test_Plan(states,start_loc,numTasks,numRobots,numRegions,tasks,regions,robot_tasks,plan)
num_of_changes=0;
abstracted = false;
start_events_only = false;
% cost=[];
% trac_plan_cost=0;
% num_spoint=0;
% %num_paths=population_size; %number of paths to be generated
% t2=tic;
% act_state=1;
% sz1=size(states{act_state,2}); %number of bifurcation of initial state
% num_path=round(population_size/sz1(1,1));
% j=1;
% t7=tic;

sz_plan=length(plan);
act_state=1;
i=1;
for k=1:sz_plan+1
        path_gen(i)=act_state; %save at the state being analyzed
        if states{act_state,3} %verify if it is a marked state, if is then stop searching
            aux=0;
            break;
        end
        sz=size(states{act_state,2});
        for r=1:sz
            if strcmpi(states{act_state,2}(r,1),plan(k))
                next_state=states{act_state,2}(r,2);
                break;
            end
        end
        i=i+1;
        act_state=str2double(next_state);     
end

[plan_cost,cost_trans{1}{1},cost_extra{1}{1}]= path_cost(path_gen,plan,start_loc,states,tasks,regions,numRegions,numTasks,abstracted,start_events_only,robot_tasks,numRobots);

end

