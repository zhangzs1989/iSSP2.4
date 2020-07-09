## 0 前言
- 该程序是基于MATLAB开发的一款用于震源谱参数和震源参数计算的工具，方便地震监测预报人员开展日常工作，以及辅助完成部分科研任务。该版本为Ver2.0,比Ver1.0版本更为简洁、稳定。另外，2.0版本开发过程中避免使用GUIDE开发工具，使得源码开放性和兼容性更好。该计算程序可免费共享使用，由于水平有限，程序中仍然存在许多错误和撇脚难用之处，欢迎使用人员提出修改建议，逐步完善，丰富更多的功能。欢迎将问题反馈至邮箱：**858488045@qq.com**.
- 特别感谢**郑建常研究员**提供的原始计算程序脚本和技术指导。感谢黑龙江地震局**周晨**、辽宁省地震局**夏彩韵**、淄博市应急局**孙强**、山东地震局**崔华伟**、**刘承雨**、**王书豪**、**李国一**等对程序调试、使用过程中提出的改进意见，感谢山东地震局**李铂**提供的测试数据。本程序是在中国地震局震情跟踪面上项目和青年项目的共同资助下完成。

## 1 原理简介
### 1.1 震源理论
- 根据台站记录波形的振幅谱反演求解地震事件的震源参数，在目前已经逐渐成为地震学中的日常工作；很多情况下，基于经典Brune模型由观测谱拟合得到的诸如应力降、视应力等参数在大震危险性估计、震后趋势判定等方面有着重要的应用。
- 尽管震源参数的测定已经成为地震研究中一项重要课题，但是仍然存在许多争议。首先，Brune震源模型简化的理想化模型，理论谱仅仅采用零频极值和拐角频率两个参数进行约束，自由度比较低；其次，在地震频谱图上，无论采用人工标定还是自动识别拐角频率都是难以测准的；而且，在通过震源谱参数估算震源物理参数时，使用了许多经验公式和经验值，这就导致与真实破裂过程存在一定的偏差。
- 客观地，从震源谱中我们可以得到四个参数：零频极值、拐角频率、高频衰减系数γ 以及频率
上限（截止频率）fmax（陈运泰等,2000）。但在日常的地震频谱分析和震源参数反演中，绝大多数的工作只考虑了前两项．在理论上，高频端的震源谱Ω（ω）以ω^(－γ)的形式衰减。．假定断层面上的应力降的随机起伏满足布朗运动分布，且应力降超出平均水平部分为“小地震”，则Ｄ＝２－η，显然γ＝5-1.5Ｄ．经典的Brune模型中，破裂面被理想化为圆盘状，分形维Ｄ＝２，因此高频衰减系数γ也就被固定为2.
- Brune震源模型是将震源建模为瞬时施加到位错面内部的切向应力脉冲，该模型采用三个独立的参数（地震矩、震源尺度和应力降），它们共同确定了体波的远场位移谱的形状。该模型已被广泛用于根据地震波的观测数据估算震源参数。位移源频谱 具有简单的 形状，即对于低于拐角频率的频率它具有平坦特性，而对于大于拐角频率的频率它具有 的衰减。类似地，对于低于拐角频率的频率，加速度频谱的加速度具有 形状，对于大于拐角频率的频率，加速度频谱具有平坦的水平。Hanks等在对地面运动的观测中发现，地震波加速度频谱中广泛存在一种现象，即加速度谱振幅在达到某个频率上限时会突然减小观察到，该频率称为最大截止频率 ，高于该频率时，加速度谱幅会突然减小。在地震工程中，该截止频率 是一个重要参数，因为它控制着地面的峰值加速度。于是，在考虑了地震波加速度谱中存在的最大截止频率，给出了基于Brune的高频截（High-Cut）模型。ver2.0版本支持Brune（γ可变以及γ=2两种震源模型）和Higc-Cut两个模型进行计算。
- 由于在自相似的假设和Brune模型下，应力降与视应力存在成比例的线性对应关系(Singh and Ordaz,1994；Baltay et al.,2011)。因此本程序中不再单独生成视应力参数。
### 1.2 方法简述
- 粒子群寻优算法
粒子群优化（PSO）是一种无导数的全局最优解算器。它的灵感来自动物令人惊讶的有组织的行为，如成群的鸟类，鱼群或成群的蝗虫。此算法中的单个生物或“粒子”是原始的，仅知道四个简单的事物：1搜索空间中的当前位置；2适应度值；3他们之前的个人最佳位置；以及4整体“swarm”中所有粒子找到的最佳位置。没有渐变或Hessians来计算。每个粒子基于该信息不断地在搜索空间中调整其速度和轨迹，每次迭代都更接近全局最优。
- 最小二乘法
通过最小化误差的平方和寻找数据的最佳函数匹配。利用最小二乘法可以简便地求得未知的数据，并使得这些求得的数据与实际数据之间误差的平方和为最小。
- 残差最小化
第一，使用初始截止频率之内的频带，根据理论谱公式对其进行非线性拟合，当观测谱值和理论谱值的均方根误差（rmse）最小的情况下得到最优拐角频率的值；第二，使用该拐角频率之后的高频部分，仍然采用最小均方根误差最小化原则获得最优截止频率。特别需要说明的是对于初始值的选择，采取以下方法：取最大速度谱值作为拐角频率的初始值，最大加速度谱值对应的频率作为截止频率的初始值。
## 2 程序说明
- 代码介绍
	- 开发语言：matlab
	- 开发环境及编译器：项目使用MATLAB IDE完成复写与集成开发。
