function ExitMain()
try
    clear;
    close all;
    fclose('all');
catch ErrorInfo
    errordlg(ErrorInfo.message,'error warning')
end
end