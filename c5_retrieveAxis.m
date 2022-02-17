function y = c5_retrieveAxis(singleAxisImage, angle)
% Controruota l'asse e ne calcola lo scheletro del binario
% (quindi direzione relativa all'angolo analizzato)

% Re-rotation stack
y = imrotate(singleAxisImage, -angle, 'bilinear', 'crop');

% BW stack
y = imfill(imbinarize(y, 0),'holes');
% y = imfill( bwareaopen( imbinarize(y, 0) ,P) ,'holes');

% Skel stack
y = bwmorph(skeleton(y)>0,'skel',Inf);
