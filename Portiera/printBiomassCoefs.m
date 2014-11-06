biomassMetNames={'tryptophan[h]','phenylpyruvate[h]','threonine[h]','histidinol[h]','lysine[h]','arginine[h]','2_oxo_3_methylvalerate[h]','2_oxoisovalerate[h]','oxoleucine[h]','ATP[P]','carotene[h]'};
biomassMetCoefs=[.44646 .34595 .50742 .12009 .79509 .27163 .82581 .4858 .85355 45.5608 .00005];

figure('Visible','off','Renderer','zbuffer');
bar(1:1:length(biomassMetCoefs),biomassMetCoefs,1);
%set(gcr,'Units','centimeters');
%set(gcf,'PaperPositionMode','auto');
%set(gcf,'PaperPosition',[0 2.5 length(biomassMetCoefs) 6]);
%set(gca,'XTick',[]);
set(gca,'units','centimeters','position',[1.25 5.5 1.5*length(biomassMetCoefs) 6]);
ylabel('Biomass Coefficient');
%ylim([0 1]);
%ylim('manual')
%set(gca,'YLim',[0 .0000001])
%set(gca,'XTick',2:2:2*length(biomassMetCoefs));
%set(gca,'XTickLabel',biomassMetNames);
hx=get(gca,'XLabel');
%set(hx,'Units','data');
pos=get(hx,'Position');
y=pos(2);
for i=1:length(biomassMetNames)
   t(i)=text(i,-.01,biomassMetNames{i},'fontSize',10,'Interpreter','default');
end
set(t,'Rotation',90,'HorizontalAlignment','right');
saveas(gcf,'biomassCoefficients.png');