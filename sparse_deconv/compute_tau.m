function tau = compute_tau(x, sizek, mask)
[Gx, Gy] = imgradientxy(x, 'IntermediateDifference');
ang = Gy ./ (Gx+eps);
idx1 = ang >= 0 & ang <= 1;
idx2 = ang >=1 ;
idx3 = ang <= -1;
idx4 = ang >= -1 & ang <= 0;

G = (Gx.^2 + Gy.^2);
if(nargin==3)
    G = G.*mask;
end
G1 = sort(G(idx1), 'descend');
G2 = sort(G(idx2), 'descend');
G3 = sort(G(idx3), 'descend');
G4 = sort(G(idx4), 'descend');
n = round(2*sqrt(sizek(1)*sizek(2)));

tau1 = G1(min(length(G1), n));
tau2 = G2(min(length(G2), n));
tau3 = G3(min(length(G3), n));
tau4 = G4(min(length(G4), n));

tau = min([tau1, tau2, tau3, tau4]);
