close all;
clear all;
clc;
%% 结构参数定义
a = 0.130;
b = 0.875;
d1 = 0.067;
d2 = 0.0125;
h1 = 0.033;
h2 = 0.0475;
lu = 0.550;
ld = 0.600;
l0 = 2.100;
% ss=0.075;
% sl=0.145;
%% 定义求解区域
xmin = 0;
xmax = b;

ymin = 0;
ymax = l0;

zmin = -0.7;
zmax = 0;

tmin = -pi/2;
tmax = pi/2;

yn = ymax/2;

%% 定义比例因子
unit = 1000;%%单位转换  米 -> 毫米
ScaleFactor = 100;%%设置比例因子

%% 定义每个维度的搜索次数
t_x=1;
t_y=1;
t_z=1;
t_t=2;
% t_x=5;
% t_y=5;
% t_z=5;
% t_t=5;

findx = ceil((xmax-xmin)*ScaleFactor/t_x)
findy = ceil((ymax-ymin)*ScaleFactor/t_y)
findz = ceil((zmax-zmin)*ScaleFactor/t_z)
findt = ((tmax-tmin)/pi*180/t_t)%% 最后面的数是求解次数
%

% 搜索步长
stepx = (xmax-xmin)/findx;
stepy = (ymax-ymin)/findy;
stepz = (zmax-zmin)/findz;
stept = (tmax-tmin)/findt;

%% 申请内存 存放数据
workspace = zeros(findt,findx,findz);
%% 定义搜索起点
x0 = xmin;
y0 = ymin;
z0 = zmin;
t0 = tmin;

n=0;      %计数器
V=0;%工作空间体积

%%
for tt=1:1:findt
    tn = t0+(tt-0.5)*stept;
    for xx=1:1:findx
        xn = x0+(xx-0.5)*stepx;
        for zz=1:1:findz
            zn = z0+(zz-0.5)*stepz;
            %% 利用逆运动学进行空间筛选
            zc1=ld^2-(xn-a*cos(tn)/2-d1-d2)^2;
            zc2=ld^2-(xn+a*cos(tn)/2+d1+d2-b)^2;
            zC1=zn+h1+h2 + sqrt(zc1);                                       %zC1=zn+h1+h2 + sqrt(ld^2-(xn-a*cos(tn)/2-d1-d2)^2);
            zC2=zn+h1+h2 + sqrt(zc2);                                       %zC2=zn+h1+h2 + sqrt(ld^2-(xn+a*cos(tn)/2+d1+d2-b)^2);
            if(zc1>=0)&&(zc2>=0)&&(zC1>=0)&&(zC2>=0)&&(lu^2-zC1^2>=0)&&(lu^2-zC2^2>=0)&&...
                    (tn>=tmin)&&(tn<=tmax)&&(xn>=xmin)&&(xn<=xmax)&&(zn>=zmin)&&(zn<=zmax)
                
                q1 = yn-a*sin(tn)/2-sqrt(lu^2-zC1^2);
                q2 = yn-a*sin(tn)/2+sqrt(lu^2-zC1^2);
                q3 = yn+a*sin(tn)/2-sqrt(lu^2-zC2^2);
                q4 = yn+a*sin(tn)/2+sqrt(lu^2-zC2^2);
                %%
%                 if(0+sl<=q1) && (q1<q2-2*ss) && (q2<=l0-sl) && (q2-q1<= 2*lu) &&...         
%                   (0+sl<=q3) && (q3<q4-2*ss) && (q4<=l0-sl) && (q4-q3<= 2*lu) &&...
%                   (b<2*(ld+d1+d2)+a*cos(tn))
              
              %%%        ↑  实际约束，考虑电机所在滑块的尺寸
              %%%  这两个if只能存在一个，另一个要被注释掉
              %%%        ↓  理想约束，没有考虑电机所在滑块的尺寸
              
                if(0<=q1) && (q1<q2) && (q2<=l0) && (q2-q1<= 2*lu) &&... 
                  (0<=q3) && (q3<q4) && (q4<=l0) && (q4-q3<= 2*lu) &&...
                  (b<2*(ld+d1+d2)+a*cos(tn))
                    V =  V +  stept*stepx*stepz;
                    workspace(tt,xx,zz)=1;
                    n=n+1;
                end
            end
        end
    end
end
n
V

%% 工作空间绘制
[wt,wx,wz]=size(workspace);
for tt=1:wt   %% 1->wt对应-pi/2,pi/2
    for xx=1:wx %%1->wx  xmin->xmax
        for zz=1:wz
            if workspace(tt,xx,zz)>0.0000000001  %%%----大于0
                Block(tt,xx,zz,tmin,xmin,zmin,stept,stepx,stepz);
                %Block(tt,xx,zz);
                hold on;
            end
        end
    end
end
view(3)
%%%--------------------------------------------------------------------------------------------
grid on; axis on; axis tight;
set(gca,'gridlinestyle',':','linewidth',1,'color',[1 1 1],'FontName','Times New Roman','FontWeight','normal','FontSize',40);
set(gca,'XTick',-pi/2:pi/4:pi/2);%theta轴刻度设置
set(gca,'XTickLabel',{'-\pi/2','-\pi/4','0','\pi/4','\pi/2'});
title(['WorkSpace: block = ',num2str(n),', V = ',num2str(V),' m^2·rad']);
%%%--------------------------------------------------------------------------------------------
xlabel('{\it\theta}/rad ','FontName','Times New Roman','FontWeight','normal','FontSize',40,'Rotation',15)
ylabel('{\itx}/m','FontName','Times New Roman','FontWeight','normal','FontSize',40,'Rotation',-20)
zlabel('{\itz}/m','FontName','Times New Roman','FontWeight','normal','FontSize',40,'Rotation',90)



