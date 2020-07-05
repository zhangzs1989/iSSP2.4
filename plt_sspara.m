function plt_sspara()
% try
[filename,pathname]  = uigetfile({'*.par'},'选择计算结果文件');
[tree, ~ , ~] = Read_xml('./config/config.xml');
if exist('filename') && exist('pathname')
    data = importdata([pathname,filename]);
    ii = 1;
    for i = 2:length(data)
        strtmp = regexp(data{i}, '\s+', 'split');
        ymdhms{ii}=[strtmp{1},' ',strtmp{2}];
        lon(ii) = str2num(strtmp{3});lat(ii) = str2num(strtmp{4});
        mag(ii) = str2num(strtmp{5});Dep(ii) = str2num(strtmp{6});
        fc(ii) = str2num(strtmp{7});fc1(ii) = str2num(strtmp{8});fc2(ii) = str2num(strtmp{9});
        fmax(ii) = str2num(strtmp{10});fmax1(ii) = str2num(strtmp{11});fmax2(ii) = str2num(strtmp{12});
        p(ii) = str2num(strtmp{13});p1(ii) = str2num(strtmp{14});p2(ii) = str2num(strtmp{15});
        Mo(ii) = str2num(strtmp{16});Mw(ii) = str2num(strtmp{17});
        r(ii) = str2num(strtmp{18});sd(ii) = str2num(strtmp{19});
        ii = ii +1;
    end
    % 破裂半径和应力降
    f1 = figure(2001);
    plot(r,sd,'o')
    xlabel('破裂半径/m');ylabel('应力降/MPa');
    
