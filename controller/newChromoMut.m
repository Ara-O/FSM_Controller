function [path_gen,path_events] = newChromoMut(chromosome,numRobots,states_incr,num_fsm,initial_state_incr,event_list,events_incr)

i=1;
ind=1;
indb=1;
indc=1;
inde=1;
for j=1:length(chromosome)
        event{i}=chromosome{j};
        i=i+1;
        if strcmp(chromosome{j}(1),'a')
            event_mask(indc)=1;
            indc=indc+1;
            event_a{ind}=chromosome{j};
            ind=ind+1;
        else
            event_mask(indc)=0;
            indc=indc+1;
            event_b{indb}=chromosome{j};
            indb=indb+1;
        end
        if strcmp(chromosome{j}(end),'e')
            entry_event{inde}=chromosome{j};
            inde=inde+1;
        end
            
end

new_chromo=event_mask(randperm(length(event_mask)));

ind=1;
j=1;
k=1;
for i=1:length(new_chromo)
    if new_chromo(i)
        new_event{1}{ind}=event_a{j};
        j=j+1;
        ind=ind+1;
    else
        new_event{1}{ind}=event_b{k};
        k=k+1;
        ind=ind+1;
    end
end

%treating possible infeasibility with entry events
ind=1;

aux_event_a{1}='';
aux_event_a{2}=0;
aux_event_a{3}=0;
aux_event_b{1}='';
aux_event_b{2}=0;
aux_event_b{3}=0;
aux{1}=new_event{1}{1};
if strcmp(new_event{1}{1}(1),'a') && strcmp(new_event{1}{1}(end),'e')
    aux_event_a{1}=new_event{1}{1};
    aux_event_a{2}=1;
    aux_event_a{3}=1;
else
    if strcmp(new_event{1}{1}(1),'b') && strcmp(new_event{1}{1}(end),'e')
        aux_event_b{1}=new_event{1}{1};
        aux_event_b{2}=1;
        aux_event_b{3}=1;
    end
end
i=2;
while i <= length(new_event{1})
    [aux,aux_event_a,aux_event_b,i] = addEvent(aux,aux_event_a,aux_event_b,new_event,i);
    i=i+1;
end
    
aux{length(aux)+1}=new_event{1}{end};
new_event{1}='';
new_event{1}=aux;


[path_gen,path_events] = createChromossomeMod(new_event,states_incr,num_fsm,initial_state_incr,event_list,events_incr);
old_path_gen='';
old_path_gen=path_gen;
old_event_gen='';
old_event_gen=path_events;
path_gen='';
path_events='';
old_size=length(old_path_gen);

[path_gen,path_events]=check_loops_fix_new_Incr(old_path_gen,old_event_gen,num_fsm); %remove the loops
new_size=length(path_gen);    
end
