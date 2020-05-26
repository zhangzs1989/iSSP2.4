function [m0,mw,r,sd] = Sourceparameters_z(omg,fc,pre)
% 由谱参数估算震源参数
% 输出参数：地震矩、矩震级、破裂半径（m）、应力降（MPa）
density = pre.density;velocity = pre.velocity;radition = pre.radiation;
factor=4*pi*density*(velocity)^3*10^15/(2*radition);
m0=factor*omg;
mw=(0.6667*log10(m0))-10.7;
r=(2.34*(velocity*100000)/(2*pi*fc))/100;
sd=(7*m0)/(16*(r*100)^3)*0.000001;
% sd =7/16*m0/(r)^3/10^6;
m00=m0/10000000;%dyne-cm to Nm
scale=16/7*(2.34*3.2/(2*pi))^3*10^15;
% m0 =scale*sd/fc^3;
% mw=0.6667*log10(m00)-6.033;
% mw=(0.6667*log10(m0))-10.7;
sd=sd/10;%bars to MPa
end