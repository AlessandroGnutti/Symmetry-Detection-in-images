function dst = d6_computeDistancePointSegmentLine(p1, p2, c)
% COMPUTEDISTANCEPOINTSEGMENTLINE Computes the point-segment distance.
%
%   DST = computeDistancePointSegmentLine(P1, P2, C) returns the distance
%   between the segment which endpoints are P1 and P2 given in (col,row)
%   coordinates and the point C.
%
%   The adopted algorithm is described in:
%   http://math.stackexchange.com/questions/322831/determing-the-distance-from-a-line-segment-to-a-point-in-3-space

u = [p2(1) - p1(1), p2(2) - p1(2)]; % Vector u = p1p2
v = [c(1) - p1(1), c(2) - p1(2)];   % Vector v = p1c

pr = dot(u,v)/sum(u.^2);

if pr>=0 && pr<=1
    p = p1 + pr*u;
    dst = pdist([c; p]);
elseif pr >1
    dst = pdist([c; p2]);
elseif pr<0
    dst = pdist([c; p1]);
end