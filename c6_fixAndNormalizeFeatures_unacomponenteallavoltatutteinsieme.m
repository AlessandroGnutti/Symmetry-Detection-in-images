function metrica = c6_fixAndNormalizeFeatures_unacomponenteallavoltatutteinsieme(f1, metrica)

numbComp = size(f1,2);

for i = 1:size(f1,1)
    indfx = [];
    % Fix
    for comp = 1:numbComp
        ind = f1{i,comp}==0;
        indfx=[indfx ind];
        if isempty(ind)
        else
            f1{i,comp}(ind) = [];
        end
    end
    if ~isempty(indfx)
        metrica{i}(logical(indfx)) = [];
    end
    
end
metrica = c7_normalizeCell(metrica);