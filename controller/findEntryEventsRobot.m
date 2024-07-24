%Grab the possible transitions and split the finish events and entry events
%if there is any finish event to happen, it gives priority to it
function possible_trans = findEntryEventsRobot(possible_transitions,robot)
    %possible_trans=possible_transitions;
    ind=1;
    ind_1=1;
    ind_2=1;
    aux=0;
    aux_2=0;
    numRobots=length(robot);
    for i=1:length(possible_transitions)
       if ~strcmp(possible_transitions{i,1}(end),'s')
           if strcmp(possible_transitions{i,1}(end),'f')
               poss_trans1{ind_1,1}=possible_transitions{i,1};
               poss_trans1{ind_1,2}=possible_transitions{i,2};
               ind_1=ind_1+1;
               aux=1;
           else
               for j=1:numRobots
                   if strcmp(possible_transitions{i,1}(1),robot{j})
                       poss_trans2{ind,1}=possible_transitions{i,1};
                       poss_trans2{ind,2}=possible_transitions{i,2};
                       ind=ind+1;
                       aux_2=1;
                       break;
                   end
               end
               poss_trans3{ind_2,1}=possible_transitions{i,1};
               poss_trans3{ind_2,2}=possible_transitions{i,2};
               ind_2=ind_2+1;
               
           end
       end
    end
    if aux==1
       possible_trans=poss_trans1;
    elseif aux_2==1
        possible_trans=poss_trans2;
    else
        possible_trans=poss_trans3;
    end
    
    
end