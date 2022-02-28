function [z2] = b2_windowedConv2Dexp(x,N)
%WINDOWED_2D_CONV Compute windowed 2D convolution 

%load('x.mat')
%x = img;
%N = [100,100];
[rows_x, cols_x] = size(x);
cols_x_interp    = 2*cols_x-1;
x_interp         = interp1(linspace(1, cols_x_interp, cols_x), x', linspace(1, cols_x_interp, cols_x_interp))';
%q_x_interp       = x_interp.^2;
%y                = zeros(rows_x, cols_x_interp);
%z                = zeros(rows_x, cols_x_interp);
z2                = zeros(rows_x, cols_x_interp);
%conv1D           = zeros(rows_x, cols_x_interp);
%z                = zeros(rows_x, cols_x);

% % WITHOUT BORDERS
% tic
% for r = 1 : rows_x 
%     for c = N(2)+1 : cols_x_interp-N(2)
%         win_interp = x_interp(r,c-N(2):c+N(2));
%         conv1D(r,c) = sum(win_interp.*fliplr(win_interp));
%         if r>=N(1)+1
%             patch_rows = [r-N(1),r];
%             %patch_interp = x_interp(patch_rows(1):patch_rows(2),c-N(2):c+N(2));
%             z(r-N(1)/2,c) = sum(conv1D(patch_rows(1):patch_rows(2),c))./sum(sum(q_x_interp(patch_rows(1):patch_rows(2),c-N(2):c+N(2))));
%         end
%     end
% end
% z(isnan(z)) = 0;
% toc
convPippo = zeros(rows_x, cols_x_interp);
EnerPippo = zeros(rows_x, cols_x_interp);
col_utili = N(2)+1:cols_x_interp-N(2);
%tic
for r = 1 : rows_x%+N(1)/2
    if r<=rows_x
        R1 = mycirculant(x_interp(r,:),-1);
        R1 = R1(1:2*N(2)+1,1:cols_x_interp-2*N(2));
        convPippo(r,col_utili) = sum(R1.*flipud(R1));
        EnerPippo(r,col_utili) = sum(R1.^2);
    end
%     if r<=N(1)/2
%         continue
%     elseif r<=N(1)
%         patch_rows = [1,r];
%     elseif r<=rows_x
%         patch_rows = [r-N(1),r];
%     else
%         patch_rows = [r-N(1),rows_x];
%     end
%    z2(r-N(1)/2,col_utili) = sum(convPippo(patch_rows(1):patch_rows(2),col_utili))./sum(EnerPippo(patch_rows(1):patch_rows(2),col_utili));
end
for r = 1 : N(1)/2 
    z2(r,col_utili) = sum(convPippo(1:2*r-1,col_utili),1)./sum(EnerPippo(1:2*r-1,col_utili),1);
end
for r = N(1)/2+1:rows_x-N(1)/2
    z2(r,col_utili) = sum(convPippo(r-N(1)/2:r+N(1)/2,col_utili))./sum(EnerPippo(r-N(1)/2:r+N(1)/2,col_utili));
end
for r = rows_x-N(1)/2+1 : rows_x
    z2(r,col_utili) = sum(convPippo(2*r-rows_x:rows_x,col_utili),1)./sum(EnerPippo(2*r-rows_x:rows_x,col_utili),1);
end
z2(isnan(z2)) = 0;
%toc
% tic
% for r = 1 : rows_x 
%     for c = N(2)+1:cols_x_interp-N(2)
%         win_interp = x_interp(r,c-N(2):c+N(2));
%         conv1D(r,c) = sum(win_interp.*fliplr(win_interp));
%     end 
% end
% for r = 1 : N(1)/2 
%     for c = N(2)+1 : cols_x_interp-N(2)
%         y(r,c) = sum(conv1D(1:2*r-1,c)) / sum(sum(q_x_interp(1 : 2*r-1, c-N(2) : c+N(2))));
%     end
% end
% for r = N(1)/2+1:rows_x-N(1)/2
%     for c = N(2)+1:cols_x_interp-N(2)
%         y(r,c) = sum(conv1D(r-N(1)/2:r+N(1)/2,c))/ sum(sum(q_x_interp(r-N(1)/2 : r+N(1)/2, c-N(2) : c+N(2))));
%     end
% end
% for r = rows_x-N(1)/2+1 : rows_x
%     for c = N(2)+1:cols_x_interp-N(2)
%         y(r,c) = sum(conv1D(2*r-rows_x:rows_x,c))/ sum(sum(q_x_interp(2*r-rows_x:rows_x, c-N(2) : c+N(2))));
%     end
% end
% y(isnan(y)) = 0;
% toc

%R1 = mycirculant(x,-1);

