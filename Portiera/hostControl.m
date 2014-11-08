New1122SpecificModel=changeObjective(New1122SpecificModel,'biomass',1);
metabolitesToVary={'tryptophan[h]','phenylpyruvate[h]','threonine[h]','histidinol[h]','lysine[h]','arginine[h]','2_oxo_3_methylvalerate[h]','2_oxoisovalerate[h]','oxoleucine[h]','carotene[h]'};
exchangeFluxes={};
biomasses=[];

%vary the coefficients for each component of the biomass reaction,
%simulating changing host demand for each component
%store the resulting biomass flux and all exchange fluxes in the 2d arrays
%biomasses and exchangeFluxes, where each row represents a changing biomass
%metabolite, and each column the amount by which it changes
for i=1:length(metabolitesToVary)
    for j=0:.1:1
        ijthNew1122SpecificModel=New1122SpecificModel;
        ijthNew1122SpecificModel.S(strcmp(New1122SpecificModel.mets,metabolitesToVary{i}),strcmp(New1122SpecificModel.rxns,'biomass'))=...
            j*ijthNew1122SpecificModel.S(strcmp(New1122SpecificModel.mets,metabolitesToVary{i}),strcmp(New1122SpecificModel.rxns,'biomass'));
        sol=optimizeCbModel(ijthNew1122SpecificModel);
        biomasses(i,floor(j*10+1))=sol.f;
        ijthExchangeFluxes=[];
        for k=1:length(sol.x)
            if(~isempty(regexp(ijthNew1122SpecificModel.rxns{k},'Exchange')))
                ijthExchangeFluxes(end+1)=sol.x(k);
            end
        end
        exchangeFluxes{i,floor(j*10+1)}=ijthExchangeFluxes;
    end
end

%get the names of all metabolites involved in transport reactions
exchangeFluxMets={};
for i=1:length(New1122SpecificModel.rxns)
    if(~isempty(regexp(New1122SpecificModel.rxns{i},'Exchange')))
        ithRxn=New1122SpecificModel.rxns{i};
        exchangeFluxMets{end+1}=ithRxn(13:end-2);
    end
end

%store bar graphs of exchange fluxes in the folder hostControl, for the
%cases of 100% and 30% of a biomass component coefficient
for i=1:length(metabolitesToVary)
    for j=[.3 1]
        figure('Visible','off','Renderer','zbuffer');
        bar(1:1:length(exchangeFluxes{i,floor(j*10+1)}),exchangeFluxes{i,floor(j*10+1)},1);
        set(gca,'units','centimeters','position',[1.25 4.5 .6*length(exchangeFluxes{i,floor(j*10+1)}) 8]);
        set(gca,'XTickLabel',{});
        set(gca,'XTick',[]);
        ylabel('Exchange Flux');
        ylim([-10 10]);
        hx=get(gca,'XLabel');
        pos=get(hx,'Position');
        y=pos(2);
        for k=1:length(exchangeFluxMets)
            t(k)=text(k,-10,exchangeFluxMets{k},'fontSize',10,'Interpreter','default');
        end
        set(t,'Rotation',90,'HorizontalAlignment','right');
        saveas(gcf,['hostControl/' metabolitesToVary{i} num2str(floor(j*10)) 'exchangeFluxes.png']);
    end
end