function cella = c7_normalizeCell(cella)

nonEmptyCells          = ~cellfun(@isempty,cella);
max_cella              = cellfun(@(x)max(x(:)), cella(nonEmptyCells));
max_cella              = max(max_cella);
if ~max_cella
    return
end
cella(nonEmptyCells)   = cellfun(@rdivide, cella(nonEmptyCells), num2cell(repmat(max_cella, size(cella(nonEmptyCells), 1),1)),'UniformOutput',false);