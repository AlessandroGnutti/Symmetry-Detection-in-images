function table_centers_ep = d8_saveResult(data, confidence,  rows, angRange)

% Compute center and angle for each present axis for each angle

how_many         = sum(cellfun(@length, confidence));
table_centers_ep = cell(how_many, 1); % Column and row - c, e1, e2, features
cols_data        = length(data(1,:));

count            = 1;
for k=1:length(confidence)
    temp        = zeros(1,8); % angle and C and R of center
    temp(1)     = 90-angRange(k); % Angle
    other_count = 1;
    for i=1:cols_data
        if ~isempty(data{k,i})
            CC                      = bwconncomp(data{k,i});
            [ax_x, ax_y]            = d4_compute1DInterp(CC.PixelIdxList{1}, rows, angRange(k));
            temp(2:7)               = d5_computeCenterEndPoints(ax_x, ax_y); % C, E1, E2
            temp(8)                = confidence{k}(other_count);
            table_centers_ep{count} = temp;
            count                   = count + 1;
            other_count             = other_count + 1;
        end
    end
    
end