function g=key(p, n, fs)
t=0 : 1/fs : 2/n;
g=sin(2*pi* fre(p) *t);
end