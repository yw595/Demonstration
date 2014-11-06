function newModel = addMetYiping(oldModel,metName)
    newModel=oldModel;
    newModel.mets{end+1}=metName;
    newModel.metCharge(end+1)=0;
    newModel.metNames{end+1}=metName;
    newModel.metChEBIID{end+1}='';
    newModel.metKEGGID{end+1}='';
    newModel.metPubChemID{end+1}='';
    newModel.metInChIString{end+1}='';
    newModel.b(end+1)=0;
    newModel.S(end+1,:)=zeros(1,length(newModel.rxns));
end