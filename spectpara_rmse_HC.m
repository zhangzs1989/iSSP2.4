function [omg,fc,fmax,p,outfc,outfmax] = spectpara_rmse_HC(fv,vel)
v1=vel;displ=vel./(2*pi*fv).^1;acc=vel.*(2*pi*fv).^1;tecc=vel.*(2*pi*fv).^2.5;
index1=find(abs(v1)==max(abs(v1)));
fc=fv(index1,1);

t1=tecc;
index2=find(abs(t1)==max(abs(t1)));
fmax=fv(index2,1);
 
avacc=acc(index1:index2);
omg=mean(avacc)/(2*pi*fc).^2;
% -------------------------------------------------------------------------
%                   Estimation of slope above fmax
%--------------------------------------------------------------------------
n=length(fv);
px1=fv(index2);
py1=acc(index2);
px2=fv(n-20);
py2=acc(n-20);
if px1 == px2
    slope = 2;
    p = 2;
else
slop=log10(py1/py2)/(log10(px1/px2));
p=abs(slop);
end
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
        spektraf=omg./((1.+(fv./fc1).^2).*(1.+(fv./fmax).^p));
        outspek(:,i)=spektraf;
        defr(i)=mean(abs(displ-spektraf));
        outfc(2,i)=defr(i);
end
% figure(),plot(outfc(1,:),outfc(2,:));
index3=find(abs(defr)==min(abs(defr)));
fc=outfc(1,index3);
% -------------------------------------------------------------------------
%             Estimation of best - fmax
% -------------------------------------------------------------------------
    fmaxw=fv(index1+1:lf);
    lfmax=length(fmaxw);
    for i=1:lfmax
        fmax1=fmaxw(i);
        outfmax(1,i)=fmax1;
        spektrafm=omg./((1.+(fv./fc).^2).*(1.+(fv./fmax1).^p));
        outspekmax(:,i)=spektraf;
        defrm(i)=mean(abs(displ-spektrafm));
        outfmax(2,i)=defrm(i);
end
% figure(),plot(outfmax(1,:),outfmax(2,:));
index4=find(abs(defrm)==min(abs(defrm)));
fmax=outfmax(1,index4);
end