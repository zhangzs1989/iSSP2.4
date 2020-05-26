function y = brune_ga(c)
    x = load('./temp/fv.mat');x = x.xdata;
    y = load('./temp/disl.mat');y = y.disl;
    xx=x; 
    yt=y; 
%     c = [10,2];
    % fitting function
%     yf=c(1)+c(2)*cos(xx+c(3)); 
    yf = c(1)./(1+(xx./c(2)).^2);
    y=sum(abs(yf-yt))/length(yt); 
end