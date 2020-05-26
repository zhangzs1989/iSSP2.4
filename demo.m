 LB=[0 1]; % lower boundary
UB=[10000 10]; % upper boundary
%                     fitnessfcn = str2func('brune');
ObjectiveFunction = @brune; 
nvars = 2; % number of varibles
ConstraintFunction = []; % constraints
                    rng default; % for reproducibality ?
[coeff,fval]=ga(ObjectiveFunction,nvars);