%     fci=[0.01;180]; bar=[0.1,1,10,100];
%     for i=1:4 % bar bar/10=Mpa
%        for j=1:2 % fc
%           Mc(j)=(0.49*tree.ssp.velocity*100000).^3.*bar(i)/fci(j)^3;
%        end
%        loglog(Mc,fci,'--','LineWidth',1.0);
%        hold on
%     end
%     loglog(Mo,fc,'ko','MarkerSize',5),hold on;
%     box on,grid minor,xlabel('Seismic moment /N·m'),ylabel('Corner Frequency /Hz')
%     % xlim([10^10 10^18]),ylim([0.1 200])
%     legend('\sigma = 0.01 MPa','\sigma = 0.10 MPa','\sigma = 1.00 MPa','\sigma = 10.0 MPa','This study') 
%     saveas(gcf,['./figure/',filename,'_1','.png']);
%     saveas(gcf,['./figure/',filename,'_1','.eps']);
%     saveas(gcf,['./figure/',filename,'_1','.fig']);
    
    %-震级和矩震级、震级和地震矩
    f2 = figure(2002);
    subplot 121
    [pf ,sf ]= polyfit(mag,log10(Mo),1);
    magi = linspace(min(mag)-0.5,max(mag)+1,100);
    [ymwi,delta] = polyval(pf,magi,sf);
    plot(mag,log10(Mo),'ko'),hold on
    plot(magi,ymwi,'r','LineWidth',2),hold on
    plot(magi,ymwi+delta,'m--',magi,ymwi-delta,'m--')
    legend('Mo','Linear Fit','95% Prediction Interval','Location','northwest')
    note=sprintf('logM_0=%.3fM_L+%.3f',pf(1),pf(2));
    grid minor,xlabel('Magnitude /ML'),ylabel('Seismic moment(log) /N·m')
    tx=mag(1);ty=min(ymwi);
    text(tx,ty,note)
    %     R=corrcoef(mag,log10(Mo));fprintf('相关系数：%.2f\n',R(1,2));
    subplot 122
    [pf ,sf ]= polyfit(mag,Mw,1);
    magi = linspace(min(mag)-0.5,max(mag)+1,100);
    [ymwi,delta] = polyval(pf,magi,sf);
    h1 = plot(mag,Mw,'ko');hold on
    h2 = plot(magi,ymwi,'r','LineWidth',2);hold on
    h3 = plot(magi,ymwi+delta,'m--',magi,ymwi-delta,'m--');
    legend([h1,h2,h3(1)],'Mw','Linear Fit','95% Prediction Interval','Location','northwest')
    note=sprintf('M_w=%.3fM_L+%.3f',pf(1),pf(2));
    tx=mag(1);ty=min(ymwi);
    text(tx,ty,note)
    grid minor,xlabel('Magnitude /ML'),ylabel('Magnitude /Mw')
    %     R=corrcoef(mag,log10(Mo'));fprintf('相关系数：%.2f\n',R(1,2));
    saveas(gcf,['./figure/',filename,'_2','.png']);
    saveas(gcf,['./figure/',filename,'_2','.eps']);
    saveas(gcf,['./figure/',filename,'_2','.fig']);

    % 应力降变化
    f3=figure(2003);
    [~,id]=sort(datenum(ymdhms));
    tt = datenum(ymdhms);
    scatter(tt(id),fc(id),80,mag(id),'filled'),datetick('x','yyyy/mm','keepticks')
    hold on
    plot(datenum(ymdhms),fc,'color',[0.6 0.6 0.6])
    box on;grid minor;xlabel('Time'),ylabel('Stress Drop/MPa'),title('应力降时域演化');
    h = colorbar;caxis([2 5]);set(get(h,'Title'),'string','M_L');
    saveas(gcf,['./figure/',filename,'_3','.png']);
    saveas(gcf,['./figure/',filename,'_3','.eps']);
    saveas(gcf,['./figure/',filename,'_3','.fig']);
    % 相对应力降
    f4 = figure(2004);
    dp = exp(1.158.*mag-6.591);
    dsp2 = sd-dp;
    rmse = std(sd-dp);
    % rmse = sqrt(sum((dsp-dp').^2)/length(dsp2));
    [~,I] = sort(ymdhms);
    ymdhms = ymdhms(I);dsp2(I)=dsp2(I);
    h1 = plot(datenum(ymdhms),dsp2,'ko');hold on,plot(datenum(ymdhms),dsp2,'color','k')
    y = get(gca,'ylim');
%     index = find(mag>=3.5);
%     h4 = plot(ymdhms(index),dsp2(index),'rp','MarkerSize',10,'MarkerFaceColor','r');
    % for i = 1:length(index)
    %     line([ymdhms(index(i)),ymdhms(index(i))],[y(1),y(2)]),hold on
    % end
    x = get(gca,'xlim');
    h2 = line([x(1),x(2)],[mean(dsp2),mean(dsp2)],'color','m','linestyle','--','linewidth',1.2);
    h3 = line([x(1),x(2)],[rmse,rmse],'color','m','linestyle','-.','linewidth',0.8);
    line([x(1),x(2)],[-rmse,-rmse],'color','m','linestyle','-.','linewidth',0.8);
    datetick('x','mm/dd','keepticks'),set(gca,'yminortick','on');set(gca,'xminortick','on');
    xlabel('时间/月日');ylabel('相对应力降/MPa');
    legend([h1,h2,h3],'Relative stress drop','Mean','RMSE')
    saveas(gcf,['./figure/',filename,'_4','.png']);
    saveas(gcf,['./figure/',filename,'_4','.eps']);
    saveas(gcf,['./figure/',filename,'_4','.fig']);
    zip(['./figure/',filename,'-ppara','.zip'],...
        {['./figure/',filename,'_1','.png'],['./figure/',filename,'_1','.eps'],['./figure/',filename,'_1','.fig'],...
        ['./figure/',filename,'_2','.png'],['./figure/',filename,'_2','.eps'],['./figure/',filename,'_2','.fig'],...
        ['./figure/',filename,'_3','.png'],['./figure/',filename,'_3','.eps'],['./figure/',filename,'_3','.fig'],...
        ['./figure/',filename,'_4','.png'],['./figure/',filename,'_4','.eps'],['./figure/',filename,'_4','.fig']});
    delete(['./figure/',filename,'_1','.png']);
    delete(['./figure/',filename,'_1','.eps']);
    delete(['./figure/',filename,'_1','.fig']);
    delete(['./figure/',filename,'_2','.png']);
    delete(['./figure/',filename,'_2','.eps']);
    delete(['./figure/',filename,'_2','.fig']);
    delete(['./figure/',filename,'_3','.png']);
    delete(['./figure/',filename,'_3','.eps']);
    delete(['./figure/',filename,'_3','.fig']);
    delete(['./figure/',filename,'_4','.png']);
    delete(['./figure/',filename,'_4','.eps']);
    delete(['./figure/',filename,'_4','.fig']);
    close(f1);close(f2);close(f3);close(f4);
else
    msgbox('未选择.par文件！');
end
% catch
    
% end

end