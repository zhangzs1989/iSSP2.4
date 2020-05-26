function Loadwave(varargin)
% LOADWAVE Summary of this function goes here
% loadwave:导入波形数据路径和文件名  
% 输入参数小于1个，默认波形格式.evt，目前仅支持evt格式
% 输入参数：1-evt、2-seed、3-SAC、4-ASCII文本文件（格式不统一，不建议使用）
try
    if nargin > 1
        msgbox('输入参数格式过多！', '提示');
    else
        if nargin == 0
            wavetype = 1;
            [filename,filepath] = uigetfile('.evt','Select an evt file');
        end
        if nargin == 1
            wavetype = varargin{1};
           switch wavetype
                case 1
                    type =  '.evt';
                case 2
                    type =  '.seed';
                case 3
                    type =  '.SAC';
                case 4
                    type =  '.ASCII';
           end
            [filename,filepath] = uigetfile(type,['Select an',type,'file']);
        end
        if ~isequal(filename,0) && ~isequal(filepath,0)
                msgbox('获取波形文件路径成功！','操作提示')
                file_path_name = [filepath,filename];
            else
                warndlg('获取波形文件失败','操作提示')
        end
    end
    evt_path_name = file_path_name;
    save('./temp/evt_path_name.mat','evt_path_name');
catch 
end
end


