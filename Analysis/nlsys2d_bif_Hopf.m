clear all;
close all;
clc;

%% Continuazione dell'equilibrio e individuazione della biforcazione di Hopf

% punto di equilibrio
load ptEq.mat
equil = ptEq';
% valore del parametro per cui l'equilibrio e' STABILE
p = [0; 0];
% inizializzo la continuazione dell'equilibrio partendo da un equilibrio
[x0, v0] = init_EP_EP(@nlsys2d_HopfNormalForm, equil, p, 1);
% imposto le opzioni di continuazioni
opt = contset;
% >>>>>>>  singularities = 1 => rileva le biforcazioni
opt=contset(opt,'Singularities',1);
% numero massimo di passi di continuazione
opt = contset(opt,'MaxNumPoints',7000);

opt=contset(opt,'MinStepSize',0.00001);
opt=contset(opt,'MaxStepSize',0.01);
%opt=contset(opt,'Backward',1);
% continuazione vera e propria
[xE,vE,sE,hE,fE] = cont(@equilibrium, x0, [], opt);
%   grafico
figure;
cpl(xE,vE,sE,[3 2 1]); % le prime due sono le varibili di stato, la terza è il parametro (è il piano di controllo)
title('Continuazione dell''equilibrio (0,0) al variare di $p$.','Interpreter','latex');
xlabel('$p$','Interpreter','latex');
ylabel('$x_1$','Interpreter','latex');
zlabel('$x_2$','Interpreter','latex');
% figure;
% cpl(xE, vE, sE, [2 1]);
% title('Continuazione dell''equilibrio (0,0) al variare di $p$.','Interpreter','latex');
% xlabel('$p$','Interpreter','latex');
% ylabel('$x_2$','Interpreter','latex');

%% Continuazione del ciclo che nasce dalla Hopf

% indice, nel vettore delle soluzioni, della soluzioni corrispondente alla
% hopf
indice = sE(2).index;
% coordinate dell'equilibrio nel punto di biforcazione
ptH = xE(1:2,indice);
% valore del parametro nel punto di biforcazione
pH = xE(3,indice);
% norma iniziale del ciclo (qualsiasi valore "piccolo" va bene)
h = 1e-4;
% numero di punti sul ciclo
ntst = 30;
% numero di collocazioni tra ogni coppia di punti
ncol = 4;
[x0,v0]=init_H_LC(@nlsys2d_HopfNormalForm,ptH,pH,1,h,ntst,ncol);
opt=contset;
opt=contset(opt,'MaxNumPoints',100);
% opt=contset(opt,'IgnoreSingularity',1);
% opt=contset(opt,'Singularities',1);
opt=contset(opt,'Backward',1);
opt=contset(opt,'MinStepSize',10e-6);
%opt=contset(opt,'MinStepSize',1);
[x2,v2,s2,h2,f2]=cont(@limitcycle,x0,v0,opt);
figure;
hold on
%plotcycle(x2,v2,s2,[1 2]);
plotcycle(x2,v2,s2,[size(x2,1) 1 2]);
cpl(xE,vE,sE,[3 1 2]);
xlabel('$p$','Interpreter','latex');
ylabel('$x_1$','Interpreter','latex');
zlabel('$x_2$','Interpreter','latex');
%% Salvataggio dati
% save hopfnormalformcont.mat
