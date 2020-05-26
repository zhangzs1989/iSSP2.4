function [SPECTRA,EVENT]=StationSpectra(evtfile,reportfile,preconditioning,wavetype)
% function SPECTRA=zjc_StationSpectra(evtfile,reportfile)
%	Read waveforms from evtfile, and calculate its spectra.
% input:
%	evtfile     - evt files.
%	reportfile  - reportfile for one event download from "全国编目系统"
%   fftnum      - fft变换点数，默认2048
%   Qf          - Qf关系，[300,1.7];
%   gatten      - 几何扩散，1
%   instrumentcase - 去仪器响应，1-实际 ; 0- only convert to cm/s
%   wavetype    - 'S':对SH波进行震源谱;'P':对P波进行震源谱;
% output:
%	SPECTRA{stn}- Spectra for stations according to evtfile.
% demo:[SPECTRA,EVENT] = zjc_StationSpectra(evtfile,reportfile,[3,1],1024);
% JC Zheng, August 2nd, 2015 @ Jinan.
%===================================================
    fftNum = preconditioning.fftnum;
    Qf = preconditioning.Qf;
    gatten = preconditioning.gatten;
    instrumentcase = preconditioning.instrumentcase;
    site = preconditioning.site;
    delay = preconditioning.delay;
    
    
	N = fftNum;
    %-.evt地震波形格式读取-%
	[WAVE,WAVEHEAD]=zjc_readevt(evtfile);
    %-.cfs观测报告格式读取-%
	EVENT=ReadReport_for_PgSg(reportfile);
    EVENT=EVENT.event;
    %- 初始化谱结构 -%
	SPECTRA{WAVEHEAD.stn}.staname = '';
	SPECTRA{WAVEHEAD.stn}.dist    = nan;
	SPECTRA{WAVEHEAD.stn}.az      = nan;
	SPECTRA{WAVEHEAD.stn}.DataV   = NaN(N/2,4);
	SPECTRA{WAVEHEAD.stn}.DataD   = NaN(N/2,4);
	SPECTRA{WAVEHEAD.stn}.DataA   = NaN(N/2,4);
	%-NxM逻辑零的矩阵-%
	sti_bad = false(WAVEHEAD.stn,1);
	for sti = 1:WAVEHEAD.stn
		ifound      = false;
        station     = [WAVEHEAD.spara(sti).sta_lat,WAVEHEAD.spara(sti).sta_lon];
        staname     = WAVEHEAD.spara(sti).staname;
        %-方位角 & 震中距 -%
        [dist,az]   = distance(EVENT.epicenter,station);
        dist        = distdim(dist,'deg','km');
        samplerate  = WAVEHEAD.spara(sti).sample;
        y=WAVE{sti}(:,1); y=y-mean(y);  % N-S
        x=WAVE{sti}(:,2); x=x-mean(x);  % E-W
        z=WAVE{sti}(:,3); z=z-mean(z);  % U-D
        %---------------------------------------------------------------
        %   滤波0.1-20HZ
        %---------------------------------------------------------------
%         x = bandpass(x,0.1,20,0.01,4);
%         y = bandpass(y,0.1,20,0.01,4);
%         z = bandpass(z,0.1,20,0.01,4);
%         x = detrend(x);y = detrend(y);z = detrend(z);
		%--------------------------------------------------------------- 		
		%   STEP-1      ROTATION ABOUT Z-AXIS CLOCKWISE AXIS 
		%---------------------------------------------------------------
		theta1=deg2rad(az);
		x1=(x.*cos(theta1))-(y.*sin(theta1));
		y1=(x.*sin(theta1))+(y.*cos(theta1));
		z1=z;
		rdata=[x1,y1,z1];
        % -------------------------------------------------------------------------
        %       STEP-2 INSTRUMENT RESPONSE CORRECTION
        %__________________________________________________________________________
        %INSTRUMENT CONSTANT= [{SENSITIVITY (V/m/s)}/{GEN CONSTT (V/Counts)}]*100
