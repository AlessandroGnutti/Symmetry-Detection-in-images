function [img_detected_refs, best_detected_refs] = d9_fixSaveResult(table_centers_ep)

N_axis              = size(table_centers_ep,1);
img_detected_refs   = zeros(N_axis,5);
for k = 1:N_axis
    img_detected_refs(k,1) = table_centers_ep{k}(4);
    img_detected_refs(k,2) = table_centers_ep{k}(5);
    img_detected_refs(k,3) = table_centers_ep{k}(6);
    img_detected_refs(k,4) = table_centers_ep{k}(7);
    img_detected_refs(k,5) = table_centers_ep{k}(8);
end
[~,idx]             = sort(img_detected_refs(:,5),'descend');
img_detected_refs   = img_detected_refs(idx,:);
best_detected_refs  = img_detected_refs(1,1:4);