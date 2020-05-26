function Set_Pre_Para()
try
prompt0 = {                                                         % 对话框参数
    '仪器响应【1-\it{default}；2-\it{已去仪器响应}】',1
    '几何衰减【1-\it{G(R)=R^{-1}}；2-\it{三段扣除}】',1
    '非弹性衰减【Q(f)=a*f^b中系数a值】',300
    '非弹性衰减【Q(f)=a*f^b中系数b值】',0.5
    '场地响应【1-\it{default};2-\it{导入场地响应文件}】',1
};
% defaultans = {'1','2','3','4'};
% inputdlg(prompt0,'预处理',1,defaultans)
dlg0.width = 50;
dlg0.title = '预处理';
dlg0.auto = 0;
para = Paradlg(prompt0,dlg0);
try 
set_resp = para{1};set_GR = para{2};set_Qf1 = para{3}; 
set_Qf2 = para{4};set_site = para{5};
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
Write_xml('./config/config.xml',tree,RootName);
catch ErrorInfo
    msgbox(ErrorInfo.message) 
end
end