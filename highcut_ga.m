function y = highcut_ga(c)
    x = load('./temp/fv.mat');x = x.xdata;
    y = load('./temp/disl.mat');y = y.disl;
    xx=x; 
    yt=y; 
%     yf = c(1)./(1+(xx./c(2)).^2);
%     yf = c(1)./((1.+(xx./c(2)).^2)).*(1+(xx./c(3)).^c(4));
    yf = c(1)./((1.+(xx./c(2)).^2)).*(1+(x./c(3)).^c(4)).^(-1);
    y=sum(abs(yf-yt))/length(yt); 
end