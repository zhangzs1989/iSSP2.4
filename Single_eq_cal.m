function Single_eq_cal()
% clf reset
% 计算单个地震事件的震源谱参数和震源参数
% 傅里叶谱（速度谱、位移谱、加速度谱，以.csv存储在result文件夹内）
%
h_axes=findobj(gcf,'type','axes'); %%获得当前图中所有坐标的句柄
% h_children_axes=allchild(h_axes); %% 获得坐标的子对象的句柄
delete(h_axes);
if ~exist('./temp/evt_path_name.mat','file')
    msgbox('请先导入波形！','操作提示');
    return;
else if ~exist('./temp/rpt_path_name.mat','file')
        msgbox('请先导入观测报告！','操作提示');
        return;
    else if ~exist('./temp/evt_path_name.mat','file') && ~exist('./temp/rpt_path_name.mat','file')
            msgbox('请先导入波形文件和观测报告！','操作提示');
            return;
        else if ~exist('./config/config.xml','file')
                msgbox('./config/下不存在config.xml计算文件','操作提示');
                return;
            else
                try
                    evt_path_name = load('./temp/evt_path_name.mat');evt_path_name = evt_path_name.evt_path_name;
                    rpt_path_name = load('./temp/rpt_path_name.mat');rpt_path_name = rpt_path_name.rpt_path_name;
                    [tree, ~ , ~] = Read_xml('./config/config.xml');
                    %% 预处理参数
                    preconditioning.gatten = tree.preprocessing.gatten;
                    preconditioning.Qf = [tree.preprocessing.Qf_a,tree.preprocessing.Qf_b];
                    preconditioning.instrumentcase = tree.preprocessing.resp;
                    preconditioning.site = tree.preprocessing.site;
                    %% 计算参数
                    preconditioning.model = tree.model;
                    preconditioning.delay = tree.signal.delay ;
                    preconditioning.fftnum = tree.signal.fftnum;
                    if tree.signal.fftnum>2048 preconditioning.fftnum = 2048;end;
                    if tree.signal.fftnum<512 preconditioning.fftnum = 512;end;
                    preconditioning.waveform = tree.data.waveform;
                    preconditioning.wavetype = tree.signal.wavetype;
                    preconditioning.rptform = tree.data.reportform;
                    preconditioning.invert = tree.invert;
                    preconditioning.density = tree.ssp.density;
                    preconditioning.velocity = tree.ssp.velocity;
                    preconditioning.radiation = tree.ssp.radiation;
                    %%
                    switch tree.data.reportform
                        case 1
                            Event = ReadReport_for_PgSg(rpt_path_name);
                            event = Event.event;
                        case 2
                            msgbox('暂不支持该观测报告格式')
                        otherwise
                    end
                    switch tree.data.waveform
                        case 1 % .evt
                            [wave,whead] = zjc_readevt(evt_path_name);
                        case 2 % .sac
                            msgbox('暂不支持该波形报告格式')
                        case 3 % .seed
                            msgbox('暂不支持该波形报告格式')
                        otherwise
                    end
                    SPECTRA = StationSpectra_z(wave,whead,event,preconditioning);
                     SPECTRAnum = cellfun('isempty',SPECTRA);
            index = find(SPECTRAnum == 0);SPECTRA = SPECTRA(index(1:end-1));
                    if sum(SPECTRAnum~=1)>=tree.data.stanum
                    %% 画波形截取
                    h_wave = axes(gcf);
                    set(h_wave,'Position',[0.08 0.6 0.35 0.3]);
                    plot_wave(SPECTRA);
                    %%
                    stn=numel(SPECTRA);
                    staname=cell(stn,1);
                    S_sta=[];
                    DataV=0;
                    for sti=1:stn
                        DataV=DataV+SPECTRA{sti}.DataV;
                        staname{sti}=SPECTRA{sti}.staname;
                        S_sta=[S_sta SPECTRA{sti}.DataV(:,4)];
                    end
                    datav=DataV./stn;
                    datav(:,4)=median(S_sta,2);
                    switch size(datav,1)
                        case 512
                            ind =1:512;
                        case 1024
                            ind =[1:1:19 20:2:1024]';
                        case 2048
                            ind =[1:1:39 40:4:2048]';
                    end
                    S_sta= S_sta(ind,:);
                    fv   = datav(ind,1);for ii = 1:stn fvv(:,ii) = fv;end;
                    vel  = datav(ind,4);
                    dis = S_sta./(2*pi*fvv).^1;acc = S_sta.*(2*pi*fvv).^1;
                    disl= vel./(2*pi*fv).^1;acc1 = vel.*(2*pi*fv).^1;tecc1 = vel.*(2*pi*fv).^2.5;
                    nfv=numel(fv);
                    [~,name,~] = fileparts(evt_path_name);name = strtrim(name);
                    %% 保存谱结果 分别为速度谱、位移谱、加速度谱
                    fp_xls=fopen(['./result/',name,'.csv'],'w');
                    str_tmp='Frequency,';
                    for sti=1:stn
                        str_tmp=[str_tmp sprintf('%s,',char(staname{sti}))];
                    end
                    str_tmp2 = [str_tmp,'Vel_AVG',',',str_tmp,'Dis_AVG',',',str_tmp,'Acc_AVG'];
                    fprintf(fp_xls,'%s\n',str_tmp2);
                    dlmwrite(['./result/',name,'.csv'],[fv S_sta vel fv dis disl fv acc acc1],'-append','precision', 6);
                    fclose('all');
                    %% 画位移谱
                    h_dis = axes(gcf);
                    set(h_dis,'Position',[0.6 0.6 0.35 0.3]);
                    plot_stationspectrum(fv,dis,2,name);
                    h_acc = axes(gcf);
                    set(h_acc,'Position',[0.08 0.1 0.35 0.3]);
                    plot_stationspectrum(fv,acc,3,name);
                    
                    %% 拟合反演谱参数
                    fv_i = fv(fv<20);
                    vel_i = vel(fv<20);
                    specpara = Invert_z(tree.model,tree.invert,fv_i,vel_i); % 谱参数
                    [mo,mw,r,sd] = Sourceparameters_z(specpara.omg,specpara.fc,preconditioning);% 震源参数
                    %% 画拟合结果和震源参数结果
                    h_result = axes(gcf);
                    set(h_result,'Position',[0.6 0.1 0.35 0.3]);
                    plot_fitspectrum(fv,disl,tree.model,specpara,mo,mw,r,sd)
                    
                    %% 保存计算结果
                    fp_par=fopen(['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.par'],'wt');
                    if tree.model == 1
                        str_tmp = ['%%','Time, ','Lontitude, ','Latitude, ','Mag, ','Depth, ','fc, ','fc1, ','fc2, ',...
                            'fmax, ','fmax1, ','fmax2, ','p, ','p1, ','p2, ','Mo, ','Mw, ','Rupture(m), ','strssdrop(MPa)'];
                        fprintf(fp_par,'%s\t\n',str_tmp);
                        fprintf(fp_par,'%s %.3f %.3f %.2f %.1f %.3f %.3f %.3f %s %s %s %s %s %s %.3e %.2f %.1f %.4f',...
                            datestr(event.origintime,31),event.epicenter(2),...
                            event.epicenter(1),event.mag,event.depth,specpara.fc,specpara.fc_intervals(1),...
                            specpara.fc_intervals(2),nan,nan,nan,nan,nan,nan,mo,mw,r,sd);
                        fclose('all');
                    else if tree.model == 2
                            str_tmp = ['%%','Time, ','Lontitude, ','Latitude, ','Mag, ','Depth, ','fc, ','fc1, ','fc2, ',...
                                'fmax, ','fmax1, ','fmax2, ','p, ','p1, ','p2, ','Mo, ','Mw, ','Rupture(m), ','strssdrop(MPa)'];
                            fprintf(fp_par,'%s\t\n',str_tmp);
                            fprintf(fp_par,'%s %.3f %.3f %.2f %.1f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3e %.2f %.1f %.4f',...
                                datestr(event.origintime,31),event.epicenter(2),event.epicenter(1),event.mag,event.depth,...
                                specpara.fc,   specpara.fc_intervals(1),   specpara.fc_intervals(2),   ...
                                specpara.fmax, specpara.fmax_intervals(1), specpara.fmax_intervals(2), ...
                                specpara.p,    specpara.p_intervals(1),    specpara.p_intervals(2),     ...
                                mo,mw,r,sd);
                            fclose('all');
                        else
                            str_tmp = ['%%','Time, ','Lontitude, ','Latitude, ','Mag, ','Depth, ','fc, ','fc1, ','fc2, ',...
                                'fmax, ','fmax1, ','fmax2, ','p, ','p1, ','p2, ','Mo, ','Mw, ','Rupture(m), ','strssdrop(MPa)'];
                            fprintf(fp_par,'%s\t\n',str_tmp);
                            fprintf(fp_par,'%s %.3f %.3f %.2f %.1f %.3f %.3f %.3f %s %s %s %.2f %.2f %.2f %.3e %.2f %.1f %.4f',...
                                datestr(event.origintime,31),event.epicenter(2),...
                                event.epicenter(1),event.mag,event.depth,specpara.fc,specpara.fc_intervals(1),...
                                specpara.fc_intervals(2),nan,nan,nan,specpara.gamma,specpara.gamma_intervals(1),specpara.gamma_intervals(2),mo,mw,r,sd);
                            fclose('all');
                        end
                    end
                    if isfield(specpara,'outfc') || isfield(specpara,'outfmax')
                        if isfield(specpara,'outfmax')
                            fp_res = fopen(['./result/',name,'.res'],'wt');
                            dlmwrite(['./result/',name,'.res'],[specpara.outfc,specpara.outfmax],'-append','precision', 6);
                            zip(['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.zip'],{['./result/',name,'.csv'],['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.par'],['./result/',name,'.res']});
                            delete(['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.par'])
                            delete(['./result/',name,'.csv']);
                            fclose(fp_res);%先关闭句柄，否则占用，无法删除。
                            delete(['./result/',name,'.res'])
                        else
                            fp_res = fopen(['./result/',name,'.res'],'wt');
                            dlmwrite(['./result/',name,'.res'],[specpara.outfc],'-append','precision', 6);
                            zip(['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.zip'],{['./result/',name,'.csv'],['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.par'],['./result/',name,'.res']});
                            delete(['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.par'])
                            delete(['./result/',name,'.csv']);
                            fclose(fp_res);
                            delete(['./result/',(name),'.res'])
                        end
                    else
                        zip(['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.zip'],{['./result/',name,'.csv'],['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.par']});
                        delete(['./result/',name,'_',num2str(tree.model),'_',num2str(tree.invert),'.par'])
                        delete(['./result/',name,'.csv']);
                    end
                    
                    % % %                     if tree.model == 3
                    % % %                         str_tmp = ['%%','Time, ','Lontitude, ','Latitude, ','Mag, ','Depth, ','fc, ','fc1, ','fc2, ',...
                    % % %                     'fmax, ','fmax1, ','fmax2, ','p, ','p1, ','p2, ','Mo, ','Mw, ','Rupture(m), ','strssdrop(MPa)'];
                    % % %                 fprintf(fp_par,'%s\t\n',str_tmp);
                    % % %                 fprintf(fp_par,'%s %.3f %.3f %.2f %.1f %.3f %.3f %.3f %s %s %s %s %s %s %.3e %.2f %.1f %.4f',...
                    % % %                     datestr(event.origintime,31),event.epicenter(2),...
                    % % %                     event.epicenter(1),event.mag,event.depth,specpara.fc,specpara.fc_intervals(1),...
                    % % %                     specpara.fc_intervals(2),nan,nan,nan,specpara.gamma_intervals(1),specpara.gamma_intervals(1),mo,mw,r,sd);
                    % % %                         fclose('all');
                    % % %                     else
                    % % %                         str_tmp = ['%%','Time, ','Lontitude, ','Latitude, ','Mag, ','Depth, ','fc, ','fc1, ','fc2, ',...
                    % % %                             'fmax, ','fmax1, ','fmax2, ','p, ','p1, ','p2, ','Mo, ','Mw, ','Rupture(m), ','strssdrop(MPa)'];
                    % % %                         fprintf(fp_par,'%s\t\n',str_tmp);
                    % % %                         fprintf(fp_par,'%s %.3f %.3f %.2f %.1f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3e %.2f %.1f %.4f',...
                    % % % 						datestr(event.origintime,31),event.epicenter(2),event.epicenter(1),event.mag,event.depth,...
                    % % %                         specpara.fc,   specpara.fc_intervals(1),   specpara.fc_intervals(2),   ...
                    % % % 						specpara.fmax, specpara.fmax_intervals(1), specpara.fmax_intervals(2), ...
                    % % % 						specpara.p,    specpara.p_intervals(1),    specpara.p_intervals(2),     ...
                    % % %                         mo,mw,r,sd);
                    % % %                         fclose('all');
                    % % %                     end
                    else
                        msgbox('台站波形数目太少，不足4个。')
                end
                    fclose('all')
                    %                     end
                catch ErrorInfo
                    msgbox(ErrorInfo.message);
                end
            end
        end
    end
end