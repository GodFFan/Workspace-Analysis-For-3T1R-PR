clear all;close all;
clc;
%%%%%%%%%%---------------------����һ�����ֱ�ߵ���ġ�4-2-1�����������Ľṹ����,��λ��m;(����4-2-1PM��Ͽռ�)
%%%%%%%%-----------------a��ʾ��ƽ̨��ȣ�b��ʾ���ײ�����Ŀ�ȣ�lu��ʾ�ϲ�ƽ���ı��εĸ˳���ld��ʾ�²�ƽ���ı��εĸ˳���L0��ʾ���쳤��
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
%%%%%%%%%%--------------------5ƽ̨����P��xc,yc,zc,theta��,ȡy=l0/2���棬���н�ά��������x,zc,thetaά�ȵĹ����ռ�
yc= l0/2;
%%%%%%%%%%--------------------xc,zc,theta���������ã�����ȷ�������ռ�
thetamin= -pi/2;    thetamax= pi/2;
xmin= 0;            xmax= b;
zmin= -0.7;      zmax= 0;
%%%%%%%%%%-------------------ȷ��ÿ��ά�ȵĵ���������
nu=60;    nx=32;    nz=34;
%%%%%%%%%%-------------------ȷ��ÿ��ά�ȵĵ���������
du=(thetamax-thetamin)/nu;
dx=(xmax-xmin)/nx;
dz=(zmax-zmin)/nz;
%%%%%%%%%%-------------------ȷ����ʼ������
theta0 = thetamin;   x0 = xmin;    z0 = zmin;
%%%%%%%%%%%--------------------�����ռ��ʼ��
workspace=0;
%%%%%%%%%%--------------------����һ���ռ�������
stepnum1= 60;
stepnum2= 32;
stepnum3= 34;
w=zeros( stepnum1, stepnum2, stepnum3 );
w=[];
%%%%%%%%%%-------------------ȷ��**��������ÿ����Ԫ������;����λ�÷���Լ���������������ռ�
n=0;
for i=1:1:nu
    thetac=theta0 + (i-1/2)*du;
    for j=1:1:nx
        xc=x0 + (j-1/2)*dx;
        for k=1:1:nz
            zc = z0 +(k-1/2)*dz;
            %%%%%%%%%%-------------------����λ�÷��������жϵ��Ƿ��ڹ����ռ���
            zc1=ld^2-(xc-a*cos(thetac)/2-d1-d2)^2;
            zc2=ld^2-(xc+a*cos(thetac)/2+d1+d2-b)^2;
            zC1=zc+h1+h2 + sqrt(zc1);                                       %zC1=zc+h1+h2 + sqrt(ld^2-(xc-a*cos(thetac)/2-d1-d2)^2);
            zC2=zc+h1+h2 + sqrt(zc2);                                       %zC2=zc+h1+h2 + sqrt(ld^2-(xc+a*cos(thetac)/2+d1+d2-b)^2);
            %%%%%%---------------------------------------------------------λ�÷��������1��
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

workspace   %%%%%---���㹤���ռ����
n
%%%%------------------------����3D��ά����ͼ��ʵ����������������
[is,js,ks]=size(w);
for i=1:is
    
    for j=1:js
        for k=1:ks
            if w(i,j,k)>0.0000000001  %%%----����0
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
%%%%%%%%--------------------------------ͼ����ʾʱһЩ����������view([-20 20]);  view([-37.5 30]);Ĭ�������ӽ�;view([-45 25]);
grid on; axis on; axis tight;
view([-45 25]);  %%%%--ʵ����ͶӰ��ͼû�����壻Ҫ��������ͼ
set(gca,'gridlinestyle',':','linewidth',2,'color',[1 1 1],'FontName','Times New Roman','FontWeight','Bold','FontSize',36);
title(['WorkSpace: block = ',num2str(n),', V = ',num2str(workspace),' m^2��rad']);

%%%--------------------------------------------------------------------------------------------
xlabel('{\it\theta}/rad ','FontName','Times New Roman','FontWeight','Bold','FontSize',36)
ylabel('{\itx}/m','FontName','Times New Roman','FontWeight','Bold','FontSize',36,'Rotation',0)
zlabel('{\itz}/m','FontName','Times New Roman','FontWeight','Bold','FontSize',36,'Rotation',90)