%         instrumentcase = 2;
        switch instrumentcase
            case 1
            for i=1:3
                A=3.9844e-07; %A=1.6e-07; % Converts counts to cm /sec
                CX=rdata(:,i)*A;
                p=[-.707+.707j ; -.707-.707j ; -62.3816+135.392j ; -62.3816-135.392j ; -350 ; -75 ];
                z=[0;0];
                [b,a]=zp2tf(p,z,1.7071e-009);
                sys=tf(b,a);
%                 bode(sys);
                VDATA(:,i)=filter(b,a,CX);
            end
            case 0
                VDATA=rdata./10000;  % convert to cm/s
        end
		VX=VDATA(:,1);
		for stj=1:EVENT.loc_stn  % stj 观测报告中的台站编号
             %-波形中的台站名是否存在在观测报告中，存在ifound=true，初始ifound=flase;
			if strfind(staname,EVENT.STA(stj).staname)
				ifound=true;
                STANAME = EVENT.STA(stj).staname;
				break;
			end
        end
        clear ii;
        switch wavetype
            case 'S'  % 仅对SH分量进行震源谱计算
                if ifound
                Pg=EVENT.STA(stj).Pg;
                Sg=EVENT.STA(stj).Sg;
                tp=(datenum(Pg)-datenum(WAVEHEAD.begintime))*24*3600;
                ts=(datenum(Sg)-datenum(WAVEHEAD.begintime))*24*3600;
                M=round(ts*samplerate);
                t=(0:1/samplerate:(length(VX)-1)*(1/samplerate))'; 
                tsp=(ts-tp);
                tsr=tsp+1.38*tsp;%
                gr=tsp*8*100000;%
                %--------------------------------------------------------------------------
                %       STEP3           WINDOW FUNCTION 
                %--------------------------------------------------------------------------
% %                 maxsamp = max(VX);
% %                 samp = maxsamp*0.8;
% %                 w=kaiser(length(VDATA(M+1:M-1,1)));
                w=kaiser(N);%     COSINE TAPER  (20%)tukeywin(N,0.2);
                if M+N-1>size(VDATA,1) % 起始点+fftN>数据总长度？补零
                    VDATA=[VDATA;zeros(M+N-1-size(VDATA,1),3)];
                end
                for i=1:3
                    wdata(:,i)=VDATA(M:M+N-1,i).*w;
                end
                n=N/2;
                f=(1:n)*(samplerate/N);
                datav(:,1)=f;
                datad(:,1)=f;
                dataa(:,1)=f;
                %--------------------------------------------------------------------------
                %       STEP4          Anelastic attenuation adjesting弹性衰减
                %--------------------------------------------------------------------------
                for i=1:3
                    df=wdata(:,i);
                    b=fft(df,N);
                    b=abs(b(1:n))./n;
                    b=1.33*b;%场地响应
                    %-Anelastic attenuation adjesting弹性衰减-%
        %             q = 552.7.*f.^0.2801;
                    q = Qf(1).*f.^Qf(2);
                    atnn=exp(-pi*f*tsr./q);%a=exp(nu./de)
                    bb1=b'.*atnn;
                    bb=bb1*gr; % 几何衰减
                    datav(:,i+1)=bb;
                    datad(:,i+1)=bb./(2*pi*f);
                    dataa(:,i+1)=bb.*(2*pi*f);
                end
                SPECTRA{sti}.DataV   = datav;
                SPECTRA{sti}.DataD   = datad;
                SPECTRA{sti}.DataA   = dataa;
                SPECTRA{sti}.staname = STANAME;
                SPECTRA{sti}.dist    = dist;
                SPECTRA{sti}.az      = az;
                %% 
                SPECTRA{sti}.Pgtime        = Pg;
                SPECTRA{sti}.Sgtime        = Sg;
                SPECTRA{sti}.starttime     = EVENT.origintime;
                SPECTRA{sti}.wavebegintime = WAVEHEAD.begintime;
                SPECTRA{sti}.wavelength    = WAVEHEAD.recordlength;
                SPECTRA{sti}.precondition  = preconditioning;
                SPECTRA{sti}.to  = t;
                SPECTRA{sti}.do  = VDATA;
                SPECTRA{sti}.t  = t(M:M+N-1);
                SPECTRA{sti}.d  = VDATA(M:M+N-1,:);
                else
                    sti_bad(sti)=true;
                end %ifound
            case 'P' %P：Pg至Sg时间段；SH：
                if ifound
                Pg=EVENT.STA(stj).Pg;
                Sg=EVENT.STA(stj).Sg;
                tp=(datenum(Pg)-datenum(WAVEHEAD.begintime))*24*3600;
                ts=(datenum(Sg)-datenum(WAVEHEAD.begintime))*24*3600;
                tp=tp-delay;
                M=round(ts*samplerate);
                Mp = round(tp*samplerate);
                t=(0:1/samplerate:(length(VX)-1)*(1/samplerate))'; 
