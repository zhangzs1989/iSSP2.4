function plt_ssp()
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
     f1 = figure(1001);
     plot(Mw,fc,'ko')
     xlabel('Magnitude /Mw'),ylabel('Corner Frequency/Hz')
    axis square
    saveas(gcf,['./figure/',filename,'_1','.png']);
    saveas(gcf,['./figure/',filename,'_1','.eps']);
    saveas(gcf,['./figure/',filename,'_1','.fig']);
% zip(['./figure/',filename,'-ssp','.zip'],{['./figure/',filename,'_1','.png'],['./figure/',filename,'_1','.eps'],['./figure/',filename,'_1','.fig']});

    f2 = figure(1002);
%     subplot(121)
    plot(mag,fc,'ko','MarkerSize',15),xlim([2.5 4.5])
    grid minor, xlabel('ML'),ylabel('Corner frequency/Hz'),title('震级与拐角频率的关系')
%     subplot(122)
%     plot(Mw,fc,'k.','MarkerSize',15)
%     errorbar(Mw(fc<max(fc)),fc(fc<max(fc)),fc2(fc<max(fc))-fc(fc<max(fc)),fc1(fc<max(fc))-fc(fc<max(fc)),'k.','MarkerSize',15)
%     xlim([1 4])
%     grid minor, xlabel('Mw'),ylabel('Corner frequency/Hz'),title('矩震级与拐角频率的关系')
    saveas(gcf,['./figure/',filename,'_2','.png']);
    saveas(gcf,['./figure/',filename,'_2','.eps']);
    saveas(gcf,['./figure/',filename,'_2','.fig']);
%     zip(['./figure/',filename,'-ssp','.zip'],{['./figure/',filename,'_2','.png'],['./figure/',filename,'_2','.eps'],['./figure/',filename,'_2','.fig']});
    f3 = figure(1003);
    errorbar(datenum(ymdhms),fc,fc2-fc,fc1-fc,'Color',[0.7 0.7 0.7]','LineWidth',1.0)
    hold on
    scatter(datenum(ymdhms),fc,80,mag,'filled'),datetick('x','yyyy/mm','keepticks')
    grid minor;xlabel('Time'),ylabel('Corner frequency/Hz'),title('拐角频率时域演化');
    h = colorbar;caxis([2 5]);set(get(h,'Title'),'string','M_L');
    saveas(gcf,['./figure/',filename,'_3','.png']);
    saveas(gcf,['./figure/',filename,'_3','.eps']);
    saveas(gcf,['./figure/',filename,'_3','.fig']);
    zip(['./figure/',filename,'-ssp','.zip'],...
        {['./figure/',filename,'_1','.png'],['./figure/',filename,'_1','.eps'],['./figure/',filename,'_1','.fig'],...
        ['./figure/',filename,'_2','.png'],['./figure/',filename,'_2','.eps'],['./figure/',filename,'_2','.fig'],...
        ['./figure/',filename,'_3','.png'],['./figure/',filename,'_3','.eps'],['./figure/',filename,'_3','.fig']});
    close(f1);close(f2);close(f3);
    delete(['./figure/',filename,'_1','.png']);
    delete(['./figure/',filename,'_1','.eps']);
    delete(['./figure/',filename,'_1','.fig']);
    delete(['./figure/',filename,'_2','.png']);
    delete(['./figure/',filename,'_2','.eps']);
    delete(['./figure/',filename,'_2','.fig']);
    delete(['./figure/',filename,'_3','.png']);
    delete(['./figure/',filename,'_3','.eps']);
    delete(['./figure/',filename,'_3','.fig']);
else
end
end