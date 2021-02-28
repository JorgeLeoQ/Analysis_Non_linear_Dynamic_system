function nlsys2d_bif()

%% parametro alfa

% intervallo di variazione del parametro
alfa = 0:1:500;
nAlfa = length(alfa);
% punti di equilibri e jacobiano
ptEq = zeros(2,nAlfa);
Jacob = zeros(2,2,nAlfa);
t = [731, 1];
for i=1:nAlfa
    [ptEq(:,i),FVAL,EXITFLAG,OUTPUT,Jacob(:,:,i)] = fsolve(@(xx) nlsys2d(t,xx,[alfa(i) 0]), [-60, 0]);
end
% massimo tra le parti reali degli autovalori
autoval = zeros(size(alfa));
for k=1:nAlfa
    autoval(k) = max(real(eig(Jacob(:,:,k))));
end

figure; hold on;

% equilibri instabili
% metto in unstable gli indici degli elementi a parte reale positiva di autoval
unstable_temp = find(autoval>=0);

% equilibri stabili
% metto in stable gli indici degli elementi di autoval che NON stanno nel
% vettore unstable (=> elementi a parte reale negativa di autoval)
stable_temp = setdiff(1:nAlfa,unstable_temp);
% Separo i due rami del luogo degli equilibri stabili trovando il "salto"
% negli indici
brk = find(diff(stable_temp)>1);
j = 1;
i = 1;
stable = {0,0,0,0};
for i=1:length(brk)    
    stable{1,i} = stable_temp(j:brk(1,i));
    j = brk(1,i)+1;
end
stable{1,i+1} = stable_temp(j:end);

brk = find(diff(unstable_temp)>1);
j = 1;
i = 1;
unstable = {0,0,0};
for i=1:length(brk)    
    unstable{1,i} = unstable_temp(j:brk(1,i));
    j = brk(1,i)+1;
end
unstable{1,i+1} = unstable_temp(j:end);



% Rappresento in verde i rami stabili e in rosso quello instabile
% plot3(alfa(stable{1}),ptEq(1,stable{1}),ptEq(2,stable{1}),...
%     'g','LineWidth',2);
% plot3(alfa(stable{2}),ptEq(1,stable{2}),ptEq(2,stable{2}),...
%     'g','LineWidth',2);
for i=1:length(stable)
   plot3(alfa(stable{i}),ptEq(1,stable{i}),ptEq(2,stable{i}),...
     'g','LineWidth',2);
end

 for i=1:length(unstable)
   plot3(alfa(unstable{i}),ptEq(1,unstable{i}),ptEq(2,unstable{i}),...
    'r','LineWidth',2);
end

grid on; box on;
xlabel('alfa'); ylabel('x'); zlabel('y');
view(3);
set(gcf,'PaperUnits','Inch','PaperPosition',[0,0,6,4]);

%% parametro beta
