function plot_fitspectrum(xdata,ydata,model,specpara,mo,mw,r,sd)
% 拟合及结果图
fv = xdata;displ = ydata;pp = specpara;mo = mo;mw = mw;r = r;sd = sd;model = model;
fc = pp.fc;f = fv;omg = pp.omg;
switch model
    case 1 % Brune
    h1 = loglog(fv,displ,'m');grid on;%title ('SH - Spectrum');
    xlabel('Frequency/Hz'); ylabel( 'Displacement Spectrum');grid on;hold on
    spektrd=((2*pi*fv).^0)*pp.omg./((1.+(fv./pp.fc).^2));% Brune Model with high cut
    spektrd1=((2*pi*pp.fc).^0)*pp.omg./((1.+(pp.fc./pp.fc).^2));
    h2 = loglog(f,spektrd,'b','LineWidth',1.2);grid on;
    h3 = plot(fc,spektrd1,'ro', 'MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor','g');
    plot(fc,spektrd1,'r+', 'MarkerSize',20);
    tx=fv(1);
    ty=min(spektrd);
%     text(3,0.05,'\it f_c')
    mostr=num2str(mo, '%3.1e\n');fcstrr=num2str(r, '%3.1f');
    omstr=num2str(omg, '%3.1e\n');
    mstr1=num2str(mw,'%3.1f');fcstr1=num2str(fc, '%3.1f');
    mstr2=num2str(sd,'%.3f');
    text(tx,ty*3,['  {\it f}_c= ',fcstr1,' Hz;',' M_w= ',mstr1,';','{\it r} = ',fcstrr,' m;', '\Delta\sigma=',mstr2,' MPa'],...
        'HorizontalAlignment','left',...
    'BackgroundColor',[1 1 .9],'EdgeColor','r','LineWidth',1,'FontSize',10); 
%     text(tx,ty,[' M_w= ',mstr1,';','{\it r} = ',fcstrr,' m;', '\Delta\sigma=',mstr2,' MPa'],...
%     'HorizontalAlignment','left','BackgroundColor',[1 1 .9],'EdgeColor','r',...
%         'LineWidth',1,'FontSize',10);
    legend([h1,h2,h3],'平均观测位移谱','理论位移谱','拐角频率')
    case 2 % High-Cut
    h1 = loglog(fv,displ,'m');grid on;%title ('SH - Spectrum');
    xlabel('Frequency (Hz)'); ylabel( 'Displacement Spectrum');grid on;hold on
    spektrd=((2*pi*fv).^0)*pp.omg./((1.+(fv./pp.fc).^2).*(1.+(fv./pp.fmax).^pp.p));% Brune Model with high cut
    spektrd1=((2*pi*pp.fc).^0)*pp.omg./((1.+(pp.fc./pp.fc).^2).*(1.+(pp.fc./pp.fmax).^pp.p));
    spektrd2=((2*pi*pp.fmax).^0)*pp.omg./((1.+(pp.fmax./pp.fc).^2).*(1.+(pp.fmax./pp.fmax).^pp.p));
    h2 = loglog(f,spektrd,'b','LineWidth',2);grid on;
    plot(pp.fc,spektrd1,'ro', 'MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor','g');plot(pp.fc,spektrd1,'r+', 'MarkerSize',25);
%     plot(pp.fmax,spektrd2,'ro', 'MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor','g'); plot(pp.fmax,spektrd2,'r+', 'MarkerSize',25);
%     plot(pp.fc,spektrd1,'r+', 'MarkerSize',25);
    tx=fv(1);
    ty=min(spektrd);
%     text(3,0.05,'\it f_c')
%     text(fmax-5,0.005,'\it f_{max}')
    mostr=num2str(mo, '%3.1e\n');fcstrr=num2str(r, '%3.1f');
    omstr=num2str(pp.omg, '%3.1e\n');mstrp=num2str(pp.p,'%3.1f');
    mstr1=num2str(mw,'%3.1f');fcstr1=num2str(pp.fc, '%3.1f');
    mstr2=num2str(sd,'%.3f');fcstr2=num2str(pp.fmax, '%3.1f');
    text(tx,ty*3,['  {\it f}_c= ',fcstr1,' Hz;',' M_w= ',mstr1,';','{\it r} = ',fcstrr,' m;', '\Delta\sigma=',mstr2,' MPa'],'HorizontalAlignment','left',...
    'BackgroundColor',[1 1 .9],'EdgeColor','r','LineWidth',1,'FontSize',10); 
%     text(tx,ty,[' M_0= ',mostr,' Nm;',' M_w= ',mstr1,';','{\it r} = ',fcstrr,' m;', '\Delta\sigma=',mstr2,' MPa'],...
%     'HorizontalAlignment','left','BackgroundColor',[1 1 .9],'EdgeColor','r',...
%         'LineWidth',1,'FontSize',10);
    legend('平均观测位移谱','理论位移谱','Location','SouthWest')
    case 3
    h1 = loglog(fv,displ,'m');grid on;%title ('SH - Spectrum');
    xlabel('Frequency (Hz)'); ylabel( 'Displacement Spectrum');grid on;hold on
    spektrd=((2*pi*fv).^0)*pp.omg./((1.+(fv./pp.fc).^pp.gamma));% Brune Model with high cut
    spektrd1=((2*pi*pp.fc).^0)*pp.omg./((1.+(pp.fc./pp.fc).^pp.gamma));
%     spektrd2=((2*pi*pp.fmax).^0)*pp.omg./((1.+(pp.fmax./pp.fc).^pp.gamma));
    h2 = loglog(f,spektrd,'b','LineWidth',2);grid on;
    plot(pp.fc,spektrd1,'ro', 'MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor','g');plot(pp.fc,spektrd1,'r+', 'MarkerSize',25);
%     plot(pp.fmax,spektrd2,'ro', 'MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor','g'); plot(pp.fmax,spektrd2,'r+', 'MarkerSize',25);
%     plot(pp.fc,spektrd1,'r+', 'MarkerSize',25);
    tx=fv(1);
    ty=min(spektrd);
    fcstr=num2str(pp.fc, '%3.1f');
    mstr1=num2str(mw,'%3.1f');
    fcstrr=num2str(r, '%3.1f');
    mstr2=num2str(sd,'%.3f');
    text(tx,ty*3,['  {\it f}_c= ',fcstr,' Hz;',' M_w= ',mstr1,';','{\it r} = ',fcstrr,' m;', '\Delta\sigma=',mstr2,' MPa'],'HorizontalAlignment','left',...
    'BackgroundColor',[1 1 .9],'EdgeColor','r','LineWidth',1,'FontSize',10); 
end
end