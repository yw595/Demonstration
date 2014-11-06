%must take 1122SpecificOnlyEnzymes.xml file for model
addUnbalancedImportantExchanges=0;
newModel=model;
newModel.id='SPECIFIC';
modelSBML=TranslateSBML('1122SpecificOnlyEnzymes.xml');
newModel=addSBMLIdentifiersToCobra(modelSBML,newModel);

retainRxns=[];
for i=1:length(model.rxnNames)
  if(isempty(regexp(model.rxnNames{i},'^RXN')) || strcmp(model.rxnNames{i},'RXN-8991') || strcmp(model.rxnNames{i},'RXN-7800'))
    retainRxns(end+1)=i;
  end
end
newModel.rxns=model.rxns(retainRxns);
newModel.lb=model.lb(retainRxns);
newModel.ub=model.ub(retainRxns);
newModel.c=model.c(retainRxns);
newModel.rev=model.rev(retainRxns);
newModel.rxnNames=model.rxnNames(retainRxns);
newModel.rxns_ids=newModel.rxns_ids(retainRxns);
newModel.S=model.S(:,retainRxns);

retainMets=[];
for i=1:length(newModel.mets)
  if(sum(abs(newModel.S(i,:)))~=0)
    retainMets(end+1)=i;
  end
end
newModel.mets=model.mets(retainMets);
newModel.metCharge=model.mets(retainMets);
newModel.metNames=model.metNames(retainMets);
newModel.metChEBIID=model.metChEBIID(retainMets);
newModel.metKEGGID=model.metKEGGID(retainMets);
newModel.metPubChemID=model.metPubChemID(retainMets);
newModel.metInChIString=model.metInChIString(retainMets);
newModel.b=model.b(retainMets);
newModel.S=newModel.S(retainMets,:);

newModelSave=newModel;
newModelSave.name='SPECIFIC';

metConnections=[];
for i=1:length(newModel.mets)
  metConnections(end+1)=sum(newModel.S(i,:)~=0);
end

selectMets={'L-valine: C5H11NO2','L-leucine: C6H13NO2','L-glutamate: C5H8NO4','2-oxoglutarate: C5H4O5','pyruvate: C3H3O3','CO2: CO2','H+: H','NADP+: C21H25N7O17P3','NADPH: C21H26N7O17P3','H2O: H2O','acetyl-CoA: C23H34N7O17P3S','coenzyme A: C21H32N7O16P3S','NAD+: C21H26N7O14P2','NADH: C21H27N7O14P2','(2S)-2-isopropyl-3-oxosuccinate: C7H8O5'};

unbalancedMets={};
unbalancedIdxs=[];
importantMets={};
importantIdxs=[];

for i=1:size(newModel.S,1)
  if(sum(strcmp(newModel.metNames{i},selectMets))~=0)
    importantMets{end+1}=newModel.metNames{i};
    importantIdxs(end+1)=i;
  end
end

for i=1:length(importantMets)
  newModel.rxns{end+1}=['EX_' importantMets{i}];
  newModel.lb(end+1)=-1000;
  newModel.ub(end+1)=1000;
  newModel.c(end+1)=0;
  newModel.rev(end+1)=1;
  newModel.rxnNames{end+1}=['Exchange of ' importantMets{i}];
  newModel.S(:,end+1)=zeros(length(newModel.mets),1);
  newModel.S(importantIdxs(i),end)=-1;
end

if(addUnbalancedImportantExchanges)
for i=1:size(newModel.S,1)
  if(sum(newModel.S(i,:)>0)==0 || sum(newModel.S(i,:)<0)==0)
    unbalancedMets{end+1}=newModel.metNames{i};
    unbalancedIdxs(end+1)=i;
  end
  if(sum(strcmp(newModel.metNames{i},newModel.metNames(metConnections>2)))~=0 || sum(strcmp(newModel.mets{i},{'ACETYL__45__COA','CO__45__A'}))~=0)
    importantMets{end+1}=newModel.metNames{i};
    importantIdxs(end+1)=i;
  end
end

for i=1:length(unbalancedMets)
  newModel.rxns{end+1}=['EX_' unbalancedMets{i}];
  newModel.lb(end+1)=-1000;
  newModel.ub(end+1)=1000;
  newModel.c(end+1)=0;
  newModel.rev(end+1)=1;
  newModel.rxnNames{end+1}=['Exchange of ' unbalancedMets{i}];
  newModel.S(:,end+1)=zeros(length(newModel.mets),1);
  newModel.S(unbalancedIdxs(i),end)=-1;
end

for i=1:length(importantMets)
  newModel.rxns{end+1}=['EX_' importantMets{i}];
  newModel.lb(end+1)=-1000;
  newModel.ub(end+1)=1000;
  newModel.c(end+1)=0;
  newModel.rev(end+1)=1;
  newModel.rxnNames{end+1}=['Exchange of ' importantMets{i}];
  newModel.S(:,end+1)=zeros(length(newModel.mets),1);
  newModel.S(importantIdxs(i),end)=-1;
end
end

objValues=[];
nonZeroRxns=zeros(length(newModel.rxns),length(newModel.rxns));
for i=1:length(newModel.rxns)
  i
  newModel=changeObjective(newModel,newModel.rxns(i),1);
  sol=optimizeCbModel(newModel);
  for j=1:length(newModel.rxns)
    if(sol.x(j)~=0)
      nonZeroRxns(i,j)=sol.x(j);
    end
  end
  objValues(end+1)=sol.f;

  if(i<=length(newModel.rxns)-length(unbalancedMets)-length(importantMets))
    fluxdata=cobra2fluxdata(newModelSave.id,newModelSave,{newModelSave.id},{sol.x(1:length(newModel.rxns)-length(unbalancedMets)-length(importantMets))});
    fluxdata2XML(fluxdata,['1122FluxMaps/' newModel.rxns{i} '.xml']);
  end
end

subNonZeroRxns=nonZeroRxns(1:length(newModel.rxns)-length(unbalancedMets)-length(importantMets),1:length(newModel.rxns)-length(unbalancedMets)-length(importantMets));
subObjValues=objValues(1:length(newModel.rxns)-length(unbalancedMets)-length(importantMets));