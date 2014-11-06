New1122SpecificModel=readCbModel('1122Specific.xml');
New1122SpecificModel.id='PORT';

%fill in oldNames to newNames for rxns
oldNamesToNewNamesRxns=containers.Map;
readFID=fopen('ChangedNamesRxns.txt');
line=fgetl(readFID);
while(line~=-1)
    words=strsplit(line,'\t');
    oldNamesToNewNamesRxns(words{1})=words{2};
    line=fgetl(readFID);
end
fclose(readFID);

%fill in oldNames to newNames for mets
oldNamesToNewNamesMets=containers.Map;
readFID=fopen('ChangedNamesMets.txt');
line=fgetl(readFID);
while(line~=-1)
    words=strsplit(line,'\t');
    oldNamesToNewNamesMets(words{1})=words{2};
    line=fgetl(readFID);
end
fclose(readFID);

%retain rxns that are completely correct
retainRxns={'CARBPSYN__45__RXN','ORNCARBAMTRANSFER__45__RXN','ARGSUCCINSYN__45__RXN','DAHPSYN__45__RXN',...
    '_3__45__DEHYDROQUINATE__45__SYNTHASE__45__RXN','_3__45__DEHYDROQUINATE__45__DEHYDRATASE__45__RXN',...
    'SHIKIMATE__45__5__45__DEHYDROGENASE__45__RXN','SHIKIMATE__45__KINASE__45__RXN','_2__46__5__46__1__46__19__45__RXN',...
    'CHORISMATE__45__SYNTHASE__45__RXN','ANTHRANSYN__45__RXN','PRTRANS__45__RXN',...
    'PRAISOM__45__RXN','IGPSYN__45__RXN','RXN0__45_2382','RXN0__45_2381','DIHYDRODIPICSYN__45__RXN','RXN__45__14014','TETHYDPICSUCC__45__RXN',...
    'SUCCDIAMINOPIMDESUCC__45__RXN','ATPPHOSPHORIBOSYLTRANS__45__RXN','HISTPRATPHYD__45__RXN','HISTCYCLOHYD__45__RXN',...
    'PRIBFAICARPISOM__45__RXN','IMIDPHOSDEHYD__45__RXN','HISTAMINOTRANS__45__RXN','ACETOLACTSYN__45__RXN',...
    'ACETOLACTREDUCTOISOM__45__RXN','DIHYDROXYISOVALDEHYDRAT__45__RXN','ACETOOHBUTSYN__45__RXN','ACETOOHBUTREDUCTOISOM__45__RXN',...
    'DIHYDROXYMETVALDEHYDRAT__45__RXN','_2__45__ISOPROPYLMALATESYN__45__RXN',...
    '_3__45__ISOPROPYLMALDEHYDROG__45__RXN','ASPARTATEKIN__45__RXN','ASPARTATE__45__SEMIALDEHYDE__45__DEHYDROGENASE__45__RXN',...
    'HOMOSERDEHYDROG__45__RXN','HOMOSERKIN__45__RXN','THRESYN__45__RXN'};
retainRxnIdxs=[];
for i=1:length(New1122SpecificModel.rxns)
    if(sum(strcmp(New1122SpecificModel.rxns{i},retainRxns)))
        retainRxnIdxs(end+1)=i;
    end
end
New1122SpecificModel.rxns=New1122SpecificModel.rxns(retainRxnIdxs);
New1122SpecificModel.lb=New1122SpecificModel.lb(retainRxnIdxs);
New1122SpecificModel.ub=New1122SpecificModel.ub(retainRxnIdxs);
New1122SpecificModel.c=New1122SpecificModel.c(retainRxnIdxs);
New1122SpecificModel.rev=New1122SpecificModel.rev(retainRxnIdxs);
New1122SpecificModel.rxnNames=New1122SpecificModel.rxnNames(retainRxnIdxs);
New1122SpecificModel.S=New1122SpecificModel.S(:,retainRxnIdxs);

%replace spaces with underscores, otherwise writeCbToSBML will not put
%ids for reactions with spaces, which means they do not show up in
%Cytoscape
for i=1:length(New1122SpecificModel.rxns)
    New1122SpecificModel.rxnNames{i}=strrep(oldNamesToNewNamesRxns(New1122SpecificModel.rxns{i}),' ','_');
    New1122SpecificModel.rxns{i}=strrep(oldNamesToNewNamesRxns(New1122SpecificModel.rxns{i}),' ','_');
    New1122SpecificModel.rxnNames{i}=strrep(New1122SpecificModel.rxnNames{i},'-','_');
    New1122SpecificModel.rxns{i}=strrep(New1122SpecificModel.rxns{i},'-','_');
    New1122SpecificModel.rxnNames{i}=strrep(New1122SpecificModel.rxnNames{i},',','_');
    New1122SpecificModel.rxns{i}=strrep(New1122SpecificModel.rxns{i},',','_');
