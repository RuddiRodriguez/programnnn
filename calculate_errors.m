fid1=fopen('resultsdesv.txt','w+')

fid = fopen('config/program_directory_path.ini','rt')
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all')


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});

% output of parameters
parameterStruct

sigma0 = (0.1*parameterStruct.resolution);%1e-007
a = load([pathToResultsDirectory,'/results/a.txt']);
b = load([pathToResultsDirectory,'/results/b.txt']);
c = load([pathToResultsDirectory,'/results/c.txt']);
r0 = load([pathToResultsDirectory,'/results/r0.txt']);

r0 = r0(savedcontours);
sigma2u = zeros(parameterStruct.nmax,1);
sigmacnlineal_1 = zeros(1,parameterStruct.nmax);
% variii=zeros(parameterStruct.nmax,1);
% sigmacne=zeros(50,length(savedcontours));

% define cells that will hold the membrane coordinates
mempospol = cell(length(savedcontours),1);

% load data
for contour_nr_index = 1:length(savedcontours)
    mempospol{contour_nr_index} = load([pathToResultsDirectory,'/contours/polarcontour',num2str(savedcontours(contour_nr_index)),'.txt']); % load the membrane position in polar coordinates
end

hbar = waitbar(0,'Please wait...');

sigmaR2 = zeros(length(savedcontours),1);
sigma2an = zeros(length(savedcontours),1);
sigma2bn = zeros(length(savedcontours),1);
sigma2cn = zeros(length(savedcontours),1);
sigma2cnsq = zeros(length(savedcontours),1);

for mode_nr_index = 1:parameterStruct.nmax

    aa = (a(mode_nr_index,savedcontours));
    bb = (b(mode_nr_index,savedcontours));
    cc = (c(mode_nr_index,savedcontours));

    for contour_nr_index = 1:length(mempospol)
        mempospol_tmp = mempospol{contour_nr_index};
        nr_of_membrane_coordinates = size(mempospol_tmp,1);
        
        rho = mempospol_tmp(:,1);
        theta = mempospol_tmp(:,2);
        thetar = calculateThetaR(theta);

        diffThetaR = calculateDiffThetaR(thetar,nr_of_membrane_coordinates);
        diffRho = calculateDiffRho(rho,nr_of_membrane_coordinates);

        diffRho = diffRho';
        diffThetaR = diffThetaR';
        thetar = thetar';
        rho = rho';
        

        sigmaR2(contour_nr_index) = calculateSigmaRsquare(nr_of_membrane_coordinates,sigma0,rho,diffRho,diffThetaR);
        sigmaR21=sigmaR2(contour_nr_index);
        
        sigma2an(contour_nr_index) = calculateSigmaAsquare(sigmaR21,nr_of_membrane_coordinates,mode_nr_index,contour_nr_index,thetar,rho,diffThetaR,diffRho,r0,sigma0,aa,bb,cc);
        sigma2bn(contour_nr_index) = calculateSigmaBsquare(sigmaR21,nr_of_membrane_coordinates,mode_nr_index,contour_nr_index,thetar,rho,diffThetaR,diffRho,r0,sigma0,aa,bb,cc);
        
        [sigma2cnsq(contour_nr_index),sigma2cn(contour_nr_index)] = calculateSigma2CnSquare_and_sigma2Cn(contour_nr_index,sigma2an,sigma2bn,aa,bb,cc);
    end
    
[sigma2u(mode_nr_index),sigmacnlineal_1(mode_nr_index)] = calculateSigma2u_and_sigmalinal(contour_nr_index,sigma2cn,sigma2cnsq,sigmaR2,r0,cc);

waitbar(mode_nr_index/parameterStruct.nmax)
end

close (hbar)

save([pathToResultsDirectory,'/results/errores.txt'],'sigma2u','-ascii')
save([pathToResultsDirectory,'/results/sigmar2.txt'],'sigmaR2','-ascii')
save([pathToResultsDirectory,'/results/sigmacnlinealpormodo.txt'],'sigmacnlineal_1','-ascii')

msgbox('Finish');

function thetar = calculateThetaR(theta)

