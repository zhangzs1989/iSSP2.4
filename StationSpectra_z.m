function SPECTRA = StationSpectra_z(WAVE,WAVEHEAD,EVENT,Precondition)
WAVE = WAVE;WAVEHEAD = WAVEHEAD;EVENT = EVENT;preconditioning = Precondition;
%% 预处理参数
Qf = preconditioning.Qf;
gatten = preconditioning.gatten;
resp = preconditioning.instrumentcase;
site = preconditioning.site;
filterpath = preconditioning.filter;
%% 计算参数
model = preconditioning.model;
delay = preconditioning.delay;
fftnum = preconditioning.fftnum;
waveform = preconditioning.waveform;
wavetype = preconditioning.wavetype;
rptform = preconditioning.rptform;
invert = preconditioning.invert;
density = preconditioning.density;
velocity = preconditioning.velocity;
radiation = preconditioning.radiation;
delay = preconditioning.delay;
%%
N = fftnum;
SPECTRA{WAVEHEAD.stn}.staname = '';
SPECTRA{WAVEHEAD.stn}.dist    = nan;
SPECTRA{WAVEHEAD.stn}.az      = nan;
SPECTRA{WAVEHEAD.stn}.DataV   = NaN(N/2,4);
SPECTRA{WAVEHEAD.stn}.DataD   = NaN(N/2,4);
SPECTRA{WAVEHEAD.stn}.DataA   = NaN(N/2,4);
%-NxM逻辑零的矩阵-%
sti_bad = false(WAVEHEAD.stn,1);
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
    x1 = x;y1=y;z1=z;
    if filterpath==0
        y = y;x = x;z = z;
    else
        %---------------------------------------------------------------
        %   滤波
        %---------------------------------------------------------------
        coef = load(filterpath);[b,a]=sos2tf(coef.SOS,coef.G);
        y = filtfilt(b,a,y1);x = filtfilt(b,a,x1);z = filtfilt(b,a,z1);
        if sum(isnan(y))>floor(length(y)/2) || sum(isnan(x))>floor(length(x)/2) || sum(isnan(z))>floor(length(z)/2)
%             hh = msgbox('滤波器参数配置有问题，请重新设计滤波器！！');
%             pause(2);
%             close(hh);
            y = y1;x = x1;z = z1;
        else
            
        end
    end
%             x = bandpass(x,20,25,4);
%             y = bandpass(y,0.1,20,0.01,4);
%             z = bandpass(z,0.1,20,0.01,4);
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
    switch resp
        case 2
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
        case 1
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
        case 2  % 仅对SH分量进行震源谱计算
            if ifound
                Pg=EVENT.STA(stj).Pg;
                Sg=EVENT.STA(stj).Sg;
                tp=(datenum(Pg)-datenum(WAVEHEAD.begintime))*24*3600;
                ts=(datenum(Sg)-datenum(WAVEHEAD.begintime))*24*3600;
                if ts>0 && (ts*samplerate+N-1)<=WAVEHEAD.recordlength*samplerate
                    M=round(ts*samplerate);
                    t=(0:1/samplerate:(length(VX)-1)*(1/samplerate))';
                    tsp=(ts-tp);
                    tsr=tsp+1.38*tsp;%
                    gr=tsp*8*100000;%
                    %--------------------------------------------------------------------------
                    %       STEP3           WINDOW FUNCTION
                    %--------------------------------------------------------------------------
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
                        switch site
                            case 1
                                b=1.33*b;%场地响应
                            case 2
                                msgbox('暂不支持','操作提示')
                            otherwise
                        end
                        %-Anelastic attenuation adjesting弹性衰减-%
                        q = Qf(1).*f.^Qf(2);
                        atnn=exp(-pi*f*tsr./q);%a=exp(nu./de)
                        bb1=b'.*atnn;
                        switch gatten
                            case 1
                                bb=bb1*gr; % 几何衰减
                            case 2
                                msgbox('暂不支持','操作提示')
                            otherwise
                        end
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
                    continue;
                end     
            else
                sti_bad(sti)=true;
            end%ifound
        case 1 %P：Pg至Sg时间段；SH：
            if ifound
                Pg=EVENT.STA(stj).Pg;
                Sg=EVENT.STA(stj).Sg;
                tp=(datenum(Pg)-datenum(WAVEHEAD.begintime))*24*3600;
                ts=(datenum(Sg)-datenum(WAVEHEAD.begintime))*24*3600;
                if tp>0
                    tp=tp-delay;
                    M=round(ts*samplerate);
                    Mp = round(tp*samplerate);
                    t=(0:1/samplerate:(length(VX)-1)*(1/samplerate))';
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
                        switch site
                            case 1
                                b=1.33*b;%场地响应
                            case 2
                                msgbox('暂不支持','操作提示')
                            otherwise
                        end
                        %-Anelastic attenuation adjesting弹性衰减-%
                        %             q = 552.7.*f.^0.2801;
                        q = Qf(1).*f.^Qf(2);
                        atnn=exp(-pi*f*tsr./q);%a=exp(nu./de)
                        bb1=b'.*atnn;
                        switch gatten
                            case 1
                                bb=bb1*gr; % 几何衰减
                            case 2
                                msgbox('暂不支持','操作提示')
                            otherwise
                        end
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
            else
                continue;
            end
    end
    clear wdata VDATA;
end %sti
SPECTRA(sti_bad)=[];
end