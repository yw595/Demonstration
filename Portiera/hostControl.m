New1122SpecificModel=changeObjective(New1122SpecificModel,'biomass',1);
metabolitesToVary={'tryptophan[h]','phenylpyruvate[h]','threonine[h]','histidinol[h]','lysine[h]','arginine[h]','2_oxo_3_methylvalerate[h]','2_oxoisovalerate[h]','oxoleucine[h]','carotene[h]'};
exchangeFluxes={};
biomasses=[];
exchangeFluxNames={};
for i=1:length(New1122SpecificModel.rxns)
    if(~isempty(regexp(New1122SpecificModel.rxns{i},'Transport')))
        ithRxn=New1122SpecificModel.rxns{i};
        exchangeFluxNames{end+1}=ithRxn(14:end-2);
    end
end
for i=1:length(metabolitesToVary)
    for j=0:.1:1
        ijthNew1122SpecificModel=New1122SpecificModel;
        ijthNew1122SpecificModel.S(strcmp(New1122SpecificModel.mets,metabolitesToVary{i}),strcmp(New1122SpecificModel.rxns,'biomass'))=...
            j*ijthNew1122SpecificModel.S(strcmp(New1122SpecificModel.mets,metabolitesToVary{i}),strcmp(New1122SpecificModel.rxns,'biomass'));
        sol=optimizeCbModel(ijthNew1122SpecificModel);
        biomasses(i,floor(j*10+1))=sol.f;
        ijthExchangeFluxes=[];
        for k=1:length(sol.x)
            %k
            %regexp(ijthNew1122SpecificModel.rxns{k},'Exchange')
            if(~isempty(regexp(ijthNew1122SpecificModel.rxns{k},'Exchange')))
                ijthExchangeFluxes(end+1)=sol.x(k);
            end
        end
        exchangeFluxes{i,floor(j*10+1)}=ijthExchangeFluxes;
    end
end

for i=1:length(metabolitesToVary)
    i
    for j=[.3 1]
        figure('Visible','off','Renderer','zbuffer');
        bar(1:1:length(exchangeFluxes{i,floor(j*10+1)}),exchangeFluxes{i,floor(j*10+1)},1);
        set(gca,'units','centimeters','position',[1.25 2.5 1.5*length(exchangeFluxes{i,floor(j*10+1)}) 10]);
        ylabel('Exchange Flux');
        ylim([-10 10]);
        hx=get(gca,'XLabel');
        pos=get(hx,'Position');
        y=pos(2);
        for k=1:length(exchangeFluxNames)
            t(k)=text(k,-10,exchangeFluxNames{k},'fontSize',10,'Interpreter','default');
        end
        set(t,'Rotation',90,'HorizontalAlignment','right');
        saveas(gcf,[metabolitesToVary{i} num2str(floor(j*10+1)) 'exchangeFluxes.png']);
    end
end