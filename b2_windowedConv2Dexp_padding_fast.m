function [z2,R1] = b2_windowedConv2Dexp_padding_fast(x,N)
%WINDOWED_2D_CONV Compute windowed 2D convolution 
% N è riferito alla dimensione dell'immagine originale (non interpolata)
[rows_x, cols_x] = size(x);
cols_x_interp    = 2*cols_x-1;
x_interp         = interp1(linspace(1, cols_x_interp, cols_x), x', linspace(1, cols_x_interp, cols_x_interp))';
z2                = zeros(rows_x, cols_x_interp);

convPippo = zeros(rows_x, cols_x_interp);
EnerPippo = zeros(rows_x, cols_x_interp);

% N_pad = round(0.2*cols_x);
N_pad = round(N(2)/2.5);
N_pad_interp = 2*N_pad;
x_interp_pad = [zeros(rows_x, N_pad_interp), x_interp, zeros(rows_x, N_pad_interp)];
col_utili = N(2)-N_pad_interp+1:cols_x_interp-N(2)+N_pad_interp;
mat_bln = ones(2*N(2)+1,length(col_utili));
lower_tr_mat = tril(ones(N_pad_interp),-1);
mat_bln(1:N_pad_interp, end-N_pad_interp+1:end) = lower_tr_mat;
mat_bln(end-N_pad_interp+1:end, 1:N_pad_interp) = lower_tr_mat';
for r = 1 : rows_x
    R1 = b3_small_circulant(x_interp_pad(r,:),2*N(2)+1);    
    convPippo(r,col_utili) = sum(R1.*flipud(R1));
    EnerPippo(r,col_utili) = sum((R1.*mat_bln).^2);
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