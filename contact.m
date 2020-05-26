function contact()
% 联系方式说明
%
% contact()
%
% input:
% output:
% e.g.contanct()
try
    hhelp = helpdlg('山东省地震预报研究中心编制，联系QQ ：858488045','说明');
catch ErrorInfo
    errordlg(ErrorInfo.message,'error warning')
end
end