% thetar = calculateThetaRMex(theta');

thetar = zeros(length(theta),1);

for b1 = 1:length(theta)
    if (theta(b1)>2*pi)&& (theta(b1)>0)
        thetar(b1)=theta(b1)-(2*pi);
    elseif (theta(b1)>2*pi)&& (theta(b1)<0)
        thetar(b1)=abs(theta(b1))-(2*pi);
    elseif (theta(b1)<2*pi)&& (theta(b1)>0)
        thetar(b1)=(theta(b1));
    elseif (theta(b1)<2*pi)&& (theta(b1)<0)
        thetar(b1)=abs(theta(b1));
    end
end

function diffThetaR = calculateDiffThetaR(thetar,nr_of_membrane_coordinates)
    g=2:(nr_of_membrane_coordinates-1);

    factor4(g)=thetar(g+1);
    factor5(g)=thetar(g-1);

    diffThetaR = factor4-factor5;
    diffThetaR = diffThetaR'; % no idea why this is necessary as only the above lines were used in the original code?!

function diffRho = calculateDiffRho(rho,nr_of_membrane_coordinates)
    g=2:(nr_of_membrane_coordinates-1);

    % TODO: there seems to be an error -> with the way it was calculated (i.e.:
    % using 'g' as the index) the first entry of the differential vector is
    % alway ZERO
    factor6(g)=rho(g+1); % runs from 3 to end
    factor7(g)=rho(g-1); % runs from 1 to end-2

    diffRho = factor7-factor6;
    diffRho = diffRho'; % no idea why this is necessary as only the above lines were used in the original code?!

    % factor6test=rho(3:end); % TODO: use this instead
    % factor7test=rho(1:end-2);
    % diffRhoTest = factor7test-factor6test;
    % diffRhoTest = [0,diffRhoTest];

function sigmaR2 = calculateSigmaRsquare(nr_of_membrane_coordinates,sigma0,rho,diffRho,diffThetaR)
% calculate sigma of R^2

    % factor1=zeros(nr_of_membrane_coordinates-1,1);
    % factor11=zeros(nr_of_membrane_coordinates-1,1);

    g=2:nr_of_membrane_coordinates-1;
    factor1(g) = 2*sigma0.^2./rho(g).^2;
    factor11(g) = 2*sigma0.^2./rho(g); 

    sumatheta = sum( ( diffThetaR ./ (4*pi) ).^2 .* 2.* sigma0^2 );
    sumarho = sum( diffRho.^2/ (4*pi)^2 .* factor1 );
    sumarhotheta = sum( abs(diffThetaR .* diffRho ./ (4*pi)^2 .* factor11) );
    sigmaR2 = sumatheta + sumarho + 2.*sumarhotheta;


function contourRadius = calculateRadius(rho,thetar)
    % calculate vesicle radius

    factor2 = zeros(nr_of_membrane_coordinates-1,1);

    for g=1:(nr_of_membrane_coordinates-1)
        factor2(g)=(rho(g)+rho(g+1));
    end

    ulti=rho(g+1)+rho(1);
    ultidiff=abs(thetar(1)-thetar(g+1));

    factor3=abs(diff(thetar));
    contourRadius = (1/(4.*pi)).*(((sum(factor2.*factor3)))+((ulti.*ultidiff)));

    
function sigma2an = calculateSigmaAsquare(sigmaR21,nr_of_membrane_coordinates,mode_nr_index,contour_nr_index,thetar,rho,diffThetaR,diffRho,r0,sigma0,aa,bb,cc)
    % calcualte sigma of a_n^2
    g=2:(nr_of_membrane_coordinates-1);


    sigmar0=sigmaR21;
    termino9(g)=((cos(mode_nr_index.*thetar(g))).^2)./2;

    termino1suma1=sigmar0.*((aa(contour_nr_index)./r0(contour_nr_index)).^2);
    termino2suma2=(sigma0.^2).*((1./(pi.*r0(contour_nr_index))).^2);
    termino3suma3=diffThetaR.^2;

    sumaan1=termino1suma1+sum(termino2suma2.*termino3suma3.*termino9);

    termino10(g)=-mode_nr_index.*rho(g).*sin(mode_nr_index.*thetar(g));

    termino11(g)=rho(g+1).*cos(mode_nr_index.*thetar(g+1));

    termino12(g)=rho(g-1).*cos(mode_nr_index.*thetar(g-1));

    termino13(g)=1./rho(g);

    sumaan2=sum(((termino13.^1).*(2.*(sigma0.^2)).*(1./(pi.*r0(contour_nr_index)).^2)).*(((termino10.*abs(diffThetaR))-termino11-termino12)./2).^2);%sum(((termino13.^1).*(2.*(sigma0^2))).*(((1/(pi.*r0(contour_nr_index))).^2)).*((((termino10.*diffThetaR)-termino11-termino12)./2).^2));%((((termino10.*diffThetaR)-termino11-termino12)./2).^2));

    termino14(g)=cos(mode_nr_index.*thetar(g));

    sumaan3=2.*sum((((sigma0.^2)./(4.*pi)).*((((abs(diffThetaR)))+(((abs(diffRho))).*termino13)))).*((((-(aa(contour_nr_index))./r0(contour_nr_index))).*(1/(pi.*r0(contour_nr_index)))).*termino14.*((abs(diffThetaR)))));

    termino15(g)=-mode_nr_index.*rho(g).*sin(mode_nr_index.*thetar(g));

    termino16(g)=(rho(g+1).*(cos(mode_nr_index.*thetar(g+1))))+((rho(g-1).*cos(mode_nr_index.*thetar(g-1))))./2;

    factor1 = (abs(diffThetaR))+((abs(diffRho)).*(termino13));

    factor2 = termino15.*(diffThetaR./2);

    sumaan4 = 2.*sum((((((sigma0).^2)./(4.*pi)).*termino13).*factor1.*(((-aa(contour_nr_index))./(r0(contour_nr_index)))).*((1./(pi.*r0(contour_nr_index)))).*(factor2-termino16)));

    termino18(g)=(cos(mode_nr_index.*thetar(g)))./2;

    sumaan5=2.*sum((((2.*(sigma0.^2)).*termino13).*(1./((pi.*r0(contour_nr_index)).^2)).*termino18.*(abs(diffThetaR)).*(factor2-termino16)));

    sigma2an=sumaan1+sumaan2+sumaan3+sumaan4+sumaan5;

    
