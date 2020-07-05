function Set_Pre_Para()
try
prompt0 = {                                                         % 对话框参数
    '仪器响应【1-\it{default}；2-\it{已去仪器响应}】',1
    '几何衰减【1-\it{G(R)=R^{-1}}；2-\it{三段扣除}】',1
    '非弹性衰减【Q(f)=a*f^b中系数a值】',300
    '非弹性衰减【Q(f)=a*f^b中系数b值】',0.5
    '场地响应【1-\it{default};2-\it{导入场地响应文件}】',1
    '是否滤波【1-进行滤波；0-不滤波】',0
};
% defaultans = {'1','2','3','4'};
% inputdlg(prompt0,'预处理',1,defaultans)
dlg0.width = 50;
dlg0.title = '预处理';
dlg0.auto = 0;
para = Paradlg(prompt0,dlg0);
try 
set_resp = para{1};set_GR = para{2};set_Qf1 = para{3}; 
set_Qf2 = para{4};set_site = para{5};set_filter = para{6};
if set_filter == 1
    [filtername,filterpath]=uigetfile('.mat');
    coef = load([filterpath,filtername]);
    if ~isstruct(coef) || ~isfield(coef,'SOS')  || ~isfield(coef,'G')
        msgbox('导入的滤波器参数不正确，请检查后重新导入！')
        set_file_path = 0;
    else
        set_file_path = [filterpath,filtername];
    end
else
   set_file_path = 0;
end
catch ErrorInfo
    msgbox(ErrorInfo.message)
end
try
[tree, RootName , ~] = Read_xml('./config/config.xml');
tree.preprocessing.gatten = set_GR;
tree.preprocessing.resp = set_resp;
tree.preprocessing.site = set_site;
tree.preprocessing.Qf_a = set_Qf1;
tree.preprocessing.Qf_b = set_Qf2;
tree.preprocessing.filter = set_file_path;
Write_xml('./config/config.xml',tree,RootName);
catch ErrorInfo
    msgbox(ErrorInfo.message) 
end
end