% %                 figure()
% %                 plot(t,VX,'k');
% %                 hold on
% %                 plot(t(M+1:M+N),VX(M+1:M+N),'r');
% %                 hold on
% %                 plot(t(Mp+1:M),VX(Mp+1:M),'g');
                tsp=(ts-tp);
                tsr=tsp+1.38*tsp;%震中距
                gr=tsp*3.5*100000;%几何扩散估计，8km/s
                %--------------------------------------------------------------------------
                %       STEP3           WINDOW FUNCTION 
                %--------------------------------------------------------------------------
                %     COSINE TAPER  (20%)tukeywin(N,0.2);
                w=kaiser(length(VDATA(Mp+1:M-1,1)));
                for i=1:3
                    wdata(:,i)=VDATA(Mp+1:M-1,i).*w;
                end
                n=N/2;
                f = (1:n)*(samplerate/N);
                datav(:,1) = f;
                datad(:,1) = f;
                dataa(:,1) = f;
                %--------------------------------------------------------------------------
                %       STEP4          Anelastic attenuation adjesting 弹性衰减
                %--------------------------------------------------------------------------
                for i=1:3
                    df=wdata(:,i);
                    b=fft(df,N);
                    b=abs(b(1:n))./n;
                    b=1.33*b;
                    %-Anelastic attenuation adjesting弹性衰减-%
        %             q = 552.7.*f.^0.2801;
                    q = Qf(1).*f.^Qf(2);
                    atnn=exp(-pi*f*tsr./q);%a=exp(nu./de)
                    bb1=b'.*atnn;
                    bb=bb1*gr;
                    datav(:,i+1)=bb;
                    datad(:,i+1)=bb./(2*pi*f);
                    dataa(:,i+1)=bb.*(2*pi*f);
                end
                SPECTRA{sti}.DataV   = datav;
                SPECTRA{sti}.DataD   = datad;
                SPECTRA{sti}.DataA   = dataa;
                SPECTRA{sti}.staname = STANAME;
                SPECTRA{sti}.dist    = dist;
                SPECTRA{sti}.az      = az;
                %% 
                SPECTRA{sti}.Pgtime        = Pg;
                SPECTRA{sti}.Sgtime        = Sg;
                SPECTRA{sti}.starttime     = EVENT.origintime;
                SPECTRA{sti}.wavebegintime = WAVEHEAD.begintime;
                SPECTRA{sti}.wavelength    = WAVEHEAD.recordlength;
                SPECTRA{sti}.precondition  = preconditioning;
                SPECTRA{sti}.to  = t;
                SPECTRA{sti}.do  = VDATA;
                SPECTRA{sti}.t  = t(Mp+1:M);
                SPECTRA{sti}.d  = VDATA(Mp+1:M,:);
                else
                    sti_bad(sti)=true;
                end %ifound
        end
        clear wdata;
	end %sti
	SPECTRA(sti_bad)=[];
%end of file.