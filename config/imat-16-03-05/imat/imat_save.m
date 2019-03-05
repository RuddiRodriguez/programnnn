function [imato]=imat_save(imati,RESX,RESY,pictures,percent_loweronhill,percent_upperonhill,percent_lowerplus,percent_upperplus,time_start,time_end,imatuserpre1,imatuserpost1)

imato.resx=RESX;
imato.resy=RESY;
imato.pictures=pictures;
imato.percent_lower_plus=percent_lowerplus;
imato.percent_upper_plus=percent_upperplus;
imato.percent_lower_onhill=percent_loweronhill;
imato.percent_upper_onhill=percent_upperonhill;
imato.setup=imati;
imato.time.start=time_start;
imato.time.end=time_end;

yes='y';
if yes=='y'
    %then save the results in the appropriate destination path
    path=imati.source.path;
    if imati.source.single==1
        ix=find(path==xgetos);
        six=size(ix);
        sp=size(path);
        path=path(1,1:ix(six(2))-1);
        temp=[path xgetos 'IMAT_' imati.output.index '.mat'];
    else
        temp=[path xgetos 'IMAT_' imati.output.index '.mat'];
    end
    save(temp,'imato');
%     fp=fopen([path xgetos imati.analysis.preprofile '_' imati.output.index '.m'],'w');
%     textlines=size(imatuserpre1);
%     for i=1:textlines
%         line=char(imatuserpre1(i));
%         linelen=size(line);
%         linelen=linelen(2);
%         for j=1:linelen
%             fprintf(fp,'%c',line(j));
%         end
%         fprintf(fp,'\n');
%     end
%     fclose(fp);
%     fp=fopen([path xgetos imati.analysis.postprofile '_' imati.output.index '.m'],'w');
%     textlines=size(imatuserpost1);
%     for i=1:textlines
%         line=char(imatuserpost1(i));
%         linelen=size(line);
%         linelen=linelen(2);
%         for j=1:linelen
%             fprintf(fp,'%c',line(j));
%         end
%         fprintf(fp,'\n');
%     end
%     fclose(fp);
end


