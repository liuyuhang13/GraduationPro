function [D_ksvd,gamma,err]=Dictionary_train(X,par)

k=10;
m=par.patch_size^2;

params.data = X;
params.Tdata = k;
params.dictsize = m;
params.iternum = 100;
params.memusage = 'high';
[D_ksvd,gamma,err]=ksvd(params,'');