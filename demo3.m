
%% 静止目标的EMD仿真结果:大目标

clc;
close all;
clear all;

%% 1.小眼1与2 T1 T0(延时后)图像 
imgHeight = 71;
imgWidth = 71;
C1_T1 = zeros(imgHeight,imgWidth);
C1_T0 = zeros(imgWidth,imgHeight); 

C2_T1 = zeros(imgWidth,imgHeight);
C2_T0 = zeros(imgWidth,imgHeight); 

x = 1:1:imgWidth;
y = 1:1:imgHeight;
Cx = ceil(imgWidth/2);
Cy = ceil(imgHeight/2);
[X,Y] = meshgrid(x,y);
R2 = (X-Cx).*(X-Cx) + (Y-Cy).*(Y-Cy);

% 1)背景
Gray_BK = 60;
C1_T1(R2<Cx*Cy-1) = Gray_BK;
C1_T0(R2<Cx*Cy-1) = Gray_BK;
C2_T1(R2<Cx*Cy-1) = Gray_BK;
C2_T0(R2<Cx*Cy-1) = Gray_BK;

% 2)目标
Gray_OBJ = 70;
Wx=2;Wy=5;
% C1_T1:十字像在正中心//右侧视场
C1_T1(Cx-Wx:1:Cx+Wx,1:1:imgHeight) = Gray_OBJ;
C1_T1(1:1:imgWidth,Cy/2*3-Wy:1:Cy/2*3+Wy) = Gray_OBJ;

% C1_T0:延时像，非运动，与T1一致
C1_T0 = C1_T1;

% C2_T1:十字像在正中心偏左
C2_T1(Cx-Wx:1:Cx+Wx,1:1:imgHeight) = Gray_OBJ;
C2_T1(1:1:imgWidth,Cy/2-Wy:1:Cy/2+Wy) = Gray_OBJ;
% C2_T0:延时像，非运动，与T1一致
C2_T0 = C2_T1; 

% 消除视场外像素值
C1_T1(R2>Cx*Cy-1) = 0;
C1_T0(R2>Cx*Cy-1) = 0;
C2_T1(R2>Cx*Cy-1) = 0;
C2_T0(R2>Cx*Cy-1) = 0;


%%% 2.EMD
EMD = C1_T0.*C2_T1 - C1_T1.*C2_T0;
% figure;imshow(EMD,[]);%title('EMD效果');

