clf reset;
close all;
warning off;
screen=get(0,'ScreenSize');
W=screen(3);H=screen(4);
main_p = [0.1*W,0.1*H,0.5*W,0.5*H];
statelabel_p = [0.6*W,0.65*H,0.05*W,0.02*H];
stateedit_p = [0.574*W,0.05*H,0.1*W,0.6*H];
hmain = figure('Color',[1 1 1],'Position',main_p,...
    'Name','中小地震震源参数反演计算程序V2.0','NumberTitle','off','MenuBar','none');
% h_axes2 = axes(hmain);
% 定义图形位置和大小,[left bottom width height]
% set(h_axes2,'Position',[0.1 0.1 0.1 0.1]);
% China()
uicontrol('style','pushbutton','string','Enter','Position',[20 20 60 20],'callback','Enter()')
uicontrol('style','pushbutton','string','Exit','Position',[90 20 60 20],'callback','Exitenter()')
newIcon = javax.swing.ImageIcon('./icon/ccicon.png');
figFrame = get(hmain,'JavaFrame'); %取得Figure的JavaFrame。
figFrame.setFigureIcon(newIcon); %修改图标
h_axes1 = axes();%(hmain,'Position',[0.1*W/2,0.1*H/2 0.1 0.1]);
R = 6370;
E = DrawEarth(R);
% X = get(gca,'XLim');Y = get(gca,'YLim');
% x = X(1)+(X(2)-X(1)*rand(1,100));y = Y(1)+(Y(2)-Y(1)*rand(1,100));
% hold on
% plot(x,y,'w.')
hc=uicontextmenu();                         %建立快捷菜单hc
E.UIContextMenu = hc;
mhsub1=uimenu(hc,'Label','Surprise','CallBack','newegg()'); % 彩蛋
 title(['\it{Robust inversion calculation program for source parameters of small and medium earthquakes}'],'Color', 'k')
direction = [0,0,1];
for i= 1:360*24
   j=1;
   try
   rotate(E,direction,j);
   axis equal off;
   view(3);
   drawnow;  
   pause(0.05)
   catch
   end
end