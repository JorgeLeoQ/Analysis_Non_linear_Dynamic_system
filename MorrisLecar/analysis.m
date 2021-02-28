function analysis(p,x0,varargin)

% Argomenti:
%       p - parametri.
%      x0 - condizione iniziale per l'integrazione.

% integrazione numerica per una singola condizione iniziale
tspan = linspace(0,300,50000);
opt = odeset('Refine',10,'Jacobian',@jac);
[t, x] = ode45(@model,tspan,x0,opt,p);

% integrazione numerica per un vettore di condizioni iniziali
% load x0_vect;
% x_vect = zeros([50000 2 size(x0_vect,1)]);
% %t_vect = zeros([tspan(1,2) 1 size(x0_vect,1)]);
% for k=1:size(x0_vect,1)
%     [t_vect, x_vect(:,:,k)] = ode45(@model,linspace(0,300,50000),x0_vect(k,:),opt,p);
% end

% PUNTI DI EQUILIBRIO
%
[ptEq,FVAL,EXITFLAG,OUTPUT,JACOB] = fsolve(@(xx) model(t,xx,p), [0, 0]);
fprintf("Punto di equilibrio (alfa = %d, beta = %d): x=%.3d y=%.3d", p(1), p(2), ptEq(1), ptEq(2));
save ptEq.mat
% verifica
temp = feval(@(xx) model(t,xx,p), ptEq);
fprintf("\nF(%.3d,%.3d): x=%.3d y=%.3d\n",ptEq(1),ptEq(2), temp(1), temp(2));
% isocline nulle
n = 1000;
xmin = -200;
xmax = 0;
X = linspace(xmin,xmax,n);
%Xnull = nlsys2d_isonull(p,[xmin,xmax],n);
% stabilit� del p.to di equilibrio
Jacob = feval(@(xx) jac(xx,p), ptEq);
fprintf("\nJ(%.3d,%.3d): J(1,1)=%.3d J(1,2)=%.3d",ptEq(1),ptEq(2), Jacob(1,1), Jacob(1,2));
fprintf("\nJ(%.3d,%.3d): J(2,1)=%.3d J(2,2)=%.3d\n",ptEq(1),ptEq(2), Jacob(2,1), Jacob(2,2));
%fprintf("\nJACOB(%.3d,%.3d): J(1,1)=%.3d J(1,2)=%.3d",ptEq(1),ptEq(2), JACOB(1,1), JACOB(1,2));
%fprintf("\nJACOB(%.3d,%.3d): J(2,1)=%.3d J(2,2)=%.3d\n",ptEq(1),ptEq(2), JACOB(2,1), JACOB(2,2));
if(det(Jacob) == 0)
    fprintf("Equilibrio non iperbolico!");
else
    fprintf("Equilibrio iperbolico");
    eigenvalues = eig(Jacob);
    str = "Autovalori: \x03bb "+1+" = "+eigenvalues(1)+" \x03bb "+2+" = "+eigenvalues(2)+"\n";
    fprintf(str);    
    Tau = trace(Jacob);
    Delta = det(Jacob);    
    fprintf("tau = %.3d\n", Tau);
    fprintf("delta = %.3d\n", Delta);
    %Disegno le curve significative sul piano (Delta,tau)
    figure;
    hold on;
    plot([0 0],[-6 6],'r','linewidth',2);
    plot([0 8],[0 0],'b','linewidth',2);
    tau=linspace(0,6,100);
    delta=tau.^2/4;
    plot(delta,tau,'g','linewidth',2);
    plot(delta,-tau,'g','linewidth',2);
    plot(Delta,Tau,'o','color','g');
    axis([0 1 -1 1]);
    xlabel('Delta');
    ylabel('tau');
    str = "Piano tau-delta (alfa="+p(1)+")";
    title(str);
end
    
% opzioni per le figure
lw = 2;
gray = [.8,.8,.8];
if nargin == 3 && isscalar(varargin{1})
    figure(varargin{1});
