function [newlabelcont]=xsetlabels(labelcont,addlabel,color,maxy)
newlabelcont=labelcont;
ylimits=get(get(gcf,'Children'),'YLim');
xlimits=get(get(gcf,'Children'),'XLim');            
gcf2=get(get(gcf,'Children'),'Children');
dy=(ylimits(2)-ylimits(1))/30;

[N]=size(labelcont.pos,1);

for n=1:N
    newlabelcont.pos(n,:)=[max(xlimits) maxy-n*dy];
end
% Correct existing labels
leftalign=max(xlimits);
[E]=size(xlimits,2);
child=get(gcf,'Children');
children=get(child,'Children');
cand=size(children,1);
nl=1;
for c=1:cand
    userdata=get(children(c),'UserData');
    if ~isempty(userdata)
        curpos=get(children(c),'Position'); 
        curpos(1)=leftalign;
        curpos(2)=newlabelcont.pos(nl,2);
        set(children(c),'Position',curpos);    
        nl=nl+1;
    end
end

newlabelcont.pos=[newlabelcont.pos; max(xlimits) maxy-(N+1)*dy];
newlabelcont.text=[newlabelcont.text; cellstr(addlabel)];
newlabelcont.color=[newlabelcont.color; color];
hand=text(newlabelcont.pos(N+1,1),newlabelcont.pos(N+1,2),char(newlabelcont.text(N+1,:)),'Color',color);
set(hand,'FontSize',7);
set(hand,'UserData',hand);
newlabelcont.hand=[newlabelcont.hand; hand];

