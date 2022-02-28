function my_stack =...
    b0_firstPart_Y_Cb_Cr_YCbCr(YCBCR, range, bln_borders, n_p)

if length(size(YCBCR))==3
    numbComponents = 4;
elseif length(size(YCBCR))==2    
    numbComponents = 1;
else
    error('Something wrong')
end

% Stack
my_stack = zeros(size(YCBCR,1), 2*size(YCBCR,2)-1, length(range), numbComponents);

for k = 1:numbComponents
    
    fprintf('Symmetry Map Computation for component %d\n', k)
    if k<=3
        for i = 1:length(range)
            angle = range(i);
            my_stack(:,:,i,k) = b1_processStack(YCBCR(:,:,k), angle, bln_borders, n_p);
        end
    elseif k==4
        for i = 1:length(range)
            angle = range(i);
            my_stack(:,:,i,k) = b1_processStack_insieme(YCBCR, angle, bln_borders, n_p);
        end
    end
    
end