% %%%%%%-----------------���������ռ���������Ľ���ͼ(�Ż����֮ǰ�ĳ���)--------------------------------------------------------------------
% %%%%%%%%-----------------------------------������������ȡ�������Ĺ����ռ�
% %%%%%%%%%%%%---------------------------------------------------------------------xoz��Ĺ����ռ�
% w1 =w(19,:,:);  %%%------�ɵ���theta,�鿴��ͬtheta�µĹ����ռ�״��
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

% %%%%%%%%%%%%%-------------------------------------------------------------------- theta-z�����ռ�
% w2 =w(:,14,:); %%%------�ɵ���x,�鿴��ͬx�����µĹ����ռ�״��
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

% %%%%%%%%%%%%------------------------------- -- theta-x�����ռ�
% w3 =w(:,:,15); %%%------�ɵ���x,�鿴��ͬx�����µĹ����ռ�״��
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
%%%%%%%%-----------------���������ռ���������Ľ���ͼ(�Ż����֮��ĳ���)--------------------------------------------------------------------
% %%%%%%%%%%-----------------------------------������������ȡ�������Ĺ����ռ�
% %%%%%%%%%%%%%---------------------------------------------------------------------xoz��Ĺ����ռ�
% w1 =w(26,:,:);  %%%------�ɵ���theta,�鿴��ͬtheta�µĹ����ռ�״��
% for j =1:25
%     for k=1:31
%         w11(k,j)=w1(1,j,k);
%     end
% end
%  %%%%---subplot(2,2,1);
% pcolor(w11);figure(gcf);colormap(cool);hold on;grid on;
% axis on;axis tight;
% set(gca,'gridlinestyle',':','color',[1 1 1],'FontName','Times New Roman','FontSize',36,'FontWeight','Bold', 'XLim',[0 25],'YLim',[0 31]);%X���������ʾ��Χ
% xlabel('{\itx}/m','FontName','Times New Roman','FontSize',36,'FontWeight','Bold')
% ylabel('{\itz}/m','FontName','Times New Roman','FontSize',36,'FontWeight','Bold','Rotation',90)
% hold off
%
% %%%%%%%%%%%%%-------------------------------------------------------------------- theta-z�����ռ�
% w2 =w(:,13,:); %%%------�ɵ���x,�鿴��ͬx�����µĹ����ռ�״��
% for i =1:51
%     for k=1:31
%         w12(k,i)=w2(i,1,k);
%     end
% end
% %%%%---subplot(2,2,2);
% pcolor(w12);figure(gcf);colormap(cool);hold on;grid on;
% axis on;axis tight;
% set(gca,'gridlinestyle',':','color',[1 1 1],'FontName','Times New Roman','FontSize',36,'FontWeight','Bold', 'XLim',[0 51],'YLim',[0 31]);%X���������ʾ��Χ
% xlabel('{\it\theta}/rad ','FontName','Times New Roman','FontSize',36,'FontWeight','Bold')
% ylabel('{\itz}/m','FontName','Times New Roman','FontSize',36,'FontWeight','Bold','Rotation',90)
% hold off
%
% %%%%%%%%%%%%%-------------------------------                                      --- theta-x�����ռ�
% w3 =w(:,:,16); %%%------�ɵ���x,�鿴��ͬx�����µĹ����ռ�״��
% for i =1:51
%     for j=1:25
%         w13(j,i)=w3(i,j,1);
%     end
% end
% %%%%---subplot(2,2,3);
% pcolor(w13);figure(gcf);colormap(cool);hold on;
% grid on; axis on; axis tight;
% set(gca,'gridlinestyle',':','color',[1 1 1],'FontName','Times New Roman','FontSize',36,'FontWeight','Bold', 'XLim',[0 51],'YLim',[0 25]);%X���������ʾ��Χ
% xlabel('{\it\theta}/rad','FontName','Times New Roman','FontSize',36)
% ylabel('{\itx}/m','FontName','Times New Roman','FontSize',36,'Rotation',90)
% hold off