end
%set rxns_ids same as rxns, add R_ for Cytoscape
modelSBML=TranslateSBML('1122Specific.xml');
%New1122SpecificModel=addSBMLIdentifiersToCobra(modelSBML,New1122SpecificModel);
New1122SpecificModel.rxns_ids=New1122SpecificModel.rxns;
for i=1:length(New1122SpecificModel.rxns_ids)
    New1122SpecificModel.rxns_ids{i}=['R_' New1122SpecificModel.rxns_ids{i}];
end

%add new metabolites
New1122SpecificModel=addMet(New1122SpecificModel,'phenylpyruvate');
New1122SpecificModel=addMet(New1122SpecificModel,'arginine');
New1122SpecificModel=addMet(New1122SpecificModel,'fumarate');
New1122SpecificModel=addMet(New1122SpecificModel,'ubiquinol');
New1122SpecificModel=addMet(New1122SpecificModel,'ubiquinone');
New1122SpecificModel=addMet(New1122SpecificModel,'glucose');
New1122SpecificModel=addMet(New1122SpecificModel,'glucose_6_phosphate');
New1122SpecificModel=addMet(New1122SpecificModel,'6_phosphogluconolactone');
New1122SpecificModel=addMet(New1122SpecificModel,'6_phosphogluconate');
New1122SpecificModel=addMet(New1122SpecificModel,'ribulose_5_phosphate');
New1122SpecificModel=addMet(New1122SpecificModel,'geranylgeranyl_pyrophosphate');
New1122SpecificModel=addMet(New1122SpecificModel,'phytoene');
New1122SpecificModel=addMet(New1122SpecificModel,'lycopene');
New1122SpecificModel=addMet(New1122SpecificModel,'carotene');

%replace spaces with underscores, otherwise writeCbToSBML will not put
%ids for metabolites with spaces, which means they do not show up in
%Cytoscape
for i=1:length(New1122SpecificModel.mets)
    if(isKey(oldNamesToNewNamesMets,New1122SpecificModel.mets{i}))
        New1122SpecificModel.metNames{i}=strrep(oldNamesToNewNamesMets(New1122SpecificModel.mets{i}),' ','_');
        New1122SpecificModel.mets{i}=strrep(oldNamesToNewNamesMets(New1122SpecificModel.mets{i}),' ','_');
        New1122SpecificModel.metNames{i}=strrep(New1122SpecificModel.metNames{i},'-','_');
        New1122SpecificModel.mets{i}=strrep(New1122SpecificModel.mets{i},'-','_');
        New1122SpecificModel.metNames{i}=strrep(New1122SpecificModel.metNames{i},',','_');
        New1122SpecificModel.mets{i}=strrep(New1122SpecificModel.mets{i},',','_');
    end
    %add [P] to mets, for writeCbToSBML
    New1122SpecificModel.mets{i}=[New1122SpecificModel.mets{i} '[P]'];
    New1122SpecificModel.metNames{i}=[New1122SpecificModel.metNames{i} '[P]'];
end

