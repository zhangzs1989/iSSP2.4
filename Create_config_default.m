function Create_config_default()
% Create_config_xml Summary of this function goes here
% Creat a congig.xml if current directory isnot exist;
% Written by zs zhang
% $Revision: 1.0 $  $Date: 2020/03/31 $
    config=[];
    config.softinfo.application      = '中小地震震源参数稳健反演程序运行参数配置';
    config.softinfo.development_unit = '山东省地震预报研究中心';
    config.softinfo.version          = 'ver2.0 beta';
    config.softinfo.author.developer = 'zhangzs';
    config.softinfo.author.contact   = '858488045@qq.com';
    %% 输入数据类型
    config.data.waveform                = 1;            % waveform format,.evt(supported now)  .sac  .seed
    config.data.reportform              = 1;            % reportfile for one event download from "全国编目系统"
    config.data.stanum                  = 4;            % 平均震源谱所需台站数目
    %% 预处理
    config.preprocessing.Qf_a           = 363.9;          % Q value:Anelastic attenuation adjesting
    config.preprocessing.Qf_b           = 1.3741;          % Q(f) = a*f^b;
    config.preprocessing.gatten         = 1;            % 几何衰减，G(R)=R^(-1)(supported now) or 三段线性回归 
    config.preprocessing.resp     = 1;            % 仪器响应，Amplitude frequency = 1;
    config.preprocessing.site           = 1;            % 场地响应，site response = 1;               
    %% 波形截取、变换
    config.signal.fftnum   = 1024;  % 2^n，e.g. 512，1024，2048，etc.
    config.signal.wavetype = 2;   % 1-'S' or 2-'P'
    config.signal.delay = 1;
    %%
    config.model = 1; % 1-Brune model;2-High-Cut model
    %% 拟合方式
    config.invert = 1;  % 非线性最小二乘拟合 & PSO 粒子群寻优算法
    %% 震源参数计算经验值
    config.ssp.density = 2.67;   % 介质密度g/cm^3；
    config.ssp.velocity = 3.2;   % S波速度 km/s，若是wavetyep = 'P',注意修此处为P波速度
    config.ssp.radiation = 0.41; % S波辐射因子（stork A L.,2004）
    %% 
    Write_xml(['./config/','config','.xml'],config);
end

