function [omg,fc,gamma,outfc,outgamma] = spectpara_rmse_Brune2(fv,vel)
v1=vel;displ=vel./(2*pi*fv).^1;acc=vel.*(2*pi*fv).^1;tecc=vel.*(2*pi*fv).^2.5;
index1=find(abs(v1)==max(abs(v1)));
fc=fv(index1,1);

t1=tecc;
index2=find(abs(t1)==max(abs(t1)));
fmax=fv(index2,1);

avacc=acc(index1:index2);
omg=mean(avacc)/(2*pi*fc).^2;
gamma0 = 2;
% -------------------------------------------------------------------------
f=fv;lf=length(f);
% -------------------------------------------------------------------------
%             Estimation of best - fc
% -------------------------------------------------------------------------
fcw=fv(1:index2);
lfc=length(fcw);
for i=1:lfc
    fc1=fcw(i);
    outfc(1,i)=fc1;
    spektraf=omg./((1.+(fv./fc1).^gamma0));
    outspek(:,i)=spektraf;
    defr(i)=mean(abs(displ-spektraf));
    outfc(2,i)=defr(i);
end
% figure(),plot(outfc(1,:),outfc(2,:));
index3=find(abs(defr)==min(abs(defr)));
fc=outfc(1,index3);
% -------------------------------------------------------------------------
%             Estimation of best - gamma
% -------------------------------------------------------------------------
fgamma=linspace(1,5,100);
lfgamma=length(fgamma);
for i=1:lfgamma
    gamma1=fgamma(i);
    outgamma(1,i)=gamma1;
    spektrafm=omg./((1.+(fv./fc).^gamma1));
    outspekmax(:,i)=spektraf;
    defrm(i)=mean(abs(displ-spektrafm));
    outgamma(2,i)=defrm(i);
end
% figure(),plot(outgamma(1,:),outgamma(2,:));
index4=find(abs(defrm)==min(abs(defrm)));
gamma=outgamma(1,index4);
end