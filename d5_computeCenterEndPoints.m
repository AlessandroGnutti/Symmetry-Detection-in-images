function out = d5_computeCenterEndPoints(x, y)
% COMPUTECENTERENDPOINTS Computes the center and the end-points of a
% segment.
%
%   OUT = computeCenterEndPoints(X,Y) returns the vector OUT composed by 6
%   elements: col and row of the center and of the two end-points
%   referred to the segment formed by (X,Y) points.

out = zeros(1,6);

if length(find(abs(x-mean(x))<1e-6)) == length(x) % Vertical lines
    
    out(1) = x(1);
    out(2) = (min(y) + max(y))/2;
    out(3) = x(1);
    out(4) = min(y);
    out(5) = x(1);
    out(6) = max(y);
    
else                                              % All other cases
    
    [~, im] = min(x);
    [~, iM] = max(x);
    
    out(1) = (x(im) + x(iM))/2;
    out(2) = (y(im) + y(iM))/2;
    out(3) = x(im);
    out(4) = y(im);
    out(5) = x(iM);
    out(6) = y(iM);
    
end



