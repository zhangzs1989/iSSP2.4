function Creat_outpara()
% 将计算结果.par文件合并到一个文本文件中，便于后续作图和分析。
% 选择含有.par的zip压缩文件或者选择.par文件
% 输出至./result/*.par,文件名以当前时间+final命名
try
    [filename, pathname]  = uigetfile({'*.zip;*.par'},'合并结果','MultiSelect','on');
    str_tmp = ['%%','Time, ','Lontitude, ','Latitude, ','Mag, ','Depth, ','fc, ','fc1, ','fc2, ',...
        'fmax, ','fmax1, ','fmax2, ','p, ','p1, ','p2, ','Mo, ','Mw, ','Rupture(m), ','strssdrop(MPa)'];
    index = strfind(filename,'.zip');
    [~,loc_zip] = iscellempty(index);%挑选处.zip和.par文件
    index = strfind(filename,'.par');
    [~,loc_par] = iscellempty(index);%挑选处.zip和.par文件
    fout = fopen(['./result/',datestr(now,'yyyymmddTHHMMSS'),'-final','.par'],'wt');
    fprintf(fout,'%s\t\n',str_tmp);
    zipname = filename(loc_zip);parname = filename(loc_par);
    if ~isempty(zipname) || ~isempty(parname)
        if ~isempty(zipname)
            for i = 1:length(zipname)
                Files = unzip([pathname,zipname{i}]);
                for j = 1:length(Files)
                    if ~isempty(strfind(Files{j},'.par'))
                        data = importdata(Files{j});
                        for k = 2:length(data)
                            strtmp = regexp(data{k}, '\s+', 'split');
                            fprintf(fout,'%s %.3f %.3f %.2f %.1f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3e %.2f %.1f %.4f\n',...
                                [strtmp{1},' ',strtmp{2}],str2num(strtmp{3}),str2num(strtmp{4}),str2num(strtmp{5}),str2num(strtmp{6}),...
                                str2num(strtmp{7}),   str2num(strtmp{8}),  str2num(strtmp{9}),   ...
                                str2num(strtmp{10}), str2num(strtmp{11}), str2num(strtmp{12}), ...
                                str2num(strtmp{13}),  str2num(strtmp{14}), str2num(strtmp{15}),     ...
                                str2num(strtmp{16}),str2num(strtmp{17}),str2num(strtmp{18}),str2num(strtmp{19}));
                        end
                    end
                end
                for k = 1 :length(Files)
                    delete(Files{k});
                end
            end
        end
        if ~isempty(parname)
            for j = 1:length(parname)
                data = importdata([pathname,parname{j}]);
                for k = 2:length(data)
                    strtmp = regexp(data{k}, '\s+', 'split');
                    fprintf(fout,'%s %.3f %.3f %.2f %.1f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3e %.2f %.1f %.4f\n',...
                        [strtmp{1},' ',strtmp{2}],str2num(strtmp{3}),str2num(strtmp{4}),str2num(strtmp{5}),str2num(strtmp{6}),...
                        str2num(strtmp{7}),   str2num(strtmp{8}),  str2num(strtmp{9}),   ...
                        str2num(strtmp{10}), str2num(strtmp{11}), str2num(strtmp{12}), ...
                        str2num(strtmp{13}),  str2num(strtmp{14}), str2num(strtmp{15}),     ...
                        str2num(strtmp{16}),str2num(strtmp{17}),str2num(strtmp{18}),str2num(strtmp{19}));
                end
            end
            
        end
    else
        msgbox('无相关.par文件，请核实是否zip文件内是否含有.par文件！');
    end
    
catch
    
end
fclose(fout);
fclose('all');
end