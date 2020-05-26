function Exitenter()
try
    clear all;
    close all;
catch ErrorInfo
    errordlg(ErrorInfo.message,'error warning')
end
end