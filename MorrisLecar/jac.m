function J = jac(x,p)
% 
% Argomenti:
%  x - stato del sistema.
%  p - parametri.
% 

% alloco una matrice 2x2
J = zeros(2,2);

J(1,1) = ((10*tanh((20*x(1))/3 + 1/15)^2)/3 - 10/3)*(x(1) - 1) - tanh((20*x(1))/3 + 1/15)/2 - 2*x(2) - 1;
J(1,2) = - 2*x(1) - 7/5;
J(2,1) = - (100*sinh((100*x(1))/29 - 10/29)*((23*x(2))/20 + (23*tanh((200*p(2))/29 - (200*x(1))/29))/40 - 23/40))/29 - cosh((100*x(1))/29 - 10/29)*((115*tanh((200*p(2))/29 - (200*x(1))/29)^2)/29 - 115/29);
J(2,2) = -(23*cosh((100*x(1))/29 - 10/29))/20;