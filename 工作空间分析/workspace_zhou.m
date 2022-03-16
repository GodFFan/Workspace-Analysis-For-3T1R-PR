clear all;close all;
clc;
%%%%%%%%%%---------------------给出一组基于直线电机的“4-2-1”并联机构的结构参数,单位：m;(搜索4-2-1PM混合空间)
%%%%%%%%-----------------a表示动平台宽度；b表示两底部导轨的宽度；lu表示上部平行四边形的杆长；ld表示下部平行四边形的杆长；L0表示导轨长度
a = 0.130;
b = 0.875;
d1 = 0.067;
d2 = 0.0125;
h1 = 0.025;
h2 = 0.0475;
lu = 0.550;
ld = 0.600;
l0 = 2.100;
ss=0.075;
sl=0.145;
%%%%%%%%%%--------------------5平台坐标P（xc,yc,zc,theta）,取y=l0/2截面，进行降维处理，考察x,zc,theta维度的工作空间
yc= l0/2;
%%%%%%%%%%--------------------xc,zc,theta上下限设置，初步确定搜索空间
thetamin= -pi/2;    thetamax= pi/2;
xmin= 0;            xmax= b;
zmin= -0.7;      zmax= 0;
%%%%%%%%%%-------------------确定每个维度的的搜索次数
nu=60;    nx=32;    nz=34;
%%%%%%%%%%-------------------确定每个维度的的搜索步长
du=(thetamax-thetamin)/nu;
dx=(xmax-xmin)/nx;
dz=(zmax-zmin)/nz;
%%%%%%%%%%-------------------确定初始搜索点
theta0 = thetamin;   x0 = xmin;    z0 = zmin;
%%%%%%%%%%%--------------------工作空间初始化
workspace=0;
%%%%%%%%%%--------------------开辟一个空间存放数据
stepnum1= 60;
stepnum2= 32;
stepnum3= 34;
w=zeros( stepnum1, stepnum2, stepnum3 );
w=[];
%%%%%%%%%%-------------------确定**次搜索后每个单元的形心;利用位置反解约束条件搜索工作空间
n=0;
for i=1:1:nu
    thetac=theta0 + (i-1/2)*du;
    for j=1:1:nx
        xc=x0 + (j-1/2)*dx;
        for k=1:1:nz
            zc = z0 +(k-1/2)*dz;
            %%%%%%%%%%-------------------利用位置反解条件判断点是否在工作空间内
            zc1=ld^2-(xc-a*cos(thetac)/2-d1-d2)^2;
            zc2=ld^2-(xc+a*cos(thetac)/2+d1+d2-b)^2;
            zC1=zc+h1+h2 + sqrt(zc1);                                       %zC1=zc+h1+h2 + sqrt(ld^2-(xc-a*cos(thetac)/2-d1-d2)^2);
            zC2=zc+h1+h2 + sqrt(zc2);                                       %zC2=zc+h1+h2 + sqrt(ld^2-(xc+a*cos(thetac)/2+d1+d2-b)^2);
            %%%%%%---------------------------------------------------------位置反解情况（1）
            if(zc1>=0)&&(zc2>=0)&&(zC1>=0)&&(zC2>=0)&&(lu^2-zC1^2>=0)&&(lu^2-zC2^2>=0)
                q1 = yc-a*sin(thetac)/2-sqrt(lu^2-zC1^2);
                q2 = yc-a*sin(thetac)/2+sqrt(lu^2-zC1^2);
                q3 = yc+a*sin(thetac)/2-sqrt(lu^2-zC2^2);
                q4 = yc+a*sin(thetac)/2+sqrt(lu^2-zC2^2);
                %%%%----------------------------------------
                if(0<=q1) && (q1<q2) && (q2<=l0) && (q2-q1<= 2*lu) &&...
                        (0<=q3) && (q3<q4) && (q4<=l0) && (q4-q3<= 2*lu) &&...
                        (b<2*(ld+d1+d2)+a*cos(thetac))
                    workspace =  workspace +  dx*dz*du;
                    w(i,j,k)=1;
                    n=n+1;
                end
            end
        end
    end
end

