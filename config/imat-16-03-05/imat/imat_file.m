function [PICS]=imat_file(imati)

if imati.source.single==1
    %    [PICS,PNAME] = uigetfile(imati.source.imtype,'Select any image file in your directory and they will all be processed');
    %    PICS=dir([PNAME DELIMITER ]);
    PICS=dir([imati.source.path]);
else
    %    [PNAME] = uigetdir;
    PICS=dir([imati.source.path xgetos '*.*']);
    no=size(PICS);
    no=no(1);
    picsv=[];
    for picno=1:no
        filename=PICS(picno).name;
        sf=size(filename);
        sf=sf(2);
        if sf>3
            ext=filename(sf-3:sf);
            ext=lower(ext);
            if all(ext==imati.source.imtype)
                picsv=[picsv picno];
            end
        end
    end
    PICS=PICS(picsv);
    no=size(picsv);
    no=no(2);
end

