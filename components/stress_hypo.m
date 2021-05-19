%#codegen
function S = stress_hypo(lambda, mu, strain, deform, NE)
tr = repmat(eye(3), 1, 1, NE, 8);
% engineering strain
deform_inv = inv_4d(deform);
deform_det = det_4d(deform);
epsilon = pagemtimes(pagemtimes(deform_inv, 'transpose', strain, 'none'), deform_inv);
% cauchy stress
sigma = (repmat(lambda.*sum(epsilon.*tr, [1 2]),3,3,1,1) .* tr + 2*repmat(mu,3,3,1,1).*epsilon);
% converting back to 2nd PK stress
S = pagemtimes(pagemtimes(deform_inv,  sigma),'none', deform_inv, 'transpose');
S = pagemtimes(deform_det, S);

