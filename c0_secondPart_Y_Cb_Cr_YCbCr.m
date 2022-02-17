function [metrica, data] =...
    c0_secondPart_Y_Cb_Cr_YCbCr...
    (YCBCR, f1, bw_stack, peak_stack, gammaH, gammaL, bln_borders, n_p, range,str_metrica)


if length(size(YCBCR))==3
    numbComponents = 3;
elseif length(size(YCBCR))==2
    numbComponents = 1;
else
    error('Something wrong')
end

% Features
metrica = cell(length(range),1);

M = 0;
for comp = 1:numbComponents
    M = max(M,max(cellfun(@length,f1(:,comp))));
end
data = cell(length(range), M);

for t = 1:length(range)
    how_many = 0; % Quante volte dolpo la controrotazione l'asse si spezza e quindi rimossa
    angle = range(t);
    fprintf('angle %d ',angle);
    [Gmag, Gdir, GmagTh, GmagTh_v2, edge_bw] =...
        c1_calculateGradient(YCBCR(:,:,1), angle, gammaH, gammaL); 
    contatorefondamentale = 1;
    count = 0;
    for comp = 1:numbComponents
        CC = bwconncomp(bw_stack(:,:,t,comp));
        for q=1:length(f1{t,comp})
            singleAxisImage = c3_extractAxis...
                (bw_stack(:,:,t,comp), peak_stack(:,:,t,comp), CC, q);
            % Analysis of gradient
            if bln_borders
                if strcmp(str_metrica,'f5')
                    [metrica{t}(contatorefondamentale)] =...
                        c4_computef5(singleAxisImage, GmagTh, Gdir, n_p);
                elseif strcmp(str_metrica,'f6')
                    [metrica{t}(contatorefondamentale)] =...
                        c4_computef6(singleAxisImage, GmagTh, Gdir, n_p);
                elseif strcmp(str_metrica,'f7')
                    [metrica{t}(contatorefondamentale)] =...
                        c4_computef7(singleAxisImage, GmagTh, Gdir, n_p);
                elseif strcmp(str_metrica,'f61')
                    [metrica{t}(contatorefondamentale)] =...
                        c4_computef61(singleAxisImage, GmagTh, Gdir, n_p);
                elseif strcmp(str_metrica,'f71')
                    [metrica{t}(contatorefondamentale)] =...
                        c4_computef71(singleAxisImage, GmagTh, Gdir, n_p);
                elseif strcmp(str_metrica,'f72')
                    [metrica{t}(contatorefondamentale)] =...
                        c4_computef72(singleAxisImage, GmagTh, Gdir, n_p);
                end    
            end
            skelSingleAxis = c5_retrieveAxis(singleAxisImage, angle);
            % Controllo che dopo la contro-rotazione l'asse non si sia
            % spezzata: in caso quell'asse viene rimossa
            elementi = bwconncomp(skelSingleAxis);
            if elementi.NumObjects ~= 1 || length(elementi.PixelIdxList{1})==1
                f1{t,comp}(q) = 0;
                count = count +1;
                contatorefondamentale = contatorefondamentale+1;
                how_many = how_many + 1;
                continue
            else
                data{t,contatorefondamentale-count} = skelSingleAxis; % Save the bin axis
            end
            contatorefondamentale = contatorefondamentale+1;
        end
    end
    fprintf('Confidence\n');
end

metrica = c6_fixAndNormalizeFeatures_unacomponenteallavoltatutteinsieme(f1, metrica);