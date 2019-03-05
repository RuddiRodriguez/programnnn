savecell = cell(1,2);
savecell{1} = fieldnames(parameterStruct);
savecell{2} = transpose(struct2array(parameterStruct));



names = fieldnames(parameterStruct);
fieldvalues = transpose(struct2array(parameterStruct));
cellsave = cell(size(names,1),3);

for i = 1:size(names,1)
   cellsave{i,1} = names{i};
   cellsave{i,2} = '=';
   cellsave{i,3} = fieldvalues(i);
end