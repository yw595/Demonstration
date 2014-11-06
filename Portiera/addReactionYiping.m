function newModel = addReactionYiping(oldModel,reactionName,reactants,reactantsSto,products,productsSto,lowerBound,upperBound)
    newModel=oldModel;
    newModel.rxns{end+1}=reactionName;
    newModel.lb(end+1)=lowerBound;
    newModel.ub(end+1)=upperBound;
    newModel.c(end+1)=0;
    newModel.rev(end+1)=1;
    newModel.rxnNames{end+1}=reactionName;
    newModel.rxns_ids{end+1}=['R_' reactionName];
    newModel.S(:,end+1)=zeros(length(newModel.mets),1);
    for i=1:length(reactants)
        newModel.S(strcmp(newModel.metNames,reactants{i}),end)=-reactantsSto(i);
    end
    for i=1:length(products)
        newModel.S(strcmp(newModel.metNames,products{i}),end)=productsSto(i);
    end
end