workspace   %%%%%---计算工作空间体积
n
%%%%------------------------画出3D三维立体图，实际上是搜索的网格
[is,js,ks]=size(w);
for i=1:is
    
    for j=1:js
        for k=1:ks
            if w(i,j,k)>0.0000000001  %%%----大于0
                %%%%-------------------------------------------------------------------
                if  (i==1)|(i==is)|(j==1)|(j==js)|(k==1)|(k==ks)
                    boxplot5(i,j,k);
                else
                    %%%%----------------------------------------------
                    if w(i-1,j,k)*w(i+1,j,k)*w(i,j-1,k)*w(i,j+1,k)*w(i,j,k-1)*w(i,j,k+1)==1
                    else
                        boxplot5(i,j,k);
                        hold on;
                    end
                end
            end
        end
    end
end
%%%%%%%%--------------------------------图形显示时一些参数的设置view([-20 20]);  view([-37.5 30]);默认设置视角;view([-45 25]);
grid on; axis on; axis tight;
view([-45 25]);  %%%%--实际上投影视图没有意义；要画出截面图
set(gca,'gridlinestyle',':','linewidth',2,'color',[1 1 1],'FontName','Times New Roman','FontWeight','Bold','FontSize',36);
title(['WorkSpace: block = ',num2str(n),', V = ',num2str(workspace),' m^2·rad']);

%%%--------------------------------------------------------------------------------------------
xlabel('{\it\theta}/rad ','FontName','Times New Roman','FontWeight','Bold','FontSize',36)
ylabel('{\itx}/m','FontName','Times New Roman','FontWeight','Bold','FontSize',36,'Rotation',0)
zlabel('{\itz}/m','FontName','Times New Roman','FontWeight','Bold','FontSize',36,'Rotation',90)














% %%%%%%-----------------画出工作空间在三个面的截面图(优化设计之前的程序)--------------------------------------------------------------------
% %%%%%%%%-----------------------------------下面程序可以提取任意截面的工作空间
% %%%%%%%%%%%%---------------------------------------------------------------------xoz面的工作空间
% w1 =w(19,:,:);  %%%------可调整theta,查看不同theta下的工作空间状况
% for j =1:27
%     for k=1:30
%         w11(k,j)=w1(1,j,k);
%     end
% end
%  %%%%---subplot(2,2,1);
% pcolor(w11);figure(gcf);colormap(winter);hold on;
% axis on;axis equal;
% set(gca,'gridlinestyle',':','linewidth',2,'color',[1 1 1],'FontName','Times New Roman','FontWeight','Bold','FontSize',36,'XLim',[0 27],'YLim',[0 30]);
% %%%%---title('zc-xc workspace','FontName','Times New Roman','FontWeight','Bold','FontSize',45)
% xlabel('{\itx}/m','FontName','Times New Roman','FontWeight','Bold','FontSize',36)
% ylabel('{\itz}/m','FontName','Times New Roman','FontWeight','Bold','FontSize',36,'Rotation',90)
% hold off

% %%%%%%%%%%%%%-------------------------------------------------------------------- theta-z工作空间
% w2 =w(:,14,:); %%%------可调整x,查看不同x截面下的工作空间状况
% for i =1:37
%     for k=1:30
%         w12(k,i)=w2(i,1,k);
%     end
% end
%  %%%%---subplot(2,2,2);
% pcolor(w12);figure(gcf);colormap(winter);hold on;
% axis on;axis tight;
% set(gca,'gridlinestyle',':','linewidth',2,'color',[1 1 1],'FontName','Times New Roman','FontWeight','Bold','FontSize',36,'XLim',[0 37],'YLim',[0 30]);
%  %%%%---title('zc-theta workspace','FontName','Times New Roman','FontWeight','Bold','FontSize',16)
% xlabel('{\it\theta}/rad ','FontName','Times New Roman','FontWeight','Bold','FontSize',36)
% ylabel('{\itz}/m','FontName','Times New Roman','FontWeight','Bold','FontSize',36,'Rotation',90)
% hold off

