function Xnull = nlsys2d_isonull(p, domain, steps)
% Xnull = vdpnull(p, domain, steps)
% 
% Calcola le isocline nulle del sistema in funzione 
% della variabile di stato x.
% 
% Argomenti:
%      p - parametro.
% domain - dominio di definizione di x: e' un vettore di due elementi.
%  steps - numero di passi di campionamento del dominio.
% 
x = linspace(domain(1),domain(2),steps);
Minf = 0.5*(1 + tanh((x(1)+1.2)/18));

% prima isoclina nulla
Xnull(1,:) = (1./(8*(x+80))).*(-2*(x+60)-4*Minf.*(x-120)+p(1,1));
% seconda isoclina nulla: due fattori si annullano
Xnull(2,:) = 0.5*(1+tanh((x-p(1,2))/17.4));

