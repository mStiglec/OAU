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

%% crtanje tangente na step odzivu
% [y,t] = step(Gs);
% h = mean(diff(t));
% dy = gradient(y, h);                                            % Numerical Derivative
% [~,idx] = max(dy);                                              % Index Of Maximum
% b = [t([idx-1,idx+1]) ones(2,1)] \ y([idx-1,idx+1]);            % Regression Line Around Maximum Derivative
% tv = [-b(2)/b(1); (max(y)-b(2))/b(1)];                                % Independent Variable Range For Tangent Line Plot
% f = [tv ones(2,1)] * b;                                         % Calculate Tangent Line
% 
% figure(1);
% plot(t, y)
% hold on
% plot(tv, f, '-r')                                               % Tangent Line
% line([0 500],[0.3405  0.3405],'color','black');
% plot(t(idx), y(idx), '.r')                                       % Maximum Vertical
% hold off
% grid

%% parametri ZN2

Kgr=0.3405;
ta=121.22;
tz=14.28;

a=(Kgr*tz)/ta;

%% P regulator parametri
Kp=1/a;

%% PI regulator parametri
Kpi=0.9/a;
Tipi=3*tz;

%% PID regulator parametri
Kpid=1.2/a;
Tipid=2*tz;
Tdpid=0.5*tz;
Tvpid=Tdpid/10;

s=tf('s');
Gpi=(Tipi*s+1)/(Tipi*s);

 s=tf('s');
 Gpid=((Tdpid*Tipid*s^2) + (Tipid*s+1)*(Tvpid*s+1))/((Tipid*s)*(Tvpid*s+1));

%% simulacija procesa upravljanih regulatorima ZN1

figure(1);
sim('LV5_P_regulator_ZN2');
plot(Pt,h1,'b');
grid on
hold on
plot(Pt,h2,'r');
xlabel('t [s]');
ylabel('h2 [m]');
title('P regulator ZN2 metoda-nelinearni odziv sustava');

figure(2);
sim('LV5_PI_regulator_ZN2');
plot(Pt,h1,'b');
grid on
hold on
plot(Pt,h2,'r');
xlabel('t [s]');
ylabel('h2 [m]');
title('PI regulator ZN2 metoda-nelinearni odziv sustava');

figure(3);
sim('LV5_PID_regulator_ZN2');
plot(Pt,h1,'b');
grid on
hold on
plot(Pt,h2,'r');
xlabel('t [s]');
ylabel('h2 [m]');
title('PID regulator ZN2 metoda-nelinearni odziv sustava');













