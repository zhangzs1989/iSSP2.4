function Enter()
try 
    close all;
    Main;
catch ErrorInfo
    errordlg(ErrorInfo.message,'error warning')
end
end