function plot_wave(SPECTRA)

if (SPECTRA{1}.t(1)-10)>0
    idx1 = find(SPECTRA{1}.to == (SPECTRA{1}.t(1)-10));
else
    idx1 = find(SPECTRA{1}.to == (SPECTRA{1}.t(1)-5));
end
if (SPECTRA{1}.t(end)+20)<SPECTRA{1}.to(end)
    idx2 = find(SPECTRA{1}.to == (SPECTRA{1}.t(end)+20));
else
    idx2 = find(SPECTRA{1}.to == (SPECTRA{1}.t(end)+10));
end
plot(SPECTRA{1}.to(idx1:idx2),SPECTRA{1}.do(idx1:idx2,1),'color',[0 0 0]),hold on
rectangle('Position', [SPECTRA{1}.t(1) -max(max(abs(SPECTRA{1}.do(:,1)))) ...
    SPECTRA{1}.t(end)-SPECTRA{1}.t(1) 2*max(max(abs(SPECTRA{1}.do(:,1))))],'FaceColor','g'...
               ,'EdgeColor','red','LineWidth',1);
hold on
plot(SPECTRA{1}.t,SPECTRA{1}.d(:,1),'r')
% xlim([min(SPECTRA{1}.to(idx1:idx2)) max(SPECTRA{1}.to(idx1:idx2))])
xlabel('Time/s'); ylabel('Amplitude');box on;
title ([char(SPECTRA{1}.staname),',','BeginTime:',datestr(SPECTRA{1}.wavebegintime,31)]);
end