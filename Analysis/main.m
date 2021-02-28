clear all
close all

% condizioni iniziali
% x0 = [10 20];
x0 = [10 0.25];

%Inizializzo un tensore in cui memorizzero' le traiettorie (5000 punti
%ciascuna) a partire dalle diverse condizioni iniziali contenute nella
%matrice I0. Ciascuna traiettoria ha 2 componenti (x e y)
%x=zeros([5000 2 size(x0,1)]);


%% parametri del sistema
alfa = 0;
beta = 0;

% analisi numerica
nlsys2d_analysis([alfa beta],x0);

%% parametri del sistema
alfa = 60;
beta = 0;

% analisi numerica
nlsys2d_analysis([alfa beta],x0);

%% analisi di biforcazione
nlsys2d_bif();



