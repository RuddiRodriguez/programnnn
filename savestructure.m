function logic = savestructure(structure,filename)

% this function saves the 'structure' given to it into the ASCII file
% 'filename';


% % this block transforms the structur into a cell so that it can be saved
% % with the correct variable names
% names = fieldnames(structure);
% fieldvalues = transpose(struct2array(structure));
% cellsave = cell(size(names,1),3);
% 
% for i = 1:size(names,1)
%    cellsave{i,1} = names{i};
%    cellsave{i,2} = '=';
%    cellsave{i,3} = fieldvalues(i);
% end
% 
% % this block transforms the cell into a cell with strings of equal length
% % so that it can be transformed into an array of strings
% ex2 = cellfun(@ex_func,cellsave,'UniformOutput',0);
% size_ex2 = cellfun(@length,ex2,'UniformOutput',0);
% str_length = max(max(cell2mat(size_ex2)));
% ex3 = cellfun(@(x) ex_func2(x,str_length),ex2,'uniformoutput',0);
% 
% % this block transforms the cell into an array of strings and saves it
% ex4 = cell2mat(ex3);
% [row col] = size(ex4);
% fid = fopen(sprintf('%s',filename),'wt');
% for i = 1:row
% fprintf(fid,'%s %s %s \n',ex4(i,1:(col/3)),ex4(i,(col/3)+1:2*col/3),ex4(i,2*col/3+1:col));
% end
% fclose(fid);

structurename = who('structure');

fieldname = fieldnames(structure);

for i= 1:length(fieldname)
fieldvalue(i) = eval(sprintf('%s.%s',structurename{1},fieldname{i}));
end

fid = fopen(sprintf('%s',filename),'wt');

for i= 1:length(fieldname)
fprintf(fid,'%s = %g\n',fieldname{i},fieldvalue(i));
end

fclose('all');