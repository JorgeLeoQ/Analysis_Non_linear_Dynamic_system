% vedi manuale MatCont 2011 pag.71

function xdot = model(t,x,p)
% p(1) = y
% p(2) = z

Minf = (1 + tanh((x(1) + 0.01)/0.15))/2;
Winf = (1 + tanh((x(1) - p(2))/0.145))/2;
Tau = cosh((x(1)-0.1)/0.29);

xdot(1,:) = p(1) - 0.5*(x(1) + 0.5) - 2*x(2)*(x(1) + 0.7) - Minf*(x(1) - 1);
xdot(2,:) = 1.15*(Winf - x(2))*Tau;
