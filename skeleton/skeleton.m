%SKELETON produces skeletons of binary images
%
% [skg,rad] = skelgrad(img) computes the skeleton for a binary image, and
% also the local radius at each point.

disp('Compiling...  (You may need to execute ''mex -setup'' first.)');
mex './skeleton.cpp'
% mex 'C:\Users\Utente\Dropbox\Dottorato\Leonardi - Progetto simmetrie\2D symmetry\Matlab\skeleton\skeleton.cpp'

