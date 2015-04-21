function [ output_args ] = our_grad_check( fun, theta0, num_checks )
%OUR_GRAD_CHECK Summary of this function goes here
%   Detailed explanation goes here
   
  fprintf(' Iter       w             err');
  fprintf('           g_est               g               f\n')

    for i=1:num_checks
        th = theta0;
        n = size(th,1);
        w = randi(size(th,1));
        eps = 10e-4;
        X = randn(n,1);
        y = rand(1);
        e = zeros(n,1);
        e(w) = 1;
        
        [f,g] = fun(th, X, y);
        f1 = fun(th+(e*eps), X, y);
        f2 = fun(th-(e*eps), X, y);
        numGrad = (f1 - f2) / (2*eps);
        error = g(w) - numGrad;
        
        fprintf('% 5d  % 6d % 15g % 15f % 15f % 15f\n', ...
            i,w,error,g(w),numGrad,f);
        
    end

end

