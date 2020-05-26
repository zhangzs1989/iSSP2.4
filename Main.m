%   2020 is a year of history.
%   2020 is an extraordinary year.
%   2020/4/4 Global cumulative number of COVID-19 exceeded 1 million.
%   we love earth,we hope world peace.
%   The wind in March, the rain in April,
%   may the mountains and rivers be innocent and the world be safe
%   an Ordinary little man.ZS.Z, 2020 @ HOME.
clf reset;clear;close all;warning('off');
screen=get(0,'ScreenSize');
W=screen(3);H=screen(4);
main_p = [0.1*W,0.1*H,0.5*W,0.5*H];
statelabel_p = [0.6*W,0.65*H,0.05*W,0.02*H];
stateedit_p = [0.574*W,0.05*H,0.1*W,0.6*H];
hmain = figure('Color',[1,1,1],'Position',main_p,...
    'Name','中小地震震源参数反演计算程序V2.0','NumberTitle','off','MenuBar','none');
try
v = ver('MATLAB');
v = str2double(regexp(v.Version, '\d.\d','match','once'));
if (v<7)
  warndlg('Your MATLAB version is too old. You need version 10.0 or newer.');
end
newIcon = javax.swing.ImageIcon('./icon/ccicon.png');
figFrame = get(hmain,'JavaFrame');  %取得Figure的JavaFrame。
figFrame.setFigureIcon(newIcon);    %修改图标
hwb = waitbar(0,'正在初始化，请稍后 >>>>','position',[0.15*W,0.4*H/2,0.5*W/2.8,0.5*H/10]);
if ~exist([cd,'\','config']) 
    mkdir([cd,'\','config'])         % 若不存在，在当前目录中产生一个子目录‘config’,存放运行参数
end
if ~exist([cd,'\','config\config.xml'],'file')
    Create_config_default();
end
if ~exist([cd,'\','pathinp']) 
    mkdir([cd,'\','pathinp'])         % 若不存在，在当前目录中产生一个子目录‘pathinp’，数据输入文本.inp
end
if ~exist([cd,'\','figure']) 
    mkdir([cd,'\','figure'])         % 若不存在，在当前目录中产生一个子目录‘figure’，生成的图片
end 
if ~exist([cd,'\','result']) 
    mkdir([cd,'\','result'])         % 若不存在，在当前目录中产生一个子目录‘result’，计算所得参数
end
if ~exist([cd,'\','temp']) 
    mkdir([cd,'\','temp'])           % 若不存在，在当前目录中产生一个子目录‘temp’，存放临时变量
else
    rmdir([cd,'\','temp'],'s')
    mkdir([cd,'\','temp'])  
end
for step = 1:1000
   waitbar(step/1000) 
end
close(hwb);
catch ErrorInfo
    msgbox(ErrorInfo.message);
end
if ~isempty(which('pso.m'))%是否含有pso工具箱
    addpath('./psopt');%添加粒子群工具箱
end
if ~isempty(which('ga.m'))%是否含有pso工具箱
    addpath('./gaot');%添加粒子群工具箱
end
try
h_mainmenu0 = uimenu(gcf,'label','文件');
    h_submenu01 = uimenu(h_mainmenu0,'label','返回主页..','callback','Run_Main()');
    h_submenu02 = uimenu(h_mainmenu0,'label','刷新..','callback','h_axes=findobj(gcf,''type'',''axes''); delete(h_axes);fclose(''all'');');
    h_submenu03 = uimenu(h_mainmenu0,'label','退出..','callback','ExitMain()');
    
h_mainmenu1 = uimenu(gcf,'label','计算');
h_submenu11 = uimenu(h_mainmenu1,'label','单个地震自动计算');
    h_submenu111 = uimenu(h_submenu11,'label','导入波形..','callback','Loadwave();');
    h_submenu112 = uimenu(h_submenu11,'label','导入观测报告..','callback','Loadreport();');
    h_submenu113 = uimenu(h_submenu11,'label','运行计算..','callback','Single_eq_cal();');
h_submenu12 = uimenu(h_mainmenu1,'label','批量自动计算','callback','Cal_Batch();');
%     h_submenu13 = uimenu(h_mainmenu1,'label','逐步计算','callback','set(gcf,''Color'',''y'')');

h_mainmenu6 = uimenu(gcf,'label','制图');
    % 速度谱和加速度谱给出平均谱
    h_submenu61 = uimenu(h_mainmenu6,'label','傅里叶谱');% 各台站谱和平均震源谱
        h_submenu611 = uimenu(h_submenu61,'label','速度谱','callback','plt_spectrum(1)');
        h_submenu612 = uimenu(h_submenu61,'label','位移谱','callback','plt_spectrum(2)');
        h_submenu613 = uimenu(h_submenu61,'label','加速度谱','callback','plt_spectrum(3)');
    % 反演结果根据最小二乘法和pso法两种做不同拟合图
%     h_submenu63 = uimenu(h_mainmenu6,'label','反演结果','callback','plt_result');
    h_submenu64 = uimenu(h_mainmenu6,'label','谱参数','callback','plt_ssp()');
    h_submenu65 = uimenu(h_mainmenu6,'label','震源参数','callback','plt_sspara()');
h_mainmenu2 = uimenu(gcf,'label','辅助工具');
    h_submenu21 = uimenu(h_mainmenu2,'label','文件路径生成','callback','Creat_inp()');
    h_submenu22 = uimenu(h_mainmenu2,'label','计算参数合并','callback','Creat_outpara()');
    h_submenu23 = uimenu(h_mainmenu2,'label','恢复运行参数缺省值','callback','Create_config_default()');
    h_submenu24 = uimenu(h_mainmenu2,'label','恢复背景缺省值','callback','set(gcf,''Color'',''w'')');
h_mainmenu3 = uimenu(gcf,'label','设置');
    h_submenu31 = uimenu(h_mainmenu3,'label','预处理参数设置','callback','Set_Pre_Para();');
    h_submenu32 = uimenu(h_mainmenu3,'label','运行参数设置','callback','Set_Cal_Para()');
    h_submenu33 = uimenu(h_mainmenu3,'label','设置工具栏');
            h_submenu331 = uimenu(h_submenu33,'label','开启工具栏','callback','set(gcf,''toolbar'',''figure'')');
            h_submenu332 = uimenu(h_submenu33,'label','关闭工具栏','callback','set(gcf,''toolbar'',''none'')');
    h_submenu34 = uimenu(h_mainmenu3,'label','背景颜色','callback','set(gcf,''Color'',[rand rand rand])');
h_mainmenu5 = uimenu(gcf,'label','帮助');
    h_submenu51 = uimenu(h_mainmenu5,'label','软件说明','callback','contact()');
    h_submenu52 = uimenu(h_mainmenu5,'label','帮助文档','callback','Helprun()');
%     h_egg2 = axes('Parent',hmain);
%     set(h_egg2,'Position',[0.5 0.999 0.01 0.01]);
%     c = get(gcf,'Color');
%     h_egg2.YAxis.Visible = 'off';h_egg2.XAxis.Visible = 'off';
%     hc_egg2=uicontextmenu();                         %建立快捷菜单hc
%     h_egg2.UIContextMenu = hc_egg2;
%     mhsub1=uimenu(hc_egg2,'Label','Easter egg','CallBack','egg2'); % 彩蛋2
    hc_main = uicontextmenu();
    hmain.UIContextMenu = hc_main;
    mhsub1=uimenu(hc_main,'Label','save to png','CallBack','savefigure(1)'); % 另存png
    mhsub1=uimenu(hc_main,'Label','save to fig','CallBack','savefigure(2)'); % 另存fig
    mhsub1=uimenu(hc_main,'Label','save to eps','CallBack','savefigure(3)'); % 另存eps
catch
end