function [final_data, final_confidence]      = d7_filterAxes(data, confidence, thr)

final_data        = data;
final_confidence  = confidence;
for comp = 1:size(confidence,2)
    for angle = 1:size(confidence,1)
        
        if ~isempty(confidence{angle,comp})
            ind = find(confidence{angle,comp}<thr & confidence{angle,comp}>0);
            for var = ind
                final_confidence{angle,comp}(var)          = 0;
                final_data{angle,var,comp}                 = [];
            end
        end
        
    end
    
    % Fix
    for i=1:size(confidence,1)
        ind = final_confidence{i,comp}==0;
        if isempty(ind)
        else
            final_confidence{i,comp}(ind) = [];
        end
        temp = find(ind==1);
        for q=1:length(temp)
            final_data{i,temp(q),comp} = [];
        end
    end
end


