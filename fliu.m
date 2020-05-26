function fliu(R,R2,x0,y0,seta,k)
x=zeros(1,10);
y=x;
for i=1:5
x(2*(i-1)+1)=R*cos(pi/2+2*pi/5*(i-1)+seta);
x(2*i)=R2*cos(pi/2+2*pi/5*(i-1)+pi/5+seta);
y(2*(i-1)+1)=R*sin(pi/2+2*pi/5*(i-1)+seta);
y(2*i)=R2*sin(pi/2+2*pi/5*(i-1)+pi/5+seta);
end
x(11)=x(1);
y(11)=y(1);
x=x*k+x0;
y=y+y0;
fill(x,y,[1 0.7 0])
plot(x,y,'y')