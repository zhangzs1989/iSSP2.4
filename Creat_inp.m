function Creat_inp()
try
    
    inpfilename = ['.\pathinp\',datestr(now,'yyyymmddTHHMMSS'),'.inp'];
    fid = fopen(inpfilename,'wt');
    fprintf(fid,'%s\n%s\n%s\n%s\n','%%-- input filepath of seismic wave(.evt) and report(.txt)','%%-- 1st line is evtfile',...
        '%%-- 2nd line is reportfile','%%-----------------------------------------');
    folder_name_evt = uigetdir('.\','输入波形文件（.evt）所在文件夹');
    index = findstr(folder_name_evt,'\');
    folder_name_rpt = folder_name_evt(1:index(end));
    folder_name_rpt = uigetdir(folder_name_rpt,'输入观测报告所在文件夹');
    if folder_name_evt(end)~='\'
        folder_name_evt=[folder_name_evt,'\'];
    end
    if folder_name_rpt(end)~='\'
        folder_name_rpt=[folder_name_rpt,'\'];
    end
    DIRS_evt=dir([folder_name_evt,'*.evt']);  %扩展名
    DIRS_rpt=dir([folder_name_rpt,'*.txt']);  %扩展名
    n1=length(DIRS_evt);n2=length(DIRS_rpt);
    pp = 1;
    if n1 >= n2
        for i = 1:n2
            for j = 1:n1
                result=FindSameFilename(DIRS_evt(j).name,DIRS_rpt(i).name); 
                if result==1
                    evtrpt{pp,1} = [folder_name_evt,DIRS_evt(j).name];
                    evtrpt{pp,2} = [folder_name_rpt,DIRS_rpt(i).name];
                    pp=pp+1;
                end
            end
        end
    else
        for i = 1:n1
            for j = 1:n2
                result=FindSameFilename(DIRS_evt(i).name,DIRS_rpt(j).name); 
                if result==1
                    evtrpt{pp,1} = [folder_name_evt,DIRS_evt(i).name];
                    evtrpt{pp,2} = [folder_name_rpt,DIRS_rpt(j).name];
                    pp=pp+1;
                end
            end
        end
    end
    h = waitbar(0,'正在生成，请稍后...','Positon',[1 1]);
    fid = fopen(inpfilename,'a+');
    for i=1:length(evtrpt)          
        fprintf(fid,'%s\n%s\n',strrep(evtrpt{i,1},'\','/'),strrep(evtrpt{i,2},'\','/'));
        waitbar(i / length(evtrpt));
    end
        close(h);
        msgbox(['目录提取完成!','inp文件路径为:',inpfilename],'完成提示');
        fclose('all'); 
catch        
end
end