function sigma2bn = calculateSigmaBsquare(sigmaR21,nr_of_membrane_coordinates,mode_nr_index,contour_nr_index,thetar,rho,diffThetaR,diffRho,r0,sigma0,aa,bb,cc)
    % calculate sigma of b_n^2
    g=(2:nr_of_membrane_coordinates-1);

    sigmar0=sigmaR21;

    termino9(g)=((sin(mode_nr_index.*thetar(g))).^2)./2;

    termino1suma1=(((sigmar0).^1).*((bb(contour_nr_index)./r0(contour_nr_index)).^2));
    termino2suma2=(sigma0.^2).*((inv(pi*r0(contour_nr_index)))^2);
    termino3suma3=diffThetaR.^2;

    sumabn1=termino1suma1+sum(termino2suma2.*termino3suma3.*termino9);

    termino10(g)=mode_nr_index.*rho(g).*cos(mode_nr_index.*thetar(g));

    termino11(g)=rho(g+1).*sin(mode_nr_index.*thetar(g+1));

    termino12(g)=(rho(g-1).*sin(mode_nr_index*thetar(g-1)));

    termino13(g)=1./rho(g);

    sumabn2=sum(((termino13.^1).*(2.*(sigma0^2))).*(((1/(pi.*r0(contour_nr_index))).^2)).*((((termino10.*(abs(diffThetaR)))-termino11-termino12)./2).^2));

    termino14(g)=sin(mode_nr_index*thetar(g));

    sumabn3=2.*sum((((sigma0.^2)./(4.*pi)).*((diffThetaR)+(((abs(diffRho))).*termino13))).*((((-bb(contour_nr_index))./r0(contour_nr_index))).*(1/(pi.*r0(contour_nr_index)))).*termino14.*((abs(diffThetaR))));

    termino15(g)=mode_nr_index*rho(g).*cos(mode_nr_index*thetar(g));

    termino16(g)=(rho(g+1)*mode_nr_index.*(sin(mode_nr_index*thetar(g+1))))+((rho(g-1).*sin(mode_nr_index*thetar(g-1))))/2;

    factor1=(abs(diffThetaR))+((abs(diffRho)).*(termino13));
    factor2=termino15.*(diffThetaR./2);

    sumabn4=2.*sum((((((sigma0).^2)./(4.*pi)).*termino13).*factor1.*(((-bb(contour_nr_index))./(r0(contour_nr_index)))).*((1./(pi.*r0(contour_nr_index)))).*(factor2-termino16)));

    termino18(g)=(-sin(mode_nr_index*thetar(g)))./2;

    sumabn5=2.*sum((((2.*(sigma0.^2)).*termino13).*(1./((pi.*r0(contour_nr_index)).^2)).*termino18.*(abs(diffThetaR)).*(factor2-termino16)));

    sigma2bn=sumabn1+sumabn2+sumabn3+sumabn4+sumabn5;

    
