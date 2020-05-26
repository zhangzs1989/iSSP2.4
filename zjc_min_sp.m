function misfit=zjc_min_sp(x,model)
% 
%	x - [omg;fc;gamma;fmax;p];  %零频极值，拐角频率，衰减，最大频率，衰减率
% Output:
%	misfit - misfit between theoretic spectrum and observed spectrum.
%-------------------------------------------------------------------------
% JC Zheng, Aug 12, 2015 @ 408# C Plaza, 2066 Gangxi Rd, Jinan.

    global fv
    global displ
    global vel
    global acc

    global fun_d
    global fun_v
    global fun_a
%global fun_t
    fun_Brune = @(par,x)  par(1)./(1+(x./par(2)).^2);
	fun_Boore = @(par,x) (1+(x./par(1)).^par(2)).^(-1);

	fun_d=@(coeffs,f)                 fun_Brune(coeffs(1:2),f).*fun_Boore(coeffs(3:4),f);
	fun_v=@(coeffs,f) (2*pi.*f)     .*fun_Brune(coeffs(1:2),f).*fun_Boore(coeffs(3:4),f);
	fun_a=@(coeffs,f) (2*pi.*f).^2.0.*fun_Brune(coeffs(1:2),f).*fun_Boore(coeffs(3:4),f);
	fun_t=@(coeffs,f) (2*pi.*f).^3.5.*fun_Brune(coeffs(1:2),f).*fun_Boore(coeffs(3:4),f);

if strcmp(x(1:4),'init')
    options =  psoptimset;
    options.ConstrBoundary = 'soft' ;
    options.ConstrBoundary = 'penalize' ;
    options.Display = 'off' ;
    options.Generations = 100 ;
    options.HybridFcn = @fmincon ;
	%options.PlotFcns = @psoplotbestf;      %%//%% plot
    options.PopInitRange = [   0   0   10   1 ; ...
                             10^4  10  20   5];
    options.PopulationSize = 72 ;
    options.TolCon = 1e-3;
    options.TolFun = 1e-3;
    % options.KnownMin = [] ;
    misfit = options;

else
    x   = reshape(x,[],1) ;
    spektr_d = fun_d(x,fv);
    spektr_v = fun_v(x,fv);
    spektr_a = fun_a(x,fv);

%     omg  = x(1);  %    x(1) is 
%     fc   = x(2);  %    x(2) is 
%     gamma= x(3);  %    x(3) is 
%     fmax = x(4);  %    x(4) is 
%     p    = x(5);  %    x(5) is 

											% Brune Model with high cut
% 	spektr_d = ((2*pi*fv).^0)*omg./((1.+(fv./fc).^gamma).*(1.+(fv./fmax).^p));
%     spektr_v = ((2*pi*fv).^1).*spektr_d;
%     spektr_a = ((2*pi*fv).^1).*spektr_v;

% 	ind=true(numel(displ),1);
% 	ind(1)=false;ind(end)=false;
%	misfit  = norm(spektrd(ind)-displ(ind))/norm(displ(ind)); %
% 	misfit  = norm(spektrd(ind)-displ(ind),1); %使用二阶范数作为目标函数
% 	misfit  = sum(spektrd(ind)-displ(ind));
% 	corr    = corrcoef(spektrd,displ);
% 	misfit  = 1-corr(1,2);
%     x_f=log10(fv);
index1=find(fv<=.4,1,'last');
index2=find(fv>=40,1,'first');
    y_d=log10(displ);
    y_v=log10(vel);
    y_a=log10(acc);
    s_d=log10(spektr_d);
    s_v=log10(spektr_v);
    s_a=log10(spektr_a);
    
    y_d=y_d(index1:index2);
    y_v=y_v(index1:index2);
    y_a=y_a(index1:index2);
    s_d=s_d(index1:index2);
    s_v=s_v(index1:index2);
    s_a=s_a(index1:index2);
    
    misfit=zjc_expWeight(y_d,s_d)+zjc_expWeight(y_v,s_v)+zjc_expWeight(y_a,s_a);
return

end


% eof.