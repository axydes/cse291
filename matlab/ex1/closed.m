function [ theta ] = closed( X, y )
%CLOSED Summary of this function goes here
%   Detailed explanation goes here

first = (X * y');
iv = inv(X * X');
theta = (first' * iv)';

end