%add new reactions, reverse direction of ornithine carbamoyltransferase
New1122SpecificModel=addReaction(New1122SpecificModel,'tryptophan_synthase', ...
    {'indole_3_glycerol_phosphate[P]','serine[P]'},[1 1],{'glyceraldehyde_3_phosphate[P]','tryptophan[P]','water[P]'},[1 1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'bifunctional_chorismate_mutase_prephenate_dehydratase', ...
    {'chorismate[P]','proton[P]'},[1 1],{'phenylpyruvate[P]','CO2[P]','water[P]'},[1 1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'imidazole_glycerol_phosphate_synthase', ...
    {'phosphoribulosyl_formimino_AICAR_phosphate[P]','glutamine[P]'},[1 1],...
    {'glutamate[P]','AICAR[P]','imidazole_glycerol_phosphate[P]','proton[P]'},[1 1 1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'N_succinyldiaminopimelate_aminotransferase', ...
    {'N_succinyl_2_amino_6_oxo_pimelate[P]','glutamine[P]'},[1 1],{'N_succinyl_2_6_diaminopimelate[P]','glutamate[P]'},[1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'bifunctional_diaminopimelate_epimerase_decarboxylase', ...
    {'diaminopimelate[P]'},[1],{'lysine[P]','CO2[P]'},[1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'histidinol_phosphate_phosphatase', ...
    {'histidinol_phosphate[P]'},[1],{'histidinol[P]','phosphate[P]'},[1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'isopropylmalate_isomerase', ...
    {'2_isopropylmalate[P]'},[1],{'3_isopropylmalate[P]'},[1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'argininosuccinase', ...
    {'argininosuccinate[P]'},[1],{'arginine[P]','fumarate[P]'},[1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'hexokinase', ...
    {'glucose[P]','ATP[P]'},[1 1],{'glucose_6_phosphate[P]','ADP[P]','phosphate[P]'},[1 1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'glucose_6_phosphate_dehydrogenase', ...
    {'glucose_6_phosphate[P]','NADP[P]'},[1 1],{'6_phosphogluconolactone[P]','NADPH[P]','proton[P]'},[1 1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'putative gluconolactonase', ...
    {'6_phosphogluconolactone[P]','water[P]'},[1 1],{'6_phosphogluconate[P]','proton[P]'},[1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'6_phosphogluconate_dehydrogenase', ...
    {'6_phosphogluconate[P]','NADP[P]'},[1 1],{'ribulose_5_phosphate[P]','CO2[P]','NADPH[P]'},[1 1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'phytoene_synthase', ...
    {'geranylgeranyl_pyrophosphate[P]'},[2],{'phytoene[P]','pyrophosphate[P]'},[1 2],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'phytoene_dehydratase', ...
    {'phytoene[P]','NADP[P]'},[1 4],{'lycopene[P]','NADPH[P]'},[1 4],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'lycopene_cyclase', ...
    {'lycopene[P]'},[1],{'carotene[P]'},[1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'adenylate_kinase', ...
    {'ATP[P]','AMP[P]'},[1 1],{'ADP[P]'},[2],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'purine_synthesis', ...
    {'ribulose_5_phosphate[P]'},[1],{'ADP[P]'},[1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'glutathione_reductase', ...
    {'NADPH[P]'},[1],{'NADP[P]'},[1],0,1000);
%New1122SpecificModel=addReaction(New1122SpecificModel,'spontaneous_NADH_oxidation', ...
%    {'NADH[P]'},[1],{'NAD[P]'},[1],0,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'pyrophosphatase', ...
    {'pyrophosphate[P]'},[1],{'phosphate[P]'},[2],-1000,1000);
%New1122SpecificModel=addReaction(New1122SpecificModel,'ADP_synthase', ...
%    {'phosphate[P]',''},[1],{'phosphate[P]'},[2],-1000,1000);

New1122SpecificModel.S(:,strcmp(New1122SpecificModel.rxns,'ornithine_carbamoyltransferase'))=...
    -New1122SpecificModel.S(:,strcmp(New1122SpecificModel.rxns,'ornithine_carbamoyltransferase'));

%exchange and transport reaction metabollites
selectMets={};
%selectMets{end+1}='6_phosphogluconate[P]';
selectMets{end+1}='phosphoenolpyruvate[P]';
selectMets{end+1}='erythrose_4_phosphate[P]';
selectMets{end+1}='2_oxobutyrate[P]';
selectMets{end+1}='AICAR[P]';
selectMets{end+1}='phosphate[P]';
selectMets{end+1}='water[P]';
%selectMets{end+1}='NADP[P]';
%selectMets{end+1}='NADPH[P]';
%selectMets{end+1}='proton[P]';
%selectMets{end+1}='ATP[P]';
selectMets{end+1}='ADP[P]';
selectMets{end+1}='pyruvate[P]';
selectMets{end+1}='glutamate[P]';
selectMets{end+1}='glutamine[P]';
%selectMets{end+1}='pyrophosphate[P]';
selectMets{end+1}='PRPP[P]';
selectMets{end+1}='CO2[P]';
selectMets{end+1}='aspartate[P]';
selectMets{end+1}='NAD(P)[P]';
selectMets{end+1}='NAD(P)H[P]';
selectMets{end+1}='serine[P]';
selectMets{end+1}='glyceraldehyde_3_phosphate[P]';
selectMets{end+1}='alpha_ketoglutarate[P]';
selectMets{end+1}='succinyl_CoA[P]';
selectMets{end+1}='CoA[P]';
selectMets{end+1}='succinate[P]';
selectMets{end+1}='acetyl_CoA[P]';
%selectMets{end+1}='NAD[P]';
%selectMets{end+1}='NADH[P]';
selectMets{end+1}='ornithine[P]';
selectMets{end+1}='fumarate[P]';
selectMets{end+1}='bicarbonate[P]';
%selectMets{end+1}='AMP[P]';
selectMets{end+1}='glucose[P]';
%selectMets{end+1}='ribulose_5_phosphate[P]';
selectMets{end+1}='geranylgeranyl_pyrophosphate[P]';
%selectMets{end+1}='carotene[P]';

for i=1:length(selectMets)
    ithSelectMet=selectMets{i};
    ithNewSelectMet=[ithSelectMet(1:end-3) '[h]'];
    New1122SpecificModel=addMet(New1122SpecificModel,ithNewSelectMet);
    New1122SpecificModel=addReaction(New1122SpecificModel,['Transport_of_' ithSelectMet(1:end-3) '_P'], ...
    {ithSelectMet},[1],{ithNewSelectMet},[1],-1000,1000);
    %if(strcmp(ithSelectMet,'ATP[P]'))
    %    New1122SpecificModel=addReaction(New1122SpecificModel,['Exchange_of_' ithNewSelectMet(1:end-3) '_h'], ...
    %{},[],{ithNewSelectMet},[1],0,1000);
    %elseif(strcmp(ithSelectMet,'ADP[P]'))
    %    New1122SpecificModel=addReaction(New1122SpecificModel,['Exchange_of_' ithNewSelectMet(1:end-3) '_h'], ...
    %{},[],{ithNewSelectMet},[1],-1000,0);
    %else
    New1122SpecificModel=addReaction(New1122SpecificModel,['Exchange_of_' ithNewSelectMet(1:end-3) '_h'], ...
    {ithNewSelectMet},[1],{},[],-1000,1000);
    %end
end

%transport reaction metabolites
selectMets2={};
selectMets2{end+1}='histidinol[P]';
selectMets2{end+1}='2_oxo_3_methylvalerate[P]';
selectMets2{end+1}='2_oxoisovalerate[P]';
selectMets2{end+1}='oxoleucine[P]';
selectMets2{end+1}='threonine[P]';
selectMets2{end+1}='tryptophan[P]';
selectMets2{end+1}='phenylpyruvate[P]';
selectMets2{end+1}='lysine[P]';
selectMets2{end+1}='arginine[P]';
selectMets2{end+1}='carotene[P]';
%selectMets2{end+1}='proton[P]';

for i=1:length(selectMets2)
    ithSelectMet2=selectMets2{i};
    ithNewSelectMet2=[ithSelectMet2(1:end-3) '[h]'];
    New1122SpecificModel=addMet(New1122SpecificModel,ithNewSelectMet2);
    New1122SpecificModel=addReaction(New1122SpecificModel,['Transport_of_' ithSelectMet2(1:end-3) '_P'], ...
    {ithSelectMet2},[1],{ithNewSelectMet2},[1],-1000,1000);
end

%metabolites only involved in added reactions, such as proton in ETC
selectMets3={};
selectMets3{end+1}='proton[h]';
selectMets3{end+1}='glucose_6_phosphate[h]';
selectMets3{end+1}='fructose_6_phosphate[h]';
selectMets3{end+1}='fructose_1,6_bisphosphate[h]';
selectMets3{end+1}='dihydroxyacetone_phosphate[h]';
selectMets3{end+1}='1,3_bisphosphoglycerate[h]';
selectMets3{end+1}='3_phosphoglycerate[h]';
selectMets3{end+1}='2_phosphoglycerate[h]';
selectMets3{end+1}='pyruvate[h]';
for i=1:length(selectMets3)
    ithSelectMet3=selectMets3{i};
    ithNewSelectMet3=[ithSelectMet3(1:end-3) '[h]'];
    New1122SpecificModel=addMet(New1122SpecificModel,ithNewSelectMet3);
end

New1122SpecificModel=addReaction(New1122SpecificModel,'biomass', ...
    {'tryptophan[h]','phenylpyruvate[h]','threonine[h]','histidinol[h]','lysine[h]','arginine[h]','2_oxo_3_methylvalerate[h]','2_oxoisovalerate[h]','oxoleucine[h]','ATP[P]','carotene[h]','ADP[P]'},...
    [.44646 .34595 .50742 .12009 .79509 .27163 .82581 .4858 .85355 45.5608 .00005 .013297*2],{'phosphate[P]','ADP[P]'},[45.5608 45.5608],-1000,1000);

New1122SpecificModel=addReaction(New1122SpecificModel,'pyruvate_dehydrogenase', ...
    {'pyruvate[P]','CoA[P]','NAD[P]'},[1 1 1],{'acetyl_CoA[P]','CO2[P]','NADH[P]'},[1 1 1],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'NADH_dehydrogenase', ...
    {'ubiquinone[P]','NADH[P]','proton[P]'},[1 1 5],{'ubiquinol[P]','NAD[P]','proton[h]'},[1 1 4],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'cytochrome_bo_oxidase', ...
    {'ubiquinol[P]','proton[P]','oxygen[P]'},[2 8 1],{'ubiquinone[P]','water[P]','proton[h]'},[2 2 8],-1000,1000);
New1122SpecificModel=addReaction(New1122SpecificModel,'ATP_synthase', ...
    {'phosphate[P]','ADP[P]','proton[h]'},[1 1 4],{'ATP[P]','water[P]','proton[P]'},[1 1 3],-1000,1000);

%retain mets only here after all reactions have been added
retainMetIdxs=[];
for i=1:length(New1122SpecificModel.mets)
    if(sum(abs(New1122SpecificModel.S(i,:)))~=0)
        retainMetIdxs(end+1)=i;
    end
end
New1122SpecificModel.mets=New1122SpecificModel.mets(retainMetIdxs);
New1122SpecificModel.metCharge=New1122SpecificModel.metCharge(retainMetIdxs);
New1122SpecificModel.metNames=New1122SpecificModel.metNames(retainMetIdxs);
New1122SpecificModel.metChEBIID=New1122SpecificModel.metChEBIID(retainMetIdxs);
New1122SpecificModel.metKEGGID=New1122SpecificModel.metKEGGID(retainMetIdxs);
New1122SpecificModel.metPubChemID=New1122SpecificModel.metPubChemID(retainMetIdxs);
New1122SpecificModel.metInChIString=New1122SpecificModel.metInChIString(retainMetIdxs);
New1122SpecificModel.b=New1122SpecificModel.b(retainMetIdxs);
New1122SpecificModel.S=New1122SpecificModel.S(retainMetIdxs,:);

writeCbToSBML(New1122SpecificModel,'New1122Specific.xml');
fluxDistBiomass=[];
nonZeroRxns=zeros(length(New1122SpecificModel.rxns),length(New1122SpecificModel.rxns));
for i=1:length(New1122SpecificModel.rxns)
    %i
    New1122SpecificModel=changeObjective(New1122SpecificModel,New1122SpecificModel.rxns(i),1);
    sol=optimizeCbModel(New1122SpecificModel);
    if(strcmp(New1122SpecificModel.rxns{i},'biomass'))
        fluxDistBiomass=sol.x;
    end
    for j=1:length(New1122SpecificModel.rxns)
        if(sol.x(j)~=0)
            nonZeroRxns(i,j)=sol.x(j);
        end
    end
    
    if(i<=length(New1122SpecificModel.rxns))
        fluxdata=cobra2fluxdata(New1122SpecificModel.id,New1122SpecificModel, ...
            {New1122SpecificModel.id},{sol.x(1:length(New1122SpecificModel.rxns))});
        fluxdata2XML(fluxdata,['1122FluxMaps/' New1122SpecificModel.rxns{i} '.xml']);
    end
end

%rename model id to Port in model file
readFID=fopen('New1122Specific.xml');
writeFID=fopen('New1122Specific2.xml','w');
line=fgetl(readFID);
while(line~=-1)
    if(regexp(line,'<model>'))
        line=strrep(line,'<model>','<model id="PORT" name="Generated from BioCyc Pathway/Genome Database">');
    end
    fprintf(writeFID,'%s\n',line);
    line=fgetl(readFID);
end
fclose(readFID);
fclose(writeFID);
delete('New1122Specific.xml');
movefile('New1122Specific2.xml','New1122Specific.xml');

[minFlux maxFlux]=fluxVariability(New1122SpecificModel);
[junk sortIdxs]=sort(maxFlux-minFlux);
sortedRxns=New1122SpecificModel.rxns(sortIdxs);