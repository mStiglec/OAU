%PROCES 2,OAU LV
%MISLAV STIGLEC
%% PARAMETRI: 9
clear
clc

h20=2.2;
Tv=68;
Kv=0.28;
Ki=0.026;
Km=0.02;
Kh=2.39;
A1=0.35;
A2=0.4;
g=10;
k_vrij=[1 0.5 1.5];

%% vrijeme simulacije
t_sim=3000;
t_step=100;

%% RADNA TOCKA

du=0.6;
uh0=Kh*h20;
h10=2*h20;
qi0=Ki*sqrt(2*g*h20);
qu0=Ki*sqrt(2*g*(h10-h20));
xv0=qu0/Kv;
u0=xv0/Km;
vi0=sqrt(2*g*h20);

%% pojacanje
Kkr=87.44;
P_reg=[Kkr*0.6 Kkr Kkr*1.2];

%% linearni proces

B=Ki*g/sqrt(2*g*(h10-h20));
s=tf('s');
Gs=(Kh*Kv*Km*B) / (Tv*A1*A2*s^3 + (A1*A2 + 2*Tv*A1*B + Tv*B*A2)*s^2 + (2*A1*B+A2*B+Tv*B^2)*s + B^2);

%% polovi i nule
[z,p,k]=zpkdata(zpk(Gs),'v');
Gzpk=zpk(z,p,k,'DisplayFormat','time constant');

% Kr=0.4*Kkr;
% sim('PcontrollerModel');
% plot(Pt,Pu_lin,'b');
% grid on
% hold on
% plot(Pt,Puh_lin,'r');          


% figure(1);
% xlabel('t [s]');
% ylabel('h2 [m]');
% title('odziv nelinearnog sustava sa P regulatorom');
% Kr=81.3;
% sim('PcontrollerModel');
% plot(Pt,h1,'b');
% grid on
% hold on
% plot(Pt,h2,'r');   

%% ZN1 METODA
Kgr=81.3;
Tgr=53;

%% parametri P regulator(ZN1)
Kp=0.5*Kgr;

%% parametri PI regulator(ZN1)
Kpi=0.4*Kgr;
Tipi=0.8*Tgr;

%% parametri PID regulatora(ZN1)
Kpid=0.6*Kgr;
Tipid=0.5*Tgr;
Tdpid=0.125*Tgr;
Tvpid=Tdpid/10;

s=tf('s');
Gpi=(Tipi*s+1)/(Tipi*s);

 s=tf('s');
 Gpid=((Tdpid*Tipid*s^2) + (Tipid*s+1)*(Tvpid*s+1))/((Tipid*s)*(Tvpid*s+1));

%% simulacija procesa upravljanih regulatorima ZN1 

figure(1);
sim('LV5_P_regulator_ZN1');
plot(Pt,h1,'b');
grid on
hold on
plot(Pt,h2,'r');
xlabel('t [s]');
ylabel('h2 [m]');
title('P regulator ZN1 metoda-nelinearni odziv sustava');

figure(2);
sim('LV5_PI_regulator_ZN1');
plot(Pt,h1,'b');
grid on
hold on
plot(Pt,h2,'r');
xlabel('t [s]');
ylabel('h2 [m]');
title('PI regulator ZN1 metoda-nelinearni odziv sustava');

figure(3);
sim('LV5_PID_regulator_ZN1');
plot(Pt,h1,'b');
grid on
hold on
plot(Pt,h2,'r');
xlabel('t [s]');
ylabel('h2 [m]');
title('PID regulator ZN1 metoda-nelinearni odziv sustava');







