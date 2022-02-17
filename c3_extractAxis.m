function singleAxisImage = c3_extractAxis(my_bw, my_peak, CC, q)
% Estrae l'asse (pixel originali) dell'immagine ruotata
% (quindi in direzione verticale)

origSize = [size(my_bw, 1), (size(my_bw, 2)+1)/2];
plane = false(size(my_bw));
plane(CC.PixelIdxList{q}) = true;
temp = my_peak.*plane; % Immagine con un singolo asse
singleAxisImage = imresize(temp, origSize, 'bilinear'); % Resize image