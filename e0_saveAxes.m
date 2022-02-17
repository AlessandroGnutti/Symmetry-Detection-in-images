function [new_data, new_confidence, final_data, final_confidence,...
    img_detected_refs, best_detected_refs] = e0_saveAxes(data,...
    confidence, rows_img, control, th_final, range)

[new_data, new_confidence] = d3_deleteOverlappedAxes(data, confidence, rows_img, control, range);
fprintf('DONE overlap\n');
% Delete axis under the threshold
[final_data, final_confidence] = d7_filterAxes(new_data, new_confidence, th_final);
% Output
table_centers_ep    = d8_saveResult(final_data, final_confidence,  rows_img, range);
[img_detected_refs, best_detected_refs] = d9_fixSaveResult(table_centers_ep);