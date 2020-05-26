function [ ALLEVENT ] = ReadReport_for_PgSg( reportfile )
%READREPORT Summary of this function goes here
%   Detailed explanation goes here
% Input:
%   reportfile - 全国编目系统产生的正式观测报告，多个地震事件
%   Zhang ZS. 2018/08/06.JiNan
%   根据zjc_readc01.m by Zheng JC, Aug. 1st, 2015 @ Jinan.修改得到.
% Output:
%   AllEVENT      - 结构体，第i个地震事件，EVENT = AllEVENT(i).event
%   EVENT.origintime, 发震时间
%   EVENT.epicenter， 震中位置[纬度，经度]
%   EVENT.depth,      震源深度
%   EVENT.mag,        震级
%   EVENT.loc_stn，   台站数
%   EVENT.STA,        不同台站下的pg,sg到时
    file = textread(reportfile, '%s', 'delimiter', '\n','whitespace', '');
	line = numel(file);
    DBONUM = [];
    kk=1;
    for i = 1:line
        if strfind(file{i},'DBO') == 1
           DBONUM(kk) = i; 
           kk = kk+1;
        end
    end
    for j = 1:length(DBONUM)
            sti  = 0;
        %	flaw = 0;         % 仅有Pg或仅有Sg的台站个数
            Pg   = [];
            Sg   = [];
            if j~=length(DBONUM)
                e1 = DBONUM(j);
                e2 = DBONUM(j+1)-1;
            else
                e1 = DBONUM(j);
                e2 = line-3;
            end
        for i =  e1:e2
            strline = char(file{i});
            if isempty(strline)
                break;
            end
            if strcmp(strline(1:3),'DBO')
                ind=strline<=57&strline>=46;            % 仅仅保留数字和小数点
                ind=~ind;                               % 46='.', 57='9'
                strline(ind)=' ';
                TempA =sscanf(strline,'%f');
                EVENT.origintime=TempA(1:6)';
                EVENT.epicenter =TempA(7:8)';
                EVENT.depth     =TempA(9);
                EVENT.mag       =TempA(10);
                EVENT.loc_stn   =TempA(14);
                EVENT.STA(EVENT.loc_stn).staname='';
                EVENT.STA(EVENT.loc_stn).Pg=[];
                EVENT.STA(EVENT.loc_stn).Sg=[];
            end
            net_code=strtrim(strline(5:7));
            
            if strcmp(strline(1:3),'DPB') && ~isempty(strfind(strline,' Pg '))
                
                Pgsta=strtrim(strline(8:12));
                sta = [Pgsta];
                ind=strline<=57&strline>=46;            % 仅仅保留数字和小数点
                ind=~ind;
                strline(ind)=' ';
                TempA =sscanf(strline,'%f');
                if ~strcmp(net_code,'CB')
                if isempty(Pgsta(regexp(Pgsta,'\d')));
                    Pg=TempA(2:7);
                else
                    Pg=TempA(3:8);
                end
                else
                if isempty(Pgsta(regexp(Pgsta,'\d')));
                    Pg=TempA(1:6);
                else
                    Pg=TempA(2:7);
                end    
                end
                
            end
            if strcmp(strline(1:3),'DPB') && ~isempty(strfind(strline,' Sg '))
                Sgsta=strtrim(strline(8:12));
                ind=strline<=57&strline>=46;            % 仅仅保留数字和小数点
                ind=~ind;
                strline(ind)=' ';
                TempA =sscanf(strline,'%f');
                if ~strcmp(net_code,'CB')
                if isempty(Sgsta(regexp(Sgsta,'\d')));
                    Sg=TempA(2:7);
                else
                    Sg=TempA(3:8);
                end
                else
                if isempty(Sgsta(regexp(Sgsta,'\d')));
                    Sg=TempA(1:6);
                else
                    Sg=TempA(2:7);
                end    
                end
            end
            if ~isempty(Pg) && ~isempty(Sg)
                if strcmp(Pgsta,Sgsta)
                    sti=sti+1;
                    EVENT.STA(sti).staname=sta;
                    EVENT.STA(sti).Pg=Pg';
                    EVENT.STA(sti).Sg=Sg';
                    Pg=[];
                    Sg=[];
                end
            end
        end
       EVENT.loc_stn = sti;
       ALLEVENT(j).event=EVENT;
       clear EVENT;
    end
end

