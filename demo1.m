

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

C3_T1 = zeros(imgWidth,imgHeight);
C3_T0 = zeros(imgWidth,imgHeight); 

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
C3_T1(R2<Cx*Cy-1) = Gray_BK;
C3_T0(R2<Cx*Cy-1) = Gray_BK;

% 2)目标
Gray_OBJ = 70;
Wx=2;Wy=2;HX=9;HY=8;
% C1_T1:十字像在视场右上方
C1_T1(Cx/2-Wx:1:Cx/2+Wx,Cx/2*3-4:1:Cx/2*3+4) = Gray_OBJ;
C1_T1(Cx/2-4:1:Cx/2+4,Cy/2*3-Wy:1:Cy/2*3+Wy) = Gray_OBJ;

% C1_T0:延时像，十字像在正中心偏左
C1_T0(Cx-Wx:1:Cx+Wx,Cy/2-4:1:Cy/2+4) = Gray_OBJ;
C1_T0(Cx-4:1:Cx+4,Cy/2-Wy:1:Cy/2+Wy) = Gray_OBJ;

% C2_T1:十字像在视场左上方
C2_T1(Cx/2-Wx:1:Cx/2+Wx,Cy/2-4:1:Cy/2+4) = Gray_OBJ;
C2_T1(Cx/2-4:1:Cx/2+4,Cy/2-Wy:1:Cy/2+Wy) = Gray_OBJ;

% C3_T1:十字像在视场水平右侧
C3_T1(Cx-Wx:1:Cx+Wx,Cy/2*3-4:1:Cy/2*3+4) = Gray_OBJ;
C3_T1(Cx-4:1:Cx+4,Cy/2*3-Wy:1:Cy/2*3+Wy) = Gray_OBJ;

% C3_T0:延时像，十字像在左下方
C3_T0(Cx/2*3-Wx:1:Cx/2*3+Wx,Cy/2-4:1:Cy/2+4) = Gray_OBJ;
C3_T0(Cx/2*3-4:1:Cx/2*3+4,Cy/2-Wy:1:Cy/2+Wy) = Gray_OBJ;

% 消除视场外像素值
C1_T1(R2>Cx*Cy-1) = 0;
C1_T0(R2>Cx*Cy-1) = 0;
C2_T1(R2>Cx*Cy-1) = 0;
C2_T0(R2>Cx*Cy-1) = 0;
C3_T1(R2>Cx*Cy-1) = 0;
C3_T0(R2>Cx*Cy-1) = 0;





%%% 2.EMD
EMD_xx = C1_T0.*C2_T1 - C1_T1.*C2_T0;
EMD_x = (EMD_xx - min(min(EMD_xx)))/max(max(EMD_xx));
%EMD_x = EMD_x > max(max(EMD_x))/2;%二值化
EMD_yy =  C1_T0.*C3_T1 - C1_T1.*C3_T0;
EMD_y = (EMD_yy - min(min(EMD_yy)))/max(max(EMD_yy));
%EMD_y = EMD_y >0.5* max(max(EMD_y));
EMD = sqrt(EMD_x.*EMD_x+EMD_y.*EMD_y);


theta1=atan((EMD_xx./((EMD_yy+1))-cos(pi/4))/(sin(pi/4)));


EMD_TH = EMD > max(max(EMD))/1.2;%二值化
% figure;imshow(EMD_TH,[]);title('EMD阈值化');
