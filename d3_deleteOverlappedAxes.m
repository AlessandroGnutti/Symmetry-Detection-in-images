function [new_data, new_confidence]   = d3_deleteOverlappedAxes(data, confidence, rows, control, angRange)

if control == 0
    new_data        = data;
    new_confidence  = confidence;
    return;
end

dAng = angRange(2)-angRange(1);

% Removal near axis in the same plane
fixed_confidence  = confidence;
temp_confidence   = confidence;
numbComponents = size(confidence,2);
for comp = 1:numbComponents
    
    % Compute endpoints and center for each present axis for each angle
    table_centers_ep = cell(size(confidence,1), 1); % Column and row - c, e1, e2
    for k=1:size(confidence,1)
        num = length(confidence{k,comp});
        temp = zeros(1,6*num); % If there two axis, then length(temp)==12
        for i=1:num
            
            CC                    = bwconncomp(data{k,i,comp});
            points                = CC.PixelIdxList{1};
            [ax_x, ax_y]          = d4_compute1DInterp(points, rows, angRange(k));
            temp(6*(i-1)+1:6*i)   = d5_computeCenterEndPoints(ax_x, ax_y);
        end
        table_centers_ep{k} = temp;
    end
    
    for k=1:size(confidence,1)
        if isempty(confidence{k,comp})
            continue;
        end
        [~, indici] = sort(confidence{k,comp}, 'descend');
        for q=1:length(confidence{k,comp})-1 % L'ultimo non può cancellare niente
            for z=q+1:length(confidence{k,comp})
                p1A = table_centers_ep{k}((indici(q)-1)*6+3:(indici(q)-1)*6+4);
                p1B = table_centers_ep{k}((indici(q)-1)*6+5:(indici(q)-1)*6+6);
                c1  = table_centers_ep{k}((indici(q)-1)*6+1:(indici(q)-1)*6+2); %#ok<NASGU>
                p2A = table_centers_ep{k}((indici(z)-1)*6+3:(indici(z)-1)*6+4);
                p2B = table_centers_ep{k}((indici(z)-1)*6+5:(indici(z)-1)*6+6);
                c2  = table_centers_ep{k}((indici(z)-1)*6+1:(indici(z)-1)*6+2);
                dist    = d6_computeDistancePointSegmentLine(p1A, p1B, c2);
%                 th_dist = 0.2*min(pdist([p1A; p1B]), pdist([p2A; p2B]));
                th_dist = 10;
                if dist < th_dist
                    confidence{k,comp}(indici(z))    = 0;
                    data{k,indici(z),comp}           = [];
                end
            end
        end
    end
    
    % Removal near axis in different planes
    range           = 10;
    i               = 1;
    ric             = 0;
    while(true)
        % Nel caso in cui ci sia un angolo senza candidati, cellfun va in
        % crisi a calcolare il massimo di un array vuoto. Per sistemare
        % questo "bug", metto un valore bassissimo al posto dell'array
        % vuoto. FEBBRAIO 2020
        nonEmptyCells = cellfun(@isempty,temp_confidence(:,comp));
        aux_conf = temp_confidence;
        aux_conf(nonEmptyCells) = {0};
        max_confidence                     = cellfun(@(x)max(x(:)), aux_conf(:,comp));
        [max_confidence, ind_max_confidence] = max(max_confidence);
        if isempty(max_confidence) || max_confidence == 0
            break;
        end
        
%         ang = find(nonEmptyCells==true); % Il vero angolo col massimo
        ang = angRange(ind_max_confidence);
%         ang
        ind = find(temp_confidence{ind_max_confidence,comp}==max_confidence); % L'indice dell'asse sul piano
        temp_confidence{ind_max_confidence,comp}(ind) = 0;
        w = find(ric==ang); % Controllo che angolo sia già stato analizzato
        if w % Risposta positiva
            count_(w) = count_(w)+1; % Aggiorno info sull'angolo. count_ mi dice quante assi ho analizzato su quell'angolo
            if count_(w) == length(confidence{ind_max_confidence,comp})
                count_(w) = 0; % Le ho analizzate tutte, quel piano non dovrà più essere utilizzato
            end
        elseif isempty(w) % Prima volta che valuto quel piano
            ric(i) = ang; % Aggiorno angoli analizzati
            if length(confidence{ind_max_confidence,comp})==1 % C'è solo un asse, quel piano non dovrà più essere utilizzato
                count_(i) = 0;
            else % Ce ne sono più di uno, allora dico che sto analizzando il primo
                count_(i) = 1;
            end
            i = i + 1;
        end
        
        if ang <= range % Occhio se dAng non divide ang
            left = 180 - (range-ang);
            to_evaluate = [left:dAng:180, dAng:dAng:ang-dAng, ang+dAng:dAng:ang+range];
        elseif ang>(180-range)
            right = range - (180-ang);
            to_evaluate = [ang-range:dAng:ang-dAng, ang+dAng:dAng:180, dAng:dAng:right];
        else
            to_evaluate = [ang-range:dAng:ang-dAng, ang+dAng:dAng:ang+range];
        end
        to_evaluate = to_evaluate/dAng;
        
        for j=1:length(to_evaluate)
%             j
%             comp
            beta_idx = to_evaluate(j);
            gia_valutato = find(ric==angRange(beta_idx)); % Angolo già analizzato?
            many = 0;
            if gia_valutato
                many = count_(gia_valutato); % Se sì, quanti assi?
            end
            if ~ismember(angRange(beta_idx), ric) || many % Se non è stato valutato oppure se ci sono ancora assi da analizzare
                for q=1:length(confidence{beta_idx,comp})-many % Assi ancora da valutare
%                     [~, altri_indici] = sort(fixed_confidence{beta_idx,comp}, 'ascend'); % Prendo i più piccoli perchè non sono ancora stati valutati
                    [~, altri_indici] = sort(fixed_confidence{beta_idx,comp}, 'descend'); % Prendo i più piccoli perchè non sono ancora stati valutati
                    altri_indici = altri_indici(end:-1:1);
                    mappatura = altri_indici(q);
                    p1A = table_centers_ep{ind_max_confidence}((ind-1)*6+3:(ind-1)*6+4);
                    p1B = table_centers_ep{ind_max_confidence}((ind-1)*6+5:(ind-1)*6+6);
                    c1  = table_centers_ep{ind_max_confidence}((ind-1)*6+1:(ind-1)*6+2); %#ok<NASGU>
                    p2A = table_centers_ep{beta_idx}((mappatura-1)*6+3:(mappatura-1)*6+4);
                    p2B = table_centers_ep{beta_idx}((mappatura-1)*6+5:(mappatura-1)*6+6);
                    c2  = table_centers_ep{beta_idx}((mappatura-1)*6+1:(mappatura-1)*6+2);
                    dist    = d6_computeDistancePointSegmentLine(p1A, p1B, c2);
%                     th_dist = 0.2*min(pdist([p1A; p1B]), pdist([p2A; p2B]));
                    th_dist = 10;
                    if dist < th_dist
                        confidence{beta_idx,comp}(mappatura)     = 0;
                        data{beta_idx,mappatura,comp}            = [];
                    end
                end
            end
        end
        
    end
    
end
new_confidence  = confidence;
new_data        = data;