function [sigma2CnSquare,sigma2Cn] = calculateSigma2CnSquare_and_sigma2Cn(contour_nr_index,sigma2an,sigma2bn,aa,bb,cc)

    raiz = sqrt(((aa(contour_nr_index)).^2)+((bb(contour_nr_index)).^2));
    stdan = sqrt(-sigma2an(contour_nr_index));
    stdbn = sqrt(sigma2bn(contour_nr_index));

    sigma2Cn = abs(((aa(contour_nr_index).^2./raiz.^2).*(stdan^2))+((bb(contour_nr_index)^2./raiz^2).*(stdbn^2)))+(2*abs(aa(contour_nr_index))*abs(bb(contour_nr_index))*stdbn*stdan/(raiz^2));

    sigma2CnSquare = abs(((2.*aa(contour_nr_index).*(stdan))^2)+((2.*bb(contour_nr_index).*(stdbn)))^2)+(2*2*abs(aa(contour_nr_index))*abs(bb(contour_nr_index))*stdbn*stdan);

    
function [sigma2u,sigmacnlineal_1] = calculateSigma2u_and_sigmalinal(contour_nr_index,sigma2cn,sigma2cnsq,sigmaR2,r0,cc)
% calculate sigma2u

    sigma2cnmodulo2=(1/(contour_nr_index^2)).*sum((sigma2cnsq).^1);%cuadrado
    sigmacnlineal=(1/((contour_nr_index)^2)).*sum((sigma2cn).^1);%lineal

    sigmaR2mean=(1/(contour_nr_index^2)).*sum(sigmaR2);

    cov1=sqrt(sigma2cnmodulo2*sigmacnlineal);
    cov2=sqrt(sigma2cnmodulo2*sigmaR2mean);
    cov3=sqrt(sigmacnlineal*sigmaR2mean);

    R=mean(r0);

    termino20=(((pi/2)*R^3)^2).*sigma2cnmodulo2;%(((pi/2).*((mean(r0))^3))^2).*sigma2cnmodulo2;

    termino21=(((pi/2)*R^3)^2).*((2.*mean(cc)).^2).*sigmacnlineal;%((((pi/2).*((mean(r0))^3)))^2).*((2.*mean(cc)).^2).*sigmacnlineal;

    termino22=(3.*(((mean(cc.^2))-((mean(cc)).^2))).*(((pi/2).*(R.^2))^2)).*(sigmaR2mean);

    termino23=4*mean(cc)*(((pi/2).*(R^3))^2).*cov1;

    termino24=R.^3.*((mean(cc.^2))-((mean(cc)).^2));

    termino25=((3*(pi^2))/2).*R^2.*cov2;

    termino26=mean(cc).*(pi^2).*(R^3).*3.*((mean(cc.^2))-((mean(cc)).^2));

    termino27=R^2.*cov3;

    sigmacnlineal_1=(sigmacnlineal)'.*((((mean(r0)).^3).*pi)./2);

    sigma2u=termino20+termino21+termino22-termino23+(termino24*termino25)-(termino26*termino27);
    sigma2u=sqrt(sigma2u);
    % variii(mode_nr_index)=var(cc);