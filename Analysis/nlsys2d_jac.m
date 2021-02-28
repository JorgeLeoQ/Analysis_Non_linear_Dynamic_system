function J = nlsys2d_jac(x,p)
% 
% Argomenti:
%  x - stato del sistema.
%  p - parametro.
% 

% alloco una matrice 2x2
J = zeros(2,2);

J(1,1) = (-2/5) * (1+(1/18) * (1-tanh((x(1)+1.2)/18)^2)*(x(1)-120)+1+tanh((x(1)+1.2)/18)+4*x(2));
J(1,2) = (-8/5)*(x(1)+80);
J(2,1) = (1/30)*((1/34.8)*sinh((x(1)-p(2))/34.8)*(1+tanh((x(1)-p(2))/17.4)-2*x(2))+(1/17.4)*cosh((x(1)-p(2))/34.8)*(1-tanh((x(1)-p(2))/17.4)^2));
J(2,2) = (-1/15)*cosh((x(1)-p(2))/34.8);