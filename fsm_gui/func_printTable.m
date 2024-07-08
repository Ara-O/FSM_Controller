function [sOut] = func_printTable(tblName,tblCellArray)
% This function prints table so that it can be read by a matlab code file

% Example:
%
% events = {'a1f', 1, 'None', 'n/a';
%           'a1s', 1, 'Task', 'tsk1';
%           'r5e', '1,2', 'Region', 'reg5'};
%
% s = printTable('events',events)

% states = {'s0',{'a1s',  's1',  'c',  'o';
%                 'a3s', 's3', 'c', 'o'},0;
%                 's13',<2x4 cell>,0;'s12',<1x4 cell>,0;'s3',<1x4 cell>,0;'s1',<1x4 cell>,0;'s123',<2x4 cell>,0;'s134',<1x4 cell>,0;'s1234',<1x4 cell>,1;}
%
% % as one continuous string
% sOut = [tblName ' = {'];
% for i = 1:size(tblCellArray,1)
%     for j = 1:size(tblCellArray,2)
%         if j ~= size(tblCellArray,2)
%             if isa(tblCellArray{i,j},'char')
%                 sOut = [sOut '''' tblCellArray{i,j} ''', '];
%             elseif isa(tblCellArray{i,j},'numeric')
%                 sOut = [sOut num2str(tblCellArray{i,j}) ', '];
%             end
%         else
%             if i ~= size(tblCellArray,1)
%                 if isa(tblCellArray{i,j},'char')
%                     sOut = [sOut '''' tblCellArray{i,j} '''; '];
%                 elseif isa(tblCellArray{i,j},'numeric')
%                     sOut = [sOut num2str(tblCellArray{i,j}) '; '];
%                 end
%             else
%                 if isa(tblCellArray{i,j},'char')
%                     sOut = [sOut '''' tblCellArray{i,j} ''''];
%                 elseif isa(tblCellArray{i,j},'numeric')
%                     sOut = [sOut num2str(tblCellArray{i,j})];
%                 end
%             end
%         end
%     end
% end
% sOut = [sOut ' };'];

% with new lines
% with new lines
sOut = sprintf('%s = {', tblName);
for i = 1:size(tblCellArray,1)
    for j = 1:size(tblCellArray,2)
        % states var has cell arrays as the names
        if isa(tblCellArray{i,j},'cell')
            if size(tblCellArray{i,j},1) > 0
                % nested cell array
                sOut = sprintf('%s {', sOut);
                
                for event = 1:size(tblCellArray{i,j},1)
                    for item = 1:size(tblCellArray{i,j},2)
                        if item ~= size(tblCellArray{i,j},2)
                            if isa(tblCellArray{i,j}{event,item},'char')
                                sOut = sprintf('%s ''%s'', ', sOut, tblCellArray{i,j}{event,item});
                            elseif isa(tblCellArray{i,j}{event,item},'numeric')
                                sOut = sprintf('%s %s, ', sOut, num2str(tblCellArray{i,j}{event,item}));
                            end
                        else
                            if event ~= size(tblCellArray{i,j},1)
                                if isa(tblCellArray{i,j}{event,item},'char')
                                    sOut = sprintf('%s ''%s'';\n   ', sOut, tblCellArray{i,j}{event,item});
                                elseif isa(tblCellArray{i,j}{event,item},'numeric')
                                    sOut = sprintf('%s %s;\n   ', sOut, num2str(tblCellArray{i,j}{event,item}));
                                end
                            else
                                if isa(tblCellArray{i,j}{event,item},'char')
                                    sOut = sprintf('%s ''%s'' }, ', sOut, tblCellArray{i,j}{event,item});
                                elseif isa(tblCellArray{i,j}{event,item},'numeric')
                                    sOut = sprintf('%s %s }, ', sOut, num2str(tblCellArray{i,j}{event,item}));
                                end
                            end
                        end
                    end
                end
            else
                sOut = sprintf('%s {}, ',sOut);
            end
            
        else
            % regular cell
            if size(tblCellArray{i,j},1) > 0
                if j ~= size(tblCellArray,2)
                    if isa(tblCellArray{i,j},'char')
                        sOut = sprintf('%s ''%s'', ', sOut, tblCellArray{i,j});
                    elseif isa(tblCellArray{i,j},'numeric')
                        sOut = sprintf('%s %s, ', sOut, num2str(tblCellArray{i,j}));
                    end
                else
                    if i ~= size(tblCellArray,1)
                        if isa(tblCellArray{i,j},'char')
                            sOut = sprintf('%s ''%s'';\n   ', sOut, tblCellArray{i,j});
                        elseif isa(tblCellArray{i,j},'numeric')
                            sOut = sprintf('%s %s;\n   ', sOut, num2str(tblCellArray{i,j}));
                        end
                    else
                        if isa(tblCellArray{i,j},'char')
                            sOut = sprintf('%s ''%s'' };\n\n', sOut, tblCellArray{i,j});
                        elseif isa(tblCellArray{i,j},'numeric')
                            sOut = sprintf('%s %s };\n\n', sOut, num2str(tblCellArray{i,j}));
                        end
                    end
                end
            else
                sOut = sprintf('%s [];\n',sOut);
            end
        end
    end
end

