function para = paradlg(prompt0,dlg0 )
% 题目:标准化对话框创建程序
% 参数:
%       prompt0    -- 必要参数，提示语以及默认参数，n*2
%       dlg0       -- 可选参数对话框宽度，标题信息
%       dlg0.width -- 对话框宽度
%       dlg0.title -- 对话框标题
%       dlg0.auto  -- 是否自动保存上次数据，dlg0.auto=1或dlg0.auto=0
% 功能：
%       创建标准化参数输入对话框
%       支持 标量、向量、字符串
%       导出输入参数
%       记忆上次输入

%% prompt参数
n = size(prompt0,1);
prompt = cell(n,1);                                                 % 提示语
def0 = cell(n,1);                                                   % 默认参数
for iloop = 1:n
    prompt{iloop} = prompt0{iloop,1};                               % 参数分离
    def0{iloop} = num2str(prompt0{iloop,2});                        % 默认参数必须为字符串格式
end
try 
    load data_dlg                                                   % 导入上次运行数据def
catch
    def =def0;
end

%% dlg参数
try                                                                 % 宽度设置
    dlg.width = dlg0.width;
catch
    dlg.width = 60;    
end

try                                                                 % 标题设置
    dlg.title = dlg0.title;
catch
    dlg.title = '参数输入'; 
end

%% 对话框

linewidth = ones(n,2);                                              % 宽度设置
linewidth(:,2) = linewidth(:,2)*dlg.width;                          % 可以输入控制
options.Interpreter='tex';
para_dlg = inputdlg(prompt,dlg.title,linewidth,def,options);        % 打开对话框，获取参数字符串

%% 参数转换

% 向量转换，字符串转换

para = cell(n,1);                                                   % 输出参数

for iloop = 1:n
    temp = ['[',para_dlg{iloop},']'];                               % 默认按向量转换
    para{iloop} = str2num(temp);
    
    if isempty(para{iloop})                                         % 如果转换后为空，则为字符串
        para{iloop} = para_dlg{iloop};
    end
    
end

%% 参数保存
def = para_dlg;                                                     % 本次输入赋值给def
save('data_dlg','def');                                             % 保存对话框数据，用于下次导入
try 
   if ~dlg0.auto
       delete data_dlg.mat
   end
catch
end

end