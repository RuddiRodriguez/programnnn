

clear
fid1=fopen('resultsdesv.txt','w+')

fid = fopen('config/program_directory_path.ini','rt')
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all')


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');


% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});

% output of parameters
parameterStruct
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
%savedcontours=[1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63	64	65	66	67	68	69	70	71	72	73	74	75	76	77	78	79	80	81	82	83	84	85	86	87	88	89	90	91	92	93	94	95	96	97	98	99	100	101	102	103	104	105	106	107	108	109	110	111	112	113	114	115	116	117	118	119	120	121	122	123	124	125	126	127	128	129	130	131	132	133	134	135	136	137	138	139	140	141	142	143	144	145	146	156	157	158	159	160	161	162	163	164	165	166	167	173	174	175	176	177	178	180	181	233	244	245	246	268	302	310	311	312	316	322	323	324	325	326	328	375	379	384	385	387	391	392	397	398	401	402	403	405	406	410	412	418	419	422	426	427	437	444]
j=0
% r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
% %savedcontours=[4 5 6];
% r0=r0(savedcontours);


q=0
mediafluct=zeros(1,length(savedcontours))
tiempo=zeros(1,length(savedcontours))
for j = savedcontours
    q=q+1;
mempospol = load(sprintf('%s/memposs/mempos%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates
n=1:length(mempospol);
fluctpura=mempospol(n,1)
mediafluct(q)=(sum((fluctpura).^2))/(length(fluctpura))%(mean(((fluctpura)).^2))-((mean((fluctpura))).^2)    %mean(fluctpura)%  (sum((fluctpura).^2))/(length(fluctpura))
 %tiempo(q)=25.76+(0.14*j);
tiempo(q)=(0.066.*j);

end
n=1:length(savedcontours);
mediafluct=mediafluct'
tiempo=tiempo'
save(sprintf('%s/results/mediafluct.txt',working_directory_path),'mediafluct','-ascii')
save(sprintf('%s/results/tiempo.txt',working_directory_path),'tiempo','-ascii')

figure(8)
hold on;
plot(tiempo,mediafluct)
axis square;
figure(2)
plot(fluctpura)
