function path_gen=check_loops_fix(path_gen)
%check if there are loops in the path
    %aux_dup=aux_dup+1;
    ind='';
    duplicate_ind='';
    duplicate_value='';
    [~,ind]=unique(path_gen);
    duplicate_ind=setdiff(1:length(path_gen),ind);
    duplicate_value=unique(path_gen(duplicate_ind));
    if length(duplicate_value)>0
        %path_dup{aux_dup}=path_gen;
        for j=1:length(duplicate_value)
            ind_1='';
            duplicate_ind_1='';
            duplicate_value_1='';
            [~,ind_1]=unique(path_gen);
            if length(ind_1)<length(path_gen)
                duplicate_ind_1=setdiff(1:length(path_gen),ind_1);
                duplicate_value_1=unique(path_gen(duplicate_ind_1));
                ind_aux=find(path_gen==duplicate_value_1(1));
                if length(ind_aux)>1
                    %for m=1:length(ind_aux)/2
                    aux_ind=ind_aux(1);
                    num_aux_ind=aux_ind;
                    while num_aux_ind<=ind_aux(end)-1
                        path_gen(aux_ind)=[];
                        num_aux_ind=num_aux_ind+1;
                    end
                    
                    %end
                end
            end
        end
        
    end
end