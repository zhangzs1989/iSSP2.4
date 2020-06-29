function plot_wave(SPECTRA)
cmenu = uicontextmenu;
for i = 1:length(SPECTRA)
   staname{i} = SPECTRA{i}.staname; 
end
plot(SPECTRA{1}.to,SPECTRA{1}.do(:,1),'color',[0.7 0.7 0.7]);
hold on
plot(SPECTRA{1}.t,SPECTRA{1}.d(:,1),'color','r');
pp=gca;
c = uicontextmenu;
pp.UIContextMenu = c;
for j = 1:length(staname)
    name = ['m',num2str(j)];
    name = uimenu(c,'Label',staname{j},'Callback',@setlinestyle);
end
% m1 = uimenu(c,'Label','dashed','Callback',@setlinestyle);

function setlinestyle(source,callbackdata)
    cla reset
    pp = gca;
    for k = 1:length(SPECTRA)
       if strcmp(SPECTRA{k}.staname,callbackdata.Source.Label)
           plot(SPECTRA{k}.to,SPECTRA{k}.do(:,1),'color',[0.8 0.8 0.8]);
           hold on
           rectangle('Position', [SPECTRA{k}.t(1) -max(max(abs(SPECTRA{k}.do(:,1)))) ...
    SPECTRA{k}.t(end)-SPECTRA{k}.t(1) 2*max(max(abs(SPECTRA{k}.do(:,1))))],'FaceColor','g'...
               ,'EdgeColor','red','LineWidth',1);
           plot(SPECTRA{k}.t,SPECTRA{k}.d(:,1),'color','r');
           hold on
           xlabel('Time/s'); ylabel('Amplitude');box on;
           title ([char(SPECTRA{k}.staname),',','BeginTime:',datestr(SPECTRA{k}.wavebegintime,31)]);
       end
    end
end
% % % if (SPECTRA{1}.t(1)-10)>0
% % %     idx1 = find(SPECTRA{1}.to == (SPECTRA{1}.t(1)-10));
% % % else
% % %     idx1 = find(SPECTRA{1}.to == (SPECTRA{1}.t(1)));
% % % end
% % % if (SPECTRA{1}.t(end)+20)<SPECTRA{1}.to(end)
% % %     idx2 = find(SPECTRA{1}.to == (SPECTRA{1}.t(end)+20));
% % % else
% % %     idx2 = find(SPECTRA{1}.to == (SPECTRA{1}.t(end)));
% % % end
% % % plot(SPECTRA{1}.to(idx1:idx2),SPECTRA{1}.do(idx1:idx2,1),'color',[0 0 0]),hold on
% % % rectangle('Position', [SPECTRA{1}.t(1) -max(max(abs(SPECTRA{1}.do(:,1)))) ...
% % %     SPECTRA{1}.t(end)-SPECTRA{1}.t(1) 2*max(max(abs(SPECTRA{1}.do(:,1))))],'FaceColor','g'...
% % %                ,'EdgeColor','red','LineWidth',1);
% % % hold on
% % % plot(SPECTRA{1}.t,SPECTRA{1}.d(:,1),'r')
% % % % xlim([min(SPECTRA{1}.to(idx1:idx2)) max(SPECTRA{1}.to(idx1:idx2))])
% % % xlabel('Time/s'); ylabel('Amplitude');box on;
% % % title ([char(SPECTRA{1}.staname),',','BeginTime:',datestr(SPECTRA{1}.wavebegintime,31)]);
end