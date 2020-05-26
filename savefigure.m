function savefigure(type)  
try
    switch type
        case 1
            filter = {'*.png'};
            [file, path] = uiputfile(filter,'Save Image','./figure/');
            saveas(gcf,[path,file,'.png']);
        case 2
            filter = {'*.fig'};
            [file, path] = uiputfile(filter,'Save Image','./figure/');
            saveas(gcf,[path,file,'.fig']);
        case 3
            filter = {'*.eps'};
            [file, path] = uiputfile(filter,'Save Image','./figure/');
            saveas(gcf,[path,file,'.eps']);
    end
catch
end
end