function [ output_args ] = our_grad_check( fun, theta0, num_checks, X, y )
%OUR_GRAD_CHECK Summary of this function goes here
%   Detailed explanation goes here
   
  fprintf(' Iter       w             err');
  fprintf('           g_est               g               f\n')

    for i=1:num_checks
        th = theta0;
        n = size(th,1);
        w = randi(numel(th));
        eps = 10e-4;
        thPos = th;
        thPos(w) = thPos(w)+eps;
        thNeg = th;
        thNeg(w) = thNeg(w)-eps;
        
        [f,g] = fun(th, X, y);
        f1 = fun(thPos, X, y);
        f2 = fun(thNeg, X, y);
        numGrad = (f1 - f2) / (2*eps);
        error = g(w) - numGrad;
        
        fprintf('% 5d  % 6d % 15g % 15f % 15f % 15f\n', ...
            i,w,error,g(w),numGrad,f);
        
    end

end

