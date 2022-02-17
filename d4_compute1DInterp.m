function [X, Y] = d4_compute1DInterp(points, rows, ang)
% COMPUTE1DINTERP Computes interpolated points (x,y) referred to (col,row)
% coordinate system.
%
%   [X,Y] = compute1DInterp(POINTS,ROWS,ANG) starting by 1D POINTS
%   computes 2D points in coordinates (X,Y). ROWS is a number indicating
%   the rows of the image where plot(X,Y) can be displayed. ANG is the a 
%   priori slope of the axis perpendicular to the axis interpolating (X,Y). 
%   Such a value ranges from 1 to 179. Vertical or horizontal regression is 
%   used based on slope of the interpolating axis.

preY            = mod(points, rows); % Row coordinates
preY(preY==0)   = rows;              % Rows indexed by zero refer to the last row               
X               = ceil(points/rows); % Col coordinates
    
if ang >=160 || ang<=20              % Vertical regression
    p         = polyfit(preY, X, 1);
    Y         = preY;
    X         = polyval(p,preY);
else                                 % Horizontal regression
    p         = polyfit(X, preY, 1);
    Y         = polyval(p,X);
end