% %%%%%%%%%%%%------------------------------- -- theta-x工作空间
% w3 =w(:,:,15); %%%------可调整x,查看不同x截面下的工作空间状况
% for i =1:37
%     for j=1:27
%         w13(j,i)=w3(i,j,1);
%     end
% end
% %%%---subplot(2,2,3);
% pcolor(w13);figure(gcf);colormap(winter);hold on
% axis on;axis tight;
% set(gca,'gridlinestyle',':','linewidth',2,'color',[1 1 1],'FontName','Times New Roman','FontWeight','Bold','FontSize',36,'XLim',[0 37],'YLim',[0 27]);
% %%%---title('theta-xc workspace','FontName','Times New Roman','FontWeight','Bold','FontSize',16)
% xlabel('{\it\theta}/rad','FontName','Times New Roman','FontWeight','Bold','FontSize',36)
% ylabel('{\itx}/m','FontName','Times New Roman','FontWeight','Bold','FontSize',36,'Rotation',90)
% hold off

%%%%%%%%------------------------------------------------------------------------------------------------------------
%%%%%%%%------------------------------------------------------------------------------------------------------------
%%%%%%%%------------------------------------------------------------------------------------------------------------
%%%%%%%%------------------------------------------------------------------------------------------------------------
%%%%%%%%-----------------画出工作空间在三个面的截面图(优化设计之后的程序)--------------------------------------------------------------------
% %%%%%%%%%%-----------------------------------下面程序可以提取任意截面的工作空间
% %%%%%%%%%%%%%---------------------------------------------------------------------xoz面的工作空间
% w1 =w(26,:,:);  %%%------可调整theta,查看不同theta下的工作空间状况
% for j =1:25
%     for k=1:31
%         w11(k,j)=w1(1,j,k);
%     end
% end
%  %%%%---subplot(2,2,1);
% pcolor(w11);figure(gcf);colormap(cool);hold on;grid on;
% axis on;axis tight;
% set(gca,'gridlinestyle',':','color',[1 1 1],'FontName','Times New Roman','FontSize',36,'FontWeight','Bold', 'XLim',[0 25],'YLim',[0 31]);%X轴的数据显示范围
% xlabel('{\itx}/m','FontName','Times New Roman','FontSize',36,'FontWeight','Bold')
% ylabel('{\itz}/m','FontName','Times New Roman','FontSize',36,'FontWeight','Bold','Rotation',90)
% hold off
%
% %%%%%%%%%%%%%-------------------------------------------------------------------- theta-z工作空间
% w2 =w(:,13,:); %%%------可调整x,查看不同x截面下的工作空间状况
% for i =1:51
%     for k=1:31
%         w12(k,i)=w2(i,1,k);
%     end
% end
% %%%%---subplot(2,2,2);
% pcolor(w12);figure(gcf);colormap(cool);hold on;grid on;
% axis on;axis tight;
% set(gca,'gridlinestyle',':','color',[1 1 1],'FontName','Times New Roman','FontSize',36,'FontWeight','Bold', 'XLim',[0 51],'YLim',[0 31]);%X轴的数据显示范围
% xlabel('{\it\theta}/rad ','FontName','Times New Roman','FontSize',36,'FontWeight','Bold')
% ylabel('{\itz}/m','FontName','Times New Roman','FontSize',36,'FontWeight','Bold','Rotation',90)
% hold off
%
% %%%%%%%%%%%%%-------------------------------                                      --- theta-x工作空间
% w3 =w(:,:,16); %%%------可调整x,查看不同x截面下的工作空间状况
% for i =1:51
%     for j=1:25
%         w13(j,i)=w3(i,j,1);
%     end
% end
% %%%%---subplot(2,2,3);
% pcolor(w13);figure(gcf);colormap(cool);hold on;
% grid on; axis on; axis tight;
% set(gca,'gridlinestyle',':','color',[1 1 1],'FontName','Times New Roman','FontSize',36,'FontWeight','Bold', 'XLim',[0 51],'YLim',[0 25]);%X轴的数据显示范围
% xlabel('{\it\theta}/rad','FontName','Times New Roman','FontSize',36)
% ylabel('{\itx}/m','FontName','Times New Roman','FontSize',36,'Rotation',90)
% hold off






