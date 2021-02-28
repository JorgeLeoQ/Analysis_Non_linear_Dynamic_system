function xdot = nlsys2d(t,x,p)
% p(1) = alfa
% p(2) = beta

Minf = 0.5*(1 + tanh((x(1)+1.2)/18));

xdot(1,:) = 0.2*(-2*(x(1)+60)-4*Minf.*(x(1)-120)-8*x(2)*(x(1)+80)+p(1));
xdot(2,:) = ((cosh((x(1)-p(2))/34.8))*(0.5*(1+tanh((x(1)-p(2))/17.4))-x(2)))/15;
