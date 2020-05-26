function [WAVE,WAVEHEAD]=zjc_readevt(evtfile)
% [WAVE,WAVEHEAD]=zjc_readevt(evtfile)	% Version: 1.1.00, on Aug. 11, 2015
% Input:
%	evtfile - filename string.
% Output:
%	WAVE    - data cell, each cell element is a array containing 3 or 1
%			  column waveform data.
%	WAVEHEAD- structure containing head info defined in evtfile. 
% -------------------------------------------------------------------------
% Jianchang ZHENG @ Jinan, Aug 1st, 2015.
% Modified on Aug 11, 2015. A new script "zjc_readchar.m" is used instead
% of "fread(fid,n,'schar')", for encoding scheme and \00 in C strings.
%==========================================================================
WAVE={};

    fid=fopen(evtfile,'r');
    evtsign   = zjc_readchar(fid,16);            % 事件文件标志 - 16 bytes
    hosttype  = zjc_readchar(fid,16);            % 记录主机类型 - 16
    recordtype= fread(fid,1,'int');              % 文件记录类型 - 4
    processed = fread(fid,1,'int');              % 处理经历     - 4
    network   = zjc_readchar(fid,80);            % 台网名称     - 80
    stn       = fread(fid,1,'int32');            % 台站总数     - 4
    Center_lat= fread(fid,1,'float');            %
    Center_lgt= fread(fid,1,'float');            %
    Center_alt= fread(fid,1,'float');            %
    fseek(fid,120,0);
	begin_time= fread(fid,1,'long');             % 起始时间，秒数
	%  数据起始时间 
	yyyy= fread(fid,1,'int16');   
	mm  = fread(fid,1,'int16');
	dd  = fread(fid,1,'int16');
	hh  = fread(fid,1,'int16');
	nn  = fread(fid,1,'int16');
	ss  = fread(fid,1,'int16');
	begintime =[yyyy mm dd hh nn ss];
    recordlength=fread(fid,1,'long');            % 记录长度(sec)

	WAVE=cell(stn,1);
	blocksize=NaN(stn,1);
	% 循环部分
	% 1. 台站参数结构
	for i=1:stn
		spara(i).sta_no = fread(fid,1,'long');              % 台站编号 - 4
		spara(i).staname= zjc_readchar(fid,20);             % 台站名称 - 20
		spara(i).Dstyle = zjc_readchar(fid,10);             % 数采型号 - 10
		spara(i).WLEN   = fread(fid,1,'short');             % 数采字长
		if spara(i).WLEN==24
		    spara(i).WLEN=32;
		end
		spara(i).V=fread(fid,1,'float');                    % 满幅电压 - 4
		spara(i).sample   =fread(fid,1,'long');             % 采样率
		spara(i).channel_n=fread(fid,1,'long');             % 通道总数
		
		WAVE{i}=NaN(spara(i).sample*recordlength,spara(i).channel_n);
		blocksize(i)=spara(i).WLEN*spara(i).sample/spara(i).WLEN; %字块长
		
		fseek(fid,32,0);
		%  读台站的经度，纬度，高程
		spara(i).sta_lat =fread(fid,1,'float');
		spara(i).sta_lon =fread(fid,1,'float');
		spara(i).sta_alt =fread(fid,1,'float');
		spara(i).Iangle  =fread(fid,1,'float');     % 方位角
		spara(i).Oangle  =fread(fid,1,'float');     % 入射角
		spara(i).weight  =fread(fid,1,'short');
		spara(i).vmodel  =fread(fid,1,'short');     % 定位时使用的速度模型
		spara(i).datatype=fread(fid,1,'int32');
		spara(i).seismometer=zjc_readchar(fid,8);            % 地震计名称
		spara(i).seismostyle=fread(fid,1,'long');            % 地震计类型
		for channel_i=1:spara(i).channel_n
			spara(i).Channel(channel_i).name=zjc_readchar(fid,12);          % 通道名称
			spara(i).Channel(channel_i).no  =fread(fid,1,'int32');          % 通道编号
			spara(i).Channel(channel_i).gainfactor  =fread(fid,1,'float32');% 增益因子
			spara(i).Channel(channel_i).respondorder=fread(fid,1,'int32');  % 响应阶数
			
			fseek(fid,12288,0);						% 响应数据结构存放处
		end %channel_i
	end % sti
	%----------------------------------------------------------------------------------------------
	% 2. 台站参数结构
	for j=1:recordlength
		for sti=1:stn   % 逐台站读取波形数据
			spara(sti).isign=fread(fid,1,'long');   % 标识位，0: 正常
			if spara(sti).isign==0
				if spara(i).WLEN==32
					for channel_i=1:spara(sti).channel_n
						data=fread(fid,blocksize(sti),'int32')/spara(sti).Channel(channel_i).gainfactor;
						WAVE{sti}((j-1)*blocksize(sti)+(1:blocksize(sti)),channel_i)=data;
				end %channel_i
				elseif spara(i).WLEN==16
					for channel_i=1:spara(sti).channel_n
						data=fread(fid,blocksize(sti),'int32')/spara(sti).Channel(channel_i).gainfactor;
						WAVE{sti}((j-1)*blocksize(sti)+(1:blocksize(sti)),channel_i)=data;
					end %channel_i
				end %WLEN
			end %if isign
		end %sti
	end
	% read end.
	fclose(fid);
	%----------------------------------------------------------------------------------------------
	% 3. 返回头字段参数
	WAVEHEAD.stn = stn;
	WAVEHEAD.begintime=begintime;
	WAVEHEAD.recordlength=recordlength;
	for sti=1:stn
		WAVEHEAD.spara(sti)=spara(sti);
	end
	
%end of file.