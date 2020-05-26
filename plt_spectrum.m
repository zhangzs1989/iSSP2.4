function plt_spectrum(type)
%- 从导出的result里面制图，绘制垂直向速度谱,位移谱和加速度谱
%- 分两种，1，加载zip压缩文件后提取csv数据；2直接加载csv数据
type = type;
try 
    [filename, pathname]  = uigetfile({'*.zip;*.csv'},'选择数据zip or csv');
catch ErrorInfo 
    msgbox(ErrorInfo.message);
end
try
if strcmp(filename(end-3:end),'.zip') % 文件后缀为.zip，如下处理
    Files = unzip([pathname,filename],cd);
    for ii = 1:length(Files)
       if ~isempty(strfind(Files{ii},'.csv'))
           data = importdata(Files{ii});
           fdata = data.data;
           dhead = data.colheaders;
           [~,index] = find(strcmp(dhead,'Frequency'));
%            [sel,ok]=listdlg('ListString',{'速度谱','位移谱','加速度谱'},...
%             'Name','选择谱类型','OKString','确定','CancelString','取消','SelectionMode','single','ListSize',[180 80]);
%            type = sel;
%             if ok == 1
            figure()
            switch type
               case 1
                    xdata = fdata(:,1);ydata = fdata(:,index(1)+1:index(2)-2);
                    plot_stationspectrum(xdata,ydata,type,filename(1:end-4));
%                     savefigure(type);
               case 2
                   xdata = fdata(:,1);ydata = fdata(:,index(2)+1:index(3)-2);
                    plot_stationspectrum(xdata,ydata,type,filename(1:end-4));
%                     savefigure(type);
                case 3
                    xdata = fdata(:,1);ydata = fdata(:,index(3)+1:end-1);
                    plot_stationspectrum(xdata,ydata,type,filename(1:end-4));
%                     savefigure(type);
           end
           break;
%            else
            % 未选择
%            end
       end
    end
else if strcmp(filename(end-3:end),'.csv')
       data = importdata([pathname,filename]);
       fdata = data.data;
       dhead = data.colheaders;
       [~,index] = find(strcmp(dhead,'Frequency'));
%        [sel, ok]=listdlg('ListString',{'速度谱','加速度谱','位移谱'},...
%             'Name','选择谱类型','OKString','确定','CancelString','取消','SelectionMode','single','ListSize',[180 80]);
%            type = sel;
%             if ok == 1
            figure()
            switch type
               case 1
                    xdata = fdata(:,1);ydata = fdata(:,index(1)+1:index(2)-2);
                    plot_stationspectrum(xdata,ydata,type,filename(1:end-4));
%                     savefigure(type);
               case 2
                   xdata = fdata(:,1);ydata = fdata(:,index(2)+1:index(3)-2);
                    plot_stationspectrum(xdata,ydata,type,filename(1:end-4));
%                     savefigure(type);
                case 3
                    xdata = fdata(:,1);ydata = fdata(:,index(3)+1:end-1);
                    plot_stationspectrum(xdata,ydata,type,filename(1:end-4));
%                     savefigure(type);
           end
%            return;
%            else
            % 未选择
%            end
    else
        msgbox('请选择包含.csv数据的.zip文件或者直接选择.csv数据文件!')        
    end
end
catch
    
end
end