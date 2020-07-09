function plot_stationspectrum(xdata,ydata,type,str,stalist)
% 绘制观测震源谱
% type:1-速度谱；2-位移谱；3-加速度谱
% ftitle:图件title
fv = xdata;S_sta = ydata;
fv = fv(xdata<=20);S_sta=S_sta(xdata<=20,:);
type = type;str_tmp = '平均震源谱';
ydatamean = median(S_sta,2);
str = str(1:end-4);
switch type
    case 1
        loglog(fv,S_sta); hold on,h = loglog(fv,ydatamean,'k','LineWidth',1.2);
        %             str_tmp=strrep(str_tmp(12:end),',',''',''');
        %             str_tmp=strcat(char(39),str_tmp,char(39));
        %             str_tmp=strcat('hleg=legend(',str_tmp,');');
        %             eval(str_tmp);
        %             set(hleg,'FontName','Verdana','FontSize',7.0,'TextColor',[.3,.2,.1],...
        %                      'Location','SouthWest');
        legend([h],str_tmp,'Location','southwest')
        xlabel('Frequency (Hz)'); ylabel('velocity Spectrum');title(str);
        xlim([10^(-2) 100])
    case 2
        loglog(fv,S_sta); hold on,h = loglog(fv,ydatamean,'k','LineWidth',1.2);
        %             str_tmp=strrep(str_tmp(12:end),',',''',''');
        %             str_tmp=strcat(char(39),str_tmp,char(39));
        %             str_tmp=strcat('hleg=legend(',str_tmp,');');
        %             eval(str_tmp);
        %             set(hleg,'FontName','Verdana','FontSize',7.0,'TextColor',[.3,.2,.1],...
        %                      'Location','SouthWest');
        legend([h],str_tmp,'Location','southwest')
        xlabel('Frequency (Hz)'); ylabel('Displacement Spectrum');title(str);
        xlim([10^(-2) 100])
    case 3
        loglog(fv,S_sta); hold on,h = loglog(fv,ydatamean,'k','LineWidth',1.2);
        %             str_tmp=strrep(str_tmp(12:end),',',''',''');
        %             str_tmp=strcat(char(39),str_tmp,char(39));
        %             str_tmp=strcat('hleg=legend(',str_tmp,');');
        %             eval(str_tmp);
        %             set(hleg,'FontName','Verdana','FontSize',7.0,'TextColor',[.3,.2,.1],...
        %                      'Location','SouthWest');
        legend([h],str_tmp,'Location','southwest')
        xlabel('Frequency (Hz)'); ylabel('Acceleration Spectrum');title(str)
        xlim([10^(-2) 100])
end
stalist=strsplit(stalist,',');stalist = stalist(2:end);
pp=gca;
c = uicontextmenu;
pp.UIContextMenu = c;
for j = 1:length(stalist)
    name = ['m',num2str(j)];
    name = uimenu(c,'Label',stalist{j},'Callback',@plt_spectrum);
end
    function plt_spectrum(source,callbackdata)
        cla reset
        pp = gca;
        switch type
            case 1
                if ~strcmp(callbackdata.Source.Label,'ALL')
                    id = strcmp(callbackdata.Source.Label,stalist);
                    
                    loglog(fv,S_sta(:,id)); hold on,h = loglog(fv,ydatamean,'k','LineWidth',1.2);
                    legend([h],str_tmp,'Location','southwest')
                    xlabel('Frequency (Hz)'); ylabel('velocity Spectrum');title([str,',',stalist{id}]);
%                     xlim([0 50])
                else
                    loglog(fv,S_sta); hold on,h = loglog(fv,ydatamean,'k','LineWidth',1.2);
                    legend([h],str_tmp,'Location','southwest')
                    xlabel('Frequency (Hz)'); ylabel('velocity Spectrum');title([str,',',stalist{id}]);
%                     xlim([0 50])
                end
            case 2
                if ~strcmp(callbackdata.Source.Label,'ALL')
                    %                         if strcmp(stalist{k},callbackdata.Source.Label)
                    id = strcmp(callbackdata.Source.Label,stalist);
                    loglog(fv,S_sta(:,id)); hold on,h = loglog(fv,ydatamean,'k','LineWidth',1.2);
                    legend([h],str_tmp,'Location','southwest')
                    xlabel('Frequency (Hz)'); ylabel('Displacement Spectrum');title([str,',',stalist{id}]);
%                     xlim([0 50])
                    %                         end
                else
                    loglog(fv,S_sta); hold on,h = loglog(fv,ydatamean,'k','LineWidth',1.2);
                    legend([h],str_tmp,'Location','southwest')
                    xlabel('Frequency (Hz)');  ylabel('Displacement Spectrum');title([str,',',stalist{id}]);
%                     xlim([0 50])
                end
            case 3
                if ~strcmp(callbackdata.Source.Label,'ALL')
                    id = strcmp(callbackdata.Source.Label,stalist);
                    loglog(fv,S_sta(:,id)); hold on,h = loglog(fv,ydatamean,'k','LineWidth',1.2);
                    legend([h],str_tmp,'Location','southwest')
                    xlabel('Frequency (Hz)'); ylabel('Acceleration Spectrum');title([str,',',stalist{id}])
%                     xlim([0 50])
                else
                    loglog(fv,S_sta); hold on,h = loglog(fv,ydatamean,'k','LineWidth',1.2);
                    legend([h],str_tmp,'Location','southwest')
                    xlabel('Frequency (Hz)');ylabel('Acceleration Spectrum');title([str,',',stalist{id}]);
%                     xlim([0 50])
                end
        end
    end
end