%PROCES 2,OAU LV
%MISLAV STIGLEC
%% PARAMETRI: 9

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
Kkz=87.44;
Kr=2.44;
%Kr=0.6*Kkz;
%Kr=Kkz;
%Kr=1.2*Kkz;

%% linearni proces

B=Ki*g/sqrt(2*g*(h10-h20));
s=tf('s');
G1=(Kh*Kv*Km*B) / (Tv*A1*A2*s^3 + (A1*A2 + 2*Tv*A1*B + Tv*B*A2)*s^2 + (2*A1*B+A2*B+Tv*B^2)*s + B^2);

%% polovi i nule
[z,p,k]=zpkdata(zpk(G1),'v');
Gzpk=zpk(z,p,k,'DisplayFormat','time constant');
%figure(1);
%pzplot(G1);

%% bode
%figure(3);
%bode(G1*Kr);
figure(4);
margin(G1*88);

%% odziv razina tekucine
figure(1)
sim('PcontrollerModel');
plot(Pt,h1,'b');
grid on
hold on
plot(Pt,h2,'r');

%% odziv napon
figure(2)
plot(Pt,ulaz,'b');
grid on
hold on
plot(Pt,Puh_nl,'r');