- 操作系统：
 	+ 当使用window系统时，请直接下载运行run_Main.exe即可。
	+ 当使用linux系统时，请自行安装matlab开发环境。
	- 本程序目前已经在window系统下运行。  
- 配置说明
采用可扩展标记语言XML配置程序运行参数以及预处理参数。XML的简单易于在任何应用程序中读/写数据，这使XML很快成为数据交换的唯一公共语言，虽然不同的应用软件也支持其他的数据交换格式，但不久之后它们都将支持XML，那就意味着程序可以更容易的与Windows、Mac OS、Linux以及其他平台下产生的信息结合，然后可以很容易加载XML数据到程序中并分析它，并以XML格式输出结果。	 

## 3 程序介绍
程序中共存在8个系统文件夹，文件夹含义如下：
- config：计算过程中配置的运行参数和预处理参数。
- doc: 存放使用手册等其他文档资料。
- figure: 存放程序运行产生的相关图件资源。
- help: 帮助文档
- icon: 图标文件
- filter:滤波器参数
- pathinp : 批处理时波形数据和观测报告数据路径输入文件.inp
- result： 计算结果保存路径，主要包含震源谱（位移谱、速度谱和加速度谱结果）、谱参数、震源参数以及使用残差拟合时产生的残差变化值。
- temp: 保存计算过程中部分临时变量。
![程序构成](https://img-blog.csdnimg.cn/2020040821380875.png
## 4 安装
### 4.1 直接使用
将源程序包拷贝至工作目录下，运行run_main.p文件即可启动运行，点击Enter进入计算界面。如下提示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200523084821248.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
![计算主界面](https://img-blog.csdnimg.cn/20200521141752412.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
### 4.2 exe安装
运行打包文件.exe
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200521143656838.png)。
## 5 使用方法
### 5.1 设置
####  5.1.1 运行参数配置
该参数配置主要是设置计算过程中的参数，**工具栏-->设置-->运行参数设置**，主要包括以下几个参数，分别说明如下：
![运行参数设置](https://img-blog.csdnimg.cn/2020052114433482.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)	
-- 震源模型，可选择经典Brune模型和高频截止模型，可选择1 or 2 or 3，每次计算仅仅能选择一种
-- 反演方法，可选择最小二乘法、最小残差法
-- 波形格式，目前仅支持evt格式
-- 观测报告，可以读取地震编目网中CFS格式以及Jopens系统产生的观测报告（去掉头段的地震目录）
-- 选取波段，主要是根据观测报告中的数据，自动截取P波波段或者S波波段
-- 到时点偏移，主要是考虑了震相标定的误差，一般会提前1秒进行截取
-- 快速傅里叶变换点，计算观测谱时傅里叶变换，可选择512，1024，2048
-- 介质密度，岩石密度估算
-- 地震波速度，对于P波和S波分别填写相应的速度
-- 辐射因子，目前默认0.41
参数的配置主要是以xml的形式，完成传参功能。配置的计算保存至./config路径下，文件名为config.xml。
#### 5.1.2 预处理参数设置
该参数配置主要是对数据的预处理，**工具栏-->设置-->预处理参数设置**。由于目前输入源数据格式不统一，仪器响应和场地响应，本程序根据输入数据的头文件信息进行简单去除计算。该预处理参数设置主要是根据研究区的构造情况，可依据前人的研究结果给出非弹性衰减校正公示，即修改非弹性衰减系数中的系数值，默认位a=300;b=0.5;
![预处理](https://img-blog.csdnimg.cn/20200521145429214.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
滤波器参数导入：通过matlab的fdatool工具箱设计滤波器之后,如下图所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200705151932519.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
设计好滤波器之后，CTRL+E导出滤波器参数，Export To选择MAT-File，Export As选择Coefficients，Variable Names,默认未SOS和G。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200705152124694.png![在这里插入图片描述](https://img-blog.csdnimg.cn/20200705152301504.png)

#### 5.1.3 设置主界面工具栏
工具栏-->设置-->设置工具栏，主要是打开或者关闭matlab figure对象的默认工具栏工具。可以在主计算界面打开或者关闭工具栏，方便用户对图件进行细致是设置和查看。
![工具栏开/关](https://img-blog.csdnimg.cn/2020052115000577.png)
#### 5.1.4 设置背景颜色
 工具栏-->设置-->背景颜色。主要用来随机修改主计算界面的背景颜色，无记忆等功能。
![背景颜色述](https://img-blog.csdnimg.cn/20200521150136851.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
### 5.2 辅助工具
#### 5.2.1 文件路径生成
工具栏-->辅助工具-->文件路径生成器。该小工具主要是将某一路径下所有的后缀.evt的波形文件和相应的地震观测报告.txt创建并写入./pathinp/下的.inp文件，文件名以计算机当前时间命名，格式为yyyymmddTHHMMSS.inp。**需要特别说明的是，evt波形文件名和观测报告txt文件名需要一致，否则无法生成一一对应的输入文件**。inp文件内容如下图所示：
![inp文件](https://img-blog.csdnimg.cn/20200521151307575.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
#### 5.2.2 恢复运行参数缺省值
工具栏-->辅助工具-->恢复运行参数缺省值。**重置运行参数配置**。
#### 5.2.3 恢复背景缺省值
工具栏-->辅助工具-->背景缺省值。重置当前背景颜色，默认为灰色。
### 5.3 计算
#### 5.3.1 单个地震计算
工具栏->计算->单个地震自动计算。分别点击导入波形文件、观测报告，最后点击运行计算，即根据预先配置的运行参数和预处理参数进行计算。计算结果相关图件会显示在主计算界面内。
![单个地震](https://img-blog.csdnimg.cn/20200521152657819.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
计算结果会自动保存在工作目录**./result**下，计算结果会以.zip压缩文件的形式保存，其中主要包括两个文件，一是震源谱结果以.csv格式保存，包含每个台站相应的速度谱、位移谱和加速度谱以及对应的平均震源谱；二是相应地震的震源参数结果，后缀以.par保存。**若结果无意义，则以NaN值写出**。表头给出了数值对应的含义。Brune模型和High-Cut模型两个模型产出的震源谱参数有不同之处，其中High-Cut会产出高频截止频率fmax，以及高于截止频率频段的衰减系数p。若选择Brune模型为计算模型，fmax和p以及对应置信范围置为NaN。
![result](https://img-blog.csdnimg.cn/20200522091427668.png)
具体参数含义：
-- Time:						  地震发生时间
-- [Lontitude,latitude]： 地震发生经纬度
-- Mag:							 震级
-- Depth:						 震源深度
-- fc,fc1,fc2:					 拐角频率，拐角频率置信区间
-- fmax,fmax1,fmax2：截止频率，截止频率置信区间
-- p,p1,p2：					截止频率之上的衰减系数
-- Mo：						地震矩，单位N.m
-- Mw:							矩震级
-- Rupture：				破裂半径，单位m
-- stressdrop:				应力降，Mpa
#### 5.3.2 批量计算
根据5.2.1部分的文件路径生成功能，将波形文件路径和观测报告文件路径自动生成.inp文件。使用者也可能根据自己的情况，根据方便程度自己制作输入.inp文件。具体格式如下：![inp格式](https://img-blog.csdnimg.cn/20200522093944480.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)

		将需要计算的地震前面的%去掉即可。
		工具栏->计算->批量计算，选择相应的.inp文件。即可自动读取inp中的数据文件，自动计算，并将计算结果保存在./result/，计算结果.zip以输入波形的文件名命名。
![选择输入inp](https://img-blog.csdnimg.cn/20200522094134156.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
#### 5.3.3 计算结果.par中参数合并
为了将计算结果（.zip文件）中所有的.par文件中震源参数提取出来，整合到一个文件中，方便用户后续的制图以及对数据分析工作。工具栏->辅助工具->计算参数合并，该功能即可以完成参数的提取工作。将需要合并的.zip的选中，打开即可。生成的文件以计算机当前时间自动命名，格式为yyyymmddTHHMMSS-final.par。
![选择合并.zip](https://img-blog.csdnimg.cn/20200522095138835.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
### 5.4 制图
#### 5.4.1 震源谱
工具栏->制图->傅里叶谱下分为速度谱、位移谱和加速度谱。选择计算产生的.zip文件或者解压出来的.csv文件，即可自动做出相应的谱图。
![制图](https://img-blog.csdnimg.cn/20200522100113470.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200522210806810.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
#### 5.4.2 谱参数
工具栏->制图->谱参数。选择5.3.3 部分将计算结果的合并文件yyyymmddTHHMMSS-final.par中的震源谱参数提取出来进行画图，保存为.png、.eps和.fig三种格式，方便用户修改。并将结果自动压缩保存至./figure/下，文件名为：yyyymmddTHHMMSS-final.par-ssp.zip。
图件1：矩震级与拐角频率关系
图件2：震级-拐角频率关系
图件3：拐角频率随着时间的变化。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200522211227456.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70#pic_center)
#### 5.4.3 震源参数
工具栏->制图->震源参数。选择5.3.3 部分将计算结果的合并文件yyyymmddTHHMMSS-final.par中的震源谱参数提取出来进行画图，保存为.png、.eps和.fig三种格式，方便用户修改。并将结果自动压缩保存至./figure/下，文件名为：yyyymmddTHHMMSS-final.par-ppara.zip。
图件1：拐角频率、地震矩和理论应力降之间的关系；
图件2：Ml-Mo关系和Ml-Mw关系
图件3：应力降时域演化
图件4：相对应力降时域演化
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200522211247595.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70#pic_center)





## 更新修正
- 2020/6/30,修改Cal_Batch,增加输入观测报给和波形文件的路径是否颠倒的判断，并调整。修正了部分bug。
- 2020/6/60,修改plot_wave,调整波形显示，增加多台站选择显示功能。
- 2020/7/1，config中增加了平均观测台站个数配置，在运行参数设置和config缺省值修改了相关代码。
- 2020/7/1，修正了台站观测谱计算时，观测报告时间错误导致加窗超数组维数的问题。
- 2020/7/4，增加在程序预处理中对观测波形进行滤波预处理。
- 2020/7/4，修复谱参数和震源参数制图的部分问题。
- 2020/7/9，新增加了对Jopens系统产生的地震观测报告
