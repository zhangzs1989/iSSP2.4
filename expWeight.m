function ew=expWeight(tau,x0)
% 指数权重函数
pi=3.14159265359;
sigma=sqrt(tau);
c=sigma*sqrt(2*pi);

if ~exist('x0','var')
	x=-tau:1:tau;
	w=normpdf(x,0,sigma)*c;
	% figure;
	% plot(x,w)
    ew=w;
else
	x	= -tau-abs(x0):1:tau+abs(x0);
	w	= normpdf(x,0,sigma)*c;
	% figure;
	% plot(x,w)
	% vline(x0)
    i   = find(x==x0,1,'first');
	ew	= w(i);
end
