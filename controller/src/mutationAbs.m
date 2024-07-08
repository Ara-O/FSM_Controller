function path_event = mutationAbs(path_events)
    for i=1:length(path_events)
        index_1=randi([1 length(path_events)/2]);
        index_2=randi([(length(path_events)/2+1) length(path_events)]);
        
        A={path_events{1:index_1}};
        B={path_events{index_1+1:index_2}};
        C={path_events{index_2+1:end}};
        choice=rand;
        
        if choice <= 1/6
            path_event=path_events;
        elseif choice > 1/6 && choice <=2/6
            path_event={B{:},A{:},C{:}};
        elseif choice >2/6 && choice <=3/6
            path_event={B{:},C{:},A{:}};
        elseif choice >3/6 && choice <=4/6
            path_event={C{:},A{:},B{:}};
        elseif choice > 4/6 && choice <=5/6
            path_event={C{:},B{:},A{:}};
        else
            path_event={A{:},C{:},B{:}};
        end
    end
    

end