function [rpt_path_name] = Loadreport(varargin)
% LOADWAVE Summary of this function goes here
% loadreport:导入观测报告,对应相应的地震事件观测波形
% 输入参数小于1个，默认为全国编目系统产生的正式观测报告，支持多个地震事件
% 输入参数：1-中国编目系统产出的观测报告、2-else（格式未定义，后续补充）
try
    if nargin > 1
        msgbox('输入参数格式过多！', '提示');
    else
        if nargin == 0
            rpttype = 1;
            [filename,filepath] = uigetfile('.txt','Select an report file');
        end
        if nargin == 1
            rpttype = varargin{1};
           switch rpttype
                case 1
                    type =  '.txt';
                case 2
                    type =  '.nuknow'; 
           end
            [filename,filepath] = uigetfile(type,['Select an report file']);
        end
        if ~isequal(filename,0) && ~isequal(filepath,0)
                msgbox('获取观测报告文件路径成功！','操作提示')
                rpt_path_name = [filepath,filename];
            else
                warndlg('获取观测报告失败','操作提示')
        end
    end
    save('./temp/rpt_path_name.mat','rpt_path_name');
catch
end
end