else
    figure;
end


%
% SOLUZIONE NELLO SPAZIO DI STATO
%
subplot(2,2,1);
hold on;
% plot(X,Xnull(1,:),'Color',[1,1,0],'LineWidth',lw);
% plot(X,Xnull(2,:),'Color',[0,1,1],'LineWidth',lw);
af = @(a,b) p(1) - 0.5*(a + 0.5) - 2*b*(a + 0.7) - (1 + tanh((a + 0.01)/0.15))/2*(a - 1);
bf = @(a,b) 1.15*((1 + tanh((a - p(2))/0.145))/2 - b)*cosh((a-0.1)/0.29);
fimplicit(af, [-5 5 -5 5]);
fimplicit(bf, [-5 5 -5 5]);
plot(x(:,1),x(:,2),'m');
plot(x(1,1),x(1,2),'.r');
plot(x(end,1),x(end,2),'.g');
axis('tight');
xlabel('x'); ylabel('y');
str = "Soluzione nel piano di stato (alfa="+p(1)+")";
title(str);
grid('on'); box('on');
set(gca,'Color',gray);

%
% SOLUZIONE NEL TEMPO
%

subplot(2,2,2); hold on;
plot(t,x(:,1),'k');
axis([0 250 -80 40]);
plot(t,x(:,2),'r');
axis([0 250 -80 40]);
xlabel('t');
legend('x','y','Location','SouthWest');
title('Andamento temporale della soluzione')
grid('on'); box('on');
set(gca,'Color',gray);

% AUTOVALORI
%
subplot(2,2,3); hold on;
re = real(eig(Jacob));
im = imag(eig(Jacob));
plot(re(re>0),im(re>0),'ro','MarkerFaceColor','r');
plot(re(re<0),im(re<0),'go','MarkerFaceColor','g');
plot([0,0],[-1,1],'k','LineWidth',2);
grid('on'); box('on');
axis([-1,2,-1,1]);
xlabel('Re'); ylabel('Im');
title('Autovalori di J calcolata nell''equilibrio');
set(gca,'Color',gray);

% CAMPO VETTORIALE
%

% definisco la griglia di punti su cui calcolare il campo vettoriale
maxX=30.5; M=30;
maxY=60.5; N=30;
[x,y]=meshgrid(linspace(-100,maxX,M),linspace(-100,maxY,N));
%Inizializzo i vettori con le componenti del campo vettoriale
xp=zeros(M,N);
yp=zeros(M,N);
Minf = (1 + tanh((x + 0.01)/0.15))/2;
Winf = (1 + tanh((x - p(2))/0.145))/2;
Tau = cosh((x-0.1)/0.29);
xp = p(1) - 0.5*(x + 0.5) - 2*x*(x + 0.7) - Minf*(x - 1);
yp = 1.15*(Winf - y)*Tau;
% xdot = nlsys2d(t,[x(:),y(:)]',p);


subplot(2,2,4); hold on;
quiver(x,y,xp,yp,3);
% quiver(x(:),y(:),xdot(1,:)',xdot(2,:)',2);
% plot(X,Xnull(1,:),'Color',[1,1,0],'LineWidth',lw);
% plot(X,Xnull(2,:),'Color',[0,1,1],'LineWidth',lw);
fimplicit(af, [-5 5 -5 5]);
fimplicit(bf, [-5 5 -5 5]);
%axis([-90 10 -10 10]);
xlabel('x');
ylabel('y');
grid('on'); box('on');
%axis('tight');
title('Campo vettoriale e isocline nulle');
set(gca,'Color',gray);

% quadro di stato al variare delle condizioni iniziali
% figure;
% hold on;
% for k=1:size(x0_vect,1)
%     plot(x_vect(:,1,k),x_vect(:,2,k),x_vect(1,1,k),x_vect(1,2,k),'.r',x_vect(end,1,k),x_vect(end,2,k),'og');
% end
% 
% title('Quadro di stato al variare delle condizioni iniziali');