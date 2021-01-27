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
K=87.44;
P_reg=[K*0.6 K K*1.2];

%% linearni proces

B=Ki*g/sqrt(2*g*(h10-h20));
s=tf('s');
Gs=(Kh*Kv*Km*B) / (Tv*A1*A2*s^3 + (A1*A2 + 2*Tv*A1*B + Tv*B*A2)*s^2 + (2*A1*B+A2*B+Tv*B^2)*s + B^2);

%% polovi i nule
[n,p,k]=zpkdata(zpk(Gs),'v');
Gzpk=zpk(n,p,k,'DisplayFormat','time constant');


%% KMK
s=tf('s');
Gpid=((s+0.01471)*(s+0.1471))/(s*(s+2.942));      
G0=Gs*Gpid;   

figure(1);
hold on;
datacursormode on;
grid on;
zeta =0.7;
sgrid(zeta,0);
%rlocus(G0);

[n0,p0,k0]=zpkdata(zpk(G0),'v');        
Gzpk=zpk(n0,p0,k0,'DisplayFormat','time constant');

figure(2);
hold on;
Kpid=96.2;
Gpid=(96.2*(s+0.01471)*(s+0.1471))/(s*(s+2.942));
G0=Gpid*Gs;
stepinfo(feedback(G0,1))
step(feedback(G0,1))
title('Odziv izlazne velièine na step');
xlabel('t [s]');
ylabel('Uh [V]');

sim('PIDController')

figure(3)
plot(PIDt,h1,'b');
grid on
hold on
plot(PIDt,h2,'r');
title('Odziv zatvorenog regulacijskog kruga (dinamièki model)');
xlabel('t [s]');
ylabel('h2 [m]');
legend('Referentna velièina','odziv na poremeæaj','Location','SouthWest')



