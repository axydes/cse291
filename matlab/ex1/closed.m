function [ theta ] = closed( X, y )
%CLOSED Closed form solution of linear regression: theta=inv(X'*X) * (X' * y)
%   Detailed explanation goes here

first = (X * y');
iv = inv(X * X');
theta = (first' * iv)';

end


