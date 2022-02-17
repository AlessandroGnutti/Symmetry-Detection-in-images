clear
close all
clc

% Needed paths
addpath('skeleton');
addpath('altmany-export_fig-a0f8ec3');

% Strings
str_conference  = 'DatasetICCV17/'; % Parametro variabile
str_imageset    = 'Testset/'; % Parametro variabile
str_scenario    = 'ref_s/'; % Parametro variabile
str_images      = 'Images/';
str_stack       = 'Stack/';
str_fold        = strcat(str_conference, str_imageset, str_scenario, str_images);
str_fold_stack = strcat(str_conference, str_imageset, str_scenario, str_stack);

% Load images
files_img       = dir(strcat(str_fold, '*.jpg'));

% Parameters
angle_max       = 180;
range           = 2:2:angle_max;
minimum_size    = 200;
thr_imfill      = 0.25;
areaPerc        = 0.25;
gammaH          = 0.35;
gammaL          = 0.35;
cho_patch_size  = 'd'; % Patch size: Dymanic or Fixed
cho_convolution = 'load'; % Convolution: COMPUTE or LOAD
bln_borders     = true; % True -> padding

for img_number = 1
    clearvars -except str_* files_img...
        angle_max range minimum_size thr_imfill areaPerc gammaH gammaL...
        cho_* bln_borders img_number
    
    name_img = files_img(img_number).name;
    disp(name_img);
    
    % Image load and pre-processing operations
    [img_or, YCBCR] = a1_loadAndPreprocess(str_fold, name_img, minimum_size);
    if length(size(YCBCR))==3
        numbComponents = 4;
    elseif length(size(YCBCR))==2
        numbComponents = 1;
    else
        error('Something wrong')
    end
    % Parameters image-based
    P   = round(thr_imfill*min(size(YCBCR(:,:,1)))); % Threshold imfill
    n_p = a2_computePatchSize(cho_patch_size, areaPerc, YCBCR(:,:,1));
    
    %--- PART 1: AXIS DETECTIxON ---%
    
    if strcmp(cho_convolution, 'load')
        name_stack = strcat(str_fold_stack,...
            sprintf('Stack_aP%d_%s.mat',areaPerc*100,name_img(1:end-4)));
        load(name_stack)
        fprintf('Stack loaded\n')
    else
        tic
        stack = b0_firstPart_Y_Cb_Cr_YCbCr(YCBCR, range, bln_borders, n_p);
        toc
        %#####################################################################%
        name_s = strcat(str_conference, str_imageset, str_scenario, 'Stack/',...
            sprintf('stack_aP%d_%s.mat',areaPerc*100,name_img(1:end-4)));
        save(name_s,'stack');
        %#####################################################################%
    end
    
    stack(:,[1:n_p, size(stack,2)-n_p+1:end],:,:) = 0; % Azzero i bordi
    
    % Peaks computation and BW stack
    peak_stack = zeros(size(stack));
    bw_stack   = zeros(size(stack));
    f1 = cell(length(range),numbComponents);
    for i = 1:numbComponents
        for t = 1:length(range)
            angle = range(t);
            for r = 1:size(stack, 1)
                [~, peaks] = findpeaks(stack(r,:,t,i));
                peak_stack(r, peaks, t, i) = stack(r, peaks, t, i);
            end
            bw_stack(:,:,t,i) = imfill( bwareaopen( imbinarize(peak_stack(:,:,t,i), 0) ,P) ,'holes');
            % f1
            f1{t,i} = b4_computef1(bw_stack(:,:,t,i),peak_stack(:,:,t,i));
        end
    end
    fprintf('f1 computation done.\n')
    
    %--- PART 2: GRADIENT PROCESSING ---%
    
    % Metrica: f5 - f6 - f61 - ...
    [metrica, data] =...
        c0_secondPart_Y_Cb_Cr_YCbCr...
        (YCBCR, f1, bw_stack, peak_stack, gammaH, gammaL, bln_borders, n_p, range,'f6');
    
    %--- PART 3: FILTERING REDUNDANT AND LOW RESPONSE AXES ---%
    
    control = 1;
    th_final = 0.5;
    [~, ~, ~, ~,...
    img_detected_refs, best_detected_refs] =...
    e0_saveAxes(data, metrica, size(img_or,1), control, th_final